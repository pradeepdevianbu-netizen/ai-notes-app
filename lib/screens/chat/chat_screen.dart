import 'package:first_app/screens/chat/widget/service/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:first_app/services/presence_service.dart';

class ChatScreen extends StatefulWidget {
  Widget buildMessageBubble(
    Map<String, dynamic> data,
    bool isMe,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isMe ? const Color(0xFF0084FF) : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(18),
          topRight: const Radius.circular(18),
          bottomLeft: Radius.circular(isMe ? 18 : 5),
          bottomRight: Radius.circular(isMe ? 5 : 18),
        ),
      ),
      child: Text(data["text"]),
    );
  }

  final Map<String, dynamic> otherUser;

  const ChatScreen({
    super.key,
    required this.otherUser,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService _chatService = ChatService();
  final TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final PresenceService _presence = PresenceService();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController searchController = TextEditingController();

  String searchQuery = "";

  int _lastMessageCount = 0;
  bool _isTyping = false;

  Map<String, dynamic>? replyMessage;
  String? replySender;

  @override
  void initState() {
    super.initState();

    _chatService.markMessagesAsRead(
      widget.otherUser["uid"],
    );
  }
@override
void dispose() {
  _chatService.setTyping(
    otherUserId: widget.otherUser["uid"],
    isTyping: false,
  );

  messageController.dispose();
  _scrollController.dispose();
  _focusNode.dispose();

  super.dispose();
}
  

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: _presence.getUserStatus(widget.otherUser["uid"]),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text(widget.otherUser["name"]);
            }

            final data = snapshot.data!.data();
            final isOnline = data?["isOnline"] ?? false;

            return StreamBuilder<bool>(
              stream: _chatService.getTypingStatus(widget.otherUser["uid"]),
              builder: (context, typingSnapshot) {
                final isTyping = typingSnapshot.data ?? false;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.otherUser["name"],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      isTyping
                          ? "Typing..."
                          : (isOnline ? "Online" : "Offline"),
                      style: TextStyle(
                        color: isTyping
                            ? Colors.blue
                            : (isOnline ? Colors.green : Colors.grey),
                        fontSize: 13,
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
      body: Column(
        children: [
          /// Messages
          Expanded(
            child: StreamBuilder(
              stream: _chatService.getMessages(widget.otherUser["uid"]),
              builder: (context, snapshot) {
                _chatService.markMessagesAsRead(
                  widget.otherUser["uid"],
                );

                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final docs = snapshot.data!.docs;

                final currentUid = FirebaseAuth.instance.currentUser!.uid;

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: const EdgeInsets.only(bottom: 80),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final status = data["status"] ?? "sent";
                    final isRead = data["isRead"] ?? false;

                    final bool isMe = data["senderId"] == currentUid;

                    final bool isReplyMine = replyMessage != null &&
                        replyMessage!["senderId"] == currentUid;

                    final Timestamp? ts = data["timestamp"];

                    String time = "";

                    if (ts != null) {
                      time = DateFormat("hh:mm a").format(ts.toDate());
                    }
                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75,
                        ),
                        child: IntrinsicWidth(
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isMe ? Colors.blue : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Message
                                  Text(
                                    data["text"],
                                    style: TextStyle(
                                      color: isMe ? Colors.white : Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),

                                  const SizedBox(height: 2),

                                  // Time + Tick
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        time,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: isMe
                                              ? Colors.white70
                                              : Colors.grey,
                                        ),
                                      ),
                                      if (isMe) ...[
                                        const SizedBox(width: 4),
                                        Icon(
                                          isRead ? Icons.done_all : Icons.done,
                                          size: 16,
                                          color: isRead
                                              ? Colors.lightBlueAccent
                                              : Colors.white70,
                                        )
                                      ],
                                    ],
                                  ),
                                ]),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          /// Message Input
        ],
      ),
      bottomNavigationBar: AnimatedPadding(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SafeArea(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            margin: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 4,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              if (replyMessage != null)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Replying to",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              replyMessage?["text"]?.toString() ?? "",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            replyMessage = null;
                          });
                        },
                      ),
                    ],
                  ),
                ),

              // Message input field

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      focusNode: _focusNode,
                      onTap: () {
                        Future.delayed(const Duration(milliseconds: 200), () {
                          _scrollToBottom();
                        });
                      },
                      onChanged: (value) async {
                        if (value.trim().isNotEmpty && !_isTyping) {
                          _isTyping = true;

                          await _chatService.setTyping(
                            otherUserId: widget.otherUser["uid"],
                            isTyping: true,
                          );
                        }

                        if (value.trim().isEmpty && _isTyping) {
                          _isTyping = false;

                          await _chatService.setTyping(
                            otherUserId: widget.otherUser["uid"],
                            isTyping: false,
                          );
                        }
                      },
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.blue,
                    child: IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        await _chatService.sendMessage(
                          otherUserId: widget.otherUser["uid"],
                          text: messageController.text,
                          replyToMessage: replyMessage,
                          replyToSender: replySender,
                        );
                        _isTyping = false;

                        await _chatService.setTyping(
                          otherUserId: widget.otherUser["uid"],
                          isTyping: false,
                        );

                        messageController.clear();

                        setState(() {
                          replyMessage = null;
                          replySender = null;
                          _isTyping = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
