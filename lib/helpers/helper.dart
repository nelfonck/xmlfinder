import 'package:comprassj/services/preferencias.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

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

  static  Future<bool> configuracionLista()async{
    if (Preferencias.host.isNotEmpty && Preferencias.port.isNotEmpty){
          //
    }else{
      Preferencias.host = '201.192.158.233' ;
      Preferencias.port = '82' ;
      return true;
    }
  try {
    final response = await http
        .get(Uri.parse('https://api.ipify.org'))
        .timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      final ipActual = response.body.trim();

      if (ipActual == '201.192.158.233') {
        Preferencias.host = '192.168.60.254';
      } else {
        Preferencias.host = '201.192.158.233';
      }
    }
  } catch (e) {
    // Si no se puede consultar la IP, conserva la configuración existente.
  }

  return true;
  }

   static String formatoMoneda (double n){
    return  NumberFormat('#,##0.##', 'es_CR').format(n);
   }
}
