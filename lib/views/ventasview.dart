import 'package:comprassj/helpers/helper.dart';
import 'package:comprassj/helpers/mensajes.dart';
import 'package:comprassj/models/tienda.dart';
import 'package:comprassj/viewmodels/ventasviewmodel.dart';
import 'package:comprassj/widgets/fondodegradado.dart';
import 'package:comprassj/widgets/modelready.dart';
import 'package:comprassj/widgets/totalventa.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class VentasView extends StatelessWidget {
  const VentasView({super.key});

  @override
  Widget build(BuildContext context) {
    final formatoMoneda = NumberFormat('#,##0.00', 'es_CR');
    final dateFormat = DateFormat('dd/MM/yyyy');
    
    return ChangeNotifierProvider(
      create: (_) => Ventasviewmodel(),
      child: ModelReady<Ventasviewmodel>(
        onModelReady: (Ventasviewmodel model) async{
          try {
            await model.getTiendas();
            model.precargarData();
          } catch (e) {
            if (context.mounted){
              Mensajes.error(context, e.toString());
            }
          }
        },
        child: Consumer<Ventasviewmodel>(
          builder: (context,model,child) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Ventas'),
                flexibleSpace: FondoDegradado(),
                elevation: 0,
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField<Tienda>(
                            decoration: InputDecoration(
                              labelText: 'Local',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                                          
                            hint: const Text(
                              'Seleccione un local',
                              overflow: TextOverflow.ellipsis,
                            ),
                            items: model.tiendas.map((tienda) {
                              return DropdownMenuItem<Tienda>(
                                value: tienda,
                                child: Text(
                                  tienda.nombre,
                                  overflow: TextOverflow.ellipsis,
                                )
                              );
                            }).toList(), 
                            onChanged: (value){
                              
                            }
                          ),
                        ),
                        SizedBox(width: 5,),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () async {
                              DateTime? fecha =
                                  await Helper.pickupDesdeDate(context);
                        
                              if (fecha != null) {
                                model.desde = fecha;
                                model.safeNotifyListeners();
                                try {
                                  //model.getCompras();
                                } catch (e) {
                                  if (context.mounted){
                                    Mensajes.error(context, e.toString());
                                  }
                                }
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
                        SizedBox(width: 5,),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () async {
                              DateTime? fecha =
                                  await Helper.pickupHastaDate(context);
                        
                              if (fecha != null) {
                                model.hasta = fecha;
                                model.safeNotifyListeners();
                                try {
                                  //await model.getCompras();
                                } catch (e) {
                                  if (context.mounted){
                                    Mensajes.error(context, e.toString());
                                  }
                                }
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
                    SizedBox(height: 25,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: totalVenta(title: 'Total facturado', total: 47242384, symbol: 'c')
                        ),
                        Expanded(
                          flex: 1,
                          child: totalVenta(title: 'IVA', total: 616512, symbol: 'c')
                        ),
                        Expanded(
                          flex: 1,
                          child: totalVenta(title: 'Colones', total: 4177997, symbol: 'c')
                        ),
                        Expanded(
                          flex: 1,
                          child: totalVenta(title: 'Dolares', total: 1120, symbol: 'd')
                        ),
                        Expanded(
                          flex: 1,
                          child: totalVenta(title: 'Descuento', total: 68062, symbol: 'c')
                        ),
                        Expanded(
                          flex: 1,
                          child: totalVenta(title: 'Credito', total: 394787, symbol: 'c')
                        ),
                        Expanded(
                          flex: 1,
                          child: totalVenta(title: 'Sinpe Movil', total: 35564, symbol: 'c')
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Encabezado(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: model.ventas.length,
                        itemBuilder: (context,index){

                        final colorFila = index.isEven
                            ? const Color.fromARGB(255, 90, 90, 90)
                            : Colors.grey.shade700 ;

                          return Container(
                            color: colorFila,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(model.ventas[index].comercio),
                                  )
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(formatoMoneda.format(model.ventas[index].facturado)),
                                  )
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(formatoMoneda.format(model.ventas[index].iva)),
                                  )
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(formatoMoneda.format(model.ventas[index].colones)),
                                  )
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(formatoMoneda.format(model.ventas[index].dolares)),
                                  )
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(formatoMoneda.format(model.ventas[index].descuento)),
                                  )
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(formatoMoneda.format(model.ventas[index].credito)),
                                  )
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(formatoMoneda.format(model.ventas[index].sinpe)),
                                  )
                                ),
                              ],
                            ),
                          );
                        }
                      )
                    ),
                  ],
                ),
              ),
            );
          }
        ), 
      ),
    );
  }
}

class Encabezado extends StatelessWidget {
  const Encabezado({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: const Color.fromARGB(255, 46, 100, 235),
      child: const Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                'Comercio',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Facturado',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'IVA',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Colones',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Dolares',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Descuento',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Credito',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Sinpe Movil',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}