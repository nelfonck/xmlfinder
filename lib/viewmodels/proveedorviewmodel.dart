import 'package:comprassj/repositories/proveedorrepository.dart';
import 'package:comprassj/services/proveedorservice.dart';
import 'package:flutter/material.dart';

class ProveedorViewModel extends ChangeNotifier{
  FocusNode nombreFocusNode = FocusNode();
  TextEditingController identificacionController = TextEditingController();
  TextEditingController nombreController = TextEditingController();
  TextEditingController nombreComercialController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController correoController = TextEditingController();

  final ProveedorRepository _repository = ProveedorRepository(ProveedorService());

  bool _disposed = false;

  final tiposIdentificacion = {
    '01': 'Cédula Física',
    '02': 'Cédula Jurídica',
    '03': 'DIMEX',
    '04': 'NITE',
    '05': 'Extranjero No Domiciliado',
  };

  String? tipoSeleccionado;

  Future<void> guardarProveedor() async{

    Map<String,dynamic> params = {
      'identificacion': identificacionController.text,
      'tipo_identificacion': tipoSeleccionado,
      'nombre': nombreController.text,
      'nombre_comercial': nombreComercialController.text,
      'telefono': telefonoController.text,
      'correo': correoController.text,
    };

    await _repository.guardarProveedor(params);
  }

  Future<void> getProveedores()async{

     await _repository.getProveedores();

    safeNotifyListeners();
  }

  void clearControllers(){
      nombreController.clear();
      telefonoController.clear();
      nombreComercialController.clear();
      correoController.clear();
      nombreFocusNode.requestFocus();
      
      identificacionController.clear();
  }
  void cargarValores(Map<String,dynamic>? emisor){
      nombreController.text = emisor?['nombre_emisor'] ?? '';
      telefonoController.text = emisor?['telefono_emisor'] ?? '';
      nombreComercialController.text = emisor?['nombre_emisor'] ?? '';
      identificacionController.text = emisor?['identificacion_emisor'] ?? '';
      correoController.text = emisor?['correo_emisor'] ?? '';
      tipoSeleccionado = emisor?['tipo_identificacion_emisor'] ?? '';
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