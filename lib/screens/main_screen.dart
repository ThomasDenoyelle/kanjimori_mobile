import 'package:flutter/material.dart';
import 'package:kanji_mobile/screens/home_screen.dart';
import 'package:kanji_mobile/screens/quiz_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const QuizScreen(),
    const Center(child: Text('Explorer les dossiers')),
    const Center(child: Text('Mon Profil')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.home_outlined),
            icon: Icon(Icons.home_outlined),
            label: 'Accueil',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.quiz),
            icon: Icon(Icons.quiz_outlined),
            label: 'Quiz',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.folder),
            icon: Icon(Icons.folder_copy_outlined),
            label: 'Dossiers',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}