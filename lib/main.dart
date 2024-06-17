import 'package:fishstick_gym/pages/AuthPages/home_page.dart';
import 'package:fishstick_gym/pages/AuthPages/login_page.dart';
import 'package:fishstick_gym/pages/AuthPages/signup_page.dart';
import 'package:fishstick_gym/pages/HomePages/admin_page.dart';
import 'package:fishstick_gym/pages/HomePages/client_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',//Ruta inicial
      theme: ThemeData(
        primarySwatch: Colors.orange, 
      ),
      routes: {
        '/': (context) => const HomePage(),//Ruta de la página Home
        '/login': (context) => const LoginPage(),//Ruta de la página de Login
        '/signup': (context) => const SignupPage(),//Ruta de la página de Registro
        '/admin': (context) => const AdminPage(),//Ruta de la página de Administrador
        '/client': (context) => const ClientPage(),//Ruta de la página de Cliente
      },
    ),
  );
}