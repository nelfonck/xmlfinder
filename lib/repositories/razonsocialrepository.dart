import 'package:comprassj/models/razonsocial.dart';
import 'package:comprassj/services/razonsocialservice.dart';

class RazonSocialRepository {
  final RazonSocialService  _service ;
  RazonSocialRepository(this._service) ;

  Future<List<RazonSocial>> getRazonesSociales() async {
    return _service.getRazonesSociales();
  }

  Future<RazonSocial> guardarRazonSocial(Map<String,dynamic> params) async {
    return _service.guardarRazonSocial(params);
  }

  Future<bool> existeRazonSocial(String identificacion)async{
    return _service.existeRazonSocial(identificacion);
  }

}