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
    String correo;
    String direccion;
    String claveCorreo;

    Tienda({
        required this.id,
        required this.nombre,
        required this.telefono,
        required this.correo,
        required this.direccion,
        required this.claveCorreo,
    });

    Tienda copyWith({
        int? id,
        String? nombre,
        String? telefono,
        String? correo,
        String? direccion,
        String? claveCorreo,
    }) => 
        Tienda(
            id: id ?? this.id,
            nombre: nombre ?? this.nombre,
            telefono: telefono ?? this.telefono,
            correo: correo ?? this.correo,
            direccion: direccion ?? this.direccion,
            claveCorreo: claveCorreo ?? this.claveCorreo,
        );

    factory Tienda.fromJson(Map<String, dynamic> json) => Tienda(
        id: json["id"],
        nombre: json["nombre"],
        telefono: json["telefono"],
        correo: json["correo"],
        direccion: json["direccion"],
        claveCorreo: json["clave_correo"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "telefono": telefono,
        "correo": correo,
        "direccion": direccion,
        "clave_correo": claveCorreo,
    };
}
