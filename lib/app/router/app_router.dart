import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/expenses/presentation/screens/expenses_screen.dart';
import '../../features/expenses/presentation/screens/add_expense_screen.dart';
import '../../features/expenses/presentation/screens/edit_expense_screen.dart';
import '../../features/expenses/presentation/screens/expense_detail_screen.dart';
import '../../features/ledger/presentation/screens/ledger_screen.dart';
import '../../features/ledger/presentation/screens/add_contact_screen.dart';
import '../../features/ledger/presentation/screens/add_ledger_entry_screen.dart';
import '../../features/ledger/presentation/screens/contact_detail_screen.dart';
import '../../features/ledger/presentation/screens/ledger_entry_detail_screen.dart';
import '../../features/ledger/domain/entities/ledger_entry.dart';
import '../../features/split/presentation/screens/split_screen.dart';
import '../../features/budget/presentation/screens/budget_screen.dart';
import '../../features/subscriptions/presentation/screens/subscriptions_screen.dart';
import '../../features/analytics/presentation/screens/analytics_screen.dart';
import '../screens/home_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/splash_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => _AppShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/expenses',
          builder: (context, state) => const ExpensesScreen(),
        ),
        GoRoute(
          path: '/expenses/add',
          builder: (context, state) => const AddExpenseScreen(),
        ),
        GoRoute(
          path: '/expenses/:id',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return ExpenseDetailScreen(expenseId: id);
          },
        ),
        GoRoute(
          path: '/expenses/:id/edit',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return EditExpenseScreen(expenseId: id);
          },
        ),
        GoRoute(
          path: '/ledger',
          builder: (context, state) => const LedgerScreen(),
        ),
        GoRoute(
          path: '/ledger/add',
          builder: (context, state) {
            final extra = state.extra as Map<String, String>?;
            LedgerEntryType? preselectedType;
            if (extra != null && extra['type'] != null) {
              preselectedType = extra['type'] == 'paid'
                  ? LedgerEntryType.paid
                  : LedgerEntryType.received;
            }
            return AddLedgerEntryScreen(preselectedType: preselectedType);
          },
        ),
        GoRoute(
          path: '/ledger/contacts/add',
          builder: (context, state) => const AddContactScreen(),
        ),
        GoRoute(
          path: '/ledger/contacts/:id',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return ContactDetailScreen(contactId: id);
          },
        ),
        GoRoute(
          path: '/ledger/contacts/:id/edit',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return AddContactScreen(contactId: id);
          },
        ),
        GoRoute(
          path: '/ledger/contacts/:id/entry',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            final extra = state.extra as Map<String, String>?;
            LedgerEntryType? preselectedType;
            if (extra != null && extra['type'] != null) {
              preselectedType = extra['type'] == 'paid'
                  ? LedgerEntryType.paid
                  : LedgerEntryType.received;
            }
            return AddLedgerEntryScreen(
              preselectedContactId: id,
              preselectedType: preselectedType,
            );
          },
        ),
        GoRoute(
          path: '/ledger/entries/:id',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return LedgerEntryDetailScreen(entryId: id);
          },
        ),
        GoRoute(
          path: '/ledger/entries/:id/edit',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return AddLedgerEntryScreen(editEntryId: id);
          },
        ),
        GoRoute(
          path: '/split',
          builder: (context, state) => const SplitScreen(),
        ),
        GoRoute(
          path: '/budget',
          builder: (context, state) => const BudgetScreen(),
        ),
        GoRoute(
          path: '/subscriptions',
          builder: (context, state) => const SubscriptionsScreen(),
        ),
        GoRoute(
          path: '/analytics',
          builder: (context, state) => const AnalyticsScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
  ],
);

class _AppShell extends StatelessWidget {
  final Widget child;

  const _AppShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
    );
  }
}
