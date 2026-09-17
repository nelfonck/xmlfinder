import 'package:comprassj/services/preferencias.dart';
import 'package:flutter/material.dart';

class Helper {

  static Future<DateTime?>  pickupDesdeDate(BuildContext context)async{
    final fecha = await showDatePicker(
          context: context,
          initialDate: DateTime(DateTime.now().year, 1, 1),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
    return fecha;
  } 
  static Future<DateTime?>  pickupHastaDate(BuildContext context)async{
    final fecha = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
    return fecha;
  } 

  static  bool configuracionLista(){
    if (Preferencias.host.isNotEmpty && Preferencias.port.isNotEmpty){
      return true;
    }else{
      Preferencias.host = '10.147.18.3' ;
      Preferencias.port = '82' ;
      return true;
    }
    //return false;
  }
}
