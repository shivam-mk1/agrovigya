import 'package:agro/pageview.dart';
import 'package:agro/splash.dart';
import 'package:agro/views/pages/about_us.dart';
import 'package:agro/views/pages/farmer_main.dart';
import 'package:agro/views/login/login.dart';
import 'package:agro/views/login/signup.dart';
import 'package:agro/views/login/sign_up_password.dart';
import 'package:agro/views/login/login_or_signup.dart';
import 'package:agro/views/pages/profile_screen.dart';
import 'package:agro/wrapper/auth_wrapper.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const Splash()),
      GoRoute(path: '/auth', builder: (context, state) => const AuthWrapper()),
      GoRoute(
        path: '/slideshow',
        builder: (context, state) => const SlideshowScreen(),
      ),
      GoRoute(
        path: '/login-or-signup',
        builder: (context, state) => const SelectUserRole(),
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
      GoRoute(path: '/main', builder: (context, state) => const MainScreen()),
      GoRoute(
        path: '/about-us',
        builder: (context, state) => const AboutUsScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
}
