import 'package:first_app/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget {
  final String email;
  final String phone;
  final String college;
  final String department;
  final String year;

  const ContactCard({
    super.key,
    required this.email,
    required this.phone,
    required this.college,
    required this.department,
    required this.year,
  });

  Widget buildTile(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            height: 47,
            width: 47,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value.isEmpty ? "-" : value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.contact_phone,
                color: AppColors.primary,
              ),
              SizedBox(width: 10),
              Text(
                "Contact Details",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          buildTile(
            Icons.email_outlined,
            "Email",
            email,
          ),
          const Divider(),
          buildTile(
            Icons.phone_outlined,
            "Phone",
            phone,
          ),
          const Divider(),
          buildTile(
            Icons.school_outlined,
            "College",
            college,
          ),
          const Divider(),
          buildTile(
            Icons.account_tree_outlined,
            "Department",
            department,
          ),
          const Divider(),
          buildTile(
            Icons.calendar_month_outlined,
            "Year",
            year,
          ),
        ],
      ),
    );
  }
}
