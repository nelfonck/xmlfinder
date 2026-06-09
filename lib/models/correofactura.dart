class CorreoFactura {
  final int uid;
  final String asunto;
  final String? remitente;
  final DateTime? fecha;
  final List<String>? fileNames;



  CorreoFactura({
    required this.uid,
    required this.asunto,
    this.remitente,
    this.fecha,
    this.fileNames
  });
}