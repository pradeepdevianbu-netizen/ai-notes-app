import 'package:first_app/screens/home/department/year_card.dart';
import 'package:flutter/material.dart';
import 'package:first_app/screens/home/department/students_screen.dart';
import 'students_screen.dart';
class YearsScreen extends StatelessWidget {
  final String departmentName;

  const YearsScreen({
    super.key,
    required this.departmentName,
  });

  final List<String> years = const [
    "1st Year",
    "2nd Year",
    "3rd Year",
    "4th Year",
  ];

  Color getColor(int index) {
    final colors = [
      const Color(0xFF5B8CFF),
      const Color(0xFF36CFC9),
      const Color(0xFF52C41A),
      const Color(0xFFFFA940),
    ];

    return colors[index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(departmentName),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: years.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: .82,
          ),
          itemBuilder: (context, index) {
            return YearCard(
                title: years[index],
                color: getColor(index),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>  StudentsScreen(
                        departmentName: departmentName,
                        year: years[index], 
                      ),
                    ),
                  );
                });
            // StudentsScreen()
          },
        ),
      ),
    );
  }
}



