// To parse this JSON data, do
//
//     final detalleFacturaCompra = detalleFacturaCompraFromJson(jsonString);

import 'dart:convert';

List<DetalleFacturaCompra> detalleFacturaCompraFromJson(String str) => List<DetalleFacturaCompra>.from(json.decode(str).map((x) => DetalleFacturaCompra.fromJson(x)));

String detalleFacturaCompraToJson(List<DetalleFacturaCompra> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DetalleFacturaCompra {
    int? id;
    int? facturaId;
    int? numeroLinea;
    String? codigoCabys;
    String? codigoComercialTipo;
    String? codigoComercial;
    String? detalle;
    double? cantidad;
    String? unidadMedida;
    String? unidadMedidaComercial;
    String? tipoTransaccion;
    double? precioUnitario;
    double? montoTotal;
    double? subtotal;
    double? baseImponible;
    double? impuesto;
    double? tarifaImpuesto;
    double? montoTotalLinea;

    DetalleFacturaCompra({
        this.id,
        this.facturaId,
        this.numeroLinea,
        this.codigoCabys,
        this.codigoComercialTipo,
        this.codigoComercial,
        this.detalle,
        this.cantidad,
        this.unidadMedida,
        this.unidadMedidaComercial,
        this.tipoTransaccion,
        this.precioUnitario,
        this.montoTotal,
        this.subtotal,
        this.baseImponible,
        this.impuesto,
        this.tarifaImpuesto,
        this.montoTotalLinea,
    });

    DetalleFacturaCompra copyWith({
        int? id,
        int? facturaId,
        int? numeroLinea,
        String? codigoCabys,
        String? codigoComercialTipo,
        String? codigoComercial,
        String? detalle,
        double? cantidad,
        String? unidadMedida,
        String? unidadMedidaComercial,
        String? tipoTransaccion,
        double? precioUnitario,
        double? montoTotal,
        double? subtotal,
        double? baseImponible,
        double? impuesto,
        double? tarifaImpuesto,
        double? montoTotalLinea,
    }) => 
        DetalleFacturaCompra(
            id: id ?? this.id,
            facturaId: facturaId ?? this.facturaId,
            numeroLinea: numeroLinea ?? this.numeroLinea,
            codigoCabys: codigoCabys ?? this.codigoCabys,
            codigoComercialTipo: codigoComercialTipo ?? this.codigoComercialTipo,
            codigoComercial: codigoComercial ?? this.codigoComercial,
            detalle: detalle ?? this.detalle,
            cantidad: cantidad ?? this.cantidad,
            unidadMedida: unidadMedida ?? this.unidadMedida,
            unidadMedidaComercial: unidadMedidaComercial ?? this.unidadMedidaComercial,
            tipoTransaccion: tipoTransaccion ?? this.tipoTransaccion,
            precioUnitario: precioUnitario ?? this.precioUnitario,
            montoTotal: montoTotal ?? this.montoTotal,
            subtotal: subtotal ?? this.subtotal,
            baseImponible: baseImponible ?? this.baseImponible,
            impuesto: impuesto ?? this.impuesto,
            tarifaImpuesto: tarifaImpuesto ?? this.tarifaImpuesto,
            montoTotalLinea: montoTotalLinea ?? this.montoTotalLinea,
        );

    factory DetalleFacturaCompra.fromJson(Map<String, dynamic> json) => DetalleFacturaCompra(
        id: json["id"],
        facturaId: json["factura_id"],
        numeroLinea: json["numero_linea"],
        codigoCabys: json["codigo_cabys"],
        codigoComercialTipo: json["codigo_comercial_tipo"],
        codigoComercial: json["codigo_comercial"],
        detalle: json["detalle"],
        cantidad: json["cantidad"]?.toDouble(),
        unidadMedida: json["unidad_medida"],
        unidadMedidaComercial: json["unidad_medida_comercial"],
        tipoTransaccion: json["tipo_transaccion"],
        precioUnitario: json["precio_unitario"]?.toDouble(),
        montoTotal: json["monto_total"]?.toDouble(),
        subtotal: json["subtotal"]?.toDouble(),
        baseImponible: json["base_imponible"]?.toDouble(),
        impuesto: json["impuesto"]?.toDouble(),
        tarifaImpuesto: json["tarifa_impuesto"]?.toDouble(),
        montoTotalLinea: json["monto_total_linea"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "factura_id": facturaId,
        "numero_linea": numeroLinea,
        "codigo_cabys": codigoCabys,
        "codigo_comercial_tipo": codigoComercialTipo,
        "codigo_comercial": codigoComercial,
        "detalle": detalle,
        "cantidad": cantidad,
        "unidad_medida": unidadMedida,
        "unidad_medida_comercial": unidadMedidaComercial,
        "tipo_transaccion": tipoTransaccion,
        "precio_unitario": precioUnitario,
        "monto_total": montoTotal,
        "subtotal": subtotal,
        "base_imponible": baseImponible,
        "impuesto": impuesto,
        "tarifa_impuesto": tarifaImpuesto,
        "monto_total_linea": montoTotalLinea,
    };
}
