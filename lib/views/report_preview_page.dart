import 'package:comprassj/models/factura_compra.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart' as pw_pdf;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';

class ReportPreviewPage extends StatelessWidget {
   const ReportPreviewPage({super.key, required this.facturas});
   final List<FacturaCompra> facturas;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visor de Reportes (Estilo Crystal Reports)'),
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

  Future<Uint8List> _crearReportePersonalizado(pw_pdf.PdfPageFormat format) async {
    final pdf = pw.Document();

    double subtotalTotal = 100;
    double impuesto = subtotalTotal * 0.13;
    double granTotal = subtotalTotal + impuesto;

    // Usamos el widget nativo pw.Table con un delegate optimizado para paginación masiva
    pdf.addPage(
      pw.MultiPage(
        pageFormat: format,
        margin: const pw.EdgeInsets.all(32),
        
        // Encabezado que aparecerá limpio en cada hoja generada
        // Encabezado seguro que no rompe el contexto de la página
        header: (pw.Context context) {
          return pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('SISTEMA DE GESTIÓN EMPRESARIAL - REPORTE DE VENTAS', 
                style: pw.TextStyle(fontSize: 9, color: pw_pdf.PdfColors.grey700, fontWeight: pw.FontWeight.bold)),
              // Cambiamos temporalmente la interpolación directa de context.pageNumber 
              // para evitar el crash del operador nulo interno de la librería pdf
              pw.Text('DOCUMENTO OFICIAL', 
                style: pw.TextStyle(fontSize: 9, color: pw_pdf.PdfColors.grey700)),
            ],
          );
        },

        // Cuerpo limpio: Evitamos anidar elementos pesados fuera de la tabla
        build: (pw.Context context) {
          // Si es la página 1, inyectamos los datos de la empresa arriba de la tabla
          bool esPrimeraPagina = context.pageNumber == 1;

          List<pw.Widget> elementosPagina = [];

          if (esPrimeraPagina) {
            elementosPagina.addAll([
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('MI COMPAÑÍA S.A.', 
                        style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold, color: pw_pdf.PdfColors.blue800)),
                      pw.Text('Cédula Jurídica: 3-101-999999', style: const pw.TextStyle(fontSize: 10)),
                      pw.Text('San José, Costa Rica', style: const pw.TextStyle(fontSize: 10)),
                    ],
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: pw_pdf.PdfColors.blue800, width: 1.2),
                      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('REPORTE GENERAL', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                        pw.Text('N°: REP-2026-0042', style: const pw.TextStyle(fontSize: 9)),
                        pw.Text('Fecha: ${DateTime.now().toString().substring(0, 10)}', style: const pw.TextStyle(fontSize: 9)),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 15),
            ]);
          }

          // Agregamos la tabla masiva optimizada mediante Table.fromTextArray 
          // (Es infinitamente más liviana para renderizar miles de registros en lote que construir TableRow manuales uno por uno)
          elementosPagina.add(
            pw.Table.fromTextArray(
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: pw_pdf.PdfColors.white, fontSize: 8.5),
              headerDecoration: const pw.BoxDecoration(color: pw_pdf.PdfColors.blue800),
              rowDecoration: const pw.BoxDecoration(
                border: pw.Border(bottom: pw.BorderSide(color: pw_pdf.PdfColors.grey300, width: 0.4)),
              ),
              cellHeight: 18, // Altura ultra compacta para maximizar rendimiento
              cellPadding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 3),
              columnWidths: {
                0: const pw.FlexColumnWidth(2.5), 
                1: const pw.FlexColumnWidth(3.0), 
                2: const pw.FlexColumnWidth(3.0), 
                3: const pw.FlexColumnWidth(1.5), 
                4: const pw.FlexColumnWidth(1.5), 
              },
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerLeft,
                2: pw.Alignment.centerLeft,
                3: pw.Alignment.centerRight,
                4: pw.Alignment.centerRight,
              },
              headers: ['Consecutivo', 'Emisor', 'Receptor', 'Sub. total', 'Total'],
              data: facturas.map((item) {
                return [
                  item.numeroConsecutivo?.toString() ?? 'N/D',
                  item.emisorNombre?.toString() ?? 'N/D',
                  item.receptorNombre?.toString() ?? 'N/D',
                  item.totalComprobante?.toStringAsFixed(2) ?? '0.00',
                  item.totalComprobante?.toStringAsFixed(2) ?? '0.00',
                ];
              }).toList(),
            ),
          );

          // Si es la última página, agregamos los totales y las firmas al final de todo el documento
          if (context.pageNumber == context.pagesCount) {
            elementosPagina.addAll([
              pw.SizedBox(height: 15),
              pw.Container(
                alignment: pw.Alignment.centerRight,
                child: pw.SizedBox(
                  width: 200,
                  child: pw.Column(
                    children: [
                      _buildFilaTotal('Subtotal:', '\$${subtotalTotal.toStringAsFixed(2)}', false),
                      _buildFilaTotal('IVA (13%):', '\$${impuesto.toStringAsFixed(2)}', false),
                      pw.Divider(),
                      _buildFilaTotal('TOTAL:', '\$${granTotal.toStringAsFixed(2)}', true),
                    ],
                  ),
                ),
              ),
              pw.SizedBox(height: 30),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(width: 140, child: pw.Divider(color: pw_pdf.PdfColors.black)),
                      pw.Text('Elaborado por', style: const pw.TextStyle(fontSize: 9)),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(width: 140, child: pw.Divider(color: pw_pdf.PdfColors.black)),
                      pw.Text('Autorizado por', style: const pw.TextStyle(fontSize: 9)),
                    ],
                  ),
                ],
              ),
            ]);
          }

          return elementosPagina;
        },
      ),
    );

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