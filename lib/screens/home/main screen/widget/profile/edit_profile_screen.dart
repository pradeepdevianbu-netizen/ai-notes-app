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
          const SizedBox(height: 9),
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

  Future<void> saveProfile() async {
    // Firestore update code
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
