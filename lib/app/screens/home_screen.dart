import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Wallet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.1,
              children: [
                _FeatureCard(
                  icon: Icons.receipt_long,
                  label: 'Expenses',
                  color: const Color(0xFF4A90D9),
                  onTap: () => context.push('/expenses'),
                ),
                _FeatureCard(
                  icon: Icons.swap_horiz,
                  label: 'Borrow / Lend',
                  color: const Color(0xFF50C878),
                  onTap: () => context.push('/ledger'),
                ),
                _FeatureCard(
                  icon: Icons.call_split,
                  label: 'Bill Splitter',
                  color: const Color(0xFFFFA726),
                  onTap: () => context.push('/split'),
                ),
                _FeatureCard(
                  icon: Icons.pie_chart,
                  label: 'Budgets',
                  color: const Color(0xFFE53935),
                  onTap: () => context.push('/budget'),
                ),
                _FeatureCard(
                  icon: Icons.subscriptions,
                  label: 'Subscriptions',
                  color: const Color(0xFF7B1FA2),
                  onTap: () => context.push('/subscriptions'),
                ),
                _FeatureCard(
                  icon: Icons.analytics,
                  label: 'Analytics',
                  color: const Color(0xFF00897B),
                  onTap: () => context.push('/analytics'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: Theme.of(context).textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
