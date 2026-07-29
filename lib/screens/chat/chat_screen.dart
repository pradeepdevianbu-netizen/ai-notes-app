import 'package:first_app/screens/chat/widget/date_separator.dart';
import 'package:first_app/screens/chat/widget/message_bubbles.dart';
import 'package:first_app/screens/chat/widget/message_input.dart';
import 'package:first_app/screens/chat/widget/reply_preview.dart';
import 'package:first_app/screens/chat/widget/service/chat_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  final String otherUserId;
  final String otherUserName;

  const ChatScreen({
    super.key,
    required this.otherUserId,
    required this.otherUserName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService _chatService = ChatService();

  final TextEditingController messageController = TextEditingController();

  final String currentUid = FirebaseAuth.instance.currentUser!.uid;

  Map<String, dynamic>? replyMessage;

  void cancelReply() {
    setState(() {
      replyMessage = null;
    });
  }

  void copyMessage(String text) {
    Clipboard.setData(
      ClipboardData(
        text: text,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Message copied",
        ),
      ),
    );
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();

    if (text.isEmpty) return;

    await _chatService.sendMessage(
      receiverId: widget.otherUserId,
      text: text,
      replyMessage: replyMessage,
    );

    messageController.clear();

    cancelReply();
  }

  bool shouldShowDate(
    DateTime current,
    DateTime? previous,
  ) {
    if (previous == null) {
      return true;
    }

    return current.day != previous.day ||
        current.month != previous.month ||
        current.year != previous.year;
  }

  @override
  void dispose() {
    messageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  const Color.fromARGB(255, 17, 89, 68),
      appBar: AppBar(
        backgroundColor: const Color(0xff075E54),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.otherUserName,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
            StreamBuilder<bool>(
              stream: _chatService.getTypingStatus(widget.otherUserId),
              builder: (context, snapshot) {
                if (snapshot.data == true) {
                  return const Text(
                    "typing...",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  );
                }

                return const SizedBox();
              },
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: const Color(0xffEFEAE2),
              child: StreamBuilder<QuerySnapshot>(
                stream: _chatService.getMessages(widget.otherUserId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final docs = snapshot.data!.docs;

                  if (docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "Start conversation",
                      ),
                    );
                  }

                  DateTime? previousDate;

                  return ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];

                      final data = doc.data() as Map<String, dynamic>;

                      final Timestamp timestamp =
                          data["timestamp"] ?? Timestamp.now();

                      final currentDate = timestamp.toDate();

                      final showDate = shouldShowDate(
                        currentDate,
                        previousDate,
                      );

                      previousDate = currentDate;

                      return Column(
                        children: [
                          if (showDate)
                            DateSeparator(
                              date: currentDate,
                            ),
                          MessageBubble(
                            message: data,
                            isMe: data["senderId"] == currentUid,
                            onReply: () {
                              setState(() {
                                replyMessage = data;
                              });
                            },
                            onCopy: () {
                              copyMessage(
                                data["text"] ?? "",
                              );
                            },
                            onDelete: () async {
                              await _chatService.deleteMessage(
                                widget.otherUserId,
                                doc.id,
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
          ReplyPreview(
            replyMessage: replyMessage,
            isMe: replyMessage?["senderId"] == currentUid,
            onCancel: cancelReply,
          ),
          MessageInput(
            controller: messageController,
            onSend: sendMessage,
            onAttachment: () {},
            onCamera: () {},
            onEmoji: () {},
            onMic: () {},
          ),
        ],
      ),
    );
  }
}
