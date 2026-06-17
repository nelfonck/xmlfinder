import 'package:flutter/material.dart';

class Mensajes {

  static void exito(
    BuildContext context,
    String mensaje,
  ) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green.shade700,
        duration: Duration(seconds: 1),
        content: Text(
          mensaje,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  static void error(
    BuildContext context,
    String mensaje,
  ) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red.shade700,
        content: Text(
          mensaje,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}