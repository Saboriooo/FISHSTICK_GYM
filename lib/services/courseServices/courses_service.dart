import 'package:fishstick_gym/models/course.dart';
import 'package:fishstick_gym/models/token.dart';
import 'package:fishstick_gym/services/authServices/isar_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//Servicio de cursos

class CourseService {
  String baseUrl = dotenv.env['BASE_URL_ANDROID']!;//URL base de la API
  final IsarService _isarService = IsarService();//Instancia del servicio de la base de datos Isar

  Future<List<Course>> getCourses() async {//Método para obtener todos los cursos
    final url = Uri.parse('$baseUrl/cursos');
    final token = await _isarService.getToken(); //Obtiene el token de la base de datos isar

    final response = await http.get(//Petición GET a la API
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {//Si la petición es exitosa
      List<Course> cursos = [];
      final data = json.decode(response.body);//Decodifica la respuesta

      for (var courseJson in data['data']) {
        cursos.add(Course.fromJson(courseJson));//Agrega los cursos a la lista
      }
      return cursos;//Retorna la lista de cursos
    } else {//Si la petición falla
      return [];//Retorna una lista vacía
    }
  }

  Future<List<Course>> getCoursesForUser() async {//Método para obtener los cursos de un usuario
    try {
      final url = Uri.parse('$baseUrl/users/me?populate=cursos');
      final token = await _isarService.getToken();//Obtiene el token de la base de datos isar

      final response = await http.get(//Petición GET a la API
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {//Si la petición es exitosa
        List<Course> cursos = [];
        final data = json.decode(response.body);//Decodifica la respuesta

        if (data['cursos'] != null) {//Si la respuesta contiene la clave 'cursos'
          List<dynamic> cursosJson = data['cursos'];
          cursos = cursosJson.map((courseJson) => Course.fromJson(courseJson)).toList();//Mapea los cursos y los incluye en unsa lista
        }

        return cursos;//Retorna la lista de cursos
      } else {//Si la petición falla
        throw Exception('Failed to load user courses');//Muestra mensaje de error
      }
    } catch (e) {
      throw Exception('Failed to load user courses: $e');
    }
  }

  Future<List<User>> getParticipantsForCourse(int courseId) async {//Método para obtener los participantes de un curso
    final url = Uri.parse('$baseUrl/cursos/$courseId?populate=users');
    final token = await _isarService.getToken(); //Obtiene el token de la base de datos isar

    final response = await http.get(//Petición GET a la API
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {//Si la petición es exitosa
      List<User> users = [];
      final data = json.decode(response.body)['data'];//Decodifica la respuesta

      if (data['attributes']['users'] != null) {//Si la respuesta contiene la clave 'users'
        List<dynamic> usersJson = data['attributes']['users']['data'];
        users = usersJson.map((userJson) => User.fromJson(userJson)).toList();//Mapea los usuarios y los incluye en una lista
      }

      return users;//Retorna la lista de usuarios
    } else {//Si la petición falla
      throw Exception('Failed to load participants for course');//Muestra mensaje de error
    }
  }


  Future<bool> modifyCourse(int id, String nombre, String capacidad) async {//Método para modificar un curso
    final url = Uri.parse('$baseUrl/cursos/$id');
    final token = await _isarService.getToken();//Obtiene el token de la base de datos isar

    final response = await http.put(//Petición PUT a la API
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'data':{
          'Nombre': nombre,
          'Capacidad': capacidad
        }
      }),
    );

    if (response.statusCode == 200) {//Si la petición es exitosa
      return true;//Modificación exitosa
    } else {//Si la petición falla
      // ignore: avoid_print
      print('Modify course failed with status: ${response.statusCode}');//Muestra mensaje de error
      return false;
    }
  }

  Future<bool> createCourse(String nombre, String capacidad) async {//Método para crear un curso
  final url = Uri.parse('$baseUrl/cursos');
  final token = await _isarService.getToken();//Obtiene el token de la base de datos isar

  final response = await http.post(//Petición POST a la API
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'data': {
        'Nombre': nombre,
        'Capacidad': capacidad
      }
    }),
  );

  if (response.statusCode == 200) {//Si la petición es exitosa
    return true;//Creación exitosa
  } else {//Si la petición falla
    // ignore: avoid_print
    print('Failed to create course: ${response.statusCode}, ${response.body}');//Muestra mensaje de error
    return false;
  }
}

  Future<bool> deleteCourse(int id) async {//Método para eliminar un curso

    final participants = await getParticipantsForCourse(id);//Obtiene los participantes del curso
    if (participants.isNotEmpty) {//Si el curso tiene participantes
      return false;//No se puede eliminar el curso
    }

    final url = Uri.parse('$baseUrl/cursos/$id');
    final token = await _isarService.getToken();//Obtiene el token de la base de datos isar

    final response = await http.delete(//Petición DELETE a la API
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {//Si la petición es exitosa
      return true;//Eliminación exitosa
    } else {//Si la petición falla
      return false;//Eliminación fallida
    }
  }
}
