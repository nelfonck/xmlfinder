import 'package:comprassj/models/factura_compra.dart';
import 'package:comprassj/models/razonsocial.dart';
import 'package:comprassj/services/compraservice.dart';

class CompraRepository {
  final CompraService  _service ;
  CompraRepository(this._service) ;

  Future<Map<String,dynamic>> guardarCompra(FacturaCompra factura) async {
    return _service.guardarCompra(factura);
  }

  Future<Map<String,dynamic>> getCompras(int? estadoRecepcion, RazonSocial? emisor, RazonSocial? receptor, DateTime? desde, DateTime? hasta) async {
    return _service.getCompras(estadoRecepcion, emisor, receptor, desde, hasta);
  }


}