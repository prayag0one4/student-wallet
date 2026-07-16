import 'package:flutter/material.dart';
import '../../../../core/extensions/number_extension.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/contact.dart';

class ContactCard extends StatelessWidget {
  final Contact contact;
  final double netBalance;
  final VoidCallback onTap;

  const ContactCard({
    super.key,
    required this.contact,
    required this.netBalance,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isReceivable = netBalance > 0;
    final isPayable = netBalance < 0;
    final balanceColor = isReceivable
        ? AppTheme.successColor
        : isPayable
            ? AppTheme.warningColor
            : Colors.grey;

    final balanceText = isReceivable
        ? 'You will receive ${netBalance.toCurrency()}'
        : isPayable
            ? 'You will pay ${netBalance.abs().toCurrency()}'
            : 'Settled up';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(contact.avatarColor).withAlpha(40),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact.name,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        balanceText,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: balanceColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
