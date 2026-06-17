import 'package:comprassj/models/tienda.dart';
import 'package:comprassj/services/tiendaservice.dart';

class Tiendarepository {
  final TiendaService  _service ;
  Tiendarepository(this._service) ;

  Future<List<Tienda>> getTiendas() async {
    return _service.getTiendas();
  }

  Future<Tienda> guardarTienda(Map<String,dynamic> params) async {
    return _service.guardarTienda(params);
  }
}
