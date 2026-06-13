import 'package:comprassj/services/preferencias.dart';
import 'package:flutter/material.dart';

class ConfiguracionViewModel extends ChangeNotifier{
  TextEditingController txtHostController = TextEditingController();
  TextEditingController txtPortController = TextEditingController();
  TextEditingController txtCantidadCorreosController= TextEditingController();

  void init()async {
    leerParametros();
  }

  void leerParametros(){
    txtHostController.text = Preferencias.host;
    txtPortController.text = Preferencias.port;
    txtCantidadCorreosController.text = Preferencias.cantidadCorreos;
  }

  void guardarParametros(){
    Preferencias.host = txtHostController.text;
    Preferencias.port = txtPortController.text;
    Preferencias.cantidadCorreos = txtCantidadCorreosController.text;
  }

}