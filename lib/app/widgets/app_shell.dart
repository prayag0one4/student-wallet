import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/floating_nav_bar.dart';

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final isMore = location == '/more' || location.startsWith('/more');
    final selectedIndex = isMore ? 1 : 0;

    return Scaffold(
      body: child,
      bottomNavigationBar: FloatingNavBar(
        selectedIndex: selectedIndex,
        onTabChanged: (index) {
          if (index == 0) {
            context.go('/');
          } else {
            context.go('/more');
          }
        },
      ),
    );
  }
}
