import 'package:fishstick_gym/models/token.dart';
import 'package:fishstick_gym/services/authServices/isar_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginService {
  String baseUrl = dotenv.env['BASE_URL_ANDROID']!;
  final IsarService _isarService = IsarService();

  Future<bool> login(String email, String password) async {
      final url = Uri.parse('$baseUrl/auth/local');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'identifier': email,
          'password': password,
        }),
      );


      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final jwt = responseData['jwt'];
        final userId = responseData['user']['id'];
        final role = await _fetchUserRole(userId);

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

        await _isarService.createToken(jwt, user, role);

        return true; 
      } else {
        // ignore: avoid_print
        print('Fallo al iniciar sesión codigo de status: ${response.statusCode}');
        return false; 
      }
  }

  Future<String> _fetchUserRole(int userId) async {
    final roleUrl = Uri.parse('$baseUrl/users/$userId?populate=role');
    final roleResponse = await http.get(roleUrl);
    if (roleResponse.statusCode == 200) {
      final userRoleData = jsonDecode(roleResponse.body);
      return userRoleData['role']['name'];
    } else {
      throw Exception('Fallo al asignar rol al usuario');
    }
  }
}
