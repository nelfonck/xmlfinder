import 'package:comprassj/models/razonsocial.dart';
import 'package:comprassj/repositories/razonsocialrepository.dart';
import 'package:comprassj/repositories/tiendarepository.dart';
import 'package:comprassj/services/razonsocialservice.dart';
import 'package:comprassj/services/tiendaservice.dart';
import 'package:flutter/material.dart';

class TiendaViewModel extends ChangeNotifier{
  FocusNode nombreFocusNode = FocusNode();
  TextEditingController nombreController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController direccionController = TextEditingController();
  TextEditingController correoController = TextEditingController();

  final Tiendarepository _repository = Tiendarepository(TiendaService());
  final RazonSocialRepository _repositoryRS = RazonSocialRepository(RazonSocialService());

  List<RazonSocial> razonSocialList = [];

  bool _disposed = false;

  Future<void> guardarTienda() async{

    Map<String,dynamic> params = {
      'nombre': nombreController.text,
      'id_razon_social': 1,
      'telefono': telefonoController.text,
      'correo': correoController.text,
      'direccion': direccionController.text
    };

    await _repository.guardarTienda(params);
  }

  Future<void> getRazonesSociales()async{

    razonSocialList = await _repositoryRS.getRazonesSociales();

    safeNotifyListeners();
  }

  void clearControllers(){
      nombreController.clear();
      telefonoController.clear();
      direccionController.clear();
      correoController.clear();
      nombreFocusNode.requestFocus();
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