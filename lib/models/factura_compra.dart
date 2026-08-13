
// To parse this JSON data, do
//
//     final proveedor = proveedorFromJson(jsonString);
import 'package:intl/intl.dart';
import 'dart:convert';
import 'detallefacturacompra.dart';

FacturaCompra facturaFromJson(String str) => FacturaCompra.fromJson(json.decode(str));

String facturaToJson(FacturaCompra data) => json.encode(data.toJson());

class FacturaCompra{
  final int? id;
  final String? clave;
  final String? numeroConsecutivo;
  final DateTime? fechaEmision;
  final String? proveedorSistemas;
  final String? codigoActividadEmisor;
  final String? codigoActividadReceptor;
  final String? emisorIdentificacion;
  final String? emisorNombre;
  final String? emisorNombreComercial;
  final String? receptorIdentificacion;
  final String? receptorNombre;
  final String? receptorNombreComercial;
  final String? condicionVenta;
  final String? condicionVentaOtros;
  final int? plazoCredito;
  final String? moneda;
  final double? tipoCambio;
  final double? totalGravado;
  final double? totalVenta;
  final double? totalVentaNeta;
  final double? totalImpuesto;
  final double? totalComprobante;
  final DateTime? fechaRegistro;
  final List<DetalleFacturaCompra>? detalle;

  FacturaCompra({
    this.id,
    this.clave,
    this.numeroConsecutivo,
    this. fechaEmision,
    this.proveedorSistemas,
    this.codigoActividadEmisor,
    this.codigoActividadReceptor,
    this.emisorIdentificacion,
    this.emisorNombre,
    this.emisorNombreComercial,
    this.receptorIdentificacion,
    this.receptorNombre,
    this.receptorNombreComercial,
    this.condicionVenta,
    this.condicionVentaOtros,
    this.plazoCredito,
    this.moneda,
    this.tipoCambio,
    this.totalGravado,
    this.totalVenta,
    this.totalVentaNeta,
    this.totalImpuesto,
    this.totalComprobante,
    this.fechaRegistro,
    this.detalle
  });

FacturaCompra copyWith({
  int? id,
  String? clave,
  String? numeroConsecutivo,
  DateTime? fechaEmision,
  String? proveedorSistemas,
  String? codigoActividadEmisor,
  String? codigoActividadReceptor,
  String? emisorIdentificacion,
  String? emisorNombre,
  String? emisorNombreComercial,
  String? receptorIdentificacion,
  String? receptorNombre,
  String? receptorNombreComercial,
  String? condicionVenta,
  String? condicionVentaOtros,
  int? plazoCredito,
  String? moneda,
  double? tipoCambio,
  double? totalGravado,
  double? totalVenta,
  double? totalVentaNeta,
  double? totalImpuesto,
  double? totalComprobante,
  DateTime? fechaRegistro,
  List<DetalleFacturaCompra>? detalle,
}) =>
    FacturaCompra(
      id: id ?? this.id,
      clave: clave ?? this.clave,
      numeroConsecutivo: numeroConsecutivo ?? this.numeroConsecutivo,
      fechaEmision: fechaEmision ?? this.fechaEmision,
      proveedorSistemas: proveedorSistemas ?? this.proveedorSistemas,
      codigoActividadEmisor:
          codigoActividadEmisor ?? this.codigoActividadEmisor,
      codigoActividadReceptor:
          codigoActividadReceptor ?? this.codigoActividadReceptor,
      emisorIdentificacion:
          emisorIdentificacion ?? this.emisorIdentificacion,
      emisorNombre: emisorNombre ?? this.emisorNombre,
      emisorNombreComercial:
          emisorNombreComercial ?? this.emisorNombreComercial,
      receptorIdentificacion:
          receptorIdentificacion ?? this.receptorIdentificacion,
      receptorNombre: receptorNombre ?? this.receptorNombre,
      receptorNombreComercial:
          receptorNombreComercial ?? this.receptorNombreComercial,
      condicionVenta: condicionVenta ?? this.condicionVenta,
      condicionVentaOtros:
          condicionVentaOtros ?? this.condicionVentaOtros,
      plazoCredito: plazoCredito ?? this.plazoCredito,
      moneda: moneda ?? this.moneda,
      tipoCambio: tipoCambio ?? this.tipoCambio,
      totalGravado: totalGravado ?? this.totalGravado,
      totalVenta: totalVenta ?? this.totalVenta,
      totalVentaNeta: totalVentaNeta ?? this.totalVentaNeta,
      totalImpuesto: totalImpuesto ?? this.totalImpuesto,
      totalComprobante: totalComprobante ?? this.totalComprobante,
      fechaRegistro: fechaRegistro ?? this.fechaRegistro,
      detalle: detalle ?? this.detalle,
    );

  factory FacturaCompra.fromJson(Map<String, dynamic> json) => FacturaCompra(
    id: json["id"] as int?,
    clave: json["clave"]?.toString(),
    numeroConsecutivo: json["numero_consecutivo"]?.toString(),

    fechaEmision: json["fecha_emision"] != null
        ? DateTime.tryParse(json["fecha_emision"].toString())
        : null,

    proveedorSistemas: json["proveedor_sistemas"]?.toString(),
    codigoActividadEmisor: json["codigo_actividad_emisor"]?.toString(),
    codigoActividadReceptor: json["codigo_actividad_receptor"]?.toString(),
    emisorIdentificacion: json["emisor_identificacion"]?.toString(),
    emisorNombre: json["emisor_nombre"]?.toString(),
    emisorNombreComercial: json["emisor_nombre_comercial"]?.toString(),
    receptorIdentificacion: json["receptor_identificacion"]?.toString(),
    receptorNombre: json["receptor_nombre"]?.toString(),
    receptorNombreComercial: json["receptor_nombre_comercial"]?.toString(),
    condicionVenta: json["condicion_venta"]?.toString(),
    condicionVentaOtros: json["condicion_venta_otros"]?.toString(),

    plazoCredito: json["plazo_credito"] == null
        ? null
        : (json["plazo_credito"] is int
            ? json["plazo_credito"]
            : int.tryParse(json["plazo_credito"].toString())),

    moneda: json["moneda"]?.toString(),

    tipoCambio: json["tipo_cambio"] == null
        ? null
        : double.tryParse(json["tipo_cambio"].toString()),

    totalGravado: json["total_gravado"] == null
        ? null
        : double.tryParse(json["total_gravado"].toString()),

    totalVenta: json["total_venta"] == null
        ? null
        : double.tryParse(json["total_venta"].toString()),

    totalVentaNeta: json["total_venta_neta"] == null
        ? null
        : double.tryParse(json["total_venta_neta"].toString()),

    totalImpuesto: json["total_impuesto"] == null
        ? null
        : double.tryParse(json["total_impuesto"].toString()),

    totalComprobante: json["total_comprobante"] == null
        ? null
        : double.tryParse(json["total_comprobante"].toString()),

    fechaRegistro: json["fecha_registro"] != null
        ? DateTime.tryParse(json["fecha_registro"].toString())
        : null,
    detalle: json["detalle"] == null
        ? []
        : List<DetalleFacturaCompra>.from(
            json["detalle"].map(
              (x) => DetalleFacturaCompra.fromJson(x),
            ),
          ),
  );

Map<String, dynamic> toJson() => {
  "id": id,
  "clave": clave,
  "numero_consecutivo": numeroConsecutivo,
  "fecha_emision": fechaEmision == null
    ? null
    : DateFormat('yyyy-MM-dd HH:mm:ss').format(fechaEmision!),
  "proveedor_sistemas": proveedorSistemas,
  "codigo_actividad_emisor": codigoActividadEmisor,
  "codigo_actividad_receptor": codigoActividadReceptor,
  "emisor_identificacion": emisorIdentificacion,
  "emisor_nombre": emisorNombre,
  "emisor_nombre_comercial": emisorNombreComercial,
  "receptor_identificacion": receptorIdentificacion,
  "receptor_nombre": receptorNombre,
  "receptor_nombre_comercial": receptorNombreComercial,
  "condicion_venta": condicionVenta,
  "condicion_venta_otros": condicionVentaOtros,
  "plazo_credito": plazoCredito,
  "moneda": moneda,
  "tipo_cambio": tipoCambio,
  "total_gravado": totalGravado,
  "total_venta": totalVenta,
  "total_venta_neta": totalVentaNeta,
  "total_impuesto": totalImpuesto,
  "total_comprobante": totalComprobante,
  "fecha_registro": fechaRegistro == null
    ? null
    : DateFormat('yyyy-MM-dd HH:mm:ss').format(fechaRegistro!),
  "detalle": detalle == null
      ? []
      : List<dynamic>.from(detalle!.map((x) => x.toJson())),
};
}