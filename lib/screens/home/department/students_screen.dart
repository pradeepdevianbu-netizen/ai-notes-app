import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:first_app/screens/home/department/student_card.dart';
import 'package:first_app/screens/home/department/student_profile_screen.dart';

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

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: Text(departmentName),
            ),
            body: const Center(
              child: Text(
                "No Students Found",
                style: TextStyle(fontSize: 18),
              ),
            ),
          );
        }

        final students = snapshot.data!.docs;

        return Scaffold(
          backgroundColor: const Color(0xffF7F8FC),

          appBar: AppBar(
            toolbarHeight: 80,
            centerTitle: false,
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  departmentName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    Text(
                      year,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Icon(
                      Icons.groups_rounded,
                      size: 18,
                      color: Colors.grey.shade600,
                    ),

                    const SizedBox(width: 5),

                    Text(
                      "${students.length} Students",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          body: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: students.length,
            itemBuilder: (context, index) {

              final student =
                  students[index].data() as Map<String, dynamic>;

              return StudentCard(
                student: student,

                onConnect: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Connection request sent to ${student["name"]}",
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