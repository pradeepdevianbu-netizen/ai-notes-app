import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/screens/connection/service/connection_service.dart';
import 'package:flutter/material.dart';

class PendingRequestsSection extends StatelessWidget {
  const PendingRequestsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final connectionService = ConnectionService();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("connection_requests")
          .where("receiverId", isEqualTo: uid)
          .where("status", isEqualTo: "pending")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.people_outline,
                  color: Colors.white54,
                  size: 45,
                ),
                SizedBox(height: 12),
                Text(
                  "No Pending Requests",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }

        final requests = snapshot.data!.docs;

        return Column(
          children: requests.map((request) {
            final data = request.data() as Map<String, dynamic>;
            final senderId = data["senderId"];

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection("users")
                  .doc(senderId)
                  .get(),
              builder: (context, userSnapshot) {
                if (!userSnapshot.hasData) {
                  return const SizedBox();
                }

                final sender =
                    userSnapshot.data!.data() as Map<String, dynamic>;

                return Container(
                  margin: const EdgeInsets.only(bottom: 18),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.blue.shade100,
                        child: Text(
                          sender["name"][0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      Text(
                        sender["name"],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        "${sender["department"]} • ${sender["year"]}",
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        "Wants to connect with you",
                        style: TextStyle(
                          color: Colors.white54,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () async {
                                await connectionService.rejectRequest(
                                  request.id,
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Request Rejected"),
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(
                                  color: Colors.white30,
                                ),
                                minimumSize: const Size.fromHeight(48),
                              ),
                              child: const Text("Reject"),
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                await connectionService.acceptRequest(
                                  request.id,
                                  senderId,
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Connection Accepted"),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2563EB),
                                foregroundColor: Colors.white,
                                minimumSize: const Size.fromHeight(48),
                              ),
                              child: const Text("Accept"),
                            ),
                          ),
                        ],
                      ),
                    ],
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