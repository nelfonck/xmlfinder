import 'package:comprassj/services/preferencias.dart';
import 'package:comprassj/views/configuracionview.dart';
import 'package:comprassj/views/nuevarazonsocialview.dart';
import 'package:comprassj/views/nuevatiendaview.dart';
import 'package:comprassj/views/nuevoproveedorview.dart';
import 'package:comprassj/views/xmlfinderview.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Preferencias.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Xml finder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,

        colorScheme: const ColorScheme.dark(
          primary: Colors.blue,
        ),
        
        scaffoldBackgroundColor: const Color(0xFF4B4F54),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF34373D),
          foregroundColor: Colors.white,
        ),

        cardTheme: CardThemeData(
          color: const Color(0xFF5A5F66),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.blue,
            side: const BorderSide(
              color: Colors.blue,
              width: 0.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      routes: {
        'configuracion': (context) => const ConfiguracionView(),
        'razon_social': (context) => const NuevaRazonSocialView(),
        'nueva_tienda': (context) => const NuevaTiendaView(),
        'nuevo_proveedor': (context) => const NuevoProveedorView(),
      },
      home: const XmlFinderView(),
    );
  }
}
