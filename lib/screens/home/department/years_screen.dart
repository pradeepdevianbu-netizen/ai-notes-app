import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/screens/home/department/year_preview_card.dart';
import 'package:first_app/screens/home/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:first_app/screens/home/department/students_screen.dart';

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
      backgroundColor: const Color(0xffF7F8FC),

      appBar: CustomAppBar(
        title: (departmentName),
        subtitle: "4 years Available",
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: years.length,
        itemBuilder: (context, index) {
          return FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection("users")
                .where("department", isEqualTo: departmentName)
                .where("year", isEqualTo: years[index])
                .get(),
            builder: (context, snapshot) {

              int studentCount = 0;

              if (snapshot.hasData) {
                studentCount = snapshot.data!.docs.length;
              }

              return YearPreviewCard(
                title: years[index],
                studentCount: studentCount,
                color: getColor(index),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StudentsScreen(
                        departmentName: departmentName,
                        year: years[index],
                      ),
                    ),
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