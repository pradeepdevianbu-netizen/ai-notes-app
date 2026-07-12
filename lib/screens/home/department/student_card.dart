import 'package:first_app/screens/connection/service/connection_service.dart';
import 'package:flutter/material.dart';

class StudentCard extends StatelessWidget {
  final Map<String, dynamic> student;
  final VoidCallback onConnect;
  final VoidCallback onView;

  const StudentCard({
    super.key,
    required this.student,
    required this.onConnect,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          /// Top Row
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.blue.shade100,
                    child: Text(
                      (student["name"] ?? "A")[0].toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 2,
                    bottom: 2,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student["name"] ?? "",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${student["department"]} • ${student["year"]}",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Section ${student["section"]}",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              student["about"] ?? "No bio available",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: StreamBuilder<String>(
                  stream: ConnectionService()
                      .getConnectionStatusStream(student["uid"]),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final status = snapshot.data!;

                    //

                    if (status == "connect") {
                      return ElevatedButton.icon(
                        onPressed: onConnect,
                        icon: const Icon(Icons.person_add_alt_1),
                        label: const Text("Connect"),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(46),
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      );
                    }
                    if (status == "requested") {
                      return ElevatedButton.icon(
                        onPressed: () async {
                          await ConnectionService()
                              .cancelRequest(student["uid"]);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Request Cancelled"),
                            ),
                          );
                        },
                        icon: const Icon(Icons.close),
                        label: const Text("Requested"),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(46),
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      );
                    }

                    if (status == "connected") {
                      return ElevatedButton.icon(
                        onPressed: null,
                        icon: const Icon(Icons.check_circle),
                        label: const Text("Connected"),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(46),
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      );
                    }

                    return ElevatedButton(
                      onPressed: null,
                      child: const Text("Loading"),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onView,
                  icon: const Icon(Icons.visibility_outlined),
                  label: const Text("Profile"),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(46),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
