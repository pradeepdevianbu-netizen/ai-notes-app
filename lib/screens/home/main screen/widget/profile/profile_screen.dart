import 'package:first_app/constants/app_colors.dart';
import 'package:first_app/screens/home/main%20screen/widget/about_card.dart';
import 'package:first_app/screens/home/main%20screen/widget/contact_card.dart';
import 'package:first_app/screens/home/main%20screen/widget/developer_card.dart';
import 'package:first_app/screens/home/main%20screen/widget/profile/edit_profile_screen.dart';
import 'package:first_app/screens/home/main%20screen/widget/profile_header.dart';
import 'package:first_app/screens/home/main%20screen/widget/profile_model.dart';
import 'package:first_app/screens/home/main%20screen/widget/social_card.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileModel profile = const ProfileModel(
    name: "Pradeep A",
    headline: "Flutter Developer",
    about:
        "Passionate AI & Data Science student. I enjoy building beautiful Flutter applications using Firebase and modern UI.",
    email: "pradeepdevianbu@gmail.com",
    phone: "+91 9876543210",
    department: "AI & Data Science",
    year: "3rd Year",
    github: "github.com/pradeep",
    linkedin: "linkedin.com/in/pradeep",
    portfolio: "portfolio.pradeep.dev",
    photoUrl: "",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ProfileHeader(
                profile: profile,
                onEditPhoto: () {},
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AboutCard(
                  about: profile.about,
                ),
              ),

              const SizedBox(height: 18),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: DeveloperCard(
                  skills: [
                    "Flutter",
                    "Firebase",
                    "Dart",
                    "Git",
                    "REST API",
                    "UI Design",
                    "Figma",
                    "AI",
                  ],
                ),
              ),

              const SizedBox(height: 18),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SocialCard(
                  github: profile.github,
                  linkedin: profile.linkedin,
                  portfolio: profile.portfolio,
                ),
              ),

              const SizedBox(height: 18),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ContactCard(
                  email: profile.email,
                  phone: profile.phone,
                  college: "ABC Engineering College",
                  department: profile.department,
                  year: profile.year,
                ),
              ),

              const SizedBox(height: 25),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final result = await Navigator.push<ProfileModel>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditProfileScreen(
                            profile: profile,
                          ),
                        ),
                      );

                      if (result != null) {
                        setState(() {
                          profile = result;
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Edit Profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}