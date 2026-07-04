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

              const SizedBox(height: 24),

              /// AI Assistant Card (Temporary)
             

              const SizedBox(height: 30),

              /// Departments Title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Departments",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Department Grid
              // We'll build this next.
            ],
          ),
        ),
      ),
    );
  }
}