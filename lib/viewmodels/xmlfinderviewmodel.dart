import 'dart:convert';
import 'dart:io';
import 'package:comprassj/models/tienda.dart';
import 'package:comprassj/repositories/tiendarepository.dart';
import 'package:comprassj/services/preferencias.dart';
import 'package:comprassj/services/tiendaservice.dart';
import 'package:xml/xml.dart';

import 'package:comprassj/models/correofactura.dart';
import 'package:flutter/material.dart';
import 'package:enough_mail/enough_mail.dart';



class Xmlfinderviewmodel extends ChangeNotifier{
  ImapClient? client;
  List<CorreoFactura> correos = [];
  List<CorreoFactura> correosBusqueda = [];
  bool obteniendoMensajes = false;
  List<Tienda> tiendas = [];
  bool _disposed = false;
  int? tiendaSeleccionada;

  final Tiendarepository _repository = Tiendarepository(TiendaService());

  Future<void> conectar() async {
    client = ImapClient(isLogEnabled: true);

    await client?.connectToServer(
      'imap.gmail.com',
      993,
      isSecure: true,
    );

    await client?.login(
      'facturas.lacasadelascarnes1@gmail.com',
      'wozfxmekrkysjrqf',
    );

    client?.isLogEnabled = false;

  }

  Future<void> cargarFacturas() async{
    await client?.selectInbox();

    obteniendoMensajes = true;
    notifyListeners();
    final resultado = await client?.fetchRecentMessages(
      messageCount: 100,
      criteria: '(UID BODY.PEEK[])',
    );

    for (final mensaje in resultado!.messages.reversed) {
     
      if (!mensaje.hasAttachments()) {
        continue;
      }

      mensaje.parse();
      final List<String> fileNames = [];


      //guardar nombre archivos adjuntos
      for (final info in mensaje.findContentInfo()) {
        final nombre = info.fileName ?? '';

        if ((nombre.toLowerCase().endsWith('.xml') || nombre.toLowerCase().endsWith('.pdf'))) {
          fileNames.add(nombre);
          
        }

      }

      correos.add(
        CorreoFactura(
          uid: mensaje.uid ?? 0,
          asunto: mensaje.decodeSubject() ?? '',
          remitente: mensaje.from?.firstOrNull?.email,
          fecha: mensaje.decodeDate(),
          fileNames: fileNames
        ),
      );  
    }
    correosBusqueda = correos;
    obteniendoMensajes = false;
    notifyListeners();

    return;
  }

  void encontrarFacturas(String wordkey){
    correosBusqueda = correos.where((correo) {
      return correo.fileNames?.any(
        (nombre) => nombre.contains(wordkey),
      ) ?? false;
    }).toList();
    notifyListeners();
  }

  Future<void> descargarAdjuntos(
    CorreoFactura correo,
  ) async {

    final resultado = await client?.uidFetchMessage(
      correo.uid, // UID
      '(UID BODY.PEEK[])',
    );

    if (resultado?.messages == null || resultado!.messages.isEmpty) {
      return;
    }
    final mensaje = resultado.messages.first;

      //crear carpeta con el nombre comercial de la factura, antes de guardar los archivos
      //Crear carpeta con ese nombre comercial
      final Map<String,dynamic>? params = await getNombreComercial(mensaje);
      final String? nombreComercial = params?['nombre_comercial'];
      final String? numeroConsecutivo = params?['numero_consecutivo'];
      
      if (nombreComercial==null){
        return;
      }

      final carpeta = Directory(nombreComercial);

      if (!await carpeta.exists()) {
        await carpeta.create(recursive: true);
      }
      
      for (final part in mensaje.parts ?? <MimePart>[]) {

          final nombreArchivo = obtenerNombreArchivo(part);

          
          if (nombreArchivo == null) {
            continue;
          }

          if (!validarNombreArchivo(nombreArchivo)) {
            continue;
          }  


          final extension = nombreArchivo.split('.').last.toLowerCase();

          if (!['xml', 'pdf'].contains(extension)) {
            continue;
          }

          final mimeText = part.mimeData.toString();

          final indice = mimeText.indexOf('\r\n\r\n');
  
          if (indice == -1) {
            continue;
          }

          var contenidoBase64 = mimeText.substring(indice + 4);

          contenidoBase64 = contenidoBase64
              .replaceAll('\r', '')
              .replaceAll('\n', '');

          final bytes = base64.decode(contenidoBase64);

          String prefix = nombreArchivo.toLowerCase().contains('nc') ? 'NC-' : '' ;

          String nombreArchivoSalida =   '$prefix$numeroConsecutivo.$extension';

          //definir la ruta completa del archivo
          final rutaArchivo ='${carpeta.path}/$nombreArchivoSalida';
          
          await File(rutaArchivo).writeAsBytes(bytes);

        } 

  }

  String? obtenerNombreArchivo(MimePart part) {
    for (final header in part.headers ?? []) {
      final texto = header.toString();

      final match = RegExp(
        r'(?:filename|name)="?([^";]+)"?',
        caseSensitive: false,
      ).firstMatch(texto);

      if (match != null) {
        return match.group(1);
      }
    }

    return null;
  }

  Future<Map<String,dynamic>?> getNombreComercial(MimeMessage? mensaje)async{
      for (final part in mensaje?.parts ?? <MimePart>[]) {

          final nombreArchivo = obtenerNombreArchivo(part);

          if (nombreArchivo == null) {
            continue;
          }

          if (!validarNombreArchivo(nombreArchivo)) {
            continue;
          }  

          final extension = nombreArchivo.split('.').last.toLowerCase();

          if (extension != 'xml') {
            continue;
          }


          final mimeText = part.mimeData.toString();

          final indice = mimeText.indexOf('\r\n\r\n');
  
          if (indice == -1) {
            continue;
          }

          var contenidoBase64 = mimeText.substring(indice + 4);

          contenidoBase64 = contenidoBase64
              .replaceAll('\r', '')
              .replaceAll('\n', '');

          final bytes = base64.decode(contenidoBase64);


          //leer el xml
          final xmlString = utf8.decode(bytes);

          final document = XmlDocument.parse(xmlString);

          //obtener el nombre comercial
          final nombreComercial = document
              .findAllElements('NombreComercial')
              .firstOrNull
              ?.innerText;

          //obtener el nombre comercial
          final numeroConsecutivo = document
              .findAllElements('NumeroConsecutivo')
              .firstOrNull
              ?.innerText;

          final params = {
            'nombre_comercial': nombreComercial,
            'numero_consecutivo': numeroConsecutivo
          };

          return params;

        } 
        
    return null;
  }

  bool validarNombreArchivo(String nombre){
    if (
      nombre.toLowerCase().contains('resp') || 
      nombre.toLowerCase().contains('hacienda') ||
      //nombre.toLowerCase().contains('nc') ||
      nombre.toLowerCase().contains('dgt') ||
      nombre.toLowerCase().contains('ahc') ||
      nombre.toLowerCase().endsWith('r.xml') ||
      nombre.toLowerCase().contains('mh') ||
      nombre.toLowerCase().contains('nota') 
    ){
      return false;
    }
    return true;
  }

  Future<void> cargarTiendas(BuildContext context) async{
    if (!configuracionLista()){
      Navigator.pushNamed(context, 'configuracion');
      return;
    }
    tiendas = await _repository.getTiendas();
    safeNotifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void safeNotifyListeners() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  bool configuracionLista(){
    if (Preferencias.host.isNotEmpty && Preferencias.port.isNotEmpty){
      return true;
    }
    return false;
  }

  void seleccionarTienda(int index) {
    tiendaSeleccionada = index;
    safeNotifyListeners();
  }

}