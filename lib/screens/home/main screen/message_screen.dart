import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/screens/chat/widget/chat_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7FB),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 16,
        title: Text(
          "Messages",
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF111827),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: Color(0xFF374151),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
              color: Color(0xFF374151),
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
            final ta = (a["lastMessageTime"] as Timestamp?)?.toDate() ??
                DateTime(2000);

            final tb = (b["lastMessageTime"] as Timestamp?)?.toDate() ??
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
              final chat = chats[index].data() as Map<String, dynamic>;

              final participants = List<String>.from(chat["participants"]);

              final otherUid = participants.firstWhere(
                (e) => e != currentUid,
              );

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection("users")
                    .doc(otherUid)
                    .get(),
                builder: (context, userSnap) {
                  if (!userSnap.hasData || !userSnap.data!.exists) {
                    return const SizedBox();
                  }

                  final user = userSnap.data!.data() as Map<String, dynamic>;

                  final name = user["name"] ?? "Unknown";

                  final lastMessage = chat["lastMessage"] ?? "";

                  final Timestamp? ts = chat["lastMessageTime"];

                  final time = ts == null
                      ? ""
                      : DateFormat("hh:mm a").format(ts.toDate());

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
