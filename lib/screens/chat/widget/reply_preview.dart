import 'package:first_app/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ReplyPreview extends StatelessWidget {
  final Map<String, dynamic>? replyMessage;
  final bool isMe;
  final VoidCallback onCancel;

  const ReplyPreview({
    super.key,
    required this.replyMessage,
    required this.isMe,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    if (replyMessage == null) {
      return const SizedBox.shrink();
    }

    final senderName = isMe ? "You" : (replyMessage!["senderName"] ?? "User");

    final text = replyMessage!["text"] ?? "";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(
            color: AppColors.border,
          ),
          bottom: BorderSide(
            color: AppColors.border,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Replying to $senderName",
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  text,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: onCancel,
            icon: const Icon(
              Icons.close,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}