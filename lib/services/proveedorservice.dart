import 'dart:convert';
import 'package:comprassj/models/proveedor.dart';
import 'package:comprassj/services/preferencias.dart';
import 'package:http/http.dart' as http;

class ProveedorService {


  Future<List<Proveedor>> getProveedores()async{
    try {
      final url = Uri.http(Preferencias.baseUrl, '/comprassjapi/public/api/proveedores');

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
      return decoded.map<Proveedor>((e) => Proveedor.fromJson(e)).toList(); 

    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Proveedor> guardarProveedor(Map<String,dynamic> params)async{
    try {
      final url = Uri.http(Preferencias.baseUrl, '/comprassjapi/public/api/guardar-proveedor');

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
      return Proveedor.fromJson(decoded);

    } catch (e) {
      throw Exception(e.toString());
    }
  }

}