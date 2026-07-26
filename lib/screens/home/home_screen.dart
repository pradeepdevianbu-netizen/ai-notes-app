import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/screens/home/widgets/ai_assistant_card.dart';
import 'package:first_app/screens/home/department/department_card.dart';
import 'package:first_app/screens/home/widgets/home_app_bar.dart';
import 'package:first_app/screens/home/widgets/home_search_bar.dart';
import 'package:first_app/screens/home/widgets/post_feed.dart';
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

          return const Scaffold(
            backgroundColor: Color(0xFFF5F7FB),
            appBar: CustomAppBar(
              title: "CampusX",
              subtitle: "Connect • Chat • Grow",
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    HomeSearchBar(),
                    SizedBox(height: 24),
                    AIAssistantCard(),
                    SizedBox(height: 24),
                    Departmentcard(),
                    SizedBox(height: 24),
                    PostFeed(),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
