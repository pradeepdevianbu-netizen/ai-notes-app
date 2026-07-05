import 'package:first_app/screens/home/widgets/ai_assistant_card.dart';
import 'package:first_app/screens/home/widgets/department_card.dart';
import 'package:first_app/screens/home/widgets/department_grid.dart';
import 'package:first_app/screens/home/widgets/department_screen.dart';
import 'package:flutter/material.dart';

import 'widgets/home_app_bar.dart';
import 'widgets/home_search_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Temporary data
    // Later this value will come from Firebase Firestore.
    const String userName = "Pradeep";

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// App Bar
              HomeAppBar(
                userName: userName,
                onNotificationTap: () {
                  // TODO: Open Notification Screen
                },
                onProfileTap: () {
                  // TODO: Open Profile Screen
                },
              ),

              const SizedBox(height: 24),

              /// Search Bar
              const HomeSearchBar(),

              const SizedBox(height: 30),

              const AIAssistantCard(),

              const SizedBox(height: 24),

              const DepartmentScreen()
             
              // Department Grid
              // We'll build this next.
            ],
          ),
        ),
      ),
    );
  }
}

