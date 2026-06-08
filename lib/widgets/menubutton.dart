import 'package:flutter/material.dart';

Widget menuButton({
  required IconData icon,
  required String text,
  required VoidCallback onPressed,
}) {
  return InkWell(
    onTap: onPressed,
    child: SizedBox(
      width: 90,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 28,
          ),
          const SizedBox(height: 4),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
            ),
            maxLines: 2,
          ),
        ],
      ),
    ),
  );
}