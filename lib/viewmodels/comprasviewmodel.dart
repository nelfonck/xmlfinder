import 'dart:async';

import 'package:comprassj/enums/estado_recepcion.dart';
import 'package:comprassj/models/factura_compra.dart';
import 'package:comprassj/repositories/comprarepository.dart';
import 'package:comprassj/services/compraservice.dart';
import 'package:flutter/material.dart';

class ComprasViewModel extends ChangeNotifier{
  List<FacturaCompra> facturas = [];
  final CompraRepository _compraRepository = CompraRepository(CompraService());
  bool _disposed = false;
  EstadoRecepcion? estadoSeleccionado = EstadoRecepcion.esperadescarga;
  Timer? _timer;
  Timer? _timerContador;
  int refreshEveryMinutes = 1 ;
  Duration tiempoRestante = Duration();
  
  @override
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    _timerContador?.cancel();
    super.dispose();
  }

  Future<void> init()async{
    await getCompras();
    _iniciarActualizacionAutomatica();
    _iniciarContador();
  }

  void _iniciarActualizacionAutomatica() {
    _timer?.cancel();
    _timer = Timer.periodic(
      Duration(minutes: refreshEveryMinutes),
      (timer) async {
        await getCompras();
        _iniciarContador();
      },
    );
  }

  void _iniciarContador() {
    _timerContador?.cancel();
    tiempoRestante =  Duration(minutes: refreshEveryMinutes);
    _timerContador = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (tiempoRestante.inSeconds > 0) {
          tiempoRestante -= const Duration(seconds: 1);
          _safeNotifyListeners();
        }
      },
    );
  }

  void setEstado(EstadoRecepcion estado){
    estadoSeleccionado = estado;
    _safeNotifyListeners();
  }

  Future<Map<String,dynamic>?> getCompras()async{
    final result = await _compraRepository.getCompras(estadoSeleccionado?.codigo == 6 ? null : estadoSeleccionado?.codigo);
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