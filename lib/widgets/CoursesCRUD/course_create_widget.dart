// ignore_for_file: use_build_context_synchronously

import 'package:fishstick_gym/providers/theme_provider.dart';
import 'package:fishstick_gym/services/courseServices/courses_service.dart';
import 'package:flutter/material.dart';

//Widget para crear un nuevo curso

class CreateCoursePopup extends StatefulWidget {
  const CreateCoursePopup({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateCoursePopupState createState() => _CreateCoursePopupState();
}

class _CreateCoursePopupState extends State<CreateCoursePopup> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _capacidadController = TextEditingController();

  final CourseService _courseService = CourseService();

  @override
  void dispose() {
    _nombreController.dispose();
    _capacidadController.dispose();
    super.dispose();
  }

  void _createCourse() async { //Función para crear un curso
    if (_formKey.currentState!.validate()) {
      final String nombre = _nombreController.text;
      final String capacidad = _capacidadController.text;
      final bool success = await _courseService.createCourse(nombre, capacidad);//Llama a la función de CourseService para crear un curso

      if (success) {//Si se crea el curso
        Navigator.pushReplacementNamed(context, '/admin');//Regresa a la página de administrador
      } else {//Si no se crea el curso
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al crear el curso')),//Muestra un mensaje de error
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {//Cierra el popup al tocar fuera de él
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.5),
        body: Center(
          child: GestureDetector(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(//Título del popup
                      'Nuevo Curso',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(//Campo para ingresar el nombre del curso
                      controller: _nombreController,
                      decoration: const InputDecoration(labelText: 'Nombre'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa el nombre';
                        }
                        return null;
                      },
                    ),
                    TextFormField(//Campo para ingresar la capacidad del curso
                      controller: _capacidadController,
                      decoration: const InputDecoration(labelText: 'Capacidad'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa la capacidad';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Por favor ingresa un número válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(//Botón para crear el curso
                      onPressed: _createCourse,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: AppTheme.nonBrightOrange,
                      ),
                      child: const Text('Crear Curso'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
