import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/screens/connection/service/connection_service.dart';
import 'package:first_app/screens/home/department/student_profile_screen.dart';
import 'package:first_app/screens/home/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:first_app/screens/home/department/student_card.dart';

class StudentsScreen extends StatelessWidget {
  final String departmentName;
  final String year;

  const StudentsScreen({
    super.key,
    required this.departmentName,
    required this.year,
  });

  @override
  Widget build(BuildContext context) {
    final ConnectionService connectionService = ConnectionService();
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .where("department", isEqualTo: departmentName)
          .where("year", isEqualTo: year)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final currentUser = FirebaseAuth.instance.currentUser;

        final students = (snapshot.data?.docs ?? []).where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return data["uid"] != currentUser?.uid;
        }).toList();

        if (students.isEmpty) {
          return Scaffold(
            appBar: CustomAppBar(
              title: departmentName,
              subtitle: "$year • 0 Students",
            ),
            body: const Center(
              child: Text(
                "No Students Found",
                style: TextStyle(fontSize: 18),
              ),
            ),
          );
        }

        return Scaffold(
          appBar: CustomAppBar(
            title: departmentName,
            subtitle: "$year • ${students.length} Students",
            actions: [
              IconButton(
                icon: const Icon(Icons.search_rounded),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.tune_rounded),
                onPressed: () {},
              ),
            ],
          ),
          body: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index].data() as Map<String, dynamic>;

              return StudentCard(
                student: student,
                onConnect: () async {
                  bool success = await connectionService.sendConnectionRequest(
                    student["uid"],
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        success
                            ? "Connection request sent"
                            : "Request already exists",
                      ),
                    ),
                  );
                },
                onView: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StudentProfileScreen(
                        student: student,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
