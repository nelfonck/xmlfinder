
// To parse this JSON data, do
//
//     final proveedor = proveedorFromJson(jsonString);
import 'package:intl/intl.dart';
import 'dart:convert';
FacturaCompra facturaFromJson(String str) => FacturaCompra.fromJson(json.decode(str));

String facturaToJson(FacturaCompra data) => json.encode(data.toJson());

class FacturaCompra{
  int? id;
  String? clave;
  String? numeroConsecutivo;
  DateTime? fechaEmision;
  String? proveedorSistemas;
  String? codigoActividadEmisor;
  String? codigoActividadReceptor;
  String? emisorIdentificacion;
  String? emisorNombre;
  String? emisorNombreComercial;
  String? receptorIdentificacion;
  String? receptorNombre;
  String? receptorNombreComercial;
  String? condicionVenta;
  String? condicionVentaOtros;
  int? plazoCredito;
  String? moneda;
  double? tipoCambio;
  double? totalGravado;
  double? totalVenta;
  double? totalVentaNeta;
  double? totalImpuesto;
  double? totalComprobante;
  DateTime? fechaRegistro;

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
  });

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
        : (json["tipo_cambio"] as num).toDouble(),

    totalGravado: json["total_gravado"] == null
        ? null
        : (json["total_gravado"] as num).toDouble(),

    totalVenta: json["total_venta"] == null
        ? null
        : (json["total_venta"] as num).toDouble(),

    totalVentaNeta: json["total_venta_neta"] == null
        ? null
        : (json["total_venta_neta"] as num).toDouble(),

    totalImpuesto: json["total_impuesto"] == null
        ? null
        : (json["total_impuesto"] as num).toDouble(),

    totalComprobante: json["total_comprobante"] == null
        ? null
        : (json["total_comprobante"] as num).toDouble(),

    fechaRegistro: json["fecha_registro"] != null
        ? DateTime.tryParse(json["fecha_registro"].toString())
        : null,
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
};

}