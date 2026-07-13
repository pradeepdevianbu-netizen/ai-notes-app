import 'package:first_app/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 82,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,

      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            subtitle ?? "Connect • Chat • Grow",
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            title,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),

      actions: [

        /// Search
        _actionButton(
          icon: Icons.search_rounded,
          onTap: () {},
        ),

        const SizedBox(width: 8),

        /// Notification
        Stack(
          children: [

            _actionButton(
              icon: Icons.notifications_none_rounded,
              onTap: () {},
            ),

            Positioned(
              right: 8,
              top: 8,
              child: Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            )
          ],
        ),

        const SizedBox(width: 10),

        GestureDetector(
          onTap: () {},

          child: Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white24,
                width: 1.3,
              ),
              shape: BoxShape.circle,
            ),
            child: const CircleAvatar(
              radius: 20,
              backgroundColor: Color(0xFF2563EB),
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],

      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: Colors.white12,
          height: 1,
        ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Material(
        color: Colors.white.withOpacity(.08),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(83);
}