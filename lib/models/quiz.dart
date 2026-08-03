import 'question.dart';

class Quiz {
  final int id;
  final String title;
  final bool isPublic;
  final DateTime createdAt;
  final List<Question> questions;

  Quiz({
      required this.id,
      required this.title,
      required this.isPublic,
      required this.createdAt,
      required this.questions
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] as int,
      title: json['title'] as String,
      isPublic: json['isPublic'] ?? false, 
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'] as String) 
          : DateTime.now(),
      questions: (json['questions'] as List<dynamic>?)
          ?.map((questionJson) => Question.fromJson(questionJson))
          .toList() ?? [],
    );
  }
}