import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/enums/fuel_type.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../vehicle/domain/entities/vehicle.dart';
import '../../../vehicle/presentation/providers/vehicle_providers.dart';
import '../../domain/entities/refuel.dart';
import '../providers/refuel_providers.dart';
import '../widgets/consumption_preview_bar.dart';
import '../widgets/refuel_big_field.dart';

/// Form to log (or edit) a refueling for a vehicle.
class RefuelFormScreen extends ConsumerStatefulWidget {
  const RefuelFormScreen({super.key, required this.vehicleId, this.refuelId});

  final String vehicleId;

  /// Null when logging a new refueling; otherwise the refueling being edited.
  final String? refuelId;

  bool get isEditing => refuelId != null;

  @override
  ConsumerState<RefuelFormScreen> createState() => _RefuelFormScreenState();
}

class _RefuelFormScreenState extends ConsumerState<RefuelFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _litersController = TextEditingController();
  final _odometerController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _date = DateTime.now();
  FuelType? _fuelType;
  bool _fullTank = true;
  bool _saving = false;
  bool _prefilled = false;

  @override
  void initState() {
    super.initState();
    _litersController.addListener(_onInputChanged);
    _odometerController.addListener(_onInputChanged);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _litersController.dispose();
    _odometerController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onInputChanged() => setState(() {});

  /// Highest odometer among this vehicle's other refuelings, falling back to the
  /// vehicle's current mileage. The new reading must exceed it.
  int _lastOdometer(Vehicle vehicle, List<Refuel> refuels) {
    var last = vehicle.currentMileage;
    for (final r in refuels) {
      if (r.id == widget.refuelId) continue;
      if (r.odometer > last) last = r.odometer;
    }
    return last;
  }

  void _prefillIfEditing(List<Refuel> refuels, FuelType vehicleFuel) {
    if (_prefilled) return;
    if (widget.isEditing) {
      final refuel = refuels.where((r) => r.id == widget.refuelId).firstOrNull;
      if (refuel == null) return;
      _amountController.text = Formatters.currency(refuel.amountPaid)
          .replaceAll(RegExp(r'[^0-9,]'), '');
      _litersController.text = refuel.liters.toString().replaceAll('.', ',');
      _odometerController.text = Formatters.odometer(refuel.odometer);
      _notesController.text = refuel.notes ?? '';
      _date = refuel.date;
      _fuelType = refuel.fuelType;
      _fullTank = refuel.fullTank;
    } else {
      _fuelType = vehicleFuel;
    }
    _prefilled = true;
  }

  double? _livePreview(int lastOdometer) {
    final liters = Formatters.parsePositiveDecimal(_litersController.text);
    final odometer = Formatters.parseMileage(_odometerController.text);
    if (liters == null || odometer == null || odometer <= lastOdometer) {
      return null;
    }
    return (odometer - lastOdometer) / liters;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save(Refuel? existing) async {
    if (!_formKey.currentState!.validate()) return;

    final amount = Formatters.parsePositiveDecimal(_amountController.text)!;
    final liters = Formatters.parsePositiveDecimal(_litersController.text)!;
    final odometer = Formatters.parseMileage(_odometerController.text)!;
    final notes = _notesController.text.trim();
    final notifier = ref.read(refuelListProvider.notifier);

    setState(() => _saving = true);
    try {
      if (widget.isEditing && existing != null) {
        await notifier.edit(existing.copyWith(
          date: _date,
          amountPaid: amount,
          liters: liters,
          fuelType: _fuelType,
          odometer: odometer,
          fullTank: _fullTank,
          notes: notes.isEmpty ? null : notes,
        ));
      } else {
        await notifier.register(
          vehicleId: widget.vehicleId,
          date: _date,
          amountPaid: amount,
          liters: liters,
          fuelType: _fuelType!,
          odometer: odometer,
          fullTank: _fullTank,
          notes: notes.isEmpty ? null : notes,
        );
      }
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    final vehicle = ref
        .watch(vehicleListProvider)
        .value
        ?.where((v) => v.id == widget.vehicleId)
        .firstOrNull;
    final refuels = ref.watch(refuelsForVehicleProvider(widget.vehicleId));

    if (vehicle == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    _prefillIfEditing(refuels, vehicle.fuelType);
    final existing =
        refuels.where((r) => r.id == widget.refuelId).firstOrNull;
    final lastOdometer = _lastOdometer(vehicle, refuels);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditing ? 'Editar Abastecimento' : 'Registrar Abastecimento',
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(spacing.containerPadding),
            children: [
              _ContextRow(
                date: _date,
                vehicleName: vehicle.name,
                onPickDate: _pickDate,
              ),
              SizedBox(height: spacing.stackLg),
              RefuelBigField(
                controller: _amountController,
                label: 'Valor pago',
                unit: 'R\$',
                decimal: true,
                autofocus: !widget.isEditing,
                validator: (v) =>
                    Formatters.parsePositiveDecimal(v ?? '') == null
                        ? 'Informe um valor válido.'
                        : null,
              ),
              SizedBox(height: spacing.stackMd),
              RefuelBigField(
                controller: _litersController,
                label: 'Litros',
                unit: 'L',
                decimal: true,
                validator: (v) =>
                    Formatters.parsePositiveDecimal(v ?? '') == null
                        ? 'Informe os litros.'
                        : null,
              ),
              SizedBox(height: spacing.stackMd),
              RefuelBigField(
                controller: _odometerController,
                label: 'Quilometragem atual',
                unit: 'km',
                helper: 'Última: ${Formatters.mileage(lastOdometer)}',
                validator: (v) {
                  final value = Formatters.parseMileage(v ?? '');
                  if (value == null) return 'Informe a quilometragem.';
                  if (value <= lastOdometer) {
                    return 'Deve ser maior que ${Formatters.mileage(lastOdometer)}.';
                  }
                  return null;
                },
              ),
              SizedBox(height: spacing.stackLg),
              Text('Combustível', style: context.textStyles.labelCaps),
              SizedBox(height: spacing.stackSm),
              SegmentedButton<FuelType>(
                segments: [
                  for (final fuel in FuelType.values)
                    ButtonSegment(value: fuel, label: Text(fuel.label)),
                ],
                selected: {_fuelType ?? vehicle.fuelType},
                onSelectionChanged: (s) => setState(() => _fuelType = s.first),
              ),
              SizedBox(height: spacing.stackMd),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Tanque cheio'),
                value: _fullTank,
                onChanged: (v) => setState(() => _fullTank = v),
              ),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Observações (opcional)',
                ),
                maxLines: 2,
                textCapitalization: TextCapitalization.sentences,
              ),
              SizedBox(height: spacing.stackLg),
              ConsumptionPreviewBar(kmPerLiter: _livePreview(lastOdometer)),
              SizedBox(height: spacing.stackMd),
              FilledButton.icon(
                onPressed: _saving ? null : () => _save(existing),
                icon: const Icon(Icons.local_gas_station),
                label: Text(_saving ? 'Salvando...' : 'Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContextRow extends StatelessWidget {
  const _ContextRow({
    required this.date,
    required this.vehicleName,
    required this.onPickDate,
  });

  final DateTime date;
  final String vehicleName;
  final VoidCallback onPickDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final spacing = context.spacing;

    return Container(
      padding: EdgeInsets.all(spacing.containerPadding),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        borderRadius: context.radii.lgRadius,
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('DATA', style: context.textStyles.labelCaps),
              SizedBox(height: spacing.stackSm / 2),
              InkWell(
                onTap: onPickDate,
                child: Row(
                  children: [
                    Icon(Icons.calendar_today,
                        size: 18, color: colors.outline),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('dd/MM/yyyy', 'pt_BR').format(date),
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('VEÍCULO', style: context.textStyles.labelCaps),
              SizedBox(height: spacing.stackSm / 2),
              Row(
                children: [
                  Text(vehicleName, style: theme.textTheme.bodyLarge),
                  const SizedBox(width: 8),
                  Icon(Icons.directions_car, size: 18, color: colors.outline),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
