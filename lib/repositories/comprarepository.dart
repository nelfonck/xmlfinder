import 'package:comprassj/models/factura_compra.dart';
import 'package:comprassj/services/compraservice.dart';

class CompraRepository {
  final CompraService  _service ;
  CompraRepository(this._service) ;

  Future<Map<String,dynamic>> guardarCompra(FacturaCompra factura) async {
    return _service.guardarCompra(factura);
  }

  Future<Map<String,dynamic>> getCompras(int? estadoRecepcion) async {
    return _service.getCompras(estadoRecepcion);
  }


}