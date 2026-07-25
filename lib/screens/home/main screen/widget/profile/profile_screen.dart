import 'package:first_app/constants/app_colors.dart';
import 'package:first_app/screens/home/main%20screen/widget/profile/edit_profile_screen.dart';
import 'package:first_app/screens/home/main%20screen/widget/profile_model.dart';
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
   
    department: "AI & Data Science",
    year: "3rd Year",
    github: "github.com/pradeep",
    linkedin: "linkedin.com/in/pradeep",
    portfolio: "portfolio.pradeep.dev",
    photoUrl: "",
  );

  Widget buildTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value.isEmpty ? "-" : value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 18),
          ...children,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.appBar,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary,
                      width: 3,
                    ),
                  ),
                  child: const CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Text(
              profile.name,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              profile.headline,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 30),

            buildSection(
              title: "Personal Information",
              children: [
                buildTile("Full Name", profile.name),
                buildTile("Headline", profile.headline),
                buildTile("About", profile.about),
              ],
            ),

            buildSection(
              title: "Academic Information",
              children: [
                buildTile("Department", profile.department),
                buildTile("Year", profile.year),
              ],
            ),

            buildSection(
              title: "Social Links",
              children: [
                buildTile("GitHub", profile.github),
                buildTile("LinkedIn", profile.linkedin),
                buildTile("Portfolio", profile.portfolio),
              ],
            ),

            buildSection(
              title: "Account",
              children: [
                buildTile("Email", profile.email),
              ],
            ),

            const SizedBox(height: 20),
                        SizedBox(
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
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}