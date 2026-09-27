class Compania {
    String? identificacion;
    String? razonSocial;
    String? razonComercial;

    Compania({
        this.identificacion,
        this.razonSocial,
        this.razonComercial,
    });

    Compania copyWith({
        String? identificacion,
        String? razonSocial,
        String? razonComercial,
    }) => 
        Compania(
            identificacion: identificacion ?? this.identificacion,
            razonSocial: razonSocial ?? this.razonSocial,
            razonComercial: razonComercial ?? this.razonComercial,
        );

    factory Compania.fromJson(Map<String, dynamic> json) => Compania(
        identificacion: json["identificacion"],
        razonSocial: json["razon_social"],
        razonComercial: json["razon_comercial"],
    );

    Map<String, dynamic> toJson() => {
        "identificacion": identificacion,
        "razon_social": razonSocial,
        "razon_comercial": razonComercial,
    };
}