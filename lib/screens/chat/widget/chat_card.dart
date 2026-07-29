import 'package:first_app/constants/app_colors.dart';
import 'package:first_app/screens/chat/chat_screen.dart';
import 'package:flutter/material.dart';

class ChatCard extends StatelessWidget {
  final Map<String, dynamic> user;
  final String name;
  final String lastMessage;
  final String time;

  const ChatCard({
    super.key,
    required this.user,
    required this.name,
    required this.lastMessage,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final hasPhoto =
        user["photoUrl"] != null && user["photoUrl"].toString().isNotEmpty;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatScreen(otherUserId: user["uid"],
otherUserName: user["name"],
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(
              bottom: BorderSide(
                color: AppColors.border,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              /// Profile Picture
              Stack(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.primary,
                    backgroundImage:
                        hasPhoto ? NetworkImage(user["photoUrl"]) : null,
                    child: !hasPhoto
                        ? Text(
                            name.isNotEmpty
                                ? name[0].toUpperCase()
                                : "?",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),

                  /// Online Indicator
                  if (user["isOnline"] == true)
                    Positioned(
                      right: 1,
                      bottom: 1,
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(width: 14),

              /// Name & Message
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),

                    user["typing"] == true
                        ? const Text(
                            "Typing...",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          )
                        : Text(
                            lastMessage.isEmpty
                                ? "Start a conversation"
                                : lastMessage,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              /// Time & Badge
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    time,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Container(
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      "1",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}