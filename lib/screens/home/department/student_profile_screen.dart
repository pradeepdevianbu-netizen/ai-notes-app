import 'package:flutter/material.dart';

class StudentProfileScreen extends StatelessWidget {
  final Map<String, dynamic> student;

  const StudentProfileScreen({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F8FC),

      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: Colors.blue,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF5B8CFF),
                      Color(0xFF7AA7FF),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [

                  Transform.translate(
                    offset: const Offset(0, -70),
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.blue.shade100,
                        child: Text(
                          (student["name"] ?? "A")[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Transform.translate(
                    offset: const Offset(0, -50),
                    child: Column(
                      children: [

                        Text(
                          student["name"] ?? "",
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          student["department"] ?? "",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 17,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          "${student["year"]} • Section ${student["section"]}",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),

                        const SizedBox(height: 18),

                        Row(
                          children: [

                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.person_add_alt_1),
                                label: const Text("Connect"),
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.chat_bubble_outline),
                                label: const Text("Message"),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 28),

                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [

                                const Text(
                                  "About",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 12),

                                Text(
                                  student["about"] ??
                                      "No bio available",
                                ),

                                const Divider(height: 35),

                                ListTile(
                                  leading: const Icon(Icons.school),
                                  title: const Text("College"),
                                  subtitle: Text(
                                    student["collegeName"] ?? "-",
                                  ),
                                ),

                                ListTile(
                                  leading: const Icon(Icons.account_tree),
                                  title: const Text("Department"),
                                  subtitle: Text(
                                    student["department"] ?? "-",
                                  ),
                                ),

                                ListTile(
                                  leading: const Icon(Icons.calendar_today),
                                  title: const Text("Year"),
                                  subtitle: Text(
                                    student["year"] ?? "-",
                                  ),
                                ),

                                ListTile(
                                  leading: const Icon(Icons.group),
                                  title: const Text("Section"),
                                  subtitle: Text(
                                    student["section"] ?? "-",
                                  ),
                                ),

                                ListTile(
                                  leading: const Icon(Icons.email),
                                  title: const Text("Email"),
                                  subtitle: Text(
                                    student["email"] ?? "-",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}