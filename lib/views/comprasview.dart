import 'package:comprassj/enums/estado_recepcion.dart';
import 'package:comprassj/helpers/helper.dart';
import 'package:comprassj/models/razonsocial.dart';
import 'package:comprassj/viewmodels/comprasviewmodel.dart';
import 'package:comprassj/widgets/fondodegradado.dart';
import 'package:comprassj/widgets/modelready.dart';
import 'package:comprassj/widgets/totalcompra.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ComprasView extends StatelessWidget {
  const ComprasView({super.key});

  @override
  Widget build(BuildContext context) {
    final formatoMoneda = NumberFormat('#,##0.00', 'es_CR');
    final dateFormat = DateFormat('dd/MM/yyyy');

    return ChangeNotifierProvider(
      create: (_) => ComprasViewModel(),
      child: ModelReady<ComprasViewModel>(
        onModelReady: (ComprasViewModel model) async {
          await model.init();
        },
        child: Consumer<ComprasViewModel>(
          builder: (context, model, child) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Compras'),
                flexibleSpace: FondoDegradado(),
                elevation: 0,
              ),

              body: Column(
                children: [

                  // =========================================================
                  // FILTROS
                  // =========================================================
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [

                        // =====================================================
                        // EMISOR / RECEPTOR
                        // =====================================================
                        Row(
                          children: [

                            // EMISOR
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: DropdownButtonFormField<RazonSocial>(
                                  initialValue: model.emisor,
                                  isExpanded: true,

                                  decoration: InputDecoration(
                                    labelText: 'Emisor',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                  ),

                                  hint: const Text(
                                    'Seleccione una razón social',
                                    overflow: TextOverflow.ellipsis,
                                  ),

                                  items: model.razonesSociales.map((emisor) {
                                    return DropdownMenuItem<RazonSocial>(
                                      value: emisor,
                                      child: Text(
                                        emisor.nombre,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }).toList(),

                                  onChanged: (value) {
                                    if (value != null) {
                                      model.emisor = value;
                                      model.safeNotifyListeners();
                                    }
                                  },
                                ),
                              ),
                            ),

                            // RECEPTOR
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: DropdownButtonFormField<RazonSocial>(
                                  initialValue: model.receptor,
                                  isExpanded: true,

                                  decoration: InputDecoration(
                                    labelText: 'Receptor',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                  ),

                                  hint: const Text(
                                    'Seleccione una razón social',
                                    overflow: TextOverflow.ellipsis,
                                  ),

                                  items: model.razonesSociales.map((receptor) {
                                    return DropdownMenuItem<RazonSocial>(
                                      value: receptor,
                                      child: Text(
                                        receptor.nombre,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }).toList(),

                                  onChanged: (value) {
                                    if (value != null) {
                                      model.receptor = value;
                                      model.safeNotifyListeners();
                                    }
                                  },
                                ),
                              ),
                            ),
                            SizedBox(width: 100,),
                            // FECHAS
                            // =====================================================
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  DateTime? fecha =
                                      await Helper.pickupDate(context);
                            
                                  if (fecha != null) {
                                    model.desde = fecha;
                                    model.safeNotifyListeners();
                                  }
                                },
                                child: Container(
                                  height: 50,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.calendar_today),
                                      const SizedBox(width: 8),
                            
                                      Expanded(
                                        child: Text(
                                          model.desde != null
                                              ? dateFormat.format(model.desde!)
                                              : 'DESDE',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            
                            const SizedBox(width: 10),
                            
                            // HASTA
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  DateTime? fecha =
                                      await Helper.pickupDate(context);
                            
                                  if (fecha != null) {
                                    model.hasta = fecha;
                                    model.safeNotifyListeners();
                                  }
                                },
                                child: Container(
                                  height: 50,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.calendar_today),
                                      const SizedBox(width: 8),
                            
                                      Expanded(
                                        child: Text(
                                          model.hasta != null
                                              ? dateFormat.format(model.hasta!)
                                              : 'HASTA',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                        // =====================================================
                        // ESTADO DE RECEPCIÓN
                        // =====================================================
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              'Estado recepción:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(width: 10),

                            SizedBox(
                              width: 250,
                              child: DropdownButtonFormField<EstadoRecepcion>(
                                initialValue: model.estadoSeleccionado,
                                isExpanded: true,
                              
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                              
                                hint: const Text(
                                  'Seleccione un estado',
                                ),
                              
                                items: EstadoRecepcion.values.map((estado) {
                                  return DropdownMenuItem<EstadoRecepcion>(
                                    value: estado,
                                    child: Text(
                                      estado.descripcion,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                              
                                onChanged: (value) async {
                                  if (value != null) {
                                    model.setEstado(value);
                                    await model.getCompras();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // =========================================================
                  // LISTA DE FACTURAS
                  // =========================================================
                  Expanded(
                    child: ListView.builder(
                      itemCount: model.facturas.length,
                      itemBuilder: (context, index) {
                        final factura = model.facturas[index];

                        final estado = factura.estadoRecepcion != null
                            ? EstadoRecepcion.desdeCodigo(
                                factura.estadoRecepcion!,
                              )
                            : null;

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: ListTile(

                            // =================================================
                            // TITULO
                            // =================================================
                            title: Row(
                              children: [

                                // EMISOR
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    'Emisor -> ${factura.emisorNombreComercial}',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),

                                const SizedBox(width: 10),

                                // CONSECUTIVO
                                Text(
                                  'CONSECUTIVO: ${factura.numeroConsecutivo}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                                IconButton(
                                    icon: const Icon(Icons.copy),
                                    onPressed: () {
                                      Clipboard.setData(
                                        ClipboardData(
                                          text: model.facturas[index].numeroConsecutivo ?? '',
                                        ),
                                      );

                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          duration: Duration(milliseconds: 200),
                                          content: Text('Copiado al portapapeles'),
                                        ),
                                      );
                                    },
                                  ),

                                const SizedBox(width: 10),

                                // FECHA
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    factura.fechaEmision != null
                                        ? 'FECHA: ${factura.fechaEmision!.day}/'
                                          '${factura.fechaEmision!.month}/'
                                          '${factura.fechaEmision!.year}'
                                        : 'Sin fecha',
                                    textAlign: TextAlign.right,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),

                            // =================================================
                            // SUBTITULO
                            // =================================================
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text(
                                  'Receptor -> ${factura.receptorNombreComercial}',
                                  overflow: TextOverflow.ellipsis,
                                ),

                                const SizedBox(height: 5),

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    // ESTADO
                                    Expanded(
                                      child: Text(
                                        'Estado : ${estado?.descripcion ?? ''}',
                                        style: TextStyle(
                                          color: estado?.color,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),

                                    // TOTALES
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [

                                        Text(
                                          'Moneda: ${factura.moneda}',
                                        ),

                                        Text(
                                          'Tipo cambio: ${factura.tipoCambio}',
                                        ),

                                        Text(
                                          'Sub total: '
                                          '${formatoMoneda.format(
                                            factura.totalVentaNeta ?? 0,
                                          )}',
                                        ),

                                        Text(
                                          'Total impuesto: '
                                          '${formatoMoneda.format(
                                            factura.totalImpuesto ?? 0,
                                          )}',
                                        ),

                                        Text(
                                          'Total comprobante: '
                                          '${formatoMoneda.format(
                                            factura.totalComprobante ?? 0,
                                          )}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // =========================================================
                  // TOTAL COMPRA
                  // =========================================================
                  TotalCompra(
                    model: model,
                  ),

                  Container(
                    color: Colors.black.withValues(
                      alpha: 0.30,
                    ),
                    child: Row(
                      children: [

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Número de registros: ${model.facturas.length}',
                          ),
                        ),

                        const Spacer(),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '🔄 Próxima actualización: '
                            '${model.tiempoRestante.inMinutes.toString().padLeft(2, '0')}:'
                            '${(model.tiempoRestante.inSeconds % 60).toString().padLeft(2, '0')}',
                          ),
                        ),
                      ],
                    ),
                  ),

                  // =========================================================
                  // LOADING
                  // =========================================================
                  Visibility(
                    visible: model.cargando,
                    child: const LinearProgressIndicator(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}