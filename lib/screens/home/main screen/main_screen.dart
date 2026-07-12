import 'package:first_app/screens/home/home_screen.dart';
import 'package:first_app/screens/home/main%20screen/connection_screen.dart';
import 'package:first_app/screens/home/main%20screen/message_screen.dart';
import 'package:first_app/screens/home/main%20screen/notification_screen.dart';
import 'package:first_app/screens/home/main%20screen/profile_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    HomeScreen(),
    ConnectionScreen(),
    MessageScreen(),
    NotificationScreen(),
    ProfileScreen(),
  ];
  Widget _navItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final selected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF5B8CFF) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 250),
              scale: selected ? 1.15 : 1,
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: selected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _badgeNavItem({
    required int index,
    required IconData icon,
    required int badge,
    required String label,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _navItem(
          index: index,
          icon: icon,
          label: label,
        ),
        Positioned(
          right: 4,
          top: -2,
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: Text(
              badge.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _profileNavItem({
    required int index,
  }) {
    final selected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF5B8CFF) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const CircleAvatar(
          radius: 18,
          backgroundColor: Colors.white,
          child: Icon(
            Icons.person,
            color: Color(0xFF5B8CFF),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF5B8CFF).withOpacity(.25),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(
                index: 0,
                icon: Icons.home_rounded,
                label: "Home",
              ),
              _navItem(
                index: 1,
                icon: Icons.people_alt_rounded,
                label: "Connect",
              ),
              _badgeNavItem(
                index: 2,
                icon: Icons.chat_bubble_rounded,
                badge: 3,
                label: "Messages",
              ),
              _badgeNavItem(
                index: 3,
                icon: Icons.notifications_rounded,
                badge: 8,
                label: "Alerts",
              ),
              _profileNavItem(index: 4),
            ],
          ),
        ),
      ),
    );
  }
}
