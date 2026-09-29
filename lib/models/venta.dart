// To parse this JSON data, do
//
//     final ventas = ventasFromJson(jsonString);

import 'dart:convert';
import 'package:comprassj/models/compania.dart';

List<Ventas> ventasFromJson(String str) => List<Ventas>.from(json.decode(str).map((x) => Ventas.fromJson(x)));

String ventasToJson(List<Ventas> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Ventas {
    Compania? compania;
    double? facturado;
    double? iva;
    double? colones;
    double? dolares;
    double? descuento;
    double? credito;
    double? tarjeta;
    double? sinpe;
    double? mixto;
    double? notasCredito;

    Ventas({
        this.compania,
        this.facturado,
        this.iva,
        this.colones,
        this.dolares,
        this.descuento,
        this.credito,
        this.tarjeta,
        this.sinpe,
        this.mixto,
        this.notasCredito
    });

    Ventas copyWith({
        Compania? compania,
        double? facturado,
        double? iva,
        double? colones,
        double? dolares,
        double? descuento,
        double? credito,
        double? tarjeta,
        double? sinpe,
        double? mixto,
        double? notasCredito
    }) => 
        Ventas(
            compania: compania ?? this.compania,
            facturado: facturado ?? this.facturado,
            iva: iva ?? this.iva,
            colones: colones ?? this.colones,
            dolares: dolares ?? this.dolares,
            descuento: descuento ?? this.descuento,
            credito: credito ?? this.credito,
            tarjeta: tarjeta ?? this.tarjeta,
            sinpe: sinpe ?? this.sinpe,
            mixto: mixto ?? this.mixto,
            notasCredito: notasCredito ?? this.notasCredito,
        );

    factory Ventas.fromJson(Map<String, dynamic> json) => Ventas(
        compania: json["compania"] == null ? null : Compania.fromJson(json["compania"]),
        facturado: json["facturado"]?.toDouble(),
        iva: json["iva"]?.toDouble(),
        colones: json["colones"]?.toDouble(),
        dolares: json["dolares"]?.toDouble(),
        descuento: json["descuento"]?.toDouble(),
        credito: json["credito"]?.toDouble(),
        tarjeta: json["tarjeta"]?.toDouble(),
        sinpe: json["sinpe"]?.toDouble(),
        mixto: json["mixto"]?.toDouble(),
        notasCredito: json["notas_credito"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "compania": compania?.toJson(),
        "facturado": facturado,
        "iva": iva,
        "colones": colones,
        "dolares": dolares,
        "descuento": descuento,
        "credito": credito,
        "tarjeta": tarjeta,
        "sinpe": sinpe,
        "mixto": mixto,
        "notas_credito": notasCredito,
    };
}


