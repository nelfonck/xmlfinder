import 'dart:convert';
import 'package:xml/xml.dart';

import 'package:comprassj/models/correofactura.dart';
import 'package:flutter/material.dart';
import 'package:enough_mail/enough_mail.dart';



class Xmlfinderviewmodel extends ChangeNotifier{
  ImapClient? client;
  List<CorreoFactura> correos = [];
  List<CorreoFactura> correosBusqueda = [];
  bool obteniendoMensajes = false;

  //dos pinos 40500249010000048907
  //tres jotas 00100031010000036714\\


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
      messageCount: 500,
      criteria: 'BODY.PEEK[]',
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

  /*Future<void> buscarFactura(
    ImapClient client,
    String consecutivo
  ) async {

    correos.clear();
    notifyListeners();

    await client.selectInbox();

    obteniendoMensajes = true;
    notifyListeners();
    final resultado = await client.fetchRecentMessages(
      messageCount: 500,
      criteria: 'BODY.PEEK[]',
    );
    obteniendoMensajes = false;
    notifyListeners();

    for (final mensaje in resultado.messages.reversed) {
     
      if (!mensaje.hasAttachments()) {
        continue;
      }

      mensaje.parse();

      final adjuntos = <String>[];
      final mimeMessages = <MimeMessage>[];

      for (final info in mensaje.findContentInfo()) {

        final nombre = info.fileName ?? '';

        if (nombre.contains(consecutivo)) {

          adjuntos.add(nombre);
          mimeMessages.add(mensaje);
        }
      }

      if (adjuntos.isEmpty) {
        continue;
      }
      correos.add(
        CorreoFactura(
          uid: mensaje.uid ?? 0,
          asunto: mensaje.decodeSubject() ?? '',
          remitente: mensaje.from?.firstOrNull?.email,
          fecha: mensaje.decodeDate(),
        ),
      );
      notifyListeners();
      return;
    }

  }*/


  /*Future<void> descargarAdjuntos(
    ImapClient client,
    CorreoFactura correo,
  ) async {
    for (final mensaje in correo.mimeMessages!) {

      //crear carpeta con el nombre comercial de la factura, antes de guardar los archivos
      //Crear carpeta con ese nombre comercial
      final String? nombreComercial = await getNombreComercial(mensaje, correo.consecutivoFacturacion!);
      final carpeta = Directory(nombreComercial!);

      if (!await carpeta.exists()) {
        await carpeta.create(recursive: true);
      }
      
      for (final part in mensaje.parts ?? <MimePart>[]) {

          final nombreArchivo = obtenerNombreArchivo(part);

          
          if (nombreArchivo == null) {
            continue;
          }

          if (!nombreArchivo.contains(correo.consecutivoFacturacion!)) {
            continue;
          }

          if (nombreArchivo.contains('r') || nombreArchivo.contains('R') || nombreArchivo.contains('M') || nombreArchivo.contains('H')) {
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




          String nombreArchivoSalida =  '${correo.consecutivoFacturacion}.$extension';

          //definir la ruta completa del archivo
          final rutaArchivo ='${carpeta.path}/$nombreArchivoSalida';
          
          await File(rutaArchivo).writeAsBytes(bytes);

        } 
      } 
  }*/

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

  Future<String?> getNombreComercial(MimeMessage mensaje, String consecutivoFacturacion)async{
      for (final part in mensaje.parts ?? <MimePart>[]) {

          final nombreArchivo = obtenerNombreArchivo(part);

          
          if (nombreArchivo == null) {
            continue;
          }

          if (!nombreArchivo.contains(consecutivoFacturacion)) {
            continue;
          }

          if (nombreArchivo.contains('r') || nombreArchivo.contains('R') || nombreArchivo.contains('M') || nombreArchivo.contains('H')) {
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

          return nombreComercial;

        } 
        
    return null;
  }

}