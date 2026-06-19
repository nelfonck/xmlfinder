import 'package:shared_preferences/shared_preferences.dart';

class Preferencias {
  static late SharedPreferences? _prefs;

  static const Map<String,String> headers = {
    'Authorization':'Bearer DuheFwIAohGVp6hwWEDWwChvi6j4SJt7',
    'Content-Type': 'application/json'
  };

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String get host => _prefs?.getString('host') ?? '';

  static set host(String valor) {
    _prefs?.setString('host', valor);
  }

  static String get port => _prefs?.getString('port') ?? '';

  static set port(String valor) {
    _prefs?.setString('port', valor);
  }

  static String get cantidadCorreos => _prefs?.getString('cantidad_correos') ?? '';

  static set cantidadCorreos(String valor) {
    _prefs?.setString('cantidad_correos', valor);
  }

  static String get baseUrl{
    String host = _prefs?.getString('host') ?? '';
    String port = _prefs?.getString('port') ?? '';
    return '$host:$port';
  }

  static String get directoryxml => _prefs?.getString('directoryxml') ?? '';

  static set directoryxml(String valor){
    _prefs?.setString('directoryxml', valor);
  }
}