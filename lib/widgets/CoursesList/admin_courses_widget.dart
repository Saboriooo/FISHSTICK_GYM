import 'package:fishstick_gym/models/course.dart';
import 'package:fishstick_gym/providers/theme_provider.dart';
import 'package:fishstick_gym/services/courseServices/courses_service.dart';
import 'package:fishstick_gym/widgets/CoursesCRUD/course_actions_widget.dart';
import 'package:flutter/material.dart';

//Lista de cursos para el administrador

class AdminCoursesList extends StatefulWidget {
  const AdminCoursesList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdminCoursesListState createState() => _AdminCoursesListState();
}

class _AdminCoursesListState extends State<AdminCoursesList> {
  late Future<List<Course>> futureCourses;

  @override
  void initState() {
    super.initState();
    futureCourses = _fetchCourses();
  }

  Future<List<Course>> _fetchCourses() async {//Función para obtener los cursos
    return CourseService().getCourses();//Llama a la función de CourseService para obtener los cursos
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Course>>(
        future: futureCourses,
        builder: (context, snapshot) {//Construye la lista de cursos
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay cursos disponibles'));
          } else {
            final courses = snapshot.data!;
            return ListView.builder(//Crea los items de la lista de cursos
              itemCount: courses.length,
              itemBuilder: (context, index) {
                return CourseItem(course: courses[index]);
              },
            );
          }
        },
      ),
    );
  }
}

class CourseItem extends StatelessWidget {
  final Course course;

  const CourseItem({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showCourseActions(context, course),//Muestra las acciones del curso al tocarlo
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.nonBrightOrange,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.7),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(//Nombre del curso
                    course.nombre,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(//Capacidad del curso
                    'Capacidad: ${course.capacidad}',
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => showCourseActions(context, course),//Muestra las acciones del curso al tocarlo
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(1),
                ),
                child: const Icon(Icons.arrow_forward_ios, size: 20, color: AppTheme.nonBrightOrange),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
