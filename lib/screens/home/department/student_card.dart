import 'package:first_app/screens/chat/chat_screen.dart';
import 'package:first_app/screens/connection/service/connection_service.dart';
import 'package:flutter/material.dart';

class StudentCard extends StatefulWidget {
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
  State<StudentCard> createState() => _StudentCardState();
}

// ignore: non_constant_identifier_names
class _StudentCardState extends State<StudentCard> {
  bool isRequested = false;

  @override
  void initState() {
    super.initState();
    loadRequestStatus();
  }

  void loadRequestStatus() async {
    final result =
        await ConnectionService().checkRequest(widget.student["uid"]);

    if (mounted) {
      setState(() {
        isRequested = result;
      });
    }
  }

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
            blurRadius: 17,
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
                      widget.student["name"] ?? "",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${widget.student["department"]} • ${widget.student["year"]}",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Section ${widget.student["section"]}",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder<String>(
                  stream: ConnectionService()
                      .getConnectionStatusStream(widget.student["uid"]),
                  builder: (context, snapshot) {
                    final status = snapshot.data ?? "connect";

                    if (status != "connected") {
                      return const SizedBox.shrink();
                    }
                    return PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert),
                      onSelected: (value) async {
                        if (value == "disconnect") {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Disconnect"),
                              content: Text(
                                "Disconnect from ${widget.student["name"]}?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                  child: const Text("Cancel"),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                  child: const Text("Disconnect"),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await ConnectionService()
                                .disconnect(widget.student["uid"]);

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Disconnected from ${widget.student["name"]}",
                                  ),
                                ),
                              );
                            }
                          }
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem<String>(
                          value: "disconnect",
                          child: Row(
                            children: [
                              Icon(Icons.person_remove, color: Colors.red),
                              SizedBox(width: 8),
                              Text("Disconnect"),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
            ],
          ),

          const SizedBox(height: 14),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.student["about"] ?? "No bio available",
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
                      .getConnectionStatusStream(widget.student["uid"]),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final status = snapshot.data!;

                    if (status == "connected") {
                      return ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatScreen(
                                otherUserId: widget.student["uid"],
                                otherUserName: widget.student["name"],
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.chat_bubble_outline),
                        label: const Text("Message"),
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
                              .cancelRequest(widget.student["uid"]);

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Request Cancelled"),
                              ),
                            );
                          }
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

                    if (status == "received") {
                      return ElevatedButton.icon(
                        onPressed: null,
                        icon: const Icon(Icons.person),
                        label: const Text("Request Received"),
                        style: ElevatedButton.styleFrom(
                          disabledBackgroundColor: Colors.green,
                          disabledForegroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(46),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      );
                    }

                    return ElevatedButton.icon(
                      onPressed: widget.onConnect,
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
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: widget.onView,
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
