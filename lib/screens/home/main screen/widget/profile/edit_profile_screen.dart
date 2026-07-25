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
  final _githubController = TextEditingController();
  final _linkedinController = TextEditingController();
  final _portfolioController = TextEditingController();
  final _departmentController = TextEditingController();
  final _yearController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _nameController.text = widget.profile.name;
    _headlineController.text = widget.profile.headline;
    _aboutController.text = widget.profile.about;
    _githubController.text = widget.profile.github;
    _linkedinController.text = widget.profile.linkedin;
    _portfolioController.text = widget.profile.portfolio;
    _departmentController.text = widget.profile.department;
    _yearController.text = widget.profile.year;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _headlineController.dispose();
    _aboutController.dispose();
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
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: maxLines,
            style: TextStyle(
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surface,
              hintStyle: TextStyle(
                color: AppColors.textSecondary,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 15,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(
                  color: AppColors.border,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
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
        border: Border.all(
          color: AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
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
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: Stack(
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
                          color: Colors.white,
                          size: 18,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            buildSection(
              title: "Personal Information",
              children: [
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
              ],
            ),
            buildSection(
              title: "Academic Information",
              children: [
                buildField(
                  title: "Department",
                  controller: _departmentController,
                ),
                buildField(
                  title: "Year",
                  controller: _yearController,
                ),
              ],
            ),
            buildSection(
              title: "Social Links",
              children: [
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
              ],
            ),
            buildSection(
              title: "Account",
              children: [
                buildField(
                  title: "Email",
                  controller: TextEditingController(text: widget.profile.email),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  final updatedProfile = ProfileModel(
                    name: _nameController.text.trim(),
                    headline: _headlineController.text.trim(),
                    about: _aboutController.text.trim(),
                    email: widget.profile.email,
                    department: widget.profile.department,
                    year: widget.profile.year,
                    github: _githubController.text.trim(),
                    linkedin: _linkedinController.text.trim(),
                    portfolio: _portfolioController.text.trim(),
                    photoUrl: widget.profile.photoUrl,
                  );

                  Navigator.pop(context, updatedProfile);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  "Save Changes",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
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
