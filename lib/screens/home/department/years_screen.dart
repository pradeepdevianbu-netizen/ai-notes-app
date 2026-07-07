import 'package:flutter/material.dart';
import 'package:first_app/models/year.dart';
import 'package:first_app/screens/home/widgets/year_card.dart';

class YearsScreen extends StatelessWidget {
  final String departmentName;

  const YearsScreen({
    super.key,
    required this.departmentName,
  });

  final List<YearModel> years = const [
    YearModel(
      title: "First Year",
      subtitle: "Explore first year students",
      icon: Icons.looks_one_rounded,
      color: Color(0xFF4F8CFF),
    ),
    YearModel(
      title: "Second Year",
      subtitle: "Explore second year students",
      icon: Icons.looks_two_rounded,
      color: Color(0xFF00C2A8),
    ),
    YearModel(
      title: "Third Year",
      subtitle: "Explore third year students",
      icon: Icons.looks_3_rounded,
      color: Color(0xFFFF8A00),
    ),
    YearModel(
      title: "Final Year",
      subtitle: "Explore final year students",
      icon: Icons.workspace_premium_rounded,
      color: Color(0xFF8B5CF6),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: Text(
          departmentName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text(
              "Select Year",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Choose your academic year",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 28),
            ...years.map(
              (year) => YearCard(
                title: year.title,
                subtitle: year.subtitle,
                icon: year.icon,
                color: year.color,
                onTap: () {
                  // Navigate to SectionsScreen
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}