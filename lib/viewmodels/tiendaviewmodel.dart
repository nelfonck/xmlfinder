import 'package:comprassj/repositories/tiendarepository.dart';
import 'package:comprassj/services/tiendaservice.dart';
import 'package:flutter/material.dart';

class TiendaViewModel extends ChangeNotifier{
  FocusNode nombreFocusNode = FocusNode();
  TextEditingController nombreController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController direccionController = TextEditingController();
  TextEditingController correoController = TextEditingController();
  TextEditingController claveCorreoController = TextEditingController();
  bool mostrandoClave = false;
  

  final Tiendarepository _repository = Tiendarepository(TiendaService());


  Future<void> guardarTienda() async{

    Map<String,dynamic> params = {
      'nombre': nombreController.text,
      'id_razon_social': 1,
      'telefono': telefonoController.text,
      'correo': correoController.text,
      'direccion': direccionController.text,
      'clave_correo': claveCorreoController.text
    };

    await _repository.guardarTienda(params);
  }

  void clearControllers(){
      nombreController.clear();
      telefonoController.clear();
      direccionController.clear();
      correoController.clear();
      claveCorreoController.clear();
      nombreFocusNode.requestFocus();
  }

  void mostrarClave(bool value){
    mostrandoClave = value;
    notifyListeners();
  }

}