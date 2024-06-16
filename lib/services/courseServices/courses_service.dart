import 'package:fishstick_gym/models/course.dart';
import 'package:fishstick_gym/models/token.dart';
import 'package:fishstick_gym/services/authServices/isar_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class CourseService {
  String baseUrl = dotenv.env['BASE_URL_ANDROID']!;
  final IsarService _isarService = IsarService();

  Future<List<Course>> getCourses() async {
    final url = Uri.parse('$baseUrl/cursos');
    final token = await _isarService.getToken(); 

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<Course> cursos = [];
      final data = json.decode(response.body);

      for (var courseJson in data['data']) {
        cursos.add(Course.fromJson(courseJson));
      }
      return cursos;
    } else {
      return [];
    }
  }

  Future<List<Course>> getCoursesForUser() async {
    try {
      final url = Uri.parse('$baseUrl/users/me?populate=cursos');
      final token = await _isarService.getToken();

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<Course> cursos = [];
        final data = json.decode(response.body);

        if (data['cursos'] != null) {
          List<dynamic> cursosJson = data['cursos'];
          cursos = cursosJson.map((courseJson) => Course.fromJson(courseJson)).toList();
        }

        return cursos;
      } else {
        throw Exception('Failed to load user courses');
      }
    } catch (e) {
      throw Exception('Failed to load user courses: $e');
    }
  }

  Future<List<User>> getParticipantsForCourse(int courseId) async {
    final url = Uri.parse('$baseUrl/cursos/$courseId?populate=users');
    final token = await _isarService.getToken(); 

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<User> users = [];
      final data = json.decode(response.body)['data'];

      if (data['attributes']['users'] != null) {
        List<dynamic> usersJson = data['attributes']['users']['data'];
        users = usersJson.map((userJson) => User.fromJson(userJson)).toList();
      }

      return users;
    } else {
      throw Exception('Failed to load participants for course');
    }
  }


  Future<bool> modifyCourse(int id, String nombre, String capacidad) async {
    final url = Uri.parse('$baseUrl/cursos/$id');
    final token = await _isarService.getToken();

    final response = await http.put(
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

    if (response.statusCode == 200) {
      return true;
    } else {
      // ignore: avoid_print
      print('Modify course failed with status: ${response.statusCode}');
      return false;
    }
  }

  Future<bool> createCourse(String nombre, String capacidad) async {
  final url = Uri.parse('$baseUrl/cursos');
  final token = await _isarService.getToken();

  final response = await http.post(
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

  if (response.statusCode == 200) {
    return true;
  } else {
    // ignore: avoid_print
    print('Failed to create course: ${response.statusCode}, ${response.body}');
    return false;
  }
}

  Future<bool> deleteCourse(int id) async {

    final participants = await getParticipantsForCourse(id);
    if (participants.isNotEmpty) {
      return false;
    }

    final url = Uri.parse('$baseUrl/cursos/$id');
    final token = await _isarService.getToken();

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
