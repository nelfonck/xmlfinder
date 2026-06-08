import 'package:flutter/material.dart';

Widget reportesButton({
  required VoidCallback onPuntoVenta,
  required VoidCallback onRazonSocial,
  required VoidCallback onProveedor
}) {
  return PopupMenuButton<String>(
    tooltip: 'Reportes',
    onSelected: (value) {
      switch (value) {
        case 'pv':
          onPuntoVenta();
          break;

        case 'rs':
          onRazonSocial();
          break;

        case 'pr':
          onProveedor();
          break;
      }
    },
    itemBuilder: (context) => const [
      PopupMenuItem(
        value: 'pv',
        child: Text('Reporte por Punto de Venta'),
      ),
      PopupMenuItem(
        value: 'rs',
        child: Text('Reporte por Razón Social'),
      ),
      PopupMenuItem(
        value: 'pr',
        child: Text('Reporte por Proveedor'),
      ),
    ],
    child: SizedBox(
      width: 90,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.assessment,
            color: Colors.white,
            size: 28,
          ),
          SizedBox(height: 4),
          Text(
            'Reportes',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
            ),
          ),
        ],
      ),
    ),
  );
}