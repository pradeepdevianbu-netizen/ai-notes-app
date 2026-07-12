import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/screens/home/widgets/ai_assistant_card.dart';
import 'package:first_app/screens/home/department/department_card.dart';
import 'package:first_app/screens/home/widgets/home_app_bar.dart';
import 'package:first_app/screens/home/widgets/home_search_bar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection("users").doc(uid).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            backgroundColor: const Color(0xFFF5F7FB),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final user = snapshot.data!.data() as Map<String, dynamic>;

        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 231, 232, 234),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeAppBar(
                    username: user["name"] ?? "",
                    collegeName: user["collegeName"] ?? "",
                    onNotificationTap: () {},
                    onProfileTap: () {},
                  ),
                  const SizedBox(height: 24),
                  const HomeSearchBar(),
                  const SizedBox(height: 30),
                  const AIAssistantCard(),
                  const SizedBox(height: 24),
                  const Departmentcard(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
