import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

abstract final class Routes {
  static const String vehicles = 'vehicles';

  static const String vehicleNew = 'vehicle-new';

  static const String vehicleDashboard = 'vehicle-dashboard';

  static const String vehicleEdit = 'vehicle-edit';

  static const String refuelNew = 'refuel-new';

  static const String refuelEdit = 'refuel-edit';

  static const String history = 'history';

  static const String reports = 'reports';

  static const String vehicleIdParam = 'vehicleId';

  static const String refuelIdParam = 'refuelId';
}

extension AppNavigation on BuildContext {

  void goVehicles() => goNamed(Routes.vehicles);

  void goHistory() => goNamed(Routes.history);

  void goReports() => goNamed(Routes.reports);

  Future<T?> pushVehicleDashboard<T>(String vehicleId) =>
      pushNamed<T>(
        Routes.vehicleDashboard,
        pathParameters: {Routes.vehicleIdParam: vehicleId},
      );

  Future<T?> pushVehicleForm<T>({String? vehicleId}) {
    if (vehicleId == null) return pushNamed<T>(Routes.vehicleNew);
    return pushNamed<T>(
      Routes.vehicleEdit,
      pathParameters: {Routes.vehicleIdParam: vehicleId},
    );
  }

  Future<T?> pushNewRefuel<T>(String vehicleId) =>
      pushNamed<T>(
        Routes.refuelNew,
        pathParameters: {Routes.vehicleIdParam: vehicleId},
      );

  Future<T?> pushRefuelEdit<T>(String vehicleId, String refuelId) =>
      pushNamed<T>(
        Routes.refuelEdit,
        pathParameters: {
          Routes.vehicleIdParam: vehicleId,
          Routes.refuelIdParam: refuelId,
        },
      );
}
