import 'package:fishstick_gym/models/token.dart';
import 'package:fishstick_gym/services/authServices/isar_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//Servicio de inicio de sesión

class LoginService {
  String baseUrl = dotenv.env['BASE_URL_ANDROID']!;//URL base de la API
  final IsarService _isarService = IsarService();

  Future<bool> login(String email, String password) async {//Método para iniciar sesión
      final url = Uri.parse('$baseUrl/auth/local');

      final response = await http.post(//Petición POST a la API
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'identifier': email,
          'password': password,
        }),
      );


      if (response.statusCode == 200) {//Si la petición es exitosa

        final responseData = jsonDecode(response.body);//Decodifica la respuesta
        final jwt = responseData['jwt'];//Token de autenticación
        final userId = responseData['user']['id'];//ID del usuario
        final role = await _fetchUserRole(userId);//Rol del usuario

        final user = User(
          id: userId,
          username: responseData['user']['username'],
          email: responseData['user']['email'],
          provider: responseData['user']['provider'],
          confirmed: responseData['user']['confirmed'],
          blocked: responseData['user']['blocked'],
          createdAt: DateTime.parse(responseData['user']['createdAt']),
          updatedAt: DateTime.parse(responseData['user']['updatedAt']),
        );

        await _isarService.createToken(jwt, user, role);//Crea un token en la base de datos isar

        return true; 
      } else {//Si la petición falla
        // ignore: avoid_print
        print('Fallo al iniciar sesión codigo de status: ${response.statusCode}');//Muestra mensaje de error
        return false; 
      }
  }

  Future<String> _fetchUserRole(int userId) async {//Método para obtener el rol del usuario
    final roleUrl = Uri.parse('$baseUrl/users/$userId?populate=role');
    final roleResponse = await http.get(roleUrl);//Petición GET a la API
    if (roleResponse.statusCode == 200) {// Si la petición es exitosa
      final userRoleData = jsonDecode(roleResponse.body);
      return userRoleData['role']['name'];//Devuelve el rol del usuario
    } else {//Si la petición falla
      throw Exception('Fallo al asignar rol al usuario');//Muestra mensaje de error
    }
  }
}
