import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
    required this.userName,
    this.onNotificationTap,
    this.onProfileTap,
  });

  final String userName;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      child: Row(
        children: [
          // Greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "👋 Good Morning",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  userName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),

          // Notification
          IconButton(
            onPressed: onNotificationTap,
            icon: const Icon(Icons.notifications_outlined),
          ),

          // Profile
          GestureDetector(
            onTap: onProfileTap,
            child: const CircleAvatar(
              radius: 20,
              child: Icon(Icons.person),
            ),
          ),
        ],
      ),
    );
  }
}