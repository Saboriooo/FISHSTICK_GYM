import 'package:flutter/material.dart';

Widget makeInput({required TextEditingController controller, required String label, bool obscureText = false, required String? Function(String?) validator}) {//Método para crear un campo de texto
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            errorMaxLines: 3,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget makePasswordInput({required String label, required TextEditingController controller, required bool obscureText,
  required String? Function(String?) validator, required VoidCallback toggleObscureText}) { //Método para crear un campo de texto de contraseña
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            errorMaxLines: 3,
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: toggleObscureText,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }