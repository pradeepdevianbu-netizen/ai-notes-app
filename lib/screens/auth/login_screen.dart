import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/screens/Profile/complete_profile_screen.dart';
import 'package:first_app/screens/auth/sign_up_screen.dart';
import 'package:first_app/screens/home/home_screen.dart';

import 'package:flutter/material.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPasswordHidden = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signIn() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login Successful"),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const CompleteProfileScreen (), // Change this to your next screen
        ),
      );

      // Navigate to Home Screen
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (_) => const HomeScreen()),
      // );
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Login Failed"),
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
              const SizedBox(height: 60),

              /// Title
              Center(
                child: Text(
                  "Welcome Back",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Center(
                child: Text(
                  "Login to continue your MindNote AI",
                  style: theme.textTheme.bodyMedium,
                ),
              ),

              const SizedBox(height: 50),

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

              const SizedBox(height: 10),

              /// Forgot password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text("Forgot Password?"),
                ),
              ),

              const SizedBox(height: 30),

              /// Login Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: signIn,
                  child: const Text("Login"),
                ),
              ),

              const SizedBox(height: 20),

              /// Go to Sign Up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SignUpScreen(),
                        ),
                      );
                    },
                    child: const Text("Sign Up"),
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
