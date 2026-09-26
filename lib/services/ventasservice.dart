import 'dart:convert';
import 'package:comprassj/models/razonsocial.dart';
import 'package:comprassj/services/preferencias.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class VentasService {

  Future<Map<String,dynamic>> getCompras(int? estadoRecepcion, RazonSocial? emisor, RazonSocial? receptor, DateTime? desde, DateTime? hasta)async{
    try {

      final params = <String, String>{};

      if (estadoRecepcion != null) {
        params['estado_recepcion'] = estadoRecepcion.toString();
      }

      if (emisor != null) {
        params['emisor'] = jsonEncode(emisor.toJson());
      }

      if (receptor != null) {
        params['receptor'] = jsonEncode(receptor.toJson());
      }

      if (desde != null) {
        params['desde'] = DateFormat('yyyy-MM-dd').format(desde);
      }

      if (hasta != null) {
        params['hasta'] = DateFormat('yyyy-MM-dd').format(hasta);
      }

      final url = Uri.http(Preferencias.baseUrl, '/comprassjapi/public/api/compras',params);

      final resp = await http.get(
        url,
        headers: Preferencias.headers
      );


      final body = jsonDecode(resp.body);

      if (resp.statusCode != 200) {
        throw Exception(
          body['message'],
        );
      }

      return body;

    } catch (e) {
      throw Exception(e.toString());
    }
  }

}