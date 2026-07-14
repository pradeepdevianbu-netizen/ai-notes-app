import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/screens/connection/connection_request_screen.dart';
import 'package:flutter/material.dart';
import 'widgets/my_connections_section.dart';

class ConnectionScreen extends StatelessWidget {
  const ConnectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        centerTitle: false,
        title: const Text(
          "Connect",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          /// Connection Requests
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("connection_requests")
                .where(
                  "receiverId",
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                )
                .where(
                  "status",
                  isEqualTo: "pending",
                )
                .snapshots(),
            builder: (context, snapshot) {
              int count = 0;

              if (snapshot.hasData) {
                count = snapshot.data!.docs.length;
              }

              return _buildCard(
                context,
                icon: Icons.person_add_alt_1,
                title: "Connection Requests",
                subtitle: "Manage pending requests",
                badge: count,
                color: Colors.blue,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ConnectionRequestsScreen(),
                    ),
                  );
                },
              );
            },
          ),

          const SizedBox(height: 18),

          /// My Connections
          _buildCard(
            context,
            icon: Icons.people,
            title: "My Connections",
            subtitle: "Students you're connected with",
            color: Colors.green,
            onTap: () {},
          ),

          const SizedBox(height: 18),
          const MyConnectionsSection(),

          /// Suggested Students
          _buildCard(
            context,
            icon: Icons.person_search,
            title: "Suggested Students",
            subtitle: "Find new students",
            color: Colors.orange,
            onTap: () {},
          ),

          const SizedBox(height: 18),

          /// Trending Students
          _buildCard(
            context,
            icon: Icons.local_fire_department,
            title: "Trending Students",
            subtitle: "Most connected this week",
            color: Colors.redAccent,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    int badge = 0,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.15),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color.withOpacity(.15),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      if (badge > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "$badge",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white54,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
