// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fishstick_gym/models/course.dart';
import 'package:fishstick_gym/services/courseServices/courses_service.dart';

class ModifyCoursePopup extends StatefulWidget {
  final Course course;

  const ModifyCoursePopup({super.key, required this.course});

  @override
  // ignore: library_private_types_in_public_api
  _ModifyCoursePopupState createState() => _ModifyCoursePopupState();
}

class _ModifyCoursePopupState extends State<ModifyCoursePopup> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _capacidadController;

  final CourseService _courseService = CourseService();

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.course.nombre);
    _capacidadController = TextEditingController(text: widget.course.capacidad.toString());
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _capacidadController.dispose();
    super.dispose();
  }

  void _modifyCourse() async {
    if (_formKey.currentState!.validate()) {
      final String nombre = _nombreController.text;
      final String capacidad = _capacidadController.text;
      final bool success = await _courseService.modifyCourse(widget.course.id, nombre, capacidad);

      if (success) {
        Navigator.pushReplacementNamed(context, '/admin');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Curso modificado exitosamente')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al modificar el curso')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Modificar Curso',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
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
              ElevatedButton(
                onPressed: _modifyCourse,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: const Color(0xFFE67E22),
                ),
                child: const Text('Modificar Curso'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
