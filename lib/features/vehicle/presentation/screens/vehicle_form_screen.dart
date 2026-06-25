import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/enums/fuel_type.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/entities/vehicle_type.dart';
import '../providers/vehicle_providers.dart';

class VehicleFormScreen extends ConsumerStatefulWidget {
  const VehicleFormScreen({super.key, this.vehicleId});

  /// Null when creating a new vehicle; otherwise the vehicle being edited.
  final String? vehicleId;

  bool get isEditing => vehicleId != null;

  @override
  ConsumerState<VehicleFormScreen> createState() => _VehicleFormScreenState();
}

class _VehicleFormScreenState extends ConsumerState<VehicleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mileageController = TextEditingController();

  VehicleType _type = VehicleType.carro;
  FuelType _fuelType = FuelType.gasolina;
  bool _saving = false;
  bool _prefilled = false;

  @override
  void dispose() {
    _nameController.dispose();
    _mileageController.dispose();
    super.dispose();
  }

  // Pre-fills once, when the list data first becomes available in edit mode.
  void _prefillIfEditing(List<Vehicle> vehicles) {
    if (_prefilled || !widget.isEditing) return;
    final vehicle = vehicles.where((v) => v.id == widget.vehicleId).firstOrNull;
    if (vehicle == null) return;
    _nameController.text = vehicle.name;
    _mileageController.text = Formatters.mileage(vehicle.currentMileage)
        .replaceAll(' km', '');
    _type = vehicle.type;
    _fuelType = vehicle.fuelType;
    _prefilled = true;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final mileage = Formatters.parseMileage(_mileageController.text)!;
    final notifier = ref.read(vehicleListProvider.notifier);

    setState(() => _saving = true);
    try {
      if (widget.isEditing) {
        final existing = ref
            .read(vehicleListProvider)
            .value
            ?.where((v) => v.id == widget.vehicleId)
            .firstOrNull;
        if (existing != null) {
          await notifier.edit(existing.copyWith(
            name: name,
            type: _type,
            fuelType: _fuelType,
            currentMileage: mileage,
          ));
        }
      } else {
        await notifier.register(
          name: name,
          type: _type,
          fuelType: _fuelType,
          currentMileage: mileage,
        );
      }
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vehicles = ref.watch(vehicleListProvider).value ?? const <Vehicle>[];
    _prefillIfEditing(vehicles);

    final spacing = context.spacing;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Editar Veículo' : 'Novo Veículo'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(spacing.containerPadding),
            children: [
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o nome do veículo.';
                  }
                  return null;
                },
              ),
              SizedBox(height: spacing.stackLg),
              Text('Tipo', style: context.textStyles.labelCaps),
              SizedBox(height: spacing.stackSm),
              SegmentedButton<VehicleType>(
                segments: [
                  for (final type in VehicleType.values)
                    ButtonSegment(
                      value: type,
                      label: Text(type.label),
                      icon: Icon(type.icon),
                    ),
                ],
                selected: {_type},
                onSelectionChanged: (selection) =>
                    setState(() => _type = selection.first),
              ),
              SizedBox(height: spacing.stackLg),
              DropdownButtonFormField<FuelType>(
                initialValue: _fuelType,
                decoration: const InputDecoration(labelText: 'Combustível'),
                items: [
                  for (final fuel in FuelType.values)
                    DropdownMenuItem(value: fuel, child: Text(fuel.label)),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _fuelType = value);
                },
              ),
              SizedBox(height: spacing.stackLg),
              TextFormField(
                controller: _mileageController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Quilometragem atual',
                  suffixText: 'km',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe a quilometragem.';
                  }
                  if (Formatters.parseMileage(value) == null) {
                    return 'Use um número válido (km), maior ou igual a zero.';
                  }
                  return null;
                },
              ),
              SizedBox(height: spacing.stackLg),
              FilledButton(
                onPressed: _saving ? null : _save,
                child: Text(_saving
                    ? 'Salvando...'
                    : (widget.isEditing ? 'Salvar alterações' : 'Salvar')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
