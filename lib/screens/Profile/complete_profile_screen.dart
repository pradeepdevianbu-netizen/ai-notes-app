import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:first_app/screens/home/home_screen.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();

  String? selectedCollegeId;
  String? selectedCollegeName;
  String? selectedDepartment;
  String? selectedYear;
  String? selectedSection;

  List<Map<String, dynamic>> colleges = [];
  List<String> departments = [];

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
  void initState() {
    super.initState();
    fetchColleges();
  }

  Future<void> fetchColleges() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('colleges').get();

    print("Documents found: ${snapshot.docs.length}");

    for (var doc in snapshot.docs) {
      print(doc.data());
    }
    setState(() {
      colleges = snapshot.docs.map((doc) {
        return {
          "id": doc.id,
          "name": doc["collegeName"],
        };
      }).toList();
    });
    print(colleges);
  }

  Future<void> fetchDepartments(String collegeId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("departments")
        .where("collegeId", isEqualTo: collegeId)
        .get();

    setState(() {
      departments =
          snapshot.docs.map((doc) => doc["departmentName"].toString()).toList();

      selectedDepartment = null;
    });
  }

  Future<bool> saveProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) return false;

      await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
        "uid": user.uid,
        "email": user.email,
        "name": fullNameController.text.trim(),
        "collegeId": selectedCollegeId,
        "collegeName": selectedCollegeName,
        "department": selectedDepartment,
        "year": selectedYear,
        "section": selectedSection,
        "about": aboutController.text.trim(),
        "createdAt": FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xffF8FAFF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "Complete Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    children: [
                      Container(
                        height: 120,
                        width: 120,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Color(0xff5B8CFF),
                              Color(0xff7B61FF),
                            ],
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(3),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30),

                Text(
                  "Complete Your Profile",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Complete your profile to continue",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 30),

                /// Full Name
                TextField(
                  controller: fullNameController,
                  decoration: InputDecoration(
                    labelText: "Full Name",
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// College Dropdown
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: selectedCollegeId,
                  decoration: InputDecoration(
                    labelText: "College",
                    prefixIcon: const Icon(Icons.school_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  items: colleges.map((college) {
                    return DropdownMenuItem<String>(
                      value: college["id"],
                      child: Text(college["name"]),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCollegeId = value;

                      selectedCollegeName = colleges.firstWhere(
                        (college) => college["id"] == value,
                      )["name"];
                    });

                    fetchDepartments(value!);
                  },
                ),

                const SizedBox(height: 20),

                /// Department Dropdown
                DropdownSearch<String>(
                  items: (filter, infiniteScrollProps) => departments,
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                  ),
                  decoratorProps: DropDownDecoratorProps(
                    decoration: InputDecoration(
                      labelText: "Department",
                      prefixIcon: Icon(Icons.account_tree_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedDepartment = value;
                    });
                  },
                  selectedItem: selectedDepartment,
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedYear,
                        decoration: InputDecoration(
                          labelText: "Year",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        items: years.map((year) {
                          return DropdownMenuItem(
                            value: year,
                            child: Text(year),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedYear = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: selectedSection,
                        decoration: InputDecoration(
                          labelText: "Section",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        items: sections.map((section) {
                          return DropdownMenuItem(
                            value: section,
                            child: Text(section),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedSection = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// About
                TextField(
                  controller: aboutController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: "About You",
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(bottom: 70),
                      child: Icon(Icons.edit_note),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),

                const SizedBox(height: 35),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (fullNameController.text.trim().isEmpty ||
                          selectedCollegeId == null ||
                          selectedDepartment == null ||
                          selectedYear == null ||
                          selectedSection == null ||
                          aboutController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please complete all fields"),
                          ),
                        );
                        return;
                      }

                      bool success = await saveProfile();

                      if (success) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HomeScreen(),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff5B8CFF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text(
                      "Complete Profile",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            )),
      ),
    );
  }
}
