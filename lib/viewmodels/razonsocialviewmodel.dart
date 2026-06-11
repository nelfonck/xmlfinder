import 'package:flutter/material.dart';

class NuevaRazonSocialViewModel extends ChangeNotifier{

  TextEditingController identificacionController = TextEditingController();
  TextEditingController razonSocialController = TextEditingController();
  TextEditingController nombreComercialController = TextEditingController();

  final tiposIdentificacion = {
    '01': 'Cédula Física',
    '02': 'Cédula Jurídica',
    '03': 'DIMEX',
    '04': 'NITE',
    '05': 'Extranjero No Domiciliado',
  };

  String? tipoSeleccionado;

}