import 'dart:convert';
import 'package:comprassj/models/factura_compra.dart';
import 'package:comprassj/services/preferencias.dart';
import 'package:http/http.dart' as http;

class CompraService {

  Future<Map<String,dynamic>> guardarCompra(FacturaCompra factura)async{
    try {
      final url = Uri.http(Preferencias.baseUrl, '/comprassjapi/public/api/guardar-compra');

      final resp = await http.post(
        url,
        body:  facturaToJson(factura),
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

  Future<Map<String,dynamic>> getCompras()async{
    try {
      final url = Uri.http(Preferencias.baseUrl, '/comprassjapi/public/api/compras');

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