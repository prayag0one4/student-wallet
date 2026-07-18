# Student Wallet

A student-focused personal finance management app built with Flutter. Track expenses, manage borrow/lend relationships, split bills in groups, and visualize spending through analytics.

## Features

- **Expense Tracking** — Log personal expenses with categories, payment methods, and filters. View monthly/daily spending dashboards.
- **Ledger (Borrow/Lend)** — Track money owed to and by you with contact management, due dates, and overdue alerts.
- **Group Split** — Split bills with groups (equal/percentage/custom). Simplified settlement suggestions using debt simplification.
- **Analytics** — Monthly trends, category distribution, average transaction size, and spending frequency.
- **Budget & Subscriptions** — Coming soon.

## Tech Stack

| Layer | Technology |
|---|---|
| UI Framework | Flutter (Material 3, Neumorphic design) |
| State Management | Riverpod + GetIt (DI) |
| Routing | GoRouter with ShellRoute |
| Database | Isar (embedded NoSQL) |
| Notifications | flutter_local_notifications + timezone |
| Formatting | intl (currency, date, number) |

## Architecture

Feature-first Clean Architecture:

```
lib/
├── app/          # App shell, routing, DI, screens (splash, home, settings)
├── core/         # Theme, database, error handling, shared widgets
├── features/     # Feature modules (expenses, ledger, split, analytics, budget, subscriptions)
│   └── each feature has:
│       ├── data/        # Isar models, datasources, repository implementations
│       ├── domain/      # Entities, repository interfaces, use cases, domain services
│       └── presentation/# Riverpod providers, screens, widgets
└── shared/       # Shared utilities
```

## Getting Started

```bash
# Clone the repository
git clone https://github.com/prayag0one4/wallet-app.git
cd wallet-app

# Install dependencies
flutter pub get

# Generate Isar models
dart run build_runner build

# Run the app
flutter run
```

## Build

Minimum SDK: `^3.12.0`  
Platforms: Android, iOS, Web
