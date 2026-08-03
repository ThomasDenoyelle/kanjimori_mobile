import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KanjiMori',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,

          primary: Color(0xFF7C3AED),
          onPrimary: Colors.white,

          secondary: Color(0xFFA78BFA),
          onSecondary: Colors.white,

          error: Colors.redAccent,
          onError: Colors.white,

          surface: Color(0xFF1D232A),
          onSurface: Colors.white,

          primaryContainer: Color(0xFF2B2344),
          onPrimaryContainer: Colors.white,

          secondaryContainer: Color(0xFF1F2333),
          onSecondaryContainer: Colors.white,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}