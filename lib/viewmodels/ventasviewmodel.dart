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
  bool isLoading = false;

  //TOTALES
  double facturado = 0;
  double iva = 0;
  double colones = 0;
  double dolares = 0;
  double descuento = 0;
  double credito = 0;
  double tarjeta = 0;
  double sinpe = 0;
  double mixto = 0;
  double notasCredito = 0;

  Future<void> getTiendas()async{
    tiendas = await _tiendarepository.getTiendas();
    safeNotifyListeners();
  }
  Future<void> getVentas()async{
    isLoading = true;
    safeNotifyListeners();

    final result = await _repository.getVentas(desde,hasta);

    if (result['statusCode']==200){
      ventas = result['data'].map<Ventas>((e) => Ventas.fromJson(e)).toList(); 
      sumarTotales();
    }

    isLoading = false;
    safeNotifyListeners();
  }

  void sumarTotales(){
    facturado = 0;
    iva = 0;
    colones = 0;
    dolares = 0;
    descuento = 0;
    credito = 0;
    tarjeta = 0;
    sinpe = 0;
    mixto = 0;
    notasCredito = 0;

    for (var venta in ventas) {
       facturado+= venta.facturado ?? 0;
       iva+= venta.iva ?? 0;
       colones+= venta.colones ?? 0;
       dolares+= venta.dolares ?? 0;
       descuento+= venta.descuento ?? 0;
       credito+= venta.credito ?? 0;
       tarjeta+= venta.tarjeta ?? 0;
       sinpe+= venta.sinpe ?? 0;
       mixto+= venta.mixto ?? 0;
       notasCredito+= venta.notasCredito ?? 0;
    }
    safeNotifyListeners();
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