import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/constants/app_colors.dart';
import 'package:first_app/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isPasswordHidden = true;
  bool isConfirmPasswordHidden = true;

    // Firebase Auth
final FirebaseAuth _auth = FirebaseAuth.instance;

// Text Controllers
final TextEditingController fullNameController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController confirmPasswordController =
    TextEditingController();


Future<void> signUp() async {
  if (passwordController.text.trim() !=
      confirmPasswordController.text.trim()) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Passwords do not match"),
      ),
    );
    return;
  }

  try {
    await _auth.createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Account Created Successfully"),
      ),
    );

    fullNameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();

    // TODO: Navigate to Home Screen
  } on FirebaseAuthException catch (e) {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.message ?? "Something went wrong"),
      ),
    );
  }
}



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),

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
                        color: theme.colorScheme.primary.withValues(alpha: 0.25),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                   Icons.rocket_launch_rounded,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Center(
                child: Text(
                  "Create Account",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Center(
                child: Text(
                  "Create your MindNote AI account",
                  style: theme.textTheme.bodyMedium,
                ),
              ),

              const SizedBox(height: 40),

              /// Full Name
               TextField(
                controller: fullNameController,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  prefixIcon: Icon(Icons.person_outline),
                  
                ),
              ),

              const SizedBox(height: 20),

              /// Email
               TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),

              const SizedBox(height: 20),

              /// Password
              TextField(
                controller: passwordController,
                obscureText: isPasswordHidden,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordHidden
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordHidden = !isPasswordHidden;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// Confirm Password
              TextField(
                controller: confirmPasswordController,
                obscureText: isConfirmPasswordHidden,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isConfirmPasswordHidden
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        isConfirmPasswordHidden = !isConfirmPasswordHidden;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 36),
                  //height changed

              /// Create Account Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: signUp,
                  child: const Text("Create Account"),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginScreen(),
                      ),
                    );
                    },
                    child: const Text("Sign In"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}