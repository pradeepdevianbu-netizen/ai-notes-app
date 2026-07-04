import 'package:flutter/material.dart';

class DepartmentCard extends StatelessWidget {
  const DepartmentCard({
    super.key,
    required this.title,
    required this.icon,
    required this.studentCount,
    this.onTap,
  });

  final String title;
  final IconData icon;
  final int studentCount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(
            color: colors.primary.withValues(alpha: 0.10),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: colors.primary.withValues(alpha: 0.12),
              child: Icon(
                icon,
                color: colors.primary,
                size: 26,
              ),
            ),

            const Spacer(),

            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 6),

            Text(
              "$studentCount Students",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}