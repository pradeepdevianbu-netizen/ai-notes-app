import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/screens/chat/widget/chat_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        centerTitle: false,
        title: const Text(
          "Messages",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search_rounded,
              color: Colors.black87,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black87,
            ),
          ),
        ],
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("chats")
            .where("participants", arrayContains: currentUid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No conversations yet",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }

          final chats = snapshot.data!.docs;

          chats.sort((a, b) {
            final ta =
                (a["lastMessageTime"] as Timestamp?)?.toDate() ??
                    DateTime(2000);

            final tb =
                (b["lastMessageTime"] as Timestamp?)?.toDate() ??
                    DateTime(2000);

            return tb.compareTo(ta);
          });

          return ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat =
                  chats[index].data() as Map<String, dynamic>;

              final participants =
                  List<String>.from(chat["participants"]);

              final otherUid = participants.firstWhere(
                (e) => e != currentUid,
              );

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection("users")
                    .doc(otherUid)
                    .get(),
                builder: (context, userSnap) {
                  if (!userSnap.hasData ||
                      !userSnap.data!.exists) {
                    return const SizedBox();
                  }

                  final user = userSnap.data!.data()
                      as Map<String, dynamic>;

                  final name = user["name"] ?? "Unknown";

                  final lastMessage =
                      chat["lastMessage"] ?? "";

                  final Timestamp? ts =
                      chat["lastMessageTime"];

                  final time = ts == null
                      ? ""
                      : DateFormat("hh:mm a")
                          .format(ts.toDate());

                  return ChatCard(
                    user: user,
                    name: name,
                    lastMessage: lastMessage,
                    time: time,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}