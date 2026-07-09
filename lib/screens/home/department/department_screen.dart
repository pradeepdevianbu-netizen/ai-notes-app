import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:first_app/screens/home/department/department_gridcolor.dart';
import 'package:first_app/screens/home/department/years_screen.dart';

class DepartmentsScreen extends StatefulWidget {
  const DepartmentsScreen({super.key});

  @override
  State<DepartmentsScreen> createState() => _DepartmentsScreenState();
}

class _DepartmentsScreenState extends State<DepartmentsScreen> {
  List<Map<String, dynamic>> departments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDepartments();
  }

  Future<void> fetchDepartments() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) return;

      // Fetch logged-in user's profile
      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      final String collegeId = userDoc["collegeId"];

      // Fetch only that college's departments
      final snapshot = await FirebaseFirestore.instance
          .collection("departments")
          .where("collegeId", isEqualTo: collegeId)
          .get();

      departments = snapshot.docs.map((doc) {
        return {
          "departmentName": doc["departmentName"],
        };
      }).toList();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

      setState(() {
        isLoading = false;
      });
    }
  }

  Color getColor(int index) {
    final colors = [
      const Color(0xFF5B8CFF),
      const Color(0xFF36CFC9),
      const Color(0xFF52C41A),
      const Color(0xFFFFA940),
      const Color(0xFFFADB14),
      const Color(0xFFB37FEB),
      const Color(0xFFFF6B6B),
      const Color(0xFF00C2A8),
      const Color(0xFF845EC2),
      const Color(0xFFFF8066),
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
        return Icons.architecture_rounded;

      case "biomedical engineering":
      case "bme":
        return Icons.biotech_rounded;

      case "automobile engineering":
        return Icons.directions_car_rounded;

      case "aeronautical engineering":
        return Icons.flight_rounded;

      default:
        return Icons.grid_view_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Departments"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : departments.isEmpty
              ? const Center(
                  child: Text(
                    "No Departments Found",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: GridView.builder(
                    itemCount: departments.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: .95,
                    ),
                    itemBuilder: (context, index) {
                      final department = departments[index];

                      return Departmentgridcolor(
                        title: department["departmentName"],
                        icon: getDepartmentIcon(department["departmentName"]),
                        color: getColor(index),
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
                  ),
                ),
    );
  }
}
