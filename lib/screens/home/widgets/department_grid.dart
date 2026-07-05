import 'package:flutter/material.dart';
import 'department_card.dart';

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
          DepartmentCard(
            title: "AI & DS",
            icon: Icons.auto_awesome,
            color: Colors.blue,
            onTap: () {},
          ),
          DepartmentCard(
            title: "CSE",
            icon: Icons.terminal,
            color: Colors.cyan,
            onTap: () {},
          ),
          DepartmentCard(
            title: "IT",
            icon: Icons.hub,
            color: Colors.green,
            onTap: () {},
          ),
          DepartmentCard(
            title: "ECE",
            icon: Icons.developer_board,
            color: Colors.orange,
            onTap: () {},
          ),
          DepartmentCard(
            title: "EEE",
            icon:Icons.bolt,
            color: Colors.amber,
            onTap: () {},
          ),
          DepartmentCard(
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
