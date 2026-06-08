import 'dart:convert';
import 'dart:io';
import 'package:xml/xml.dart';

import 'package:comprassj/models/correofactura.dart';
import 'package:flutter/material.dart';
import 'package:enough_mail/enough_mail.dart';

class Xmlfinderviewmodel extends ChangeNotifier{
  ImapClient? client;
  List<CorreoFactura> correos = [];

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

  Future<void> buscarFactura(
    ImapClient client,
    String consecutivo
  ) async {

    await client.selectInbox();


    final busqueda = await client.searchMessages(
      searchCriteria: 'TEXT "$consecutivo"',
    );

    if (busqueda.matchingSequence!.isEmpty){
      correos.clear();
      notifyListeners();
      return;
    }

    final resultado = await client.fetchMessages(
      busqueda.matchingSequence!,
      'BODY.PEEK[]',
    );

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
          adjuntos: adjuntos,
          mimeMessages: mimeMessages,
          consecutivoFacturacion: consecutivo
        ),
      );
      notifyListeners();
      return;
    }

  }


  Future<void> descargarAdjuntos(
    ImapClient client,
    CorreoFactura correo,
  ) async {
    for (final mensaje in correo.mimeMessages!) {
      
      for (final part in mensaje.parts ?? <MimePart>[]) {

          final nombreArchivo = _obtenerNombreArchivo(part);

          
          if (nombreArchivo == null) {
            continue;
          }

          print(nombreArchivo);

          if (!nombreArchivo.contains(correo.consecutivoFacturacion!)) {
            continue;
          }

          if (nombreArchivo.contains('r') || nombreArchivo.contains('R')) {
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

          //Crear carpeta con ese nombre comercial
          final carpeta = Directory(nombreComercial!);


          if (!await carpeta.exists()) {
            await carpeta.create(recursive: true);
          }
          String nombreArchivoSalida =  '${correo.consecutivoFacturacion}.$extension';

          //definir la ruta completa del archivo
          final rutaArchivo ='${carpeta.path}/$nombreArchivoSalida';
          
          await File(rutaArchivo).writeAsBytes(bytes);

        } 
      } 
  }

  String? _obtenerNombreArchivo(MimePart part) {

    for (final header in part.headers!) {

      final texto = header.toString();

      if (texto.contains('filename=')) {

        final match = RegExp(
          r'filename="?([^"]+)"?',
          caseSensitive: false,
        ).firstMatch(texto);

        if (match != null) {
          return match.group(1);
        }
      }
    }

    return null;
  }

}