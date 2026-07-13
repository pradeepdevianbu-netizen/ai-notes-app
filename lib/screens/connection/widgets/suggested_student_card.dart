import 'package:flutter/material.dart';

class SuggestedStudentCard extends StatelessWidget {
  final String name;
  final String department;
  final VoidCallback onConnect;

  const SuggestedStudentCard({
    super.key,
    required this.name,
    required this.department,
    required this.onConnect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          const CircleAvatar(
            radius: 34,
            backgroundColor: Color(0xFF5B8CFF),
            child: Icon(
              Icons.person,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 15),

          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            department,
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),

          const Spacer(),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onConnect,
              child: const Text("Connect"),
            ),
          )
        ],
      ),
    );
  }
}