import 'package:comprassj/widgets/totalventa.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:comprassj/models/razonsocial.dart';
import 'package:comprassj/viewmodels/ventasviewmodel.dart';
import 'package:comprassj/helpers/helper.dart';
import 'package:comprassj/helpers/mensajes.dart';

class VentasMobileView extends StatelessWidget {
  final Ventasviewmodel model;

  const VentasMobileView({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final formatoMoneda = NumberFormat('#,##0.##', 'es_CR');
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // --- Tus Filtros adaptados a columna en móvil ---
          Column(
            children: [
              DropdownButtonFormField<RazonSocial>(
                decoration: InputDecoration(
                  labelText: 'Razón social',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                hint: const Text('Seleccione una razón social', overflow: TextOverflow.ellipsis),
                value: model.selectedRs,
                items: model.rs.map((tienda) {
                  return DropdownMenuItem<RazonSocial>(
                    value: tienda,
                    child: Text(tienda.nombre, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (value) => model.selectedRs = value,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        DateTime? fecha = await Helper.pickupDesdeDate(context, model.desde);
                        if (fecha != null) {
                          model.desde = fecha;
                          model.safeNotifyListeners();
                        }
                      },
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 18),
                            const SizedBox(width: 8),
                            Expanded(child: Text(model.desde != null ? dateFormat.format(model.desde!) : 'DESDE', overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        DateTime? fecha = await Helper.pickupHastaDate(context, model.hasta);
                        if (fecha != null) {
                          model.hasta = fecha;
                          model.safeNotifyListeners();
                        }
                      },
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 18),
                            const SizedBox(width: 8),
                            Expanded(child: Text(model.hasta != null ? dateFormat.format(model.hasta!) : 'HASTA', overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.outlined(
                    onPressed: () async {
                      try {
                        await model.getVentas();
                      } catch (e) {
                        if (context.mounted) {
                          model.isLoading = false;
                          model.safeNotifyListeners();
                          Mensajes.error(context, e.toString());
                        }
                      }
                    },
                    icon: const Icon(Icons.search),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),

          // --- Lista de Tarjetas con TODOS los totales visibles ---
          model.isLoading
              ? Expanded(child: const Center(child: CircularProgressIndicator()))
              : Expanded(
                  child: ListView.builder(
                    itemCount: model.ventas.length,
                    itemBuilder: (context, index) {
                      final venta = model.ventas[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                        elevation: 3,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      venta.compania?.razonComercial ?? 'Comercio sin nombre',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade900,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      'Fact: ${formatoMoneda.format(venta.facturado ?? 0)}',
                                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              if (venta.compania?.razonSocial != null && (venta.compania?.razonSocial?.isNotEmpty ?? false)) ...[
                                const SizedBox(height: 2),
                                Text(
                                  venta.compania!.razonSocial ?? '',
                                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                                ),
                              ],
                              const Divider(height: 16),
                              Table(
                                columnWidths: const {
                                  0: FlexColumnWidth(1),
                                  1: FlexColumnWidth(1),
                                },
                                children: [
                                  _filaTablaMovil('Colones', formatoMoneda.format(venta.colones ?? 0), 'Dólares', formatoMoneda.format(venta.dolares ?? 0)),
                                  _filaTablaMovil('IVA', formatoMoneda.format(venta.iva ?? 0), 'Descuento', formatoMoneda.format(venta.descuento ?? 0)),
                                  _filaTablaMovil('Crédito', formatoMoneda.format(venta.credito ?? 0), 'Tarjeta', formatoMoneda.format(venta.tarjeta ?? 0)),
                                  _filaTablaMovil('Sinpe Móvil', formatoMoneda.format(venta.sinpe ?? 0), 'Abonos', formatoMoneda.format(venta.abonos ?? 0)),
                                  _filaTablaMovil('NC', formatoMoneda.format(0 - (venta.notasCredito ?? 0)), '', ''),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Divider(),
                SizedBox(
                  height: 70,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      totalVenta(title: 'Colones', total: model.colones, symbol: 'c'),
                      totalVenta(title: 'Dolares', total: model.dolares, symbol: 'd'),
                      totalVenta(title: 'IVA', total: model.iva, symbol: 'c'),
                      totalVenta(title: 'Descuento', total: model.descuento, symbol: 'c'),
                      totalVenta(title: 'Credito', total: model.credito, symbol: 'c'),
                      totalVenta(title: 'Tarjeta', total: model.tarjeta, symbol: 'c'),
                      totalVenta(title: 'Sinpe Movil', total: model.sinpe, symbol: 'c'),
                      totalVenta(title: 'Abonos', total: model.abonos, symbol: 'c'),
                      totalVenta(title: 'NC', total: 0-model.notasCredito, symbol: 'c'),
                      totalVenta(title: 'Facturado', total: model.facturado, symbol: 'c'),
                    ],
                  ),
                )
        ],
      ),
    );
  }

  TableRow _filaTablaMovil(String label1, String val1, String label2, String val2) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label1, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              Text(val1, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 4.0),
          child: label2.isNotEmpty
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(label2, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    Text(val2, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                  ],
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}