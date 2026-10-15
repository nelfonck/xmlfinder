import 'package:comprassj/services/preferencias.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Helper {

  static Future<DateTime?>  pickupDesdeDate(BuildContext context, DateTime? desde)async{
    final fecha = await showDatePicker(
          context: context,
          initialDate: desde,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
    return fecha;
  } 
  static Future<DateTime?>  pickupHastaDate(BuildContext context, DateTime? hasta)async{
    final fecha = await showDatePicker(
          context: context,
          initialDate: hasta,
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

   static String formatoMoneda (double n){
    return  NumberFormat('#,##0.##', 'es_CR').format(n);
   }
}
