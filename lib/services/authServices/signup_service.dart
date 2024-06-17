import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//Servicio de registro

class SignupService {
  String baseUrl = dotenv.env['BASE_URL_ANDROID']!;//URL base de la API

  Future<bool> register(String username, email, String password) async {//Método para registrar un usuario
    final url = Uri.parse('$baseUrl/auth/local/register');

    final response = await http.post(//Petición POST a la API
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

    if (response.statusCode == 200) {//Si la petición es exitosa
      return true;//Registro exitoso
    } else {//Si la petición falla
      // ignore: avoid_print
      print('Registro fallido');//Muestra mensaje de error
      return false;
    }
  }
}