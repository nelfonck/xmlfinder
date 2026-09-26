import 'package:comprassj/models/razonsocial.dart';
import 'package:comprassj/services/ventasservice.dart';

class VentasRepository {
  final VentasService  _service ;
  VentasRepository(this._service) ;

  Future<Map<String,dynamic>> getCompras(int? estadoRecepcion, RazonSocial? emisor, RazonSocial? receptor, DateTime? desde, DateTime? hasta) async {
    return _service.getCompras(estadoRecepcion, emisor, receptor, desde, hasta);
  }


}