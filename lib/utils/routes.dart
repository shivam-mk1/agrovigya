
import 'package:agro/home.dart';
import 'package:agro/pageview.dart';
import 'package:agro/splash.dart';
import 'package:agro/views/pages/about_us.dart';
import 'package:agro/views/pages/farmer_main.dart';
import 'package:agro/views/pages/login.dart';
import 'package:agro/views/pages/signup_details.dart';
import 'package:agro/views/pages/sign_up_password.dart';
import 'package:agro/wrapper/auth_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const Splash(),
      ),
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthWrapper(),
      ),
      GoRoute(
        path: '/slideshow',
        builder: (context, state) => const SlideshowScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const Home(),
      ),
      GoRoute(
        path: '/login/:userType',
        builder: (context, state) {
          final userType = state.pathParameters['userType']!;
          return SignIn(userType: userType);
        },
      ),
      GoRoute(
        path: '/signup/:userType',
        builder: (context, state) {
          final userType = state.pathParameters['userType']!;
          return SignUp(userType: userType);
        },
      ),
      GoRoute(
        path: '/signup-password/:email',
        builder: (context, state) {
          final email = state.pathParameters['email']!;
          return SignUpPassword(email: email);
        },
      ),
      GoRoute(
        path: '/main',
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: '/about-us',
        builder: (context, state) => const AboutUsScreen(),
      ),
    ],
    redirect: (context, state) {
      final auth = FirebaseAuth.instance;
      final user = auth.currentUser;

      final loggingIn = state.matchedLocation == '/login/:userType' || state.matchedLocation == '/signup/:userType';

      if (user == null && !loggingIn) {
        return '/slideshow';
      }

      if (user != null && loggingIn) {
        return '/main';
      }

      return null;
    },
  );
}
