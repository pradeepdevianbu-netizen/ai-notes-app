import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  final String username;
  final String collegeName;
  final String? profileImageUrl;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;

  const HomeAppBar({
    super.key,
    required this.username,
    required this.collegeName,
    this.profileImageUrl,
    this.onNotificationTap,
    this.onProfileTap,
  });

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good Morning 👋";
    } else if (hour < 17) {
      return "Good Afternoon ☀️";
    } else if (hour < 21) {
      return "Good Evening 🌆";
    } else {
      return "Good Night 🌙";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 18, 18, 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onProfileTap,
            child: Hero(
              tag: "profile",
              child: CircleAvatar(
                radius: 28,
                backgroundColor: Colors.blue.shade100,
                backgroundImage: profileImageUrl != null
                    ? NetworkImage(profileImageUrl!)
                    : null,
                child: profileImageUrl == null
                    ? const Icon(
                        Icons.person,
                        size: 30,
                        color: Colors.blue,
                      )
                    : null,
              ),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getGreeting(),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  username,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    Icon(
                      Icons.school_rounded,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        collegeName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Stack(
            children: [
              IconButton(
                onPressed: onNotificationTap,
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  size: 30,
                ),
              ),

              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  height: 10,
                  width: 10,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}