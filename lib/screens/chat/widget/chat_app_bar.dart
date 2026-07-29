import 'package:first_app/constants/app_colors.dart';
import 'package:first_app/screens/chat/widget/service/chat_service.dart';
import 'package:first_app/services/presence_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final Map<String, dynamic> otherUser;

  ChatAppBar({
    super.key,
    required this.otherUser,
  });

  final PresenceService _presence = PresenceService();
  final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.appBar,
      surfaceTintColor: Colors.transparent,
      leadingWidth: 30,

      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.white,
        ),
        onPressed: () => Navigator.pop(context),
      ),

      titleSpacing: 0,

      title: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: _presence.getUserStatus(otherUser["uid"]),
        builder: (context, snapshot) {
          final data = snapshot.data?.data();

          final isOnline = data?["isOnline"] ?? false;

          return StreamBuilder<bool>(
            stream: _chatService.getTypingStatus(otherUser["uid"]),
            builder: (context, typingSnap) {
              final isTyping = typingSnap.data ?? false;

              return Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.primary,
                    backgroundImage:
                        otherUser["photoUrl"] != null &&
                                otherUser["photoUrl"] != ""
                            ? NetworkImage(otherUser["photoUrl"])
                            : null,
                    child:
                        otherUser["photoUrl"] == null ||
                                otherUser["photoUrl"] == ""
                            ? Text(
                                otherUser["name"][0].toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Text(
                          otherUser["name"],
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),

                        const SizedBox(height: 2),

                        Text(
                          isTyping
                              ? "Typing..."
                              : isOnline
                                  ? "Online"
                                  : "Offline",
                          style: TextStyle(
                            color: isTyping
                                ? Colors.lightGreenAccent
                                : Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),

      actions: [
        IconButton(
          onPressed: () {
            // Voice Call
          },
          icon: const Icon(
            Icons.call_outlined,
            color: Colors.white,
          ),
        ),

        IconButton(
          onPressed: () {
            // Video Call
          },
          icon: const Icon(
            Icons.videocam_outlined,
            color: Colors.white,
          ),
        ),

        PopupMenuButton(
          iconColor: Colors.white,
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 1,
              child: Text("View Profile"),
            ),
            PopupMenuItem(
              value: 2,
              child: Text("Search"),
            ),
            PopupMenuItem(
              value: 3,
              child: Text("Clear Chat"),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}