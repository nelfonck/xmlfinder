import 'package:comprassj/models/razonsocial.dart';
import 'package:comprassj/models/venta.dart';
import 'package:comprassj/repositories/razonsocialrepository.dart';
import 'package:comprassj/repositories/ventasrepository.dart';
import 'package:comprassj/services/razonsocialservice.dart';
import 'package:comprassj/services/ventasservice.dart';
import 'package:flutter/material.dart';

class Ventasviewmodel extends ChangeNotifier{
  final RazonSocialRepository _rsRepository = RazonSocialRepository(RazonSocialService());
  final VentasRepository _repository = VentasRepository(VentasService());

  DateTime?  desde = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime?  hasta = DateTime.now();
  List<Ventas> ventas = [];
  List<RazonSocial> rs = [];
  bool _disposed = false;
  bool isLoading = false;
  RazonSocial? selectedRs ;
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
  double abonos = 0;

  Future<void> getRazonesSociales()async{
    rs.clear();
    rs = await _rsRepository.getRazonesSociales();
    //INSERTAR UNA TIENDA VACIA CON EL NOMBRE DE TODAS INDEX -1
    selectedRs = RazonSocial(id: -1, identificacion: '6666', tipoIdentificacion: '666', nombre: 'TODO', nombreComercial: 'nombreComercial', correo: 'correo', telefono: 'telefono', activo: false, fechaRegistro: DateTime.now(),claveCorreo: '');
    rs.insert(0, selectedRs! );
    safeNotifyListeners();
  }

  Future<void> getVentas()async{
    isLoading = true;
    totalesEnCero();
    safeNotifyListeners();
    if (selectedRs!=null){
      final result = await _repository.getVentas(desde,hasta, selectedRs!);
      if (result['statusCode']==200){
        ventas = result['data'].map<Ventas>((e) => Ventas.fromJson(e)).toList(); 
        //Agrupar por numero de identificacion
        ventas.sort((a,b) => a.compania!.identificacion!.compareTo(b.compania!.identificacion!));
        restarNotas();
        sumarTotales();
      }

      isLoading = false;
      safeNotifyListeners();
    }else{
      throw 'Debe seleccionar una tienda';
    }
  }

  void restarNotas(){
    for (int x=0; x<= ventas.length-1; x++){
      ventas[x].facturado = (ventas[x].facturado ?? 0) - (ventas[x].notasCredito ?? 0);
    }
  }

  void sumarTotales(){
    totalesEnCero();
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
       abonos+= venta.abonos ?? 0;
    }
    safeNotifyListeners();
  }

  void totalesEnCero(){
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
    abonos = 0;
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