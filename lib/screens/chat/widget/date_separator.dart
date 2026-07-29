import 'package:first_app/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateSeparator extends StatelessWidget {
  final DateTime date;

  const DateSeparator({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 14,
      ),
      child: Row(
        children: [
          const Expanded(
            child: Divider(
              color: AppColors.border,
              thickness: 1,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.border,
                ),
              ),
              child: Text(
                _getLabel(date),
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const Expanded(
            child: Divider(
              color: AppColors.border,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }

  static String _getLabel(DateTime date) {
    final now = DateTime.now();

    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final yesterday = today.subtract(
      const Duration(days: 1),
    );

    final messageDate = DateTime(
      date.year,
      date.month,
      date.day,
    );

    if (messageDate == today) {
      return "Today";
    }

    if (messageDate == yesterday) {
      return "Yesterday";
    }

    return DateFormat("dd MMM yyyy").format(date);
  }
}