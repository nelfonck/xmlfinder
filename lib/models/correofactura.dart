import 'package:enough_mail/enough_mail.dart';

class CorreoFactura {
  final int uid;
  final String asunto;
  final String? remitente;
  final DateTime? fecha;
  final List<String> adjuntos;
  final List<MimeMessage>? mimeMessages;
  final String? consecutivoFacturacion;

  CorreoFactura({
    required this.uid,
    required this.asunto,
    this.remitente,
    this.fecha,
    required this.adjuntos,
    this.mimeMessages,
    this.consecutivoFacturacion
  });
}