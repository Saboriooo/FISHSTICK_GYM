import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupService {
  String baseUrl = dotenv.env['BASE_URL_ANDROID']!;

  Future<bool> register(String username, email, String password) async {
    final url = Uri.parse('$baseUrl/auth/local/register');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      // Manejar error de login
      // ignore: avoid_print
      print('Registro fallido');
      return false;
    }
  }
}