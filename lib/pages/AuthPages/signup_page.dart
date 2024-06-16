// ignore_for_file: use_build_context_synchronously

import 'package:fishstick_gym/services/authServices/signup_service.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';


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
    const Color nonBrightOrange = Color(0xFFE67E22);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
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
                  children: <Widget>[
                    Text(
                      "Regístrate",
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
                const SizedBox(height: 20),
                makeInput(
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
                makeInput(
                  controller: _emailController,
                  label: "Email",
                  validator: ValidationBuilder().email('Por favor, ingresa un correo electrónico válido').build(),
                ),
                const SizedBox(height: 10),
                makePasswordInput(
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
                makePasswordInput(
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
                      color: nonBrightOrange,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: MaterialButton(
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

                                if (success) {
                                  Navigator.pushNamed(context, '/login');
                                } else {

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Registro fallido')),
                                  );
                                }
                              }
                            },
                      color: nonBrightOrange,
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
                  children: <Widget>[
                    const Text("¿Ya tienes una cuenta? "),
                    GestureDetector(
                      onTap: () {
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

  Widget makeInput({required TextEditingController controller, required String label, bool obscureText = false, required String? Function(String?) validator}) {
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

  Widget makePasswordInput({required String label, required TextEditingController controller, required bool obscureText, required String? Function(String?) validator, required VoidCallback toggleObscureText}) {
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
}
