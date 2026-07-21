import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/screens/home/main%20screen/widget/profile_button.dart';
import 'package:first_app/screens/home/main%20screen/widget/profile_info_card.dart';
import 'package:first_app/screens/home/main%20screen/widget/stat_card.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(
                child: Text(
                  "Profile not found",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }

            final user = snapshot.data!.data()!;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  /// Header Widget
                  /// We'll build this next
                  Column(
                    children: [
                      ProfileInfoCard(
                        icon: Icons.school,
                        title: "College",
                        value: user["collegeName"] ?? "",
                      ),
                      ProfileInfoCard(
                        icon: Icons.account_balance,
                        title: "Department",
                        value: user["department"] ?? "",
                      ),
                      ProfileInfoCard(
                        icon: Icons.calendar_today,
                        title: "Year",
                        value: user["year"] ?? "",
                      ),
                      ProfileInfoCard(
                        icon: Icons.groups,
                        title: "Section",
                        value: user["section"] ?? "",
                      ),
                      ProfileInfoCard(
                        icon: Icons.email_outlined,
                        title: "Email",
                        value: user["email"] ?? "",
                      ),
                      ProfileInfoCard(
                        icon: Icons.info_outline,
                        title: "About",
                        value: user["about"] ?? "",
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// About Card
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Statistics",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 18),
                      Row(
                        children: [
                          StatCard(
                            icon: Icons.people_alt_rounded,
                            title: "Connections",
                            value: "25",
                          ),
                          StatCard(
                            icon: Icons.menu_book_rounded,
                            title: "Notes",
                            value: "18",
                          ),
                          StatCard(
                            icon: Icons.favorite_rounded,
                            title: "Likes",
                            value: "320",
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// Academic Details
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Account",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 18),
                      ProfileButton(
                        icon: Icons.edit,
                        title: "Edit Profile",
                        onTap: () {
                          // Next Step
                        },
                      ),
                      ProfileButton(
                        icon: Icons.settings,
                        title: "Settings",
                        onTap: () {},
                      ),
                      ProfileButton(
                        icon: Icons.help_outline,
                        title: "Help & Support",
                        onTap: () {},
                      ),
                      ProfileButton(
                        icon: Icons.logout,
                        iconColor: Colors.red,
                        title: "Logout",
                        onTap: () async {
                          await FirebaseAuth.instance.signOut();
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// Statistics
                  Container(),

                  const SizedBox(height: 20),

                  /// Account Buttons
                  Container(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
