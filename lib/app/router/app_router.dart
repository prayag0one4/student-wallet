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
import '../../features/split/presentation/screens/create_group_screen.dart';
import '../../features/split/presentation/screens/group_dashboard_screen.dart';
import '../../features/split/presentation/screens/add_member_screen.dart';
import '../../features/split/presentation/screens/settlement_screen.dart';
import '../../features/split/presentation/screens/expense_detail_screen.dart' as split;
import '../../features/split/presentation/screens/member_profile_screen.dart';
import '../../features/split/presentation/screens/new_expense_screen.dart';
import '../../features/split/presentation/screens/new_payment_screen.dart';
import '../../features/split/presentation/screens/new_person_screen.dart';
import '../../features/split/presentation/screens/payment_detail_screen.dart';
import '../../features/budget/presentation/screens/budget_screen.dart';
import '../../features/subscriptions/presentation/screens/subscriptions_screen.dart';
import '../../features/analytics/presentation/screens/analytics_screen.dart';
import '../screens/home_screen.dart';
import '../screens/more_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/home_preference_screen.dart';
import '../screens/splash_screen.dart';
import '../widgets/app_shell.dart';

Page<dynamic> _page<T extends Widget>(T child) {
  return CustomTransitionPage<dynamic>(
    child: child,
    maintainState: true,
    transitionDuration: const Duration(milliseconds: 180),
    reverseTransitionDuration: const Duration(milliseconds: 120),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
        child: child,
      );
    },
  );
}

final GoRouter router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', pageBuilder: (_, __) => _page(const SplashScreen())),
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(path: '/', pageBuilder: (_, __) => _page(const HomeScreen())),
        GoRoute(path: '/more', pageBuilder: (_, __) => _page(const MoreScreen())),
        GoRoute(path: '/expenses', pageBuilder: (_, __) => _page(const ExpensesScreen())),
        GoRoute(path: '/expenses/add', pageBuilder: (_, __) => _page(const AddExpenseScreen())),
        GoRoute(
          path: '/expenses/:id',
          pageBuilder: (_, state) => _page(ExpenseDetailScreen(expenseId: int.parse(state.pathParameters['id']!))),
        ),
        GoRoute(
          path: '/expenses/:id/edit',
          pageBuilder: (_, state) => _page(EditExpenseScreen(expenseId: int.parse(state.pathParameters['id']!))),
        ),
        GoRoute(path: '/ledger', pageBuilder: (_, __) => _page(const LedgerScreen())),
        GoRoute(
          path: '/ledger/add',
          pageBuilder: (_, state) {
            final extra = state.extra as Map<String, String>?;
            LedgerEntryType? preselectedType;
            if (extra != null && extra['type'] != null) {
              preselectedType = extra['type'] == 'paid'
                  ? LedgerEntryType.paid
                  : LedgerEntryType.received;
            }
            return _page(AddLedgerEntryScreen(preselectedType: preselectedType));
          },
        ),
        GoRoute(path: '/ledger/contacts/add', pageBuilder: (_, __) => _page(const AddContactScreen())),
        GoRoute(
          path: '/ledger/contacts/:id',
          pageBuilder: (_, state) => _page(ContactDetailScreen(contactId: int.parse(state.pathParameters['id']!))),
        ),
        GoRoute(
          path: '/ledger/contacts/:id/edit',
          pageBuilder: (_, state) => _page(AddContactScreen(contactId: int.parse(state.pathParameters['id']!))),
        ),
        GoRoute(
          path: '/ledger/contacts/:id/entry',
          pageBuilder: (_, state) {
            final id = int.parse(state.pathParameters['id']!);
            final extra = state.extra as Map<String, String>?;
            LedgerEntryType? preselectedType;
            if (extra != null && extra['type'] != null) {
              preselectedType = extra['type'] == 'paid'
                  ? LedgerEntryType.paid
                  : LedgerEntryType.received;
            }
            return _page(AddLedgerEntryScreen(preselectedContactId: id, preselectedType: preselectedType));
          },
        ),
        GoRoute(
          path: '/ledger/entries/:id',
          pageBuilder: (_, state) => _page(LedgerEntryDetailScreen(entryId: int.parse(state.pathParameters['id']!))),
        ),
        GoRoute(
          path: '/ledger/entries/:id/edit',
          pageBuilder: (_, state) => _page(AddLedgerEntryScreen(editEntryId: int.parse(state.pathParameters['id']!))),
        ),
        GoRoute(path: '/split', pageBuilder: (_, __) => _page(const SplitScreen())),
        GoRoute(path: '/split/groups/add', pageBuilder: (_, __) => _page(const CreateGroupScreen())),
        GoRoute(
          path: '/split/groups/:id',
          pageBuilder: (_, state) => _page(GroupDashboardScreen(groupId: int.parse(state.pathParameters['id']!))),
        ),
        GoRoute(
          path: '/split/groups/:id/edit',
          pageBuilder: (_, state) => _page(CreateGroupScreen(groupId: int.parse(state.pathParameters['id']!))),
        ),
        GoRoute(
          path: '/split/groups/:id/members/add',
          pageBuilder: (_, state) => _page(AddMemberScreen(groupId: int.parse(state.pathParameters['id']!))),
        ),
        GoRoute(
          path: '/split/groups/:id/settle',
          pageBuilder: (_, state) => _page(SettlementScreen(groupId: int.parse(state.pathParameters['id']!))),
        ),
        GoRoute(
          path: '/split/groups/:id/expenses/add',
          pageBuilder: (_, state) => _page(NewExpenseScreen(groupId: int.parse(state.pathParameters['id']!))),
        ),
        GoRoute(
          path: '/split/groups/:id/expenses/:expenseId/edit',
          pageBuilder: (_, state) => _page(NewExpenseScreen(
            groupId: int.parse(state.pathParameters['id']!),
            expenseId: int.parse(state.pathParameters['expenseId']!),
          )),
        ),
        GoRoute(
          path: '/split/groups/:groupId/expenses/:expenseId',
          pageBuilder: (_, state) => _page(split.ExpenseDetailScreen(
            groupId: int.parse(state.pathParameters['groupId']!),
            expenseId: int.parse(state.pathParameters['expenseId']!),
          )),
        ),
        GoRoute(
          path: '/split/groups/:id/members/add-inline',
          pageBuilder: (_, state) => _page(NewPersonScreen(groupId: int.parse(state.pathParameters['id']!))),
        ),
        GoRoute(
          path: '/split/groups/:groupId/members/:memberId',
          pageBuilder: (_, state) => _page(MemberProfileScreen(
            groupId: int.parse(state.pathParameters['groupId']!),
            memberId: int.parse(state.pathParameters['memberId']!),
          )),
        ),
        GoRoute(
          path: '/split/groups/:id/payments/add',
          pageBuilder: (_, state) => _page(NewPaymentScreen(groupId: int.parse(state.pathParameters['id']!))),
        ),
        GoRoute(
          path: '/split/groups/:groupId/payments/:settlementId',
          pageBuilder: (_, state) => _page(PaymentDetailScreen(
            groupId: int.parse(state.pathParameters['groupId']!),
            settlementId: int.parse(state.pathParameters['settlementId']!),
          )),
        ),
        GoRoute(path: '/budget', pageBuilder: (_, __) => _page(const BudgetScreen())),
        GoRoute(path: '/subscriptions', pageBuilder: (_, __) => _page(const SubscriptionsScreen())),
        GoRoute(path: '/analytics', pageBuilder: (_, __) => _page(const AnalyticsScreen())),
        GoRoute(path: '/settings', pageBuilder: (_, __) => _page(const SettingsScreen())),
        GoRoute(path: '/settings/home-preference', pageBuilder: (_, __) => _page(const HomePreferenceScreen())),
      ],
    ),
  ],
);
