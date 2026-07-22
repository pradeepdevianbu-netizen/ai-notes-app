import 'package:first_app/constants/app_colors.dart';
import 'package:first_app/screens/home/main%20screen/widget/profile_tile.dart';

import 'package:flutter/material.dart';

class SocialCard extends StatelessWidget {
  final String github;
  final String linkedin;
  final String portfolio;

  const SocialCard({
    super.key,
    required this.github,
    required this.linkedin,
    required this.portfolio,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
                Icons.language,
                color: AppColors.primary,
              ),
              SizedBox(width: 10),
              Text(
                "Social Links",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ProfileTile(
            icon: Icons.code,
            title: "GitHub",
            subtitle: github.isEmpty ? "Add your GitHub profile" : github,
            onTap: () {},
          ),
          ProfileTile(
            icon: Icons.work_outline,
            title: "LinkedIn",
            subtitle: linkedin.isEmpty ? "Add your LinkedIn profile" : linkedin,
            onTap: () {},
          ),
          ProfileTile(
            icon: Icons.public,
            title: "Portfolio",
            subtitle: portfolio.isEmpty ? "Add your portfolio" : portfolio,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
