import 'package:first_app/constants/app_colors.dart';

import 'package:flutter/material.dart';

import 'onboarding_screen3.dart';

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Skip Button
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text("Skip"),
                ),
              ),

              const Spacer(),

              /// Logo
              Center(
                child: Container(
                  height: 110,
                  width: 110,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.25),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.edit_note_rounded,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              /// Title
              Center(
                child: Text(
                  "AI That Understands\nYour Notes",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// Description
              Center(
                child: Text(
                  "Summarize, rewrite,\ntranslate and organize\nyour notes with AI.",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
              ),

              const Spacer(),

              /// Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _dot(Colors.grey.shade300, 8),
                  const SizedBox(width: 8),
                  _dot(theme.colorScheme.primary, 24),
                  const SizedBox(width: 8),
                  _dot(Colors.grey.shade300, 8),
                ],
              ),

              const SizedBox(height: 30),

              /// Next Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const OnboardingScreen3(),
                      ),
                    );
                  },
                  child: const Text("Next"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _dot(Color color, double width) {
    return Container(
      width: width,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}