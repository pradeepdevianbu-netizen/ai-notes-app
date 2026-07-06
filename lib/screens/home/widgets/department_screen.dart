import 'package:flutter/material.dart';
import 'package:first_app/models/department.dart';
import 'package:first_app/screens/home/widgets/department_gridcolor.dart';

class DepartmentsScreen extends StatelessWidget {
  DepartmentsScreen({super.key});

  // ignore: non_constant_identifier_names
  final List<Department> Departments = [
    const Department(
      title: "AI & DS",
      icon: Icons.auto_awesome_rounded,
      color: Color(0xFF5B8CFF),
    ),
    const Department(
      title: "CSE",
      icon: Icons.code_rounded,
      color: Color(0xFF36CFC9),
    ),
    const Department(
      title: "IT",
      icon: Icons.device_hub_rounded,
      color: Color(0xFF52C41A),
    ),
    const Department(
      title: "ECE",
      icon: Icons.memory_rounded,
      color: Color(0xFFFFA940),
    ),
    const Department(
      title: "EEE",
      icon: Icons.bolt_rounded,
      color: Color(0xFFFADB14),
    ),
    const Department(
      title: "BME",
      icon: Icons.biotech_rounded,
      color: Color(0xFFB37FEB),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Departments"),
        ),
        body: GridView.builder(
          itemCount: Departments.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            final department = Departments[index];

            return Departmentgridcolor(
              title: department.title,
              icon: department.icon,
              color: department.color,
              onTap: () {
                
              },
            );
          },
        ));
  }
}
