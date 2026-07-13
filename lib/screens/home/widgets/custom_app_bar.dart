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
      automaticallyImplyLeading: true,
      centerTitle: false,
      toolbarHeight: subtitle == null ? 68 : 82,

      backgroundColor: const Color(0xFF0F172A),
      foregroundColor: Colors.white,

      elevation: 0,
      scrolledUnderElevation: 0,

      surfaceTintColor: Colors.transparent,

      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: Colors.white.withOpacity(.08),
        ),
      ),

      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
              color: Colors.white,
            ),
          ),

          if (subtitle != null) ...[
            const SizedBox(height: 3),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),

      iconTheme: const IconThemeData(
        color: Colors.white,
        size: 24,
      ),

      actions: [
        if (actions != null) ...actions!,
        const SizedBox(width: 10),
      ],
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(subtitle == null ? 68 : 82);
}