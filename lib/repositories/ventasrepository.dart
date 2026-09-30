import 'package:comprassj/models/razonsocial.dart';
import 'package:comprassj/services/ventasservice.dart';

class VentasRepository {
  final VentasService  _service ;
  VentasRepository(this._service) ;

  Future<Map<String,dynamic>> getVentas(DateTime? desde, DateTime? hasta, RazonSocial selectedRs) async {
    return _service.getVentas(desde, hasta, selectedRs);
  }

}