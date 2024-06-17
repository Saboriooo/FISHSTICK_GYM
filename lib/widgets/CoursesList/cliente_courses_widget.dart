import 'package:fishstick_gym/models/course.dart';
import 'package:fishstick_gym/providers/theme_provider.dart';
import 'package:fishstick_gym/services/authServices/isar_service.dart';
import 'package:fishstick_gym/services/courseServices/courses_service.dart';
import 'package:fishstick_gym/widgets/QR/qr_widget.dart';
import 'package:flutter/material.dart';

//Lista de cursos para el cliente

class ClienteCoursesList extends StatefulWidget {
  const ClienteCoursesList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ClienteCoursesListState createState() => _ClienteCoursesListState();
}

class _ClienteCoursesListState extends State<ClienteCoursesList> {
  late Future<List<Course>> futureCourses;

  @override
  void initState() {
    super.initState();
    futureCourses = _fetchCourses();
  }

    Future<List<Course>> _fetchCourses() async {//Función para obtener los cursos
    return CourseService().getCoursesForUser();//Llama a la función de CourseService para obtener los cursos
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
  final IsarService isarService = IsarService(); //Instancia de la clase IsarService

  CourseItem({
    super.key,
    required this.course,
  });

  void _showQrCodeDialog(BuildContext context, String username, String courseName) {//Función para mostrar el diálogo del código QR
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return QRCodeDialog(username: username, courseName: courseName);//Muestra el diálogo del código QR
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      
      onTap: () async {//Al tocar un curso muestra el diálogo del código QR
        String username = (await isarService.getUser()).username ?? '';//Obtiene el nombre de usuario que presiona el curso
        // ignore: use_build_context_synchronously
        _showQrCodeDialog(context, username, course.nombre);
      },
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
            GestureDetector(//Al tocar el icono del código QR muestra el diálogo del código QR
              onTap: () async {
                String username = (await isarService.getUser()).username ?? '';//Obtiene el nombre de usuario que presiona el curso
                // ignore: use_build_context_synchronously
                _showQrCodeDialog(context, username, course.nombre);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(1),
                ),
                child: const Icon(Icons.qr_code, size: 20, color: AppTheme.nonBrightOrange),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
