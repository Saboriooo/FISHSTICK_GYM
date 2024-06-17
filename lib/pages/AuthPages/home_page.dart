import 'package:fishstick_gym/providers/theme_provider.dart';
import 'package:flutter/material.dart';

//Home Page de la aplicación, Pagina a mostrar al iniciar la aplicación, Route: '/'

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppTheme.lightGrey,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 20,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppTheme.nonBrightOrange,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                          color: AppTheme.lightGrey,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppTheme.nonBrightOrange,
                            width: 5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Text(//Titulo de la aplicación
                          "FISHSTICK GYM",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20,),
                ],
              ),
              Container(//Imagen de la aplicación
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.height / 3,
                decoration: BoxDecoration(
                  color: AppTheme.darkGrey,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black,
                    width: 5,
                  ),
                  image: const DecorationImage(
                    image: AssetImage('assets/505.png'),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(top: 0, left: 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: AppTheme.nonBrightOrange,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: MaterialButton(//Botón para ir a la página de login
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      color: AppTheme.nonBrightOrange,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Container(
                    padding: const EdgeInsets.only(top: 0, left: 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: AppTheme.nonBrightOrange,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: MaterialButton(//Botón para ir a la página de registro
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      color: AppTheme.nonBrightOrange,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Text(
                        "Registrarse",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white,
                        ),
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
}
