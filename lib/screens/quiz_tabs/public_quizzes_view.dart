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
  List<Quiz> _quizzes = [];
  int _currentPage = 1;
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchQuizzes();
    
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && 
          !_isLoadingMore && 
          _hasMore) {
        _fetchQuizzes(loadMore: true);
      }
    });
  }

  _fetchQuizzes({bool loadMore = false}) async {
    if (loadMore) {
      setState(() {
        _isLoadingMore = true;
      });
      _currentPage++;
    } else {
      setState(() {
        _isLoading = true;
        _currentPage = 1;
        _quizzes.clear();
      });
    }

    try {
      final quizzes = await _apiService.fetchQuizzes(null, _searchController.text, true, page: _currentPage);
      setState(() {
      if (loadMore) {
        _quizzes.addAll(quizzes);
        _isLoadingMore = false;
      } else {
        _quizzes = quizzes;
        _isLoading = false;
      }
        _hasMore = quizzes.length == 10;
      });
    } catch (e) {
      setState(() {
        if (loadMore) {
          _isLoadingMore = false;
        } else {
          _isLoading = false;
        }
      });
      print('Erreur lors de la récupération des quiz : $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher un quiz...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (value) => _fetchQuizzes(loadMore: false), 
            ),
          ),
          
          Expanded(
            child: _isLoading 
                ? const Center(child: CircularProgressIndicator())
                
                : _quizzes.isEmpty
                    ? const Center(child: Text('Aucun quiz trouvé.'))
                    
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        
                        itemCount: _quizzes.length + (_hasMore ? 1 : 0),
                        
                        itemBuilder: (context, index) {
                          if (index == _quizzes.length) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          
                          final quiz = _quizzes[index];
                          return QuizCard(
                            quiz: quiz,
                            onTap: () {
                              print("Clic sur le quiz public ${quiz.id}");
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}