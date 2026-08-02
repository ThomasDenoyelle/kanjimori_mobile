import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();

  Future<bool> login(String email, String password) async {
    final url = Uri.parse('http://192.168.1.41:8080/api/login_check');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200){
        final data = jsonDecode(response.body);
        await _storage.write(key: 'jwt', value: data['token']);
        return true;
      }

      return false;

    } catch (e) {
      print("Erreur de connexion : $e");
      return false;
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt');
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'jwt');
  
    if (token == null) {
      return false;
    }

    bool isExpired = JwtDecoder.isExpired(token);

    if (isExpired) {
      await logout();
      return false;
    }

    return true;
  }
}