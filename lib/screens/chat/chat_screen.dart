import 'package:first_app/screens/chat/widget/service/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:first_app/services/presence_service.dart';

class ChatScreen extends StatefulWidget {
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

  String? replyMessage;
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
    messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
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
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                    );
                  }
                });

                final docs = snapshot.data!.docs;

                final currentUid = FirebaseAuth.instance.currentUser!.uid;

                return ListView.builder(
                  controller: _scrollController,
                  reverse: false,
                  padding: const EdgeInsets.only(bottom: 80),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;

                    final bool isMe = data["senderId"] == currentUid;

                    final Timestamp? ts = data["timestamp"];

                    String time = "";

                    if (ts != null) {
                      time = DateFormat("hh:mm a").format(ts.toDate());
                    }

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              data["text"],
                              style: TextStyle(
                                color: isMe ? Colors.white : Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              time,
                              style: TextStyle(
                                color: isMe
                                    ? Colors.white70
                                    : Colors.grey.shade700,
                                fontSize: 11,
                              ),
                            ),
                          ],
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
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                replySender!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              Text(
                                replyMessage!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              replyMessage = null;
                              replySender = null;
                            });
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),

                // TextField here...

                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        focusNode: _focusNode,
                        onTap: () {
                          Future.delayed(const Duration(milliseconds: 250), () {
                            _scrollToBottom();
                          });
                        },
                        onChanged: (value) async {
                          if (value.isNotEmpty && !_isTyping) {
                            setState(() => _isTyping = true);

                            await _chatService.setTyping(
                              otherUserId: widget.otherUser["uid"],
                              isTyping: true,
                            );
                          }

                          if (value.isEmpty && _isTyping) {
                            setState(() => _isTyping = false);

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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
