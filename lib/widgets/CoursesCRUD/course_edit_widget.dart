// ignore_for_file: use_build_context_synchronously

import 'package:fishstick_gym/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:fishstick_gym/models/course.dart';
import 'package:fishstick_gym/services/courseServices/courses_service.dart';

//Widget para modificar un curso

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

  void _modifyCourse() async {//Función para modificar un curso
    if (_formKey.currentState!.validate()) {//Valida los campos del formulario
      final String nombre = _nombreController.text;
      final String capacidad = _capacidadController.text;
      final bool success = await _courseService.modifyCourse(widget.course.id, nombre, capacidad);//Llama a la función de CourseService para modificar un curso

      if (success) {//Si se modifica el curso
        Navigator.pushReplacementNamed(context, '/admin');//Regresa a la página de administrador
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Curso modificado exitosamente')),
        );
      } else {//Si no se modifica el curso
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al modificar el curso')),//Muestra un mensaje de error
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
              const Text(//Título del popup
                'Modificar Curso',
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
              ElevatedButton(//Botón para modificar el curso
                onPressed: _modifyCourse,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: AppTheme.nonBrightOrange,
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
