import 'dart:convert';
import 'package:comprassj/models/razonsocial.dart';
import 'package:comprassj/services/preferencias.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class VentasService {

  Future<Map<String,dynamic>> getVentas(DateTime? desde, DateTime? hasta, RazonSocial selectedRs)async{
    try {
      final dateFormat = DateFormat('yyyy-MM-dd');

      final params = <String, dynamic>{
        'fecha_inicio' : desde!=null ? dateFormat.format(desde) : null,
        'fecha_fin' : hasta!=null ? dateFormat.format(hasta) : null,
        'rs' : jsonEncode(selectedRs.toJson()) 
      };

      final url = Uri.http(Preferencias.baseUrl, '/comprassjapi/public/api/ventas',params);

      final resp = await http.get(
        url,
        headers: Preferencias.headers
      );

      final data = jsonDecode(resp.body);

      if (resp.statusCode != 200) {
        throw Exception(data['message'] ?? 'Error al consultar las ventas');
      }
      
      return data;

    } catch (e) {
      rethrow;
    }
  }

}