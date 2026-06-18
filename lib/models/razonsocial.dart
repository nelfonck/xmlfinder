// To parse this JSON data, do
//
//     final razonSocial = razonSocialFromJson(jsonString);

import 'dart:convert';

List<RazonSocial> razonSocialFromJson(String str) => List<RazonSocial>.from(json.decode(str).map((x) => RazonSocial.fromJson(x)));

String razonSocialToJson(List<RazonSocial> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RazonSocial {
    int id;
    String identificacion;
    String tipoIdentificacion;
    String nombre;
    String nombreComercial;
    String correo;
    String telefono;
    bool activo;
    DateTime fechaRegistro;
    String claveCorreo;

    RazonSocial({
        required this.id,
        required this.identificacion,
        required this.tipoIdentificacion,
        required this.nombre,
        required this.nombreComercial,
        required this.correo,
        required this.telefono,
        required this.activo,
        required this.fechaRegistro,
        required this.claveCorreo,
    });

    RazonSocial copyWith({
        int? id,
        String? identificacion,
        String? tipoIdentificacion,
        String? nombre,
        String? nombreComercial,
        String? correo,
        String? telefono,
        bool? activo,
        DateTime? fechaRegistro,
        String? claveCorreo
    }) => 
        RazonSocial(
            id: id ?? this.id,
            identificacion: identificacion ?? this.identificacion,
            tipoIdentificacion: tipoIdentificacion ?? this.tipoIdentificacion,
            nombre: nombre ?? this.nombre,
            nombreComercial: nombreComercial ?? this.nombreComercial,
            correo: correo ?? this.correo,
            telefono: telefono ?? this.telefono,
            activo: activo ?? this.activo,
            fechaRegistro: fechaRegistro ?? this.fechaRegistro,
            claveCorreo: claveCorreo ?? this.claveCorreo,
        );

    factory RazonSocial.fromJson(Map<String, dynamic> json) => RazonSocial(
        id: json["id"],
        identificacion: json["identificacion"],
        tipoIdentificacion: json["tipo_identificacion"],
        nombre: json["nombre"],
        nombreComercial: json["nombre_comercial"],
        correo: json["correo"],
        telefono: json["telefono"],
        activo: json["activo"],
        fechaRegistro: DateTime.parse(json["fecha_registro"]),
        claveCorreo: json["clave_correo"]
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "identificacion": identificacion,
        "tipo_identificacion": tipoIdentificacion,
        "nombre": nombre,
        "nombre_comercial": nombreComercial,
        "correo": correo,
        "telefono": telefono,
        "activo": activo,
        "fecha_registro": fechaRegistro.toIso8601String(),
        "clave_correo": claveCorreo,
    };
}
