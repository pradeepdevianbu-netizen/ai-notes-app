import 'package:first_app/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController collegeController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();

  Future<void> saveProfile() async {
    try{
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'name': fullNameController.text.trim(),
      'college': collegeController.text.trim(),
      'department': selectedDepartment,
      'year': selectedYear,
      'section': selectedSection,
      'about': aboutController.text.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  } catch (e) {
    debugPrint(e.toString());
  }
  }


  String? selectedDepartment;
  String? selectedYear;
  String? selectedSection;

  final List<String> departments = [
    "AI & DS",
    "CSE",
    "IT",
    "ECE",
    "EEE",
    "Mechanical",
    "Civil",
    "Biomedical",
  ];

  final List<String> years = [
    "1st Year",
    "2nd Year",
    "3rd Year",
    "4th Year",
  ];

  final List<String> sections = [
    "A",
    "B",
    "C",
    "D",
  ];

  @override
  void dispose() {
    fullNameController.dispose();
    collegeController.dispose();
    aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Complete Profile"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              /// Profile Photo
              Stack(
                children: [
                  const CircleAvatar(
                    radius: 55,
                    backgroundColor: Color(0xffE8EAF6),
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.grey,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: IconButton(
                        icon: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 18,
                        ),
                        onPressed: () {
                          // Pick Image
                        },
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 35),

              /// Full Name
              TextField(
                controller: fullNameController,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),

              const SizedBox(height: 20),

              /// College
              TextField(
                controller: collegeController,
                decoration: const InputDecoration(
                  labelText: "College",
                  prefixIcon: Icon(Icons.school_outlined),
                ),
              ),

              const SizedBox(height: 20),

              /// Department
              DropdownButtonFormField<String>(
                initialValue: selectedDepartment,
                decoration: const InputDecoration(
                  labelText: "Department",
                  prefixIcon: Icon(Icons.account_tree_outlined),
                ),
                items: departments
                    .map(
                      (department) => DropdownMenuItem(
                        value: department,
                        child: Text(department),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDepartment = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              /// Year
              DropdownButtonFormField<String>(
                initialValue: selectedYear,
                decoration: const InputDecoration(
                  labelText: "Year",
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                ),
                items: years
                    .map(
                      (year) => DropdownMenuItem(
                        value: year,
                        child: Text(year),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedYear = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              /// Section
              DropdownButtonFormField<String>(
                initialValue: selectedSection,
                decoration: const InputDecoration(
                  labelText: "Section",
                  prefixIcon: Icon(Icons.groups_outlined),
                ),
                items: sections
                    .map(
                      (section) => DropdownMenuItem(
                        value: section,
                        child: Text(section),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSection = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              /// About Me
              TextField(
                controller: aboutController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "About Me",
                  alignLabelWithHint: true,
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 70),
                    child: Icon(Icons.edit_note),
                  ),
                ),
              ),

              const SizedBox(height: 35),

              /// Continue Button
              SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (fullNameController.text.trim().isEmpty ||
                          collegeController.text.trim().isEmpty ||
                          selectedDepartment == null ||
                          selectedYear == null ||
                          selectedSection == null ||
                          aboutController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please fill all the fields"),
                          ),
                        );
                        return;
                      }

                      await saveProfile();

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HomeScreen(),
                        ),
                      );
                    },
                    child: const Text("Continue"),
                  )),

              const SizedBox(height: 20),

              Text(
                "Complete your profile to continue",
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
