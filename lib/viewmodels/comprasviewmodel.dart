import 'dart:async';

import 'package:comprassj/enums/estado_recepcion.dart';
import 'package:comprassj/models/factura_compra.dart';
import 'package:comprassj/models/razonsocial.dart';
import 'package:comprassj/repositories/comprarepository.dart';
import 'package:comprassj/repositories/razonsocialrepository.dart';
import 'package:comprassj/services/compraservice.dart';
import 'package:comprassj/services/razonsocialservice.dart';
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
  bool cargando = false;
  List<RazonSocial> razonesSociales = [];
  DateTime? desde, hasta;
  RazonSocial? emisor, receptor;
  final RazonSocialRepository _rsrepository = RazonSocialRepository(RazonSocialService());
  double subTotal = 0, totalImpuesto = 0, total = 0;

  
  @override
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    _timerContador?.cancel();
    super.dispose();
  }

  Future<void> init()async{
    await getRazonesSociales();
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
          safeNotifyListeners();
        }
      },
    );
  }

  void setEstado(EstadoRecepcion estado){
    estadoSeleccionado = estado;
    safeNotifyListeners();
  }

  Future<Map<String,dynamic>?> getCompras()async{
    try {
      cargando = true;
      safeNotifyListeners();

      final result = await _compraRepository.getCompras(estadoSeleccionado?.codigo == 6 ? null : estadoSeleccionado?.codigo);
      if (result['statusCode']==200){
        facturas = result['compras'].map<FacturaCompra>((e) => FacturaCompra.fromJson(e)).toList();
        cargando = false;
        sumarTotales();
        return result;
      }
    } catch (e) {
      cargando = false;
      subTotal = 0;
      totalImpuesto = 0;
      total = 0;
      safeNotifyListeners();
      rethrow;
    }
    return null;
  }

  Future<void> getRazonesSociales() async{
    final result = await _rsrepository.getRazonesSociales();
    razonesSociales = result;
    RazonSocial initialValue = RazonSocial(
      id: -1, nombre: 'TODO', nombreComercial: 'TODO', identificacion: '1', tipoIdentificacion: '1', correo: '1', telefono: '1', activo: false, fechaRegistro: DateTime.now(), claveCorreo: '',
    );
    razonesSociales.insert(0,initialValue);
    emisor = initialValue;
    receptor = initialValue;
    safeNotifyListeners();
  }

  void sumarTotales(){
    subTotal = 0;
    totalImpuesto = 0;
    total = 0;

    for (var factura in facturas) {
      subTotal+= factura.totalGravado ?? 0;
      totalImpuesto+= factura.totalImpuesto ?? 0;
      total+= factura.totalComprobante ?? 0;
    }
    safeNotifyListeners();
  }

  void safeNotifyListeners(){
    if (!_disposed){
      notifyListeners();
    }
  }

}