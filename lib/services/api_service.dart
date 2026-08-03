import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kanji_mobile/models/quiz.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kanji_mobile/models/quiz_attempt.dart';

class ApiService {
  final _storage = const FlutterSecureStorage();

  Future<List<Quiz>> fetchQuizzes() async {
    final token = await _storage.read(key: 'jwt');

    final url = Uri.parse('http://192.168.1.41:8080/api/quizzes');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/ld+json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        
        final decodedBody = jsonDecode(response.body);

        List<dynamic> listToParse = [];

        if (decodedBody is List) {
          listToParse = decodedBody;
        } else if (decodedBody is Map && decodedBody.containsKey('member')) {
          listToParse = decodedBody['member'];
        } 
        else {
          print('Format de réponse non reconnu');
          return [];
        }

        return listToParse.map((json) => Quiz.fromJson(json)).toList();
        
      } else {
        print('Erreur serveur : ${response.statusCode}');
        return [];
      }
      
    } catch (e) {
      print("Erreur lors de la récupération des quiz : $e");
      return [];
    }
    
  }


  Future<List<QuizAttempt>> fetchMyAttempts() async {
    final token = await _storage.read(key: 'jwt');

    final url = Uri.parse('http://192.168.1.41:8080/api/quiz_attempts');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/ld+json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        
        final decodedBody = jsonDecode(response.body);

        List<dynamic> listToParse = [];

        if (decodedBody is List) {
          listToParse = decodedBody;
        } else if (decodedBody is Map && decodedBody.containsKey('member')) {
          listToParse = decodedBody['member'];
        } 
        else {
          print('Format de réponse non reconnu');
          return [];
        }

        return listToParse.map((json) => QuizAttempt.fromJson(json)).toList();
        
      } else {
        print('Erreur serveur : ${response.statusCode}');
        return [];
      }
      
    } catch (e) {
      print("Erreur lors de la récupération des quiz : $e");
      return [];
    }
    
  }
}