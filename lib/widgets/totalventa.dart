import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget totalVenta({
  required String title,
  required double total,
  required String symbol /*symbol only c or d c=colons and d= dollars*/
}){
  final formatoMoneda = NumberFormat('#,##0.00', 'es_CR');

  return Card(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title),
          Text(
            '${symbol=='c' ? '¢':symbol=='d' ? '\$' : ''}${formatoMoneda.format(total)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16
            ),
          )
        ],
      ),
    ),
  );
}