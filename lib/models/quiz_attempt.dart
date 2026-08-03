import 'package:kanji_mobile/models/quiz.dart';

class QuizAttempt {
  final int id;
  final int score;
  final int maxScore;
  final Quiz quiz;

  QuizAttempt({
    required this.id,
    required this.score,
    required this.maxScore,
    required this.quiz
  });

  factory QuizAttempt.fromJson(Map<String, dynamic> json) {
    return QuizAttempt(
      id: json['id'] as int,
      score: json['score'] as int,
      maxScore: json['maxScore'] as int, 
      quiz: Quiz.fromJson(json['quiz'])
    );
  }
}