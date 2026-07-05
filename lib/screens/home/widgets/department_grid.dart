import 'package:first_app/screens/home/widgets/department_gridcolor.dart';
import 'package:flutter/material.dart';


class DepartmentGrid extends StatelessWidget {
  const DepartmentGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.9,
        children: [
          Departmentgridcolor(
            title: "AI & DS",
            icon: Icons.auto_awesome,
            color: Colors.blue,
            onTap: () {},
          ),
          Departmentgridcolor(
            title: "CSE",
            icon: Icons.terminal,
            color: Colors.cyan,
            onTap: () {},
          ),
          Departmentgridcolor(
            title: "IT",
            icon: Icons.hub,
            color: Colors.green,
            onTap: () {},
          ),
          Departmentgridcolor(
            title: "ECE",
            icon: Icons.developer_board,
            color: Colors.orange,
            onTap: () {},
          ),
          Departmentgridcolor(
            title: "EEE",
            icon:Icons.bolt,
            color: Colors.amber,
            onTap: () {},
          ),
          Departmentgridcolor(
            title: "BME",
            icon: Icons.science,
            color: Colors.purple,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
