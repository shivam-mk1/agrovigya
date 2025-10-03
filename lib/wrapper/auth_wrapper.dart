import 'package:agro/pageview.dart';
import 'package:agro/services/auth_service.dart';
import 'package:agro/views/pages/farmer_main.dart';
import 'package:agro/views/widgets/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CustomLoadingWidget(color: Colors.green, size: 50),
            ),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          return MainScreen();
        } else {
          return SlideshowScreen();
        }
      },
    );
  }
}
