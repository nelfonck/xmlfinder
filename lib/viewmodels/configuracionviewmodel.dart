import 'package:comprassj/services/preferencias.dart';
import 'package:flutter/material.dart';

class ConfiguracionViewModel extends ChangeNotifier{
  TextEditingController txtBaseUrlController = TextEditingController();
  TextEditingController txtPortController = TextEditingController();
  TextEditingController txtCantidadCorreosController= TextEditingController();

  void init()async {
    await Preferencias.init();
    leerParametros();
  }

  void leerParametros(){
    txtBaseUrlController.text = Preferencias.baseurl;
    txtPortController.text = Preferencias.port;
    txtCantidadCorreosController.text = Preferencias.cantidadCorreos;
  }

  void guardarParametros(){
    Preferencias.baseurl = txtBaseUrlController.text;
    Preferencias.port = txtPortController.text;
    Preferencias.cantidadCorreos = txtCantidadCorreosController.text;
  }

}