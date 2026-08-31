import 'package:comprassj/enums/estado_recepcion.dart';
import 'package:comprassj/viewmodels/comprasviewmodel.dart';
import 'package:comprassj/widgets/fondodegradado.dart';
import 'package:comprassj/widgets/modelready.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ComprasView extends StatelessWidget {
  const ComprasView({super.key});

  @override
  Widget build(BuildContext context) {
    final formatoMoneda = NumberFormat('#,##0.00', 'es_CR');
    
    return ChangeNotifierProvider(
      create: (_) => ComprasViewModel(),
      child: ModelReady<ComprasViewModel>(
        onModelReady: (ComprasViewModel model) async{
          await model.getCompras();
        },
        child: Consumer<ComprasViewModel>(
          builder: ((context, model, child) {
            return Scaffold(
                appBar: AppBar(
                title: Text('Compras'),
                flexibleSpace: FondoDegradado(),
                elevation: 0
              ),
              body: Expanded(
                child: Column(
                  children: [ 
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Estado recepcion: '),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButton<EstadoRecepcion>(
                            value: model.estadoSeleccionado,
                            hint: const Text('Seleccione un estado'),
                            items:EstadoRecepcion.values.map((estado){
                              return DropdownMenuItem<EstadoRecepcion>(
                                value: estado,
                                child:Text(' ${estado.name}'),
                              );
                            }).toList(), 
                            onChanged: (value){
                              if (value!=null){
                                model.setEstado(value);      
                              }
                            }
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: model.facturas.length,
                        itemBuilder: ((context, index) {
                          return Card(
                            child: ListTile(
                              title: Row(
                                children: [
                                  // COLUMNA 2 - PROVEEDOR
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      'Emisor -> ${model.facturas[index].emisorNombreComercial}',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),

                                  // COLUMNA 1 - CONSECUTIVO
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'CONSECUTIVO: ${model.facturas[index].numeroConsecutivo}',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),

                                  // COLUMNA 3 - FECHA  
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      model.facturas[index].fechaEmision != null
                                          ? 'FECHA: ${model.facturas[index].fechaEmision!.day}/'
                                            '${model.facturas[index].fechaEmision!.month}/'
                                            '${model.facturas[index].fechaEmision!.year}'
                                          : 'Sin fecha',
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Receptor -> ${model.facturas[index].receptorNombreComercial}',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Row(
                                    children: [
                                      Spacer(),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text("Moneda: ${model.facturas[index].moneda}"),
                                          Text("Tipo cambio: ${model.facturas[index].tipoCambio}"),
                                          Text("Sub total: ${formatoMoneda.format(model.facturas[index].totalVentaNeta ?? 0)}"),
                                          Text("Total impuesto: ${formatoMoneda.format(model.facturas[index].totalImpuesto ?? 0) }"),
                                          Text("Total comprobante: ${formatoMoneda.format(model.facturas[index].totalComprobante ?? 0)}"),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        })
                      )
                    )
                  ],
                )
              )
            );
          })
        ) 
      ) 
    );
  }
}