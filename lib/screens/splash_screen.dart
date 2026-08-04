import 'package:flutter/material.dart';
import 'package:kanji_mobile/screens/main_screen.dart';
import 'login_screen.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();

    _checkLoginStatus();

  }

  Future<void>_checkLoginStatus() async {
      final bool isLoggedIn = await _authService.isLoggedIn();

      if (!mounted) return;

      if (isLoggedIn) {
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => const MainScreen())
        );
      } else {
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => const LoginScreen())
        );
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: const CircularProgressIndicator(),
      )
    );
  }
}