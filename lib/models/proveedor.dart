// To parse this JSON data, do
//
//     final proveedor = proveedorFromJson(jsonString);

import 'dart:convert';

Proveedor proveedorFromJson(String str) => Proveedor.fromJson(json.decode(str));

String proveedorToJson(Proveedor data) => json.encode(data.toJson());

class Proveedor {
    int id;
    String identificacion;
    String tipoIdentificacion;
    String nombre;
    String nombreComercial;
    String telefono;
    String? correo;

    Proveedor({
        required this.id,
        required this.identificacion,
        required this.tipoIdentificacion,
        required this.nombre,
        required this.nombreComercial,
        required this.telefono,
        this.correo,
    });

    Proveedor copyWith({
        int? id,
        String? identificacion,
        String? tipoIdentificacion,
        String? nombre,
        String? nombreComercial,
        String? telefono,
        String? correo,
    }) => 
        Proveedor(
            id: id ?? this.id,
            identificacion: identificacion ?? this.identificacion,
            tipoIdentificacion: tipoIdentificacion ?? this.tipoIdentificacion,
            nombre: nombre ?? this.nombre,
            nombreComercial: nombreComercial ?? this.nombreComercial,
            telefono: telefono ?? this.telefono,
            correo: correo ?? this.correo,
        );

    factory Proveedor.fromJson(Map<String, dynamic> json) => Proveedor(
        id: json["id"],
        identificacion: json["identificacion"],
        tipoIdentificacion: json["tipo_identificacion"],
        nombre: json["nombre"],
        nombreComercial: json["nombre_comercial"],
        telefono: json["telefono"],
        correo: json["correo"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "identificacion": identificacion,
        "tipo_identificacion": tipoIdentificacion,
        "nombre": nombre,
        "nombre_comercial": nombreComercial,
        "telefono": telefono,
        "correo": correo,
    };
}
