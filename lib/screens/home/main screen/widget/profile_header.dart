import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final Map<String, dynamic> user;
  final VoidCallback onEdit;

  const ProfileHeader({
    super.key,
    required this.user,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final image = user["profileImage"] ?? "";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2563EB),
            Color(0xFF3B82F6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(.25),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [

          CircleAvatar(
            radius: 55,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 51,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: image.isNotEmpty
                  ? NetworkImage(image)
                  : null,
              child: image.isEmpty
                  ? const Icon(
                      Icons.person,
                      size: 55,
                      color: Colors.grey,
                    )
                  : null,
            ),
          ),

          const SizedBox(height: 18),

          Text(
            user["name"] ?? "",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            "${user["department"] ?? ""} • ${user["year"] ?? ""}",
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 18),

          ElevatedButton.icon(
            onPressed: onEdit,
            icon: const Icon(Icons.edit),
            label: const Text("Edit Profile"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF2563EB),
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 13,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          )
        ],
      ),
    );
  }
}