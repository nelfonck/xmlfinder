import 'package:comprassj/models/tienda.dart';
import 'package:comprassj/models/venta.dart';
import 'package:comprassj/repositories/tiendarepository.dart';
import 'package:comprassj/services/tiendaservice.dart';
import 'package:flutter/material.dart';

class Ventasviewmodel extends ChangeNotifier{
  final Tiendarepository _tiendarepository = Tiendarepository(TiendaService());
  DateTime?  desde = DateTime(DateTime.now().year, 1, 1);
  DateTime?  hasta;
  List<Ventas> ventas = [];
  List<Tienda> tiendas = [];
  bool _disposed = false;

  void precargarData(){
    ventas.add(
      Ventas(
        comercio: 'Super joseth manuel antonio', 
        cedula: "45454654", 
        facturado: 150000, 
        iva: 56000, 
        colones: 20000, 
        dolares: 46, 
        descuento: 23000, 
        credito: 74000, 
        sinpe: 99000
      )
    );
    ventas.add(
      Ventas(
        comercio: 'Super joseth de la playa', 
        cedula: "45454654", 
        facturado: 150000, 
        iva: 56000, 
        colones: 20000, 
        dolares: 46, 
        descuento: 23000, 
        credito: 74000, 
        sinpe: 99000
      )
    );
    ventas.add(
      Ventas(
        comercio: 'Super joseth parque', 
        cedula: "45454654", 
        facturado: 150000, 
        iva: 56000, 
        colones: 20000, 
        dolares: 46, 
        descuento: 23000, 
        credito: 74000, 
        sinpe: 99000
      )
    );
    ventas.add(
      Ventas(
        comercio: 'La casa de las carnes', 
        cedula: "45454654", 
        facturado: 150000, 
        iva: 56000, 
        colones: 20000, 
        dolares: 46, 
        descuento: 23000, 
        credito: 74000, 
        sinpe: 99000
      )
    );
    ventas.add(
      Ventas(
        comercio: 'Licolera 32', 
        cedula: "45454654", 
        facturado: 150000, 
        iva: 56000, 
        colones: 20000, 
        dolares: 46, 
        descuento: 23000, 
        credito: 74000, 
        sinpe: 99000
      )
    );
  }

  Future<void> getTiendas()async{
    tiendas = await _tiendarepository.getTiendas();
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