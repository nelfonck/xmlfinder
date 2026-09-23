import 'package:comprassj/models/razonsocial.dart';
import 'package:comprassj/repositories/razonsocialrepository.dart';
import 'package:comprassj/services/razonsocialservice.dart';
import 'package:flutter/material.dart';

class NuevaRazonSocialViewModel extends ChangeNotifier{
  FocusNode identificacionFocusNode = FocusNode();
  TextEditingController identificacionController = TextEditingController();
  TextEditingController razonSocialController = TextEditingController();
  TextEditingController nombreComercialController = TextEditingController();
  TextEditingController correoController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController claveCorreoController = TextEditingController();

  final RazonSocialRepository _repository = RazonSocialRepository(RazonSocialService());

  bool _disposed = false;

  bool mostrandoClave = false;

  final tiposIdentificacion = {
    '01': 'Cédula Física',
    '02': 'Cédula Jurídica',
    '03': 'DIMEX',
    '04': 'NITE',
    '05': 'Extranjero No Domiciliado',
  };

  String? tipoSeleccionado;


  void init(RazonSocial? razonSocial){
    if (razonSocial!=null){
      identificacionController.text = razonSocial.identificacion ;
      razonSocialController.text = razonSocial.nombre ;
      nombreComercialController.text = razonSocial.nombreComercial ;
      correoController.text = razonSocial.correo ;
      telefonoController.text = razonSocial.telefono ;
      tipoSeleccionado = razonSocial.tipoIdentificacion;
      safeNotifyListeners();
    }
  }

  Future<void> guardarRazonSocial() async{

    Map<String,dynamic> params = {
      'identificacion': identificacionController.text,
      'tipo_identificacion': tipoSeleccionado,
      'nombre': razonSocialController.text,
      'nombre_comercial': nombreComercialController.text,
      'correo': correoController.text,
      'telefono': telefonoController.text,
      'clave_correo': claveCorreoController.text
    };

    await _repository.guardarRazonSocial(params);
  }

  Future<Map<String,dynamic>> modificarRazonSocial() async{

    Map<String,dynamic> params = {
      'identificacion': identificacionController.text,
      'tipo_identificacion': tipoSeleccionado,
      'nombre': razonSocialController.text,
      'nombre_comercial': nombreComercialController.text,
      'correo': correoController.text,
      'telefono': telefonoController.text,
      'clave_correo': claveCorreoController.text
    };

    return await _repository.modificarRazonSocial(params);
  }

  void clearControllers(){
      identificacionController.clear();
      tipoSeleccionado = '';
      razonSocialController.clear();
      nombreComercialController.clear();
      correoController.clear();
      telefonoController.clear();
      claveCorreoController.clear();
      identificacionFocusNode.requestFocus();
  }

  void mostrarClave(bool value){
    mostrandoClave = value;
    safeNotifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void safeNotifyListeners() {
    if (!_disposed) {
      notifyListeners();
    }
  }

}