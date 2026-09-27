import 'package:comprassj/models/tienda.dart';
import 'package:comprassj/models/venta.dart';
import 'package:comprassj/repositories/tiendarepository.dart';
import 'package:comprassj/repositories/ventasrepository.dart';
import 'package:comprassj/services/tiendaservice.dart';
import 'package:comprassj/services/ventasservice.dart';
import 'package:flutter/material.dart';

class Ventasviewmodel extends ChangeNotifier{
  final Tiendarepository _tiendarepository = Tiendarepository(TiendaService());
  final VentasRepository _repository = VentasRepository(VentasService());

  DateTime?  desde = DateTime(DateTime.now().year, DateTime.now().month, 20);
  DateTime?  hasta;
  List<Ventas> ventas = [];
  List<Tienda> tiendas = [];
  bool _disposed = false;

  Future<void> getTiendas()async{
    tiendas = await _tiendarepository.getTiendas();
    safeNotifyListeners();
  }
  Future<void> getVentas()async{

    final result = await _repository.getVentas(desde,hasta);

    if (result['statusCode']==200){
      ventas = result['data'].map<Ventas>((e) => Ventas.fromJson(e)).toList(); 
      safeNotifyListeners();
    }
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