import 'package:flutter/material.dart';

class BalanceSummaryCard extends StatelessWidget {
  final double balance;

  const BalanceSummaryCard({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    final isPositive = balance > 0.01;
    final isSettled = balance.abs() < 0.01;
    final color = isSettled
        ? Colors.grey
        : isPositive
            ? Colors.green
            : Colors.orange;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Row(
        children: [
          Icon(
            isSettled
                ? Icons.check_circle_outline
                : isPositive
                    ? Icons.arrow_downward
                    : Icons.arrow_upward,
            color: color,
            size: 28,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isSettled
                      ? 'All settled up'
                      : isPositive
                          ? 'You should receive'
                          : 'You owe',
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isSettled
                      ? 'No pending balances'
                      : '₹${balance.abs().toStringAsFixed(2)}',
                  style: TextStyle(
                    color: color,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
