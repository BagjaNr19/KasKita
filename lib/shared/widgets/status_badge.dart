import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/bill_model.dart';

class StatusBadge extends StatelessWidget {
  final BillStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;
    String label;

    switch (status) {
      case BillStatus.paid:
        color = AppColors.success;
        icon = Icons.check_circle_rounded;
        label = 'Lunas';
        break;
      case BillStatus.unpaid:
        color = AppColors.error;
        icon = Icons.cancel_rounded;
        label = 'Belum Lunas';
        break;
      case BillStatus.pending:
        color = AppColors.warning;
        icon = Icons.pending_rounded;
        label = 'Menunggu';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class GeneralStatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;

  const GeneralStatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
