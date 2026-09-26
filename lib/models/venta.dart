// To parse this JSON data, do
//
//     final ventas = ventasFromJson(jsonString);

import 'dart:convert';

Ventas ventasFromJson(String str) => Ventas.fromJson(json.decode(str));

String ventasToJson(Ventas data) => json.encode(data.toJson());

class Ventas {
    String comercio;
    String cedula;
    double facturado;
    double iva;
    double colones;
    double dolares;
    double descuento;
    double credito;
    double sinpe;

    Ventas({
        required this.comercio,
        required this.cedula,
        required this.facturado,
        required this.iva,
        required this.colones,
        required this.dolares,
        required this.descuento,
        required this.credito,
        required this.sinpe,
    });

    Ventas copyWith({
        String? comercio,
        String? cedula,
        double? facturado,
        double? iva,
        double? colones,
        double? dolares,
        double? descuento,
        double? credito,
        double? sinpe,
    }) => 
        Ventas(
            comercio: comercio ?? this.comercio,
            cedula: cedula ?? this.cedula,
            facturado: facturado ?? this.facturado,
            iva: iva ?? this.iva,
            colones: colones ?? this.colones,
            dolares: dolares ?? this.dolares,
            descuento: descuento ?? this.descuento,
            credito: credito ?? this.credito,
            sinpe: sinpe ?? this.sinpe,
        );

    factory Ventas.fromJson(Map<String, dynamic> json) => Ventas(
        comercio: json["comercio"],
        cedula: json["cedula"],
        facturado: json["facturado"],
        iva: json["iva"],
        colones: json["colones"],
        dolares: json["dolares"],
        descuento: json["descuento"],
        credito: json["credito"],
        sinpe: json["sinpe"],
    );

    Map<String, dynamic> toJson() => {
        "comercio": comercio,
        "cedula": cedula,
        "facturado": facturado,
        "iva": iva,
        "colones": colones,
        "dolares": dolares,
        "descuento": descuento,
        "credito": credito,
        "sinpe": sinpe,
    };
}
