import 'dart:convert';
import 'package:comprassj/services/preferencias.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class VentasService {

  Future<Map<String,dynamic>> getVentas(DateTime? desde, DateTime? hasta)async{
    try {
      final dateFormat = DateFormat('yyyy-MM-dd');

      final params = <String, dynamic>{
        'fecha_inicio' : desde!=null ? dateFormat.format(desde) : null,
        'fecha_fin' : hasta!=null ? dateFormat.format(hasta) : null,
      };

      final url = Uri.http(Preferencias.baseUrl, '/comprassjapi/public/api/ventas',params);

      final resp = await http.get(
        url,
        headers: Preferencias.headers
      );
      
      return jsonDecode(resp.body);

    } catch (e) {
      throw Exception(e.toString());
    }
  }

}