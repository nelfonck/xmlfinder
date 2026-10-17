
import 'dart:typed_data';

import 'package:comprassj/viewmodels/ventasviewmodel.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;


Future<Uint8List> crearReporteVentas(
  Ventasviewmodel model,
) async {
  final pdf = pw.Document();

  final formatoMoneda = NumberFormat('#,##0.##', 'es_CR');
  final formatoFecha = DateFormat('dd/MM/yyyy');

  final azul = PdfColor.fromInt(0xFF2E64EB);
  final grisClaro = PdfColor.fromInt(0xFFE8E8E8);
  final grisBorde = PdfColor.fromInt(0xFFBDBDBD);

  String dinero(num? valor) {
    return formatoMoneda.format(valor ?? 0);
  }

  final filas = model.ventas.map((venta) {
    return [
      '${venta.compania?.razonComercial ?? ''}\n'
          '${venta.compania?.razonSocial ?? ''}',
      dinero(venta.colones),
      dinero(venta.dolares),
      dinero(venta.iva),
      dinero(venta.descuento),
      dinero(venta.credito),
      dinero(venta.tarjeta),
      dinero(venta.sinpe),
      dinero(venta.abonos),
      dinero(-(venta.notasCredito ?? 0)),
      dinero(venta.facturado),
    ];
  }).toList();

  // Gran total al final de la tabla.
  filas.add([
    'GRAN TOTAL',
    dinero(model.colones),
    dinero(model.dolares),
    dinero(model.iva),
    dinero(model.descuento),
    dinero(model.credito),
    dinero(model.tarjeta),
    dinero(model.sinpe),
    dinero(model.abonos),
    dinero(-model.notasCredito),
    dinero(model.facturado),
  ]);

  final encabezados = [
    'Comercio',
    'Colones',
    'Dólares',
    'IVA',
    'Descuento',
    'Crédito',
    'Tarjeta',
    'Sinpe Móvil',
    'Abonos',
    'NC',
    'Facturado',
  ];

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4.landscape,
      margin: const pw.EdgeInsets.all(10),

      header: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'REPORTE DE VENTAS',
              style: pw.TextStyle(
                fontSize: 17,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue800,
              ),
            ),
            pw.SizedBox(height: 5),
            pw.Text(
              'Razón social: '
              '${model.selectedRs?.nombre ?? 'TODO'}',
              style: const pw.TextStyle(fontSize: 9),
            ),
            pw.Text(
              'Desde: '
              '${model.desde != null ? formatoFecha.format(model.desde!) : 'Todas'}'
              '     Hasta: '
              '${model.hasta != null ? formatoFecha.format(model.hasta!) : 'Todas'}',
              style: const pw.TextStyle(fontSize: 9),
            ),
            pw.SizedBox(height: 12),
          ],
        );
      },

      footer: (context) {
        return pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(top: 8),
          child: pw.Text(
            'Página ${context.pageNumber} de ${context.pagesCount}',
            style: const pw.TextStyle(
              fontSize: 8,
              color: PdfColors.grey700,
            ),
          ),
        );
      },

      build: (context) {
        return [
          pw.TableHelper.fromTextArray(
            headers: encabezados,
            data: filas,

            columnWidths: {
              0: const pw.FlexColumnWidth(2.7),
              1: const pw.FlexColumnWidth(1.10),
              2: const pw.FlexColumnWidth(1.00),
              3: const pw.FlexColumnWidth(1.00),
              4: const pw.FlexColumnWidth(1.00),
              5: const pw.FlexColumnWidth(1.00),
              6: const pw.FlexColumnWidth(1.00),
              7: const pw.FlexColumnWidth(1.00),
              8: const pw.FlexColumnWidth(1.00),
              9: const pw.FlexColumnWidth(1.00),
              10: const pw.FlexColumnWidth(1.25),
            },

            border: pw.TableBorder.all(
              color: grisBorde,
              width: 0.4,
            ),

            headerDecoration: pw.BoxDecoration(
              color: azul,
            ),

            headerStyle: pw.TextStyle(
              color: PdfColors.white,
              fontSize: 7,
              fontWeight: pw.FontWeight.bold,
            ),

            headerAlignment: pw.Alignment.center,

            cellStyle: const pw.TextStyle(
              fontSize: 7,
            ),

            cellAlignment: pw.Alignment.centerRight,

            cellAlignments: {
              0: pw.Alignment.centerLeft,
            },

            cellPadding: const pw.EdgeInsets.symmetric(
              horizontal: 1,
              vertical: 5,
            ),

            headerPadding: const pw.EdgeInsets.symmetric(
              horizontal: 1,
              vertical: 7,
            ),

            oddRowDecoration: pw.BoxDecoration(
              color: grisClaro,
            ),
          ),
        ];
      },
    ),
  );

  return pdf.save();
}

void abrirPdf(Uint8List bytes) {
  final blob = html.Blob([bytes], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);

  html.window.open(url, '_blank');
}
