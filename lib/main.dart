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
      initialRoute: '/',
      theme: ThemeData(
        primarySwatch: Colors.orange, // Adjust the primary color as per your theme
      ),
      routes: {
        '/': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/admin': (context) => const AdminPage(),
        '/client': (context) => const ClientPage(),
      },
    ),
  );
}