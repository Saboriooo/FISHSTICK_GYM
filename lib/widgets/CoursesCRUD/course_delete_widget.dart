// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fishstick_gym/models/course.dart';
import 'package:fishstick_gym/services/courseServices/courses_service.dart';

class DeleteCoursePopup extends StatelessWidget {
  final Course course;
  final CourseService courseService = CourseService();

  DeleteCoursePopup({super.key, required this.course});

  void _deleteCourse(BuildContext context) async {
    bool success = await courseService.deleteCourse(course.id);

    if (success) {
      Navigator.pushReplacementNamed(context, '/admin');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Curso eliminado exitosamente')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se puede eliminar el curso porque tiene estudiantes matriculados')),
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
            const Text(
              'Confirmar Eliminación',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              '¿Estás seguro que deseas eliminar este curso?',
              style: TextStyle(fontSize: 16, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _deleteCourse(context);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFFE67E22),
                  ),
                  child: const Text('Eliminar'),
                ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Color(0xFFE67E22)),
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