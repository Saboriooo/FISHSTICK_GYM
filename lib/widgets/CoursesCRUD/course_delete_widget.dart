// ignore_for_file: use_build_context_synchronously

import 'package:fishstick_gym/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:fishstick_gym/models/course.dart';
import 'package:fishstick_gym/services/courseServices/courses_service.dart';

//Widget para eliminar un curso

class DeleteCoursePopup extends StatelessWidget {
  final Course course;
  final CourseService courseService = CourseService();

  DeleteCoursePopup({super.key, required this.course});

  void _deleteCourse(BuildContext context) async {//Función para eliminar un curso
    bool success = await courseService.deleteCourse(course.id);//Llama a la función de CourseService para eliminar un curso

    if (success) {//Si se elimina el curso
      Navigator.pushReplacementNamed(context, '/admin');//Regresa a la página de administrador
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Curso eliminado exitosamente')),
      );
    } else {//Si no se elimina el curso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se puede eliminar el curso porque tiene estudiantes matriculados')),//Muestra un mensaje de error
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(//Texto de confirmación de eliminación
              'Confirmar Eliminación',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(//Pregunta de confirmación de eliminación
              '¿Estás seguro que deseas eliminar este curso?',
              style: TextStyle(fontSize: 16, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {//Botón para confirmar la eliminación del curso
                    _deleteCourse(context);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppTheme.nonBrightOrange,
                  ),
                  child: const Text('Eliminar'),
                ),
                const SizedBox(width: 16),
                TextButton(//Botón para cancelar la eliminación del curso
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: AppTheme.nonBrightOrange),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}