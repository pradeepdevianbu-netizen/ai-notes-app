import 'package:flutter/material.dart';

class YearCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const YearCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color,
                  color.withOpacity(.75),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(.35),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    height: 68,
                    width: 68,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.18),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 34,
                    ),
                  ),

                  const SizedBox(width: 18),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: Colors.white.withOpacity(.8),
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    height: 46,
                    width: 46,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.18),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}