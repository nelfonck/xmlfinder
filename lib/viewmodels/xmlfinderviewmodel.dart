import 'dart:convert';
import 'dart:io';
import 'package:comprassj/models/razonsocial.dart';
import 'package:comprassj/models/tienda.dart';
import 'package:comprassj/repositories/proveedorrepository.dart';
import 'package:comprassj/repositories/razonsocialrepository.dart';
import 'package:comprassj/repositories/tiendarepository.dart';
import 'package:comprassj/services/preferencias.dart';
import 'package:comprassj/services/proveedorservice.dart';
import 'package:comprassj/services/razonsocialservice.dart';
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
  List<RazonSocial> razonesSociales = [];
  bool _disposed = false;
  int? tiendaSeleccionada;
  int? razonSocialSeleccionada;

  final Tiendarepository _repositoryTienda = Tiendarepository(TiendaService());
  final RazonSocialRepository _repositoryRazonSocial = RazonSocialRepository(RazonSocialService());
  final ProveedorRepository _proveedorRepository = ProveedorRepository(ProveedorService());

  Future<void> conectar(String correo, String clave) async {
    client = ImapClient(isLogEnabled: true);

    await client?.connectToServer(
      'imap.gmail.com',
      993,
      isSecure: true,
    );

    await client?.login(
      correo,
      clave,
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

  Future<String?> descargarAdjuntos(
    CorreoFactura correo,
  ) async {

    final resultado = await client?.uidFetchMessage(
      correo.uid, // UID
      '(UID BODY.PEEK[])',
    );

    if (resultado?.messages == null || resultado!.messages.isEmpty) {
      return null;
    }

    final mensaje = resultado.messages.first;

      //crear carpeta con el nombre comercial de la factura, antes de guardar los archivos
      //Crear carpeta con ese nombre comercial
      final Map<String,dynamic>? params = await getNombreComercial(mensaje);
      final String? nombreComercial = params?['nombre_comercial'];
      final String? numeroConsecutivo = params?['numero_consecutivo'];
      String? rutaArchivoFactura;
      
      if (nombreComercial==null){
        throw Exception('No fue posible obtener el nombre comercial');
      }
      final rutaCarpeta = '${Preferencias.directoryxml}\\${tiendas[tiendaSeleccionada!].nombre}\\$nombreComercial';

      final carpeta = Directory(rutaCarpeta);

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
          final rutaArchivo = '$rutaCarpeta\\$nombreArchivoSalida';
          
          if (nombreArchivoSalida.toLowerCase().endsWith('.xml')){
            rutaArchivoFactura = rutaArchivo;
          }

          await File(rutaArchivo).writeAsBytes(bytes);

        } 

        return rutaArchivoFactura;

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

          final emisor = document.findAllElements('Emisor').firstOrNull;

          final nombreComercial = emisor
              ?.findElements('NombreComercial')
              .firstOrNull
              ?.innerText ??emisor
              ?.findElements('Nombre')
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

  Future<void> guardarFactura(String ruta, CorreoFactura correo,{
    required Future<void> Function(Map<String,dynamic> emisor) onEmisorNoExiste,
    required Future<void> Function(Map<String,dynamic> receptor) onReceptorNoExiste,
  }) async{

      final contenido = await File(ruta).readAsString();

      final document = XmlDocument.parse(contenido);

      final emisor = document.findAllElements('Emisor').firstOrNull;
      final receptor = document.findAllElements('Receptor').firstOrNull;


      Map<String,dynamic>? emisorMap = obtenerDatosEmisor(emisor);

      if (emisorMap==null){
        throw Exception('No fue posible obtener los datos del emisor: XmlDocument is null');
      }

      bool existeProveedor = await existeEmisor(emisorMap['identificacion_emisor']);

      if (!existeProveedor){
        await onEmisorNoExiste(emisorMap);
      }

  }

  Map<String,dynamic>? obtenerDatosEmisor(XmlElement? emisor){
      if (emisor==null) return null;

      //Datos del proveedor
      final nombreEmisor = emisor.findElements('NombreComercial').firstOrNull?.innerText ??
        emisor.findElements('Nombre').firstOrNull?.innerText;

      final identificacionEmisor = emisor.findElements('Identificacion').firstOrNull?.findElements('Numero').firstOrNull?.innerText;

      final tipoIdentificacionEmisor = emisor.findElements('Identificacion').firstOrNull?.findElements('Tipo').firstOrNull?.innerText;

      final telefonoEmisor = emisor.findElements('Telefono').firstOrNull?.findElements('NumTelefono').firstOrNull?.innerText;

      final correoEmisor = emisor.findElements('CorreoElectronico').firstOrNull?.innerText;

      return {
        'nombre_emisor': nombreEmisor,
        'identificacion_emisor': identificacionEmisor,
        'tipo_identificacion_emisor': tipoIdentificacionEmisor,
        'telefono_emisor': telefonoEmisor,
        'correo_emisor': correoEmisor,
      };
  }

  Future<bool> existeEmisor(String identificacion)async{
    return await _proveedorRepository.existeProveedor(identificacion);
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

  Future<void> cargarTiendas() async{
    if (!configuracionLista()){
      return;
    }
    tiendas = await _repositoryTienda.getTiendas();
    safeNotifyListeners();
  }

  Future<void> cargarRazonesSociales() async{
    if (!configuracionLista()){
      return;
    }
    razonesSociales = await _repositoryRazonSocial.getRazonesSociales();
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

  void seleccionarRazonSocial(int index) {
    razonSocialSeleccionada = index;
    safeNotifyListeners();
  }


}