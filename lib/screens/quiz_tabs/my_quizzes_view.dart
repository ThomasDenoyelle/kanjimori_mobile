import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:kanji_mobile/models/quiz.dart';
import 'package:kanji_mobile/services/api_service.dart';
import 'package:kanji_mobile/services/auth_service.dart';
import 'package:kanji_mobile/widgets/common/gradient_background.dart';
import 'package:kanji_mobile/widgets/quiz/quiz_card.dart';

class MyQuizzesView extends StatefulWidget {
  const MyQuizzesView({super.key});

  @override
  State<MyQuizzesView> createState() => _MyQuizzesViewState();
}

class _MyQuizzesViewState extends State<MyQuizzesView> {
  final ApiService _apiService = ApiService();
 Future<List<Quiz>>? _quizzesFuture;

  @override
  void initState() {
    super.initState();
    _loadMyQuizzes();
  }

  Future<void> _loadMyQuizzes() async {
    final userData = await _apiService.getCurrentUser();
    
    if (userData != null && userData.containsKey('id')) {
      final String authorUrl = '/api/users/${userData['id']}';
      
      setState(() {
        _quizzesFuture = _apiService.fetchQuizzes(authorUrl, null, null);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: FutureBuilder<List<Quiz>>(
        future: _quizzesFuture, 
        builder: (context, snapshot) {

          if (_quizzesFuture == null) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun quiz pour le moment.'));
          }

          final quizzes = snapshot.data!;
    
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: quizzes.length,

            itemBuilder: (context, index) {

              final quiz = quizzes[index];

              return QuizCard(
                quiz: quiz,
                onTap: () {
                  print("Quiz ${quiz.id}");
                },
              );
            },
          );
        }
        ),
    );
  }
}