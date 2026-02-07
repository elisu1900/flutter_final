import 'package:flutter/material.dart';
import 'package:flutter_final_app/routes/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  void _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEF6C00),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/state_images/logo_splash.png',
              width: 80,
              height: 80,
              color: const Color(0xFFFAFAF7),
            ),
            const SizedBox(height: 16),
            const Text(
              'NutriTrack',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Color(0xFFFAFAF7),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tu compañero de nutrición',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFFAFAF7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}