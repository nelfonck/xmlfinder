import 'dart:convert';

import 'package:comprassj/models/razonsocial';
import 'package:comprassj/services/preferencias.dart';
import 'package:http/http.dart' as http;

class RazonSocialService {


  Future<List<RazonSocial>> getRazonesSociales()async{
    try {
      final url = Uri.http(Preferencias.baseUrl, '/comprassjapi/public/api/razones-sociales');

      final resp = await http.get(url);

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

}