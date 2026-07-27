import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/constants/app_colors.dart';
import 'package:first_app/screens/chat/widget/chat_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.appBar,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          "Messages",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search_rounded,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
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
                  color: AppColors.textPrimary,
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
              horizontal: 16,
              vertical: 16,
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

                  final user =
                      userSnap.data!.data() as Map<String, dynamic>;

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