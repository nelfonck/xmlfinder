import 'package:comprassj/models/proveedor.dart';
import 'package:comprassj/services/proveedorservice.dart';

class ProveedorRepository {
  final ProveedorService  _service ;
  ProveedorRepository(this._service) ;

  Future<List<Proveedor>> getProveedores() async {
    return _service.getProveedores();
  }

  Future<Proveedor> guardarProveedor(Map<String,dynamic> params) async {
    return _service.guardarProveedor(params);
  }

  Future<bool> existeProveedor(String identificacion)async{
    return _service.existeProveedor(identificacion);
  }

}