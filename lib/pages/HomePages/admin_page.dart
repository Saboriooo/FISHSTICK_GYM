import 'package:fishstick_gym/providers/theme_provider.dart';
import 'package:fishstick_gym/widgets/CoursesCRUD/course_create_widget.dart';
import 'package:flutter/material.dart';
import 'package:fishstick_gym/widgets/CoursesList/admin_courses_widget.dart';

//Página de administrador de la aplicación, Route: '/admin'

void main() => runApp(const AdminPage());

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.nonBrightOrange,
                  width: 2.0,
                ),
              ),
            ),
            child: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              leading: IconButton(//Botón para cerrar sesión
                onPressed: () {
                  Navigator.pushNamed(context, '/');
                },
                icon: const Icon(Icons.logout, size: 20, color: Colors.black),
              ),
              title: const Text(//Título de la página
                'Lista de Cursos',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              actions: [
                IconButton(//Botón para agregar un curso
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => const CreateCoursePopup(),
                    );
                  },
                  icon: const Icon(Icons.add, size: 24, color: Colors.black),
                ),
              ],
            ),
          ),
        ),
        body: Container(
          color: Colors.white,
          child: const AdminCoursesList(),//Lista de cursos de Admin
        ),
      ),
    );
  }
}
