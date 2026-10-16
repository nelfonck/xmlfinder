import 'package:flutter/material.dart';

Widget guiaColumna({int flex = 1}) {
  return Expanded(
    flex: flex,
    child: Container(
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: Colors.white.withValues(alpha: 0.18),
            width: 1,
          ),
        ),
      ),
    ),
  );
}