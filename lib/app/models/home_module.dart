import 'package:flutter/material.dart';

enum HomeModule {
  expenses,
  ledger,
  budget,
  split,
  subscriptions,
  analytics,
}

class HomeModuleConfig {
  final HomeModule module;
  final String label;
  final String description;
  final IconData icon;
  final Color color;
  final String route;

  const HomeModuleConfig({
    required this.module,
    required this.label,
    required this.description,
    required this.icon,
    required this.color,
    required this.route,
  });

  static const List<HomeModuleConfig> all = [
    HomeModuleConfig(
      module: HomeModule.expenses,
      label: 'Expenses',
      description: 'Track your daily spending',
      icon: Icons.receipt_long,
      color: Color(0xFF4A90D9),
      route: '/expenses',
    ),
    HomeModuleConfig(
      module: HomeModule.ledger,
      label: 'Borrow / Lend',
      description: 'Track money you owe and are owed',
      icon: Icons.swap_horiz,
      color: Color(0xFF50C878),
      route: '/ledger',
    ),
    HomeModuleConfig(
      module: HomeModule.split,
      label: 'Bill Splitter',
      description: 'Split bills with friends',
      icon: Icons.call_split,
      color: Color(0xFFFFA726),
      route: '/split',
    ),
    HomeModuleConfig(
      module: HomeModule.budget,
      label: 'Budgets',
      description: 'Plan and control your spending',
      icon: Icons.pie_chart,
      color: Color(0xFFE53935),
      route: '/budget',
    ),
    HomeModuleConfig(
      module: HomeModule.subscriptions,
      label: 'Subscriptions',
      description: 'Manage recurring payments',
      icon: Icons.subscriptions,
      color: Color(0xFF7B1FA2),
      route: '/subscriptions',
    ),
    HomeModuleConfig(
      module: HomeModule.analytics,
      label: 'Analytics',
      description: 'Insights into your finances',
      icon: Icons.analytics,
      color: Color(0xFF00897B),
      route: '/analytics',
    ),
  ];

  static HomeModuleConfig get(HomeModule module) {
    return all.firstWhere((c) => c.module == module);
  }
}
