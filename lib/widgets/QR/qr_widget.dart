import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui';

//Widget para mostrar el código QR

class QRCodeDialog extends StatelessWidget {
  final String username;
  final String courseName;

  const QRCodeDialog({super.key, required this.username, required this.courseName});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackdropFilter(//Filtro para el fondo
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.black.withOpacity(0.5),
          ),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            
              Container(//Contenedor del código QR
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16), 
                child: QrImageView(//Imagen del código QR
                  data: 'Username: $username, Course: $courseName',//Información del código QR
                  version: QrVersions.auto,
                  size: 200.0,
                  embeddedImage: const AssetImage('assets/fishstick.png'),//Imagen del código QR
                ),
              ),
              const SizedBox(height: 16), 
              CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(//Botón para cerrar el diálogo
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
