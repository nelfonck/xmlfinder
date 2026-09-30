// To parse this JSON data, do
//
//     final tienda = tiendaFromJson(jsonString);

import 'dart:convert';

List<Tienda> tiendaFromJson(String str) => List<Tienda>.from(json.decode(str).map((x) => Tienda.fromJson(x)));

String tiendaToJson(List<Tienda> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Tienda {
    int id;
    String nombre;
    String telefono;
    String? correo;
    String direccion;
    int idRazonSocial;

    Tienda({
        required this.id,
        required this.nombre,
        required this.telefono,
        this.correo,
        required this.direccion,
        required this.idRazonSocial
    });

    Tienda copyWith({
        int? id,
        String? nombre,
        String? telefono,
        String? correo,
        String? direccion,
        int? idRazonSocial,
    }) => 
        Tienda(
            id: id ?? this.id,
            nombre: nombre ?? this.nombre,
            telefono: telefono ?? this.telefono,
            correo: correo ?? this.correo,
            direccion: direccion ?? this.direccion,
            idRazonSocial: idRazonSocial ?? this.idRazonSocial,
        );

    factory Tienda.fromJson(Map<String, dynamic> json) => Tienda(
        id: json["id"],
        nombre: json["nombre"],
        telefono: json["telefono"],
        correo: json["correo"],
        direccion: json["direccion"],
        idRazonSocial: json["id_razon_social"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "telefono": telefono,
        "correo": correo,
        "direccion": direccion,
        "id_razon_social": idRazonSocial,
    };
}
