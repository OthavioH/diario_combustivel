# Fuel Diary

A mobile app to record and track vehicle refueling, automatically calculating average fuel consumption, spending per period, and a complete history per vehicle.

## What it does

Fuel Diary lets you register your vehicles and log every refueling stop. The app uses the mileage and liters filled at each stop to automatically calculate your average fuel consumption (km/l) and tracks how much you've spent over time — all stored locally on your device, no account required.

### Key features

- **Vehicle management** — register cars and motorcycles with name, fuel type, and current mileage; each vehicle is tracked independently
- **Refueling log** — record date, amount paid, liters filled, fuel type, and current mileage; consumption is calculated automatically against the previous entry
- **Dashboard** — per-vehicle cards showing current average consumption, last refueling, total monthly spending, and recorded mileage
- **History** — chronological list of all refuelings with filters by period and fuel type
- **Spending report** — bar chart with monthly spending, vehicle comparison, and average cost per kilometer

## Tech stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.41 |
| State management | Riverpod 3 |
| Navigation | GoRouter |
| Local database | Hive |
| Architecture | Feature + Layered Architecture |

## Architecture

The app combines two complementary patterns: **feature architecture** at the top level and **layered architecture** inside each feature.

### Feature architecture

Code is organized around product features (`vehicle`, `refuel`, `report`). Each feature is a self-contained module — it owns its data, domain logic, and UI. Features do not import from each other; anything shared lives in `core/`.

```
features/
  vehicle/    ← everything about managing vehicles
  refuel/     ← everything about logging a refueling stop
  report/     ← spending charts and summaries
core/         ← shared utilities, theme, base providers
```

### Layered architecture

Inside every feature the code is split into three layers. Dependencies only flow downward — `presentation` calls `domain`, `domain` calls `data`, never the other way around.

```
presentation/   (screens, widgets, Riverpod providers)
      │
   domain/      (entities, use cases, repository interfaces)
      │
    data/       (Hive models, repository implementations, data sources)
```

| Layer | Responsibility |
|---|---|
| `presentation` | Flutter screens and widgets; state managed by Riverpod `AsyncNotifierProvider` / `NotifierProvider` |
| `domain` | Pure Dart — entities (`Vehicle`, `Refuel`), use case classes (`RegisterRefuelUseCase`, `CalculateAverageConsumptionUseCase`), and abstract repository interfaces |
| `data` | Hive data models, concrete repository implementations, and local data source adapters |

Navigation is handled globally in `core/` by GoRouter with named routes, keeping the vehicle flow and refueling flow separate.

## Project structure

```
.
├── app/
│   └── lib/
│       ├── core/
│       │   ├── database/           # Hive initialization and box registration
│       │   ├── navigation/         # GoRouter setup and route definitions
│       │   ├── theme/              # app theme and design tokens
│       │   └── utils/              # shared helpers and extensions
│       │
│       ├── features/
│       │   ├── vehicle/
│       │   │   ├── data/
│       │   │   │   ├── datasources/        # VehicleLocalDataSource (Hive)
│       │   │   │   ├── models/             # VehicleModel (Hive adapter)
│       │   │   │   └── repositories/       # VehicleRepositoryImpl
│       │   │   ├── domain/
│       │   │   │   ├── entities/           # Vehicle
│       │   │   │   ├── repositories/       # VehicleRepository (abstract)
│       │   │   │   └── usecases/           # RegisterVehicleUseCase, DeleteVehicleUseCase …
│       │   │   └── presentation/
│       │   │       ├── providers/          # vehicleListProvider, vehicleFormProvider
│       │   │       ├── screens/            # VehicleListScreen, VehicleFormScreen, DashboardScreen
│       │   │       └── widgets/            # VehicleCard, MileageDisplay …
│       │   │
│       │   ├── refuel/
│       │   │   ├── data/
│       │   │   │   ├── datasources/        # RefuelLocalDataSource (Hive)
│       │   │   │   ├── models/             # RefuelModel (Hive adapter)
│       │   │   │   └── repositories/       # RefuelRepositoryImpl
│       │   │   ├── domain/
│       │   │   │   ├── entities/           # Refuel
│       │   │   │   ├── repositories/       # RefuelRepository (abstract)
│       │   │   │   └── usecases/           # RegisterRefuelUseCase, CalculateAverageConsumptionUseCase …
│       │   │   └── presentation/
│       │   │       ├── providers/          # refuelListProvider, refuelFormProvider
│       │   │       ├── screens/            # RefuelFormScreen, HistoryScreen
│       │   │       └── widgets/            # RefuelHistoryTile, FuelTypeBadge …
│       │   │
│       │   └── report/
│       │       ├── data/
│       │       │   └── repositories/       # ReportRepositoryImpl
│       │       ├── domain/
│       │       │   ├── repositories/       # ReportRepository (abstract)
│       │       │   └── usecases/           # GetMonthlySpendingUseCase, GetCostPerKmUseCase …
│       │       └── presentation/
│       │           ├── providers/          # reportProvider
│       │           ├── screens/            # ReportScreen
│       │           └── widgets/            # SpendingBarChart, VehicleComparisonCard …
│       │
│       └── main.dart
└── README.md
```

## Screens

| Screen | Description |
|---|---|
| Home | Vehicle list / splash |
| Vehicle form | Register and edit vehicles |
| Dashboard | Consumption, recent history, monthly spending per vehicle |
| New refueling | Form to log a refueling stop |
| History | Full refueling history with filters |
| Report | Monthly spending chart |

## Getting started

```bash
cd app
flutter pub get
flutter run
```
