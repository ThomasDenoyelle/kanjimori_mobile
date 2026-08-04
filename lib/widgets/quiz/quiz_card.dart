import 'package:flutter/material.dart';
import 'package:kanji_mobile/models/quiz.dart';
import '../../models/quiz_attempt.dart';

class QuizCard extends StatelessWidget {
  final Quiz quiz;
  final VoidCallback? onTap;

  const QuizCard({
    super.key,
    required this.quiz,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

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
                
              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quiz.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    
                    
                    const SizedBox(height: 12),
                    
                  
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