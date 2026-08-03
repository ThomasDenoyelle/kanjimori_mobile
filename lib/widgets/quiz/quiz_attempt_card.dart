import 'package:flutter/material.dart';
import '../../models/quiz_attempt.dart';

class QuizAttemptCard extends StatelessWidget {
  final QuizAttempt quizAttempt;
  final VoidCallback? onTap;

  const QuizAttemptCard({
    super.key,
    required this.quizAttempt,
    this.onTap,
  });


  Map<String, dynamic> getModeDesign(String mode) {
    switch (mode) {
      case 'mode_kanji':
        return {
          'text': 'Mode Kanji',
          'icon': Icons.draw,
          'color': Colors.redAccent
        };

      case 'mode_reading':
        return {
          'text': 'Mode Lecture',
          'icon': Icons.record_voice_over,
          'color': Colors.blueAccent
        };

      case 'mode_translation':
        return {
          'text': 'Mode Traduction',
          'icon': Icons.translate,
          'color': Colors.green
        };

      default:
        return {
          'text': 'Mode Classique',
          'icon': Icons.videogame_asset,
          'color': Colors.deepPurple
        };
    }
  }


  @override
  Widget build(BuildContext context) {

    final mode = getModeDesign(quizAttempt.mode);

    final progress = quizAttempt.maxScore > 0
        ? quizAttempt.answersCount / quizAttempt.maxScore
        : 0.0;


    return Card(
      child: ListTile(
        onTap: onTap,

        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: mode['color'].withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),

          child: Icon(
            mode['icon'],
            color: mode['color'],
          ),
        ),


        title: Text(
          quizAttempt.quiz.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),


        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 6),

            Text(
              mode['text'],
            ),


            const SizedBox(height: 12),


            Row(
              children: [

                Expanded(
                  child: LinearProgressIndicator(
                    value: progress,
                  ),
                ),

                const SizedBox(width: 12),

                Text(
                  '${quizAttempt.answersCount}/${quizAttempt.maxScore}',
                ),
              ],
            )
          ],
        ),

        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),
      ),
    );
  }
}