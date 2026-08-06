import 'package:flutter/material.dart';
import 'package:kanji_mobile/models/quiz.dart';
import 'package:kanji_mobile/services/api_service.dart';
import 'package:kanji_mobile/widgets/common/gradient_background.dart';
import 'package:kanji_mobile/widgets/quiz/quiz_card.dart';

class PublicQuizzesView extends StatefulWidget {
  const PublicQuizzesView({super.key});

  @override
  State<PublicQuizzesView> createState() => _PublicQuizzesViewState();
}

class _PublicQuizzesViewState extends State<PublicQuizzesView> {

  final ApiService _apiService = ApiService();
  Future<List<Quiz>>? _quizzesFuture;

  @override
  void initState() {
    super.initState();
    _loadMyQuizzes();
  }

  Future<void> _loadMyQuizzes() async {
    setState(() {
        _quizzesFuture = _apiService.fetchQuizzes(null, null, true);
      });
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
                  
                },
              );
            },
          );
        },
      ),
    );
  }
}