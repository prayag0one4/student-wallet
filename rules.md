# RULES.md

# Student Wallet Development Rules

## Project Vision

Student Wallet is a local-first, offline-first personal finance application for students.

The application must work completely without:

* Authentication
* Internet connection
* Backend server
* Cloud storage

Future versions may introduce:

* Authentication
* Cloud synchronization
* Subscription plans
* Multi-device support

All architectural decisions must preserve the ability to migrate to cloud infrastructure without major refactoring.

---

# Rule 1: Local First Architecture

Everything must work locally.

The local database is the source of truth.

Current data flow:

UI
→ Providers
→ Repository
→ Local Database

Future data flow:

UI
→ Providers
→ Repository
→ Sync Manager
→ Local Database + Cloud API

UI code must never directly access databases or APIs.

---

# Rule 2: Repository Pattern is Mandatory

Every feature must expose an abstract repository interface.

Example:

ExpenseRepository

Current implementation:

* LocalExpenseRepository

Future implementation:

* SyncExpenseRepository

The presentation layer must depend only on interfaces.

---

# Rule 3: No Business Logic Inside Widgets

Widgets are responsible only for:

* Rendering UI
* Handling user interactions
* Calling providers

Forbidden:

* Database calls
* Calculations
* Data transformations
* Filtering logic

Business logic belongs in:

* Use cases
* Services
* Providers

---

# Rule 4: Every Entity Must Be Cloud Ready

Every persistent entity must contain:

* localId
* cloudId
* createdAt
* updatedAt
* deletedAt
* syncStatus
* version

Example:

Expense
Person
LedgerEntry
Group
Subscription

Never create a database entity without these fields.

---

# Rule 5: Soft Delete Only

Records must never be permanently deleted immediately.

Instead:

deletedAt = timestamp
syncStatus = deleted

Reason:
Future cloud synchronization requires deletion tracking.

---

# Rule 6: IDs Must Be Immutable

Once created:

* localId cannot change.
* cloudId cannot change.

Never reuse deleted IDs.

---

# Rule 7: Feature First Folder Structure

Allowed:

lib/features/expenses
lib/features/ledger
lib/features/split
lib/features/budget
lib/features/subscriptions
lib/features/analytics

Forbidden:

lib/screens
lib/models
lib/services

Global folders quickly become unmaintainable.

---

# Rule 8: Every Feature Must Follow Clean Architecture

Each feature contains:

data/
domain/
presentation/

data:

* models
* repositories
* datasources

domain:

* entities
* repositories
* usecases

presentation:

* screens
* widgets
* providers

No exceptions.

---

# Rule 9: State Management Rules

Use Riverpod only.

Allowed:

* Provider
* StateNotifierProvider
* AsyncNotifierProvider

Forbidden:

* Provider package
* GetX state management
* Bloc
* Global mutable state

---

# Rule 10: Dependency Injection Rules

Use GetIt only.

Do not instantiate dependencies inside widgets.

Forbidden:

ExpenseRepository()

Allowed:

getIt<ExpenseRepository>()

---

# Rule 11: Database Rules

Use Isar as the only database.

Forbidden:

* SharedPreferences for structured data
* Hive
* SQLite
* ObjectBox

Allowed:

* SharedPreferences only for small settings:

  * theme
  * onboarding status
  * feature flags

---

# Rule 12: Theme Rules

Application must support:

* Light theme
* Dark theme

Never use hardcoded colors.

All colors must come from:

AppColors
ThemeExtensions
ColorScheme

---

# Rule 13: Design Rules

Design language:

* Modern fintech
* Soft neumorphism
* Minimal interfaces
* Large touch targets

Component requirements:

* rounded corners
* subtle shadows
* reusable widgets

Avoid:

* excessive gradients
* overly bright colors
* cluttered screens

---

# Rule 14: Reusable Components First

Before creating a new widget ask:

Can this become a reusable component?

Examples:

AppCard
AppButton
AppInputField
AppBottomNavigation
AppDialog
AppSectionHeader

---

# Rule 15: Logging Rules

Every critical operation must generate logs.

Log categories:

* Database
* UI
* Errors
* Sync
* Notifications

Disable logs in release mode.

---

# Rule 16: Error Handling Rules

Never expose raw exceptions to UI.

Use:

Failure classes
Result wrappers
Domain errors

UI displays user-friendly messages only.

---

# Rule 17: Navigation Rules

Use GoRouter only.

Navigation logic belongs in:

* routes.dart
* app_router.dart

Never use direct Navigator.push() calls.

---

# Rule 18: Performance Rules

Target:

* 60 FPS
* instant screen transitions
* smooth scrolling with 10,000+ transactions

Avoid:

* expensive rebuilds
* unnecessary database queries
* heavy shadows in list items

---

# Rule 19: Feature Completion Definition

A feature is complete only if it includes:

* UI
* State management
* Repository implementation
* Database integration
* Error handling
* Loading states
* Empty states
* Tests

---

# Rule 20: Testing Rules

Every business logic component requires tests.

Required:

* Repository tests
* Use case tests
* Service tests

Optional:

* Widget tests

---

# Rule 21: Migration Rules

Never perform breaking schema changes.

Every migration must:

* preserve old data
* support upgrades
* support rollback when possible

Users must never lose financial data.

---

# Rule 22: Premium Features Must Be Additive

Free users must never lose functionality.

Premium features may add:

* cloud sync
* backups
* multi-device support
* advanced analytics

Core finance tracking remains available offline forever.

---

# Rule 23: Security Rules

Even local data deserves protection.

Requirements:

* encrypted backups
* secure local storage for tokens
* no sensitive logs
* HTTPS only for future APIs

---

# Rule 24: User Experience Rules

A financial entry should take less than 5 seconds.

Target flow:

Open app
→ Add amount
→ Save

Three taps is ideal.
Five taps is acceptable.
Ten taps is failure.

---

# Rule 25: Offline Is Not A Feature

Offline capability is a core requirement.

The application should continue operating perfectly:

* without internet
* on flights
* in hostels
* during poor connectivity

Cloud support is an enhancement, not a dependency.

---

# Golden Rule

Whenever making an architectural decision ask:

"Will this decision make future cloud migration harder?"

If the answer is yes, redesign it.

