import 'package:flutter/material.dart';
import 'package:kanji_mobile/models/quiz_attempt.dart';
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
  late Future<List<QuizAttempt>> _attemptsFuture;

  @override
  void initState() {
    super.initState();
    _attemptsFuture = _apiService.fetchMyAttempts();
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
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _confirmLogout(context),
          
          ),
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
      itemCount: attempts.length,
      itemBuilder: (context, index) {
        final quizAttempt = attempts[index];
        final modeDesign = _getModeDesign(quizAttempt.mode);
        final double progress = quizAttempt.maxScore > 0 
            ? quizAttempt.answersCount / quizAttempt.maxScore 
            : 0.0;

        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: modeDesign['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(modeDesign['icon'], color: modeDesign['color']),
              ),
              
              title: Text(
                quizAttempt.quiz.title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  
                  Text(
                    modeDesign['text'],
                    style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 8,
                            backgroundColor: Colors.deepPurple.withOpacity(0.15),
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${quizAttempt.answersCount} / ${quizAttempt.maxScore}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
              
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                print('Clic sur le quiz ${quizAttempt.id}');
              },
            ),
          ),
        );
      }
      ); 
  },
      ),
    );
  }
}