import 'package:flutter/material.dart';

class AIAssistantCard extends StatelessWidget {
  const AIAssistantCard({
    super.key,
    this.onTap,
  });

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0F172A),
                Color(0xFF1E293B),
                Color(0xFF334155),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF5B8CFF).withOpacity(.25),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [

              /// AI Logo
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: const Color(0xFF5B8CFF).withOpacity(.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF5B8CFF),
                    width: 2,
                  ),
                ),

                /// Replace this with Image.asset() later
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Color(0xFF5B8CFF),
                  size: 36,
                ),

                /*
                Future:

                child: ClipOval(
                  child: Image.asset(
                    "assets/images/mindnote_ai.png",
                    fit: BoxFit.cover,
                  ),
                ),
                */
              ),

              const SizedBox(width: 18),

              /// Text
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      "MindNote AI",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: .4,
                      ),
                    ),

                    SizedBox(height: 8),

                    Text(
                      "Ask coding doubts, explore careers, connect with seniors, get placement guidance, and discover everything about your campus.",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              /// Arrow
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFF5B8CFF),
                  borderRadius: BorderRadius.circular(14),
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
    );
  }
}