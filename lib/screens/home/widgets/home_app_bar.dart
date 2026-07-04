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


    String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good Morning 👋";
    } else if (hour < 17) {
      return "Good Afternoon ☀️";
    } else if (hour < 21) {
      return "Good Evening 🌇";
    } else {
      return "Good Night 🌙";
    }
  }

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
                  getGreeting(),
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