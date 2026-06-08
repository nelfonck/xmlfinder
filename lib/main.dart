import 'package:comprassj/views/xmlfinderview.dart';
import 'package:flutter/material.dart';

void main() {
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

        scaffoldBackgroundColor: const Color(0xFF4B4F54),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF34373D),
          foregroundColor: Colors.white,
        ),

        cardTheme: CardThemeData(
          color: const Color(0xFF5A5F66),
        ),
      ),
      home: const XmlFinderView(),
    );
  }
}
