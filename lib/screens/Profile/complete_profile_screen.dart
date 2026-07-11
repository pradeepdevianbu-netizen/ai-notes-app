import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/screens/home/main%20screen/main_screen.dart';
import 'package:flutter/material.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  // Controllers
  final TextEditingController fullNameController = TextEditingController();

  final TextEditingController aboutController = TextEditingController();

  // Selected Values
  String? selectedCollegeId;
  String? selectedCollegeName;
  String? selectedDepartment;
  String? selectedYear;
  String? selectedSection;

  // Firebase Lists
  List<Map<String, dynamic>> colleges = [];
  List<String> departments = [];

  // Static Lists
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

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchColleges();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    aboutController.dispose();
    super.dispose();
  }

  InputDecoration customDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(
        icon,
        color: const Color(0xFF5B8CFF),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 18,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: Color(0xFFE2E8F0),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: Color(0xFF5B8CFF),
          width: 2,
        ),
      ),
    );
  }
  // ---------------------- FETCH COLLEGES ----------------------

  Future<void> fetchColleges() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection("colleges").get();

      setState(() {
        colleges = snapshot.docs.map((doc) {
          return {
            "id": doc.id,
            "name": doc["collegeName"],
          };
        }).toList();
      });
    } catch (e) {
      debugPrint("Fetch Colleges Error: $e");
    }
  }

// ---------------------- FETCH DEPARTMENTS ----------------------

  Future<void> fetchDepartments(String collegeId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("departments")
          .where("collegeId", isEqualTo: collegeId)
          .get();

      setState(() {
        departments = snapshot.docs
            .map((doc) => doc["departmentName"].toString())
            .toList();
      });
    } catch (e) {
      debugPrint("Fetch Departments Error: $e");
    }
  }

// ---------------------- SAVE PROFILE ----------------------

  Future<bool> saveProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) return false;

      setState(() => isLoading = true);

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
        "profileImage": "",
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp(),
      });

      setState(() => isLoading = false);

      return true;
    } catch (e) {
      setState(() => isLoading = false);

      debugPrint(e.toString());

      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7FF),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Complete Profile",
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Welcome 👋",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Complete your profile to join your college community.",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF64748B),
                ),
              ),

              const SizedBox(height: 35),

              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF5B8CFF),
                            Color(0xFF7B61FF),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 142,
                      height: 142,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 70,
                        color: Colors.grey,
                      ),
                    ),
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF5B8CFF),
                              Color(0xFF7B61FF),
                            ],
                          ),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.05),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Personal Information",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 25),
                    TextField(
                      controller: fullNameController,
                      decoration: customDecoration(
                        label: "Full Name",
                        icon: Icons.person_outline,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: aboutController,
                      maxLines: 4,
                      decoration: customDecoration(
                        label: "About Yourself",
                        icon: Icons.edit_note_outlined,
                      ).copyWith(
                        hintText: "Tell everyone about yourself...",
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ================= Academic Information =================

              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.05),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Academic Information",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // College Dropdown
                    DropdownSearch<Map<String, dynamic>>(
                      items: (filter, loadProps) async {
                        if (filter.isEmpty) return colleges;

                        return colleges.where((college) {
                          return college["name"]
                              .toString()
                              .toLowerCase()
                              .contains(filter.toLowerCase());
                        }).toList();
                      },
                      itemAsString: (item) => item["name"],
                      compareFn: (a, b) => a["id"] == b["id"],
                      decoratorProps: DropDownDecoratorProps(
                        decoration: customDecoration(
                          label: "College",
                          icon: Icons.school_outlined,
                        ),
                      ),
                      popupProps: const PopupProps.menu(
                        showSearchBox: true,
                      ),
                      onChanged: (college) {
                        if (college == null) return;

                        setState(() {
                          selectedCollegeId = college["id"];
                          selectedCollegeName = college["name"];
                          selectedDepartment = null;
                          departments.clear();
                        });

                        fetchDepartments(selectedCollegeId!);
                      },
                    ),

                    const SizedBox(height: 20),

                    // Department Dropdown
                    DropdownSearch<String>(
                      items: (filter, loadProps) async => departments,
                      decoratorProps: DropDownDecoratorProps(
                        decoration: customDecoration(
                          label: "Department",
                          icon: Icons.account_tree_outlined,
                        ),
                      ),
                      popupProps: const PopupProps.menu(
                        showSearchBox: true,
                      ),
                      selectedItem: selectedDepartment,
                      onChanged: (value) {
                        setState(() {
                          selectedDepartment = value;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedYear,
                            decoration: customDecoration(
                              label: "Year",
                              icon: Icons.calendar_today_outlined,
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
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedSection,
                            decoration: customDecoration(
                              label: "Section",
                              icon: Icons.groups_outlined,
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
                  ],
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          // Validation
                          if (fullNameController.text.trim().isEmpty ||
                              selectedCollegeId == null ||
                              selectedDepartment == null ||
                              selectedYear == null ||
                              selectedSection == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text("Please fill all required fields."),
                              ),
                            );
                            return;
                          }

                          bool success = await saveProfile();

                          if (!mounted) return;

                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text("Profile completed successfully 🎉"),
                              ),
                            );

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const MainScreen(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Failed to save profile."),
                              ),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF5B8CFF),
                          Color(0xFF7B61FF),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Center(
                      child: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              "Continue to CampusX",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                  height:
                      30), // ===== Part 5 starts here ===== // Part 4 starts here...
            ],
          ),
        ),
      ),
    );
  }
}
