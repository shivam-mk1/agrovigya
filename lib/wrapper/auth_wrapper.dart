import 'package:agro/custom%20widgets/custom_loading_widget.dart';
import 'package:agro/pages/farmer_main.dart';
import 'package:agro/pageview.dart';
import 'package:agro/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            return SlideshowScreen();
          } else {
            return MainScreen();
          }
        } else {
          return CustomLoadingWidget(color: Colors.green, size: 50);
        }
      },
    );
  }
}
