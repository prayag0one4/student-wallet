import 'package:flutter/material.dart';
import '../../domain/entities/group_member_entity.dart';

class MemberCard extends StatelessWidget {
  final GroupMember member;
  final double? balance;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const MemberCard({
    super.key,
    required this.member,
    this.balance,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    Color balanceColor = Colors.grey;
    if (balance != null) {
      if (balance! > 0.01) {
        balanceColor = Colors.green;
      } else if (balance! < -0.01) {
        balanceColor = Colors.orange;
      }
    }

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Color(member.avatarColor),
                child: Text(
                  member.name.isNotEmpty ? member.name[0].toUpperCase() : '?',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(member.name,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500)),
                    if (member.phone != null && member.phone!.isNotEmpty)
                      Text(member.phone!,
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey[600])),
                  ],
                ),
              ),
              if (balance != null)
                Text(
                  balance! > 0.01
                      ? '+₹${balance!.toStringAsFixed(0)}'
                      : balance! < -0.01
                          ? '-₹${balance!.abs().toStringAsFixed(0)}'
                          : 'Settled',
                  style: TextStyle(
                    color: balanceColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              if (onDelete != null)
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
