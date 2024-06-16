import 'dart:ui';
import 'package:fishstick_gym/widgets/CoursesCRUD/course_delete_widget.dart';
import 'package:fishstick_gym/widgets/CoursesCRUD/course_edit_widget.dart';
import 'package:flutter/material.dart';
import 'package:fishstick_gym/models/course.dart';

void showCourseActions(BuildContext context, Course course) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Ver Participantes'),
            onTap: () {
              Navigator.pop(context);
              // Handle "Ver Participantes" action
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Modificar Curso'),
            onTap: () {
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
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Eliminar Curso'),
            onTap: () {
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