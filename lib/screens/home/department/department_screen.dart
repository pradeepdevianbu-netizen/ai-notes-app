import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/screens/home/department/department_preview_card.dart';
import 'package:first_app/screens/home/department/years_screen.dart';
import 'package:first_app/screens/home/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class DepartmentsScreen extends StatelessWidget {
  const DepartmentsScreen({super.key});

  Color getColor(int index) {
    final colors = [
      const Color(0xff5B8CFF),
      const Color(0xff36CFC9),
      const Color(0xff52C41A),
      const Color(0xffFFA940),
      const Color(0xffF759AB),
      const Color(0xff722ED1),
      const Color(0xff13C2C2),
    ];

    return colors[index % colors.length];
  }

  IconData getDepartmentIcon(String department) {
    switch (department.toLowerCase()) {
      case "artificial intelligence and data science":
      case "ai & ds":
        return Icons.psychology_rounded;

      case "computer science and engineering":
      case "cse":
        return Icons.code_rounded;

      case "information technology":
      case "it":
        return Icons.computer_rounded;

      case "electronics and communication engineering":
      case "ece":
        return Icons.memory_rounded;

      case "electrical and electronics engineering":
      case "eee":
        return Icons.electric_bolt_rounded;

      case "mechanical engineering":
        return Icons.precision_manufacturing_rounded;

      case "civil engineering":
        return Icons.architecture_rounded;

      case "biomedical engineering":
        return Icons.biotech_rounded;

      default:
        return Icons.school_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: Color(0xffF7F8FC),
      appBar: const CustomAppBar(
        title: "Departments",
         subtitle: "Browse your college departments",
          
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection("users").doc(uid).get(),
        builder: (context, userSnapshot) {
          if (!userSnapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final user = userSnapshot.data!.data() as Map<String, dynamic>;

          final collegeId = user["collegeId"];

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("departments")
                .where("collegeId", isEqualTo: collegeId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text("No Departments Found"),
                );
              }

              final departments = snapshot.data!.docs;

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: departments.length,
                itemBuilder: (context, index) {
                  final department =
                      departments[index].data() as Map<String, dynamic>;

                  return FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection("users")
                        .where(
                          "collegeId",
                          isEqualTo: collegeId,
                        )
                        .where(
                          "department",
                          isEqualTo: department["departmentName"],
                        )
                        .get(),
                    builder: (context, studentSnapshot) {
                      int count = 0;

                      if (studentSnapshot.hasData) {
                        count = studentSnapshot.data!.docs.length;
                      }

                      return DepartmentPreviewCard(
                        title: department["departmentName"],
                        studentCount: count,
                        color: getColor(index),
                        icon: getDepartmentIcon(
                          department["departmentName"],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => YearsScreen(
                                departmentName: department["departmentName"],
                              ),
                            ),
                          );
                        },
                      );
                    },
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
