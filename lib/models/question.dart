class Question {
  final int id;
  final String kanji;
  final String reading;
  final String translation;

  Question({
      required this.id,
      required this.kanji,
      required this.reading,
      required this.translation
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as int,
      kanji: json['kanji'] as String,
      reading: json['reading'] as String, 
      translation: json['translation'] as String,
    );
  }
}