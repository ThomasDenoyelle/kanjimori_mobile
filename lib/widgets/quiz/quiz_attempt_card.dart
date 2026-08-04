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
    final colors = Theme.of(context).colorScheme;

    final mode = getModeDesign(quizAttempt.mode);

    final progress = quizAttempt.maxScore > 0
        ? quizAttempt.answersCount / quizAttempt.maxScore
        : 0.0;


    return Card(
      color: colors.secondary.withValues(alpha: 0.25),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: mode['color'].withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  mode['icon'],
                  color: mode['color'],
                  size: 28,
                ),
              ),
              
              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quizAttempt.quiz.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    
                    const SizedBox(height: 4),
                    
                    Text(
                      mode['text'],
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
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
                              backgroundColor: Colors.white.withValues(alpha: 0.15),
                              color: colors.secondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${quizAttempt.answersCount} / ${quizAttempt.maxScore}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}