import 'package:flutter/material.dart';
import 'package:kanji_mobile/screens/quiz_tabs/history_view.dart';
import 'package:kanji_mobile/screens/quiz_tabs/my_quizzes_view.dart';
import 'package:kanji_mobile/screens/quiz_tabs/public_quizzes_view.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: TabBar(
            labelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 16,
            ),
            dividerColor: Colors.transparent,
            indicatorColor: Colors.deepPurpleAccent,
            tabs: [
              Tab(child: Text('Mes Quiz'),),
              Tab(child: Text('Publics'),),
              Tab(child: Text('Historique'))
            ]
          ),
        ),
        body: TabBarView(
            children: [
              MyQuizzesView(),
              PublicQuizzesView(),
              HistoryView()
            ],
          ),
      ),
    );
  }
}