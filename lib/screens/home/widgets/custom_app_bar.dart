import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final Color backgroundColor;
  final Color foregroundColor;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.backgroundColor = const Color(0xFF0F172A),
    this.foregroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: subtitle == null ? 60 : 80,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: foregroundColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: TextStyle(
                color: foregroundColor.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
        ],
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(subtitle == null ? 60 : 80);
}
