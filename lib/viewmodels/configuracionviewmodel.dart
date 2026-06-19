import 'package:comprassj/services/preferencias.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ConfiguracionViewModel extends ChangeNotifier{
  TextEditingController txtHostController = TextEditingController();
  TextEditingController txtPortController = TextEditingController();
  TextEditingController txtCantidadCorreosController= TextEditingController();
  TextEditingController txtDirectoryXml = TextEditingController();

  void init()async {
    leerParametros();
  }

  void leerParametros(){
    txtHostController.text = Preferencias.host;
    txtPortController.text = Preferencias.port;
    txtCantidadCorreosController.text = Preferencias.cantidadCorreos;
    txtDirectoryXml.text = Preferencias.directoryxml;
  }

  void guardarParametros(){
    Preferencias.host = txtHostController.text;
    Preferencias.port = txtPortController.text;
    Preferencias.cantidadCorreos = txtCantidadCorreosController.text;
    Preferencias.directoryxml = txtDirectoryXml.text;
  }

  Future<void> pickFolder() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory != null) {
 
        txtDirectoryXml.text =  selectedDirectory;
        Preferencias.directoryxml = txtCantidadCorreosController.text;
        
    }
  }

}