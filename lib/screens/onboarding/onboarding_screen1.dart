import 'package:first_app/constants/app_colors.dart';
import 'package:flutter/material.dart';

import 'onboarding_screen2.dart';
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

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
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.25),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ]),
                  child: const Icon(
                    Icons.edit_note_rounded,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              /// Title
              Center(
                child: Text(
                  "Welcome to\nMindNote AI",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              /// Description
              Center(
                child: Text(
                  "Capture your thoughts,\nideas and inspirations\nwith AI assistance.",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
              ),

              const Spacer(),

              /// Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _dot(theme.colorScheme.primary, 24),
                  const SizedBox(width: 8),
                  _dot(Colors.grey.shade300, 8),
                  const SizedBox(width: 8),
                  _dot(Colors.grey.shade300, 8),
                ],
              ),

              const SizedBox(height: 35),

              /// Next Button
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const OnboardingScreen2(),
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 8,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
