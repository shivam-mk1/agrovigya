import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigateNext();
  }

  void _navigateNext() async {
    await Future.delayed(const Duration(seconds: 5));
    if (!mounted) return;
    context.go('/auth');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFF8F0),
      body: SafeArea(
        child: Center(
          child: CircleAvatar(
            radius: MediaQuery.of(context).size.height * 0.15,
            backgroundColor: Color(0xff01342C),
            child: LayoutBuilder(
              builder:
                  (context, constraints) => SvgPicture.asset(
                    'assets/images/logo.svg',
                    width: constraints.maxWidth * 0.8,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
