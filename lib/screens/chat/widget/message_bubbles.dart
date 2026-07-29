import 'package:first_app/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final Map<String, dynamic> message;
  final bool isMe;

  final VoidCallback? onReply;
  final VoidCallback? onDelete;
  final VoidCallback? onCopy;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    this.onReply,
    this.onDelete,
    this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final String text = message["text"] ?? "";
    final String type = message["type"] ?? "text";
    final bool isRead = message["isRead"] ?? false;

    final DateTime? time =
        message["timestamp"] != null
            ? message["timestamp"].toDate()
            : null;

    final Map<String, dynamic>? reply =
        message["replyToMessage"];

    return GestureDetector(
      onLongPress: () => _showOptions(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 4,
        ),
        child: Align(
          alignment:
              isMe
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
          child: AnimatedContainer(
            duration: const Duration(
              milliseconds: 220,
            ),
            curve: Curves.easeInOut,
            constraints: BoxConstraints(
              maxWidth:
                  MediaQuery.of(context).size.width *
                  .75,
            ),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:
                  isMe
                      ? AppColors.primary
                      : AppColors.surface,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: Radius.circular(
                  isMe ? 18 : 6,
                ),
                bottomRight: Radius.circular(
                  isMe ? 6 : 18,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.05),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                /// Reply Preview
                if (reply != null)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                      bottom: 8,
                    ),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:
                          isMe
                              ? Colors.white24
                              : Colors.grey.shade200,
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Reply",
                          style: TextStyle(
                            color:
                                isMe
                                    ? Colors.white
                                    : AppColors.primary,
                            fontWeight:
                                FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          reply["text"] ?? "",
                          maxLines: 2,
                          overflow:
                              TextOverflow.ellipsis,
                          style: TextStyle(
                            color:
                                isMe
                                    ? Colors.white70
                                    : AppColors
                                        .textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                /// Message Type
                if (type == "text")
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.4,
                      color:
                          isMe
                              ? Colors.white
                              : AppColors.textPrimary,
                    ),
                  ),

                if (type == "image")
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(12),
                    child: Image.network(
                      message["imageUrl"] ?? "",
                      fit: BoxFit.cover,
                    ),
                  ),

                const SizedBox(height: 6),

                Align(
                  alignment:
                      Alignment.bottomRight,
                  child: Row(
                    mainAxisSize:
                        MainAxisSize.min,
                    children: [

                      Text(
                        time == null
                            ? ""
                            : DateFormat(
                                "hh:mm a",
                              ).format(time),
                        style: TextStyle(
                          fontSize: 11,
                          color:
                              isMe
                                  ? Colors.white70
                                  : AppColors
                                      .textSecondary,
                        ),
                      ),

                      if (isMe)
                        Padding(
                          padding:
                              const EdgeInsets.only(
                            left: 4,
                          ),
                          child: Icon(
                            isRead
                                ? Icons.done_all
                                : Icons.done,
                            size: 17,
                            color:
                                isRead
                                    ? Colors
                                        .lightBlueAccent
                                    : Colors.white70,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
    void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.reply_rounded,
                  color: AppColors.primary,
                ),
                title: const Text("Reply"),
                onTap: () {
                  Navigator.pop(context);
                  onReply?.call();
                },
              ),

              ListTile(
                leading: const Icon(
                  Icons.copy_rounded,
                  color: AppColors.primary,
                ),
                title: const Text("Copy"),
                onTap: () {
                  Navigator.pop(context);
                  onCopy?.call();
                },
              ),

              if (isMe)
                ListTile(
                  leading: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.red,
                  ),
                  title: const Text(
                    "Delete",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    onDelete?.call();
                  },
                ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}