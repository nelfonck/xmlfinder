import 'dart:convert';

import 'package:comprassj/models/tienda.dart';
import 'package:comprassj/services/preferencias.dart';
import 'package:http/http.dart' as http;

class TiendaService{
  
  Future<List<Tienda>> getTiendas()async{
    try {
      final url = Uri.http(Preferencias.baseUrl, '/comprassjapi/public/api/tiendas');

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

      final  decoded = body['data'];
      return decoded.map<Tienda>((e) => Tienda.fromJson(e)).toList(); 

    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Tienda> guardarTienda(Map<String,dynamic> params)async{
    try {
      final url = Uri.http(Preferencias.baseUrl, '/comprassjapi/public/api/guardar-tienda');

      final resp = await http.post(
        url,
        body: jsonEncode(params) ,
        headers: Preferencias.headers
      );

      final body = jsonDecode(resp.body);

      if (resp.statusCode != 200) {
        throw Exception(
          body['message'],
        );
      }

      final  decoded = body['data'];
      return Tienda.fromJson(decoded);

    } catch (e) {
      throw Exception(e.toString());
    }
  }
}