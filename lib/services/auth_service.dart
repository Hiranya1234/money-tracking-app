import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/services/db.dart';

class AuthService {
  final Db db = Db();

  Future<void> createUser(
      Map<String, String> data, BuildContext context) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: data['email']!,
        password: data['password']!,
      );
      await db.addUser(data, context);
    } catch (e) {
      _showErrorDialog(context, "Sign Up Failed", e.toString());
    }
  }

  Future<bool> login(Map<String, String> data, BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: data['email']!,
        password: data['password']!,
      );
      return true; // Login successful
    } catch (e) {
      _showErrorDialog(context, "Login Error", e.toString());
      return false; // Login failed
    }
  }

  Future<void> sendPasswordRecoveryEmail(
      String email, BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _showSuccessDialog(context, "Password Recovery Email Sent",
          "Please check your email to reset your password.");
    } catch (e) {
      _showErrorDialog(context, "Error", e.toString());
    }
  }

  Future<void> updatePassword(String newPassword, BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await user.updatePassword(newPassword);
        _showSuccessDialog(context, "Password Updated",
            "Your password has been updated successfully.");
      } catch (e) {
        _showErrorDialog(context, "Error", e.toString());
      }
    } else {
      _showErrorDialog(context, "Error", "No user is logged in.");
    }
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}




