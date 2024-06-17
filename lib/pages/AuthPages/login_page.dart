// ignore_for_file: use_build_context_synchronously

import 'package:fishstick_gym/providers/theme_provider.dart';
import 'package:fishstick_gym/services/authServices/isar_service.dart';
import 'package:fishstick_gym/services/authServices/login_service.dart';
import 'package:fishstick_gym/widgets/AuthWidgets/input_maker_widget.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

//Pagina de Login de la aplicación, Route: '/login'

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscureText = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(//Imagen de la pagina de login
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  color: AppTheme.darkGrey,
                  borderRadius: BorderRadius.circular(75),
                  border: Border.all(color: AppTheme.nonBrightOrange, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/360.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(//Titulo de la página de login
                "Login",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    makeInput(//Campo de texto para el correo electrónico
                      label: "Email",
                      controller: _emailController,
                      validator: ValidationBuilder()//Validación del correo electrónico
                          .email('Por favor, ingrese un correo electrónico válido')
                          .maxLength(50, 'El correo electrónico no puede exceder los 50 caracteres')
                          .build(),
                    ),
                    makePasswordInput(//Campo de texto para la contraseña
                      label: "Contraseña",
                      controller: _passwordController,
                      obscureText: _obscureText,
                      toggleObscureText: _toggleObscureText,
                      validator: ValidationBuilder()//Validación de la contraseña
                          .minLength(8, 'La contraseña debe tener al menos 8 caracteres')
                          .maxLength(16, 'La contraseña no puede exceder los 16 caracteres')
                          .regExp(
                              RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,16}$'),
                              'Debe contener 1 mayúscula, 1 minúscula, 1 número y 1 símbolo')
                          .build(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
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
                child: MaterialButton(//Botón para iniciar sesión
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  onPressed: _isLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            _login();
                          }
                        },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: _isLoading //Texto del botón de iniciar sesión / Depende de si esta cargando o no 
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                        )
                      : const Text(
                          "Login",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              Row(//Texto para ir a la página de registro
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("¿No tienes una cuenta? "),
                  GestureDetector(
                    onTap: () {//Botón para ir a la página de registro
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: const Text(
                      "Registrate",
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
    );
  }

  void _toggleObscureText() {//Método para mostrar u ocultar la contraseña
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _login() async {//Método para iniciar sesión
    setState(() {//Cambio de estado de la variable isLoading para mostrar Indicador de Carga
      _isLoading = true;
    });

    final email = _emailController.text;
    final password = _passwordController.text;

    final loginService = LoginService();

    bool loginSuccess = await loginService.login(email, password);

    setState(() {//Cambio de estado de la variable isLoading para ocultar Indicador de Carga
      _isLoading = false;
    });

    if (loginSuccess) {//Si el inicio de sesión es exitoso
      final role = await IsarService().getRole();

      if (role == 'Admin') {//Si el usuario es un administrador
        Navigator.pushReplacementNamed(context, '/admin');//Redirige a la página de administrador
      } else {//Si el usuario es un cliente
        Navigator.pushReplacementNamed(context, '/client');//Redirige a la página de cliente
      }
    } else {//Si el inicio de sesión falla
      ScaffoldMessenger.of(context).showSnackBar(//Muestra mensaje de error
        const SnackBar(
          content: Text('Login failed'),
        ),
      );
    }


    //Limpia los de texto
    _emailController.clear();
    _passwordController.clear();
  }
}
