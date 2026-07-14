import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/screens/connection/service/connection_service.dart';
import 'package:flutter/material.dart';

import '../../chat/chat_screen.dart';


class MyConnectionsSection extends StatelessWidget {
  const MyConnectionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("connections")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final docs = snapshot.data!.docs;

        final connectedUsers = docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;

          return data["user1"] == currentUid ||
              data["user2"] == currentUid;
        }).toList();

        if (connectedUsers.isEmpty) {
          return const Center(
            child: Text(
              "No Connections Yet",
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        return Column(
          children: connectedUsers.map((doc) {
            final data = doc.data() as Map<String, dynamic>;

            final otherUid =
                data["user1"] == currentUid
                    ? data["user2"]
                    : data["user1"];

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection("users")
                  .doc(otherUid)
                  .get(),
              builder: (context, userSnapshot) {
                if (!userSnapshot.hasData) {
                  return const SizedBox();
                }

                final user =
                    userSnapshot.data!.data() as Map<String, dynamic>;

                return Card(
                  color: const Color(0xFF1E293B),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        user["name"][0].toUpperCase(),
                      ),
                    ),
                    title: Text(
                      user["name"],
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      user["department"],
                      style:
                          const TextStyle(color: Colors.white70),
                    ),
                    trailing: PopupMenuButton(
                      color: Colors.white,
                      itemBuilder: (_) => const [
                        PopupMenuItem(
                          value: "disconnect",
                          child: Text("Disconnect"),
                        ),
                      ],
                      onSelected: (value) async {
                        if (value == "disconnect") {
                          await ConnectionService()
                              .disconnect(otherUid);
                        }
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                            otherUser: user,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}