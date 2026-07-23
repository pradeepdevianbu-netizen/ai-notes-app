import 'package:first_app/constants/app_colors.dart';
import 'package:first_app/screens/home/main%20screen/widget/profile_model.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  final ProfileModel profile;

  const EditProfileScreen({
    super.key,
    required this.profile,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _headlineController = TextEditingController();
  final _aboutController = TextEditingController();
  final _phoneController = TextEditingController();
  final _githubController = TextEditingController();
  final _linkedinController = TextEditingController();
  final _portfolioController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _nameController.text = widget.profile.name;
    _headlineController.text = widget.profile.headline;
    _aboutController.text = widget.profile.about;
    _phoneController.text = widget.profile.phone;
    _githubController.text = widget.profile.github;
    _linkedinController.text = widget.profile.linkedin;
    _portfolioController.text = widget.profile.portfolio;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _headlineController.dispose();
    _aboutController.dispose();
    _phoneController.dispose();
    _githubController.dispose();
    _linkedinController.dispose();
    _portfolioController.dispose();
    super.dispose();
  }

  Widget buildField({
    required String title,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Stack(
              children: [
                const CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.grey,
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.primary,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.camera_alt,
                        size: 18,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            buildField(
              title: "Full Name",
              controller: _nameController,
            ),
            buildField(
              title: "Headline",
              controller: _headlineController,
            ),
            buildField(
              title: "About",
              controller: _aboutController,
              maxLines: 4,
            ),
            buildField(
              title: "Phone Number",
              controller: _phoneController,
            ),
            buildField(
              title: "GitHub",
              controller: _githubController,
            ),
            buildField(
              title: "LinkedIn",
              controller: _linkedinController,
            ),
            buildField(
              title: "Portfolio",
              controller: _portfolioController,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  final updatedProfile = ProfileModel(
                    name: _nameController.text,
                    headline: _headlineController.text,
                    about: _aboutController.text,
                    email: widget.profile.email,
                    phone: _phoneController.text,
                    department: widget.profile.department,
                    year: widget.profile.year,
                    github: _githubController.text,
                    linkedin: _linkedinController.text,
                    portfolio: _portfolioController.text,
                    photoUrl: widget.profile.photoUrl,
                  );

                  Navigator.pop(context, updatedProfile);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  "Save Changes",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
