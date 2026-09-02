import 'package:flutter/material.dart';

enum EstadoRecepcion {
  aceptado(1, 'ACEPTADO', Colors.greenAccent),
  rechazado(2, 'RECHAZADO', Colors.red),
  procesando(3, 'PROCESANDO', Colors.orange),
  recibido(4, 'RECIBIDO',Colors.blue),
  esperadescarga(5, 'EN ESPERA DE DESCARGA',Colors.grey),
  todos(6,'TODO', Colors.indigo);

  final int codigo;
  final String descripcion;
  final Color color;


  const EstadoRecepcion(this.codigo, this.descripcion, this.color);

  static EstadoRecepcion? desdeCodigo(int codigo) {
    for (final estado in EstadoRecepcion.values) {
      if (estado.codigo == codigo) {
        return estado;
      }
    }

    return null;
  }
}