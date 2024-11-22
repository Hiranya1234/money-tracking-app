import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/screen/dashboard.dart';
import 'package:flutter_application_4/screen/login.dart';
import 'package:flutter_application_4/screen/welcome_screen.dart'; // Import the WelcomeScreen

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return WelcomeScreen(); // Show WelcomeScreen if no user is logged in
        }
        return Dashboard(); // Show Dashboard if user is authenticated
      },
    );
  }
}
