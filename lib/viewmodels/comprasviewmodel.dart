import 'package:comprassj/models/factura_compra.dart';
import 'package:comprassj/repositories/comprarepository.dart';
import 'package:comprassj/services/compraservice.dart';
import 'package:flutter/material.dart';

class ComprasViewModel extends ChangeNotifier{
  List<FacturaCompra> facturas = [];
  final CompraRepository _compraRepository = CompraRepository(CompraService());
  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  Future<void> init()async{
    await getCompras();
  }

  Future<Map<String,dynamic>?> getCompras()async{
    final result = await _compraRepository.getCompras();
    if (result['statusCode']==200){
      facturas = result['compras'].map<FacturaCompra>((e) => FacturaCompra.fromJson(e)).toList();
      _safeNotifyListeners();
      return result;
    }
    return null;
  }

  void _safeNotifyListeners(){
    if (!_disposed){
      notifyListeners();
    }
  }

}