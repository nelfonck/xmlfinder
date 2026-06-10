import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferencias {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    _prefs = await SharedPreferences.getInstance();
  }

  static String get baseurl => _prefs?.getString('baseurl') ?? '';

  static set baseurl(String valor) {
    _prefs?.setString('baseurl', valor);
  }

  static String get port => _prefs?.getString('port') ?? '';

  static set port(String valor) {
    _prefs?.setString('port', valor);
  }

  static String get cantidadCorreos => _prefs?.getString('cantidad_correos') ?? '';

  static set cantidadCorreos(String valor) {
    _prefs?.setString('cantidad_correos', valor);
  }
}