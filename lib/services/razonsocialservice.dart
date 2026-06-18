import 'dart:convert';

import 'package:comprassj/models/razonsocial.dart';
import 'package:comprassj/services/preferencias.dart';
import 'package:http/http.dart' as http;

class RazonSocialService {


  Future<List<RazonSocial>> getRazonesSociales()async{
    try {
      final url = Uri.http(Preferencias.baseUrl, '/comprassjapi/public/api/razones-sociales');

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
      return decoded.map<RazonSocial>((e) => RazonSocial.fromJson(e)).toList(); 

    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<RazonSocial> guardarRazonSocial(Map<String,dynamic> params)async{
    try {
      final url = Uri.http(Preferencias.baseUrl, '/comprassjapi/public/api/guardar-razon-social');

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
      return RazonSocial.fromJson(decoded);

    } catch (e) {
      throw Exception(e.toString());
    }
  }

}