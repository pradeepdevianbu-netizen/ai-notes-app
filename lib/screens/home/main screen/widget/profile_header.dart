import 'package:first_app/constants/app_colors.dart';
import 'package:first_app/screens/home/main%20screen/widget/profile_model.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final ProfileModel profile;
  final VoidCallback onEditPhoto;

  const ProfileHeader({
    super.key,
    required this.profile,
    required this.onEditPhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(25),
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
            color: AppColors.primary.withOpacity(.30),
            blurRadius: 21,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [

          /// Avatar
          Stack(
            children: [

              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 58,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: profile.photoUrl.isNotEmpty
                      ? NetworkImage(profile.photoUrl)
                      : null,
                  child: profile.photoUrl.isEmpty
                      ? const Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.grey,
                        )
                      : null,
                ),
              ),

              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onEditPhoto,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.blue,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.blue,
                      size: 20,
                    ),
                  ),
                ),
              ),

            ],
          ),

          const SizedBox(height: 18),

          /// Name
          Text(
            profile.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          /// Headline
          Text(
            profile.headline,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 18),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.18),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              "${profile.department} • ${profile.year}",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}