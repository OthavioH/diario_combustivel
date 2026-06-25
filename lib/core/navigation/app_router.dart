import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/refuel/presentation/screens/history_screen.dart';
import '../../features/refuel/presentation/screens/refuel_form_screen.dart';
import '../../features/report/presentation/screens/report_screen.dart';
import '../../features/vehicle/presentation/screens/vehicle_dashboard_screen.dart';
import '../../features/vehicle/presentation/screens/vehicle_form_screen.dart';
import '../../features/vehicle/presentation/screens/vehicle_list_screen.dart';
import 'app_shell.dart';
import 'routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final _vehiclesNavigatorKey = GlobalKey<NavigatorState>();
final _historyNavigatorKey = GlobalKey<NavigatorState>();
final _reportsNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/vehicles',
    debugLogDiagnostics: true,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            navigatorKey: _vehiclesNavigatorKey,
            routes: [
              GoRoute(
                path: '/vehicles',
                name: Routes.vehicles,
                builder: (context, state) => const VehicleListScreen(),
                routes: [
                  GoRoute(
                    path: 'new',
                    name: Routes.vehicleNew,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const VehicleFormScreen(),
                  ),
                  GoRoute(
                    path: ':${Routes.vehicleIdParam}',
                    name: Routes.vehicleDashboard,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => VehicleDashboardScreen(
                      vehicleId:
                          state.pathParameters[Routes.vehicleIdParam]!,
                    ),
                    routes: [
                      GoRoute(
                        path: 'edit',
                        name: Routes.vehicleEdit,
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) => VehicleFormScreen(
                          vehicleId:
                              state.pathParameters[Routes.vehicleIdParam]!,
                        ),
                      ),
                      GoRoute(
                        path: 'refuel/new',
                        name: Routes.refuelNew,
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) => RefuelFormScreen(
                          vehicleId:
                              state.pathParameters[Routes.vehicleIdParam]!,
                        ),
                      ),
                      GoRoute(
                        path: 'refuel/:${Routes.refuelIdParam}/edit',
                        name: Routes.refuelEdit,
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) => RefuelFormScreen(
                          vehicleId:
                              state.pathParameters[Routes.vehicleIdParam]!,
                          refuelId:
                              state.pathParameters[Routes.refuelIdParam]!,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          StatefulShellBranch(
            navigatorKey: _historyNavigatorKey,
            routes: [
              GoRoute(
                path: '/history',
                name: Routes.history,
                builder: (context, state) => const HistoryScreen(),
              ),
            ],
          ),

          StatefulShellBranch(
            navigatorKey: _reportsNavigatorKey,
            routes: [
              GoRoute(
                path: '/reports',
                name: Routes.reports,
                builder: (context, state) => const ReportScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
