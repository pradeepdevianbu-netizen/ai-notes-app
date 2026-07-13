import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/screens/Profile/complete_profile_screen.dart';
import 'package:first_app/screens/auth/login_screen.dart';
import 'package:first_app/screens/home/main%20screen/main_screen.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        print("Current User: ${FirebaseAuth.instance.currentUser}");
        print("UID: ${FirebaseAuth.instance.currentUser?.uid}");
        print("Has Data: ${authSnapshot.hasData}");

        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // User not logged in
        if (!authSnapshot.hasData) {
          return const LoginScreen();
        }

        final user = authSnapshot.data!;

        // User logged in → Check profile
        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .get(),
          builder: (context, profileSnapshot) {
            if (profileSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            // Profile not created
            if (!profileSnapshot.hasData || !profileSnapshot.data!.exists) {
              return const CompleteProfileScreen();
            }

            // Everything completed
            return const MainScreen();
          },
        );
      },
    );
  }
}
