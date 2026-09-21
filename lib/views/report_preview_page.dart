import 'package:comprassj/models/factura_compra.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart' as pw_pdf;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';

class ReportPreviewPage extends StatelessWidget {
   const ReportPreviewPage({super.key, required this.facturas,this.desde,this.hasta, required this.subTotal, required this.impuesto, required this.total });
   final List<FacturaCompra> facturas;
   final DateTime? desde, hasta;
   final double subTotal, impuesto, total;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informe'),
        backgroundColor: Colors.blueGrey,
      ),
      body: PdfPreview(
        build: (pw_pdf.PdfPageFormat format) => _crearReportePersonalizado(format),
        allowSharing: false,
        canChangeOrientation: true,
        canDebug: false,
      ),
    );
  }

Future<Uint8List> _crearReportePersonalizado(
  pw_pdf.PdfPageFormat format) async {
  final dateFormat = DateFormat('dd/MM/yyyy');
  final formatoMoneda = NumberFormat('#,##0.00', 'es_CR');
  final pdf = pw.Document();

  const int registrosPorBloque = 200;

  for (int inicio = 0;
      inicio < facturas.length;
      inicio += registrosPorBloque) {

    final fin = (inicio + registrosPorBloque < facturas.length)
        ? inicio + registrosPorBloque
        : facturas.length;

    final bloque = facturas.sublist(inicio, fin);

    final esUltimoBloque = fin == facturas.length;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: format,
        margin: const pw.EdgeInsets.all(32),

        /*header: (context) {
          return pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 10),
            child: pw.Row(
              mainAxisAlignment:
                  pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'REPORTE DE FACTURAS',
                  style: const pw.TextStyle(
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          );
        },*/

        build: (context) {
          return [
            if (inicio == 0) ...[
              pw.Text(
                'DESDE ${ desde!=null ? dateFormat.format(desde!) : '' } HASTA ${hasta!=null ? dateFormat.format(hasta!) : ''}',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              /*pw.Text(
                'Cédula Jurídica: 3-101-999999',
                style: const pw.TextStyle(fontSize: 10),
              ),

              pw.Text(
                'San José, Costa Rica',
                style: const pw.TextStyle(fontSize: 10),
              ),

              pw.SizedBox(height: 15),*/
            ],
            pw.Table.fromTextArray(
              headers: [
                'Consecutivo',
                'Emisor',
                'Receptor',
                'Subtotal',
                'Total impuesto',
                'Total',
              ],

              data: bloque.map((item) {
                return [
                  item.numeroConsecutivo?.toString() ?? 'N/D',
                  item.emisorNombre?.toString() ?? 'N/D',
                  item.receptorNombre?.toString() ?? 'N/D',
                  item.totalGravado
                          ?.toStringAsFixed(2) ??
                      '0.00',
                  item.totalImpuesto
                          ?.toStringAsFixed(2) ??
                      '0.00',
                  item.totalComprobante
                          ?.toStringAsFixed(2) ??
                      '0.00',
                ];
              }).toList(),

              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                color: pw_pdf.PdfColors.white,
                fontSize: 8,
              ),

              headerDecoration:
                  const pw.BoxDecoration(
                color: pw_pdf.PdfColors.blue800,
              ),

              cellStyle: const pw.TextStyle(
                fontSize: 8,
              ),

              cellPadding:
                  const pw.EdgeInsets.all(4),

              border: pw.TableBorder.all(
                color: pw_pdf.PdfColors.grey300,
                width: 1,
              ),

              columnWidths: {
                0: const pw.FlexColumnWidth(2.5),
                1: const pw.FlexColumnWidth(3),
                2: const pw.FlexColumnWidth(3),
                3: const pw.FlexColumnWidth(1.5),
                4: const pw.FlexColumnWidth(1.5),
                5: const pw.FlexColumnWidth(1.5),
              },

              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerLeft,
                2: pw.Alignment.centerLeft,
                3: pw.Alignment.centerRight,
                4: pw.Alignment.centerRight,
                5: pw.Alignment.centerRight,
              },
            ),
          // SOLO EN EL ÚLTIMO BLOQUE
          if (esUltimoBloque) ...[
            pw.SizedBox(height: 20),

            pw.Container(
              alignment: pw.Alignment.centerRight,
              child: pw.SizedBox(
                width: 200,
                child: pw.Column(
                  children: [
                    _buildFilaTotal(
                      'Subtotal:',
                      formatoMoneda.format(subTotal),
                      false,
                    ),

                    _buildFilaTotal(
                      'TOTAL IMPUESTO:',
                      formatoMoneda.format(impuesto),
                      false,
                    ),

                    pw.Divider(),

                    _buildFilaTotal(
                      'TOTAL:',
                      formatoMoneda.format(total),
                      true,
                    ),
                  ],
                ),
              ),
            ),
          ],
          ];
        },
      ),
    );
  }

  return pdf.save();
}

  pw.Widget _buildFilaTotal(String label, String valor, bool esNegrita) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: pw.TextStyle(fontWeight: esNegrita ? pw.FontWeight.bold : pw.FontWeight.normal, fontSize: 10)),
          pw.Text(valor, style: pw.TextStyle(fontWeight: esNegrita ? pw.FontWeight.bold : pw.FontWeight.normal, fontSize: 10)),
        ],
      ),
    );
  }
}