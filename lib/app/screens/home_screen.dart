import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../features/expenses/presentation/screens/expenses_screen.dart';
import '../../features/ledger/presentation/screens/ledger_screen.dart';
import '../../features/split/presentation/screens/groups_screen.dart';
import '../../features/budget/presentation/screens/budget_screen.dart';
import '../../features/subscriptions/presentation/screens/subscriptions_screen.dart';
import '../../features/analytics/presentation/screens/analytics_screen.dart';
import '../models/home_module.dart';
import '../providers/user_preferences_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = GetIt.instance<UserPreferencesService>();

    return ListenableBuilder(
      listenable: prefs,
      builder: (context, _) {
        return _buildFeature(prefs.homeModule);
      },
    );
  }

  Widget _buildFeature(HomeModule module) {
    return switch (module) {
      HomeModule.expenses => const ExpensesScreen(),
      HomeModule.ledger => const LedgerScreen(),
      HomeModule.split => const GroupsScreen(),
      HomeModule.budget => const BudgetScreen(),
      HomeModule.subscriptions => const SubscriptionsScreen(),
      HomeModule.analytics => const AnalyticsScreen(),
    };
  }
}
