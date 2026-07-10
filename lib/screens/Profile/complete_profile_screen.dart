import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/constants/app_colors.dart';
import 'package:first_app/screens/home/main%20screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

bool isLoading = false;

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

  InputDecoration customInputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.poppins(
        color: AppColors.subtitle,
        fontWeight: FontWeight.w500,
      ),
      prefixIcon: Icon(
        icon,
        color: AppColors.primary,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 18,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(
          color: AppColors.border,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: AppColors.text,
        ),
        title: Text(
          "Complete Profile",
          style: GoogleFonts.poppins(
            color: AppColors.text,
            fontSize: 20,
            fontWeight: FontWeight.w700,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome 👋",
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Build your CampusX identity and connect with students in your college.",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: AppColors.subtitle,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 35),
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
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
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.person_outline,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Text(
                                    "Personal Information",
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.text,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 25),
                            ],
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.all(24),
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
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.school_outlined,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Text(
                                    "Academic Information",
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.text,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 25),

                              /// College Dropdown

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
                                  decoration: customInputDecoration(
                                    label: "College",
                                    icon: Icons.school_outlined,
                                  ),
                                ),
                                popupProps: PopupProps.menu(
                                  showSearchBox: true,
                                  searchFieldProps: TextFieldProps(
                                    decoration: customInputDecoration(
                                      label: "Search College",
                                      icon: Icons.search,
                                    ),
                                  ),
                                ),
                                onChanged: (college) {
                                  if (college == null) return;

                                  setState(() {
                                    selectedCollegeId = college["id"];
                                    selectedCollegeName = college["name"];
                                    selectedDepartment = null;
                                  });

                                  fetchDepartments(selectedCollegeId!);
                                },
                              ),
                              const SizedBox(height: 20),

                              DropdownSearch<String>(
                                items: (filter, _) => departments,
                                popupProps: const PopupProps.menu(
                                  showSearchBox: true,
                                ),
                                decoratorProps: DropDownDecoratorProps(
                                  decoration: customInputDecoration(
                                    label: "Department",
                                    icon: Icons.account_tree_outlined,
                                  ),
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
                                      decoration: customInputDecoration(
                                        label: "Year",
                                        icon: Icons.calendar_today_outlined,
                                      ),
                                      items: years.map((year) {
                                        return DropdownMenuItem(
                                          value: year,
                                          child: Text(
                                            year,
                                            style: GoogleFonts.poppins(),
                                          ),
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
                                      decoration: customInputDecoration(
                                        label: "Section",
                                        icon: Icons.groups_outlined,
                                      ),
                                      items: sections.map((section) {
                                        return DropdownMenuItem(
                                          value: section,
                                          child: Text(
                                            section,
                                            style: GoogleFonts.poppins(),
                                          ),
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

                        const SizedBox(width: 15),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedSection,
                            decoration: customInputDecoration(
                              label: "Section",
                              icon: Icons.groups_outlined,
                            ),
                            items: sections.map((section) {
                              return DropdownMenuItem(
                                value: section,
                                child: Text(
                                  section,
                                  style: GoogleFonts.poppins(),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedSection = value;
                              });
                            },
                          ),
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
                          height: 58,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.primary,
                                  AppColors.secondary,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(.35),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                      if (fullNameController.text
                                              .trim()
                                              .isEmpty ||
                                          selectedCollegeId == null ||
                                          selectedDepartment == null ||
                                          selectedYear == null ||
                                          selectedSection == null ||
                                          aboutController.text.trim().isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "Please complete all fields"),
                                          ),
                                        );

                                        return;
                                      }

                                      setState(() {
                                        isLoading = true;
                                      });

                                      bool success = await saveProfile();

                                      setState(() {
                                        isLoading = false;
                                      });

                                      if (success) {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const MainScreen(),
                                          ),
                                        );
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      height: 26,
                                      width: 26,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Continue to CampusX",
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 17,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        const Icon(
                                          Icons.arrow_forward_rounded,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Center(
                          child: Text(
                            "Your profile helps classmates find and connect with you.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: AppColors.subtitle,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                          },
                          child: SingleChildScrollView(),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
