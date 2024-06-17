// ignore_for_file: use_build_context_synchronously

import 'package:fishstick_gym/providers/theme_provider.dart';
import 'package:fishstick_gym/services/authServices/signup_service.dart';
import 'package:fishstick_gym/widgets/AuthWidgets/input_maker_widget.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

//Página de registro de la aplicación, Route: '/signup'

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // ignore: unused_field
  String? _selectedRole;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(//Botón para regresar a la página anterior
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          width: double.infinity,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const Column(
                  children: <Widget>[//Titulo de la página
                    Text(
                      "Regístrate",
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
                const SizedBox(height: 20),
                makeInput(//Campo para ingresar el nombre completo
                  controller: _usernameController,
                  label: "Nombre Completo",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Por favor, ingresa tu nombre completo";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                makeInput(//Campo para ingresar el correo electrónico
                  controller: _emailController,
                  label: "Email",
                  validator: ValidationBuilder().email('Por favor, ingresa un correo electrónico válido').build(),
                ),
                const SizedBox(height: 10),
                makePasswordInput(//Campo para ingresar la contraseña
                  label: "Contraseña",
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  validator: ValidationBuilder()
                      .minLength(8, 'La contraseña debe tener al menos 8 caracteres')
                      .maxLength(16, 'La contraseña no puede exceder los 16 caracteres')
                      .regExp(
                          RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,16}$'),
                          'Debe contener 1 mayúscula, 1 minúscula, 1 número y 1 símbolo')
                      .build(),
                  toggleObscureText: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                const SizedBox(height: 10),
                makePasswordInput(//Campo para confirmar la contraseña
                  label: "Confirmar Contraseña",
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  validator: (val) {
                    if (val != _passwordController.text) {
                      return "Las contraseñas no coinciden";
                    }
                    return null;
                  },
                  toggleObscureText: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                    padding: const EdgeInsets.only(top: 0, left: 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: AppTheme.nonBrightOrange,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: MaterialButton(//Botón para registrar al usuario
                      minWidth: double.infinity,
                      height: 50,
                      onPressed: _isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });

                                SignupService authRegisterService = SignupService();
                                bool success = await authRegisterService.register(
                                  _usernameController.text,
                                  _emailController.text,
                                  _passwordController.text,
                                );

                                setState(() {
                                  _isLoading = false;
                                });

                                if (success) {//Si el registro es exitoso, se redirige a la página de login
                                  Navigator.pushNamed(context, '/login');
                                } else {//Si el registro falla, se muestra un mensaje de error
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Registro fallido')),
                                  );
                                }
                              }
                            },
                      color: AppTheme.nonBrightOrange,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Regístrate",
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[//Texto para redirigir a la página de login
                    const Text("¿Ya tienes una cuenta? "),
                    GestureDetector(
                      onTap: () {//Redirección a la página de login
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text(
                        "Inicia sesión",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  
}
