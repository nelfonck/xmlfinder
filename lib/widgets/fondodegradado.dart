import 'package:flutter/material.dart';

class FondoDegradado extends StatelessWidget {
  const FondoDegradado({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF34373D),
            Color.fromARGB(255, 25, 114, 222),
          ],
        ),
      ),
    );
  }
}