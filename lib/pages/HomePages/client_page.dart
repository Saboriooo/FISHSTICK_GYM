import 'package:fishstick_gym/providers/theme_provider.dart';
import 'package:fishstick_gym/widgets/CoursesList/cliente_courses_widget.dart';
import 'package:flutter/material.dart';

//Pagina de Cliente de la aplicación, Route: '/client'

void main() => runApp(const ClientPage());

class ClientPage extends StatelessWidget {
  const ClientPage({super.key});

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
                'Mis Cursos',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
          ),
        ),
        body: Container(
          color: Colors.white,
          child: const ClienteCoursesList(),//Lista de cursos de Cliente
        ),
      ),
    );
  }
}
