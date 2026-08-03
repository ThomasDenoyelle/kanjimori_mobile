import 'package:flutter/material.dart';
import 'package:kanji_mobile/services/auth_service.dart';
import 'login_screen.dart';
import '../services/api_service.dart';
import '../models/quiz.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Quiz>> _quizzesFuture;

  @override
  void initState() {
    super.initState();
    _quizzesFuture = _apiService.fetchQuizzes();
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Déconnexion'),
          content: const Text(
            'Êtes-vous sûr de vouloir vous déconnecter ?',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Se déconnecter'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      final authService = AuthService();
      await authService.logout();

      if (!context.mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _confirmLogout(context),
          
          ),
        ],
        ),
      body: FutureBuilder<List<Quiz>>(
  future: _quizzesFuture,
  builder: (context, snapshot) {
    
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasError) {
      return Center(child: Text('Erreur : ${snapshot.error}'));
    }
    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Center(child: Text('Aucun quiz disponible.'));
    }
    
    final quizzes = snapshot.data!;
    
    return ListView.builder(
      itemCount: quizzes.length,
      itemBuilder: (context, index) {
        final quiz = quizzes[index];

        return ListTile(
          title: Text(quiz.title),
          subtitle: Text('${quiz.questions.length} questions'),
          leading: Icon(Icons.quiz),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () { print('Clic sur le quiz ${quiz.id}'); }
        );
      }
      ); 
  },
      ),
    );
  }
}