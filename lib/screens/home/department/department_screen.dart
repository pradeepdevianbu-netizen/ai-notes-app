import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/screens/home/department/department_preview_card.dart';
import 'package:first_app/screens/home/department/years_screen.dart';
import 'package:flutter/material.dart';

class DepartmentsScreen extends StatelessWidget {
  const DepartmentsScreen({super.key});

  Color getColor(int index) {
    final colors = [
      const Color(0xFF5B8CFF),
      const Color(0xFF36CFC9),
      const Color(0xFF52C41A),
      const Color(0xFFFFA940),
      const Color(0xFFF759AB),
      const Color(0xFF722ED1),
      const Color(0xFF13C2C2),
      const Color(0xFFFA8C16),
    ];

    return colors[index % colors.length];
  }

  IconData getDepartmentIcon(String department) {
    switch (department.toLowerCase()) {
      case "ai & ds":
        return Icons.psychology_rounded;

      case "computer science and engineering":
      case "cse":
        return Icons.code_rounded;

      case "information technology":
      case "it":
        return Icons.computer_rounded;

      case "ece":
        return Icons.memory_rounded;

      case "eee":
        return Icons.electric_bolt_rounded;

      case "mechanical engineering":
      case "mech":
        return Icons.precision_manufacturing_rounded;

      case "civil engineering":
      case "civil":
        return Icons.architecture_rounded;

      case "biomedical engineering":
      case "bme":
        return Icons.biotech_rounded;

      case "automobile engineering":
        return Icons.directions_car_rounded;

      case "aeronautical engineering":
        return Icons.flight_rounded;

      default:
        return Icons.school_rounded;
    }
  }

  String getDepartmentSubtitle(String department) {
    switch (department.toLowerCase()) {
      case "ai & ds":
        return "Artificial Intelligence & Data Science";

      case "cse":
      case "computer science and engineering":
        return "Computer Science & Engineering";

      case "it":
      case "information technology":
        return "Information Technology";

      case "ece":
        return "Electronics & Communication Engineering";

      case "eee":
        return "Electrical & Electronics Engineering";

      case "mech":
      case "mechanical engineering":
        return "Mechanical Engineering";

      case "civil":
      case "civil engineering":
        return "Civil Engineering";

      case "bme":
      case "biomedical engineering":
        return "Biomedical Engineering";

      default:
        return department;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),

      appBar: AppBar(
        title: const Text(
          "Departments",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("departments")
            .orderBy("departmentName")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
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
                      "department",
                      isEqualTo: department["departmentName"],
                    )
                    .get(),
                builder: (context, userSnapshot) {
                  int studentCount = 0;

                  if (userSnapshot.hasData) {
                    studentCount = userSnapshot.data!.docs.length;
                  }

                  return DepartmentPreviewCard(
                    title: department["departmentName"],
                    subtitle: getDepartmentSubtitle(
                      department["departmentName"],
                    ),
                    studentCount: studentCount,
                    color: getColor(index),
                    icon: getDepartmentIcon(
                      department["departmentName"],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => YearsScreen(
                            departmentName:
                                department["departmentName"],
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
      ),
    );
  }
}