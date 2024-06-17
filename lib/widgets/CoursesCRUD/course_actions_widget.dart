import 'dart:ui';
import 'package:fishstick_gym/pages/UserPages/course_users_page.dart';
import 'package:fishstick_gym/widgets/CoursesCRUD/course_delete_widget.dart';
import 'package:fishstick_gym/widgets/CoursesCRUD/course_edit_widget.dart';
import 'package:flutter/material.dart';
import 'package:fishstick_gym/models/course.dart';

//Muestra las acciones disponibles para un curso

void showCourseActions(BuildContext context, Course course) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(//Botón para ver los participantes del curso
            leading: const Icon(Icons.people),
            title: const Text('Ver Participantes'),
            onTap: () {//Navega a la página de participantes del curso
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseUsersPage(
                    courseId: course.id,
                    courseName: course.nombre,
                  ),
                ),
              );
            },
          ),
          ListTile(//Botón para modificar el curso
            leading: const Icon(Icons.edit),
            title: const Text('Modificar Curso'),
            onTap: () {//Muestra el popup para modificar el curso
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: ModifyCoursePopup(course: course),
                    );
                  },
                );
            },
          ),
          ListTile(//Botón para eliminar el curso
            leading: const Icon(Icons.delete),
            title: const Text('Eliminar Curso'),
            onTap: () {//Muestra el popup para eliminar el curso
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: DeleteCoursePopup(course: course),
                  );
                },
              );
            },
          ),
        ],
      );
    },
  );
}