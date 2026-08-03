import 'package:flutter/material.dart';
import 'package:kanji_mobile/models/quiz_attempt.dart';
import 'package:kanji_mobile/services/auth_service.dart';
import 'package:kanji_mobile/widgets/common/confirm_dialog.dart';
import 'package:kanji_mobile/widgets/quiz/quiz_attempt_card.dart';
import 'login_screen.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<QuizAttempt>> _attemptsFuture;

  @override
  void initState() {
    super.initState();
    _attemptsFuture = _apiService.fetchMyAttempts();
  }

  Map<String, dynamic> _getModeDesign(String mode) {
    switch (mode) {
      case 'mode_kanji':
        return {'text': 'Mode Kanji', 'icon': Icons.draw, 'color': Colors.redAccent};
      case 'mode_reading':
        return {'text': 'Mode Lecture', 'icon': Icons.record_voice_over, 'color': Colors.blueAccent};
      case 'mode_translation':
        return {'text': 'Mode Traduction', 'icon': Icons.translate, 'color': Colors.green};
      default:
        return {'text': 'Mode Classique', 'icon': Icons.videogame_asset, 'color': Colors.deepPurple};
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil'),
        actions: <Widget>[
          ConfirmDialog()
        ],
        ),
      body: FutureBuilder<List<QuizAttempt>>(
        future: _attemptsFuture,
        builder: (context, snapshot) {
    
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucune tentative pour le moment.'));
          }
    
          final attempts = snapshot.data!;
    
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: attempts.length,

            itemBuilder: (context, index) {

              final attempt = attempts[index];

              return QuizAttemptCard(
                quizAttempt: attempt,
                onTap: () {
                  print("Quiz ${attempt.id}");
                },
              );
            },
          );
        },
      ),
    );
  }
}