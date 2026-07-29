import 'package:first_app/constants/app_colors.dart';
import 'package:flutter/material.dart';

class MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback? onAttachment;
  final VoidCallback? onCamera;
  final VoidCallback? onEmoji;
  final VoidCallback? onMic;

  const MessageInput({
    super.key,
    required this.controller,
    required this.onSend,
    this.onAttachment,
    this.onCamera,
    this.onEmoji,
    this.onMic,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border(
            top: BorderSide(
              color: AppColors.border.withOpacity(.5),
            ),
          ),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: onEmoji,
              icon: const Icon(Icons.emoji_emotions_outlined),
            ),

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: AppColors.border,
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: onAttachment,
                      icon: const Icon(Icons.attach_file),
                    ),

                    Expanded(
                      child: TextField(
                        controller: controller,
                        minLines: 1,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          hintText: "Type a message...",
                          border: InputBorder.none,
                          isCollapsed: true,
                        ),
                      ),
                    ),

                    IconButton(
                      onPressed: onCamera,
                      icon: const Icon(Icons.photo_camera_outlined),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 8),

            InkWell(
              onTap: onSend,
              borderRadius: BorderRadius.circular(30),
              child: Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(width: 6),

            IconButton(
              onPressed: onMic,
              icon: const Icon(Icons.mic_none_rounded),
            ),
          ],
        ),
      ),
    );
  }
}