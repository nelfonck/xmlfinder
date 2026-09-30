import 'package:comprassj/helpers/helper.dart';
import 'package:comprassj/helpers/mensajes.dart';
import 'package:comprassj/models/razonsocial.dart';
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
    final formatoMoneda = NumberFormat('#,##0.##', 'es_CR');
    final dateFormat = DateFormat('dd/MM/yyyy');
    
    return ChangeNotifierProvider(
      create: (_) => Ventasviewmodel(),
      child: ModelReady<Ventasviewmodel>(
        onModelReady: (Ventasviewmodel model) async{
          try {
            await model.getRazonesSociales();
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
                actions: [
                  IconButton(
                    onPressed: ()async{
                      try {
                        await model.getVentas();
                      } catch (e) {
                        if (context.mounted){
                          model.isLoading = false;
                          model.safeNotifyListeners();
                          Mensajes.error(context, e.toString());
                        }
                      }
                    }, 
                    icon: Icon(Icons.refresh)
                  )
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: DropdownButtonFormField<RazonSocial>(
                            decoration: InputDecoration(
                              labelText: 'Razon social',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                                          
                            hint: const Text(
                              'Seleccione una razon social',
                              overflow: TextOverflow.ellipsis,
                            ),
                            initialValue: model.selectedRs,
                            items: model.rs.map((tienda) {
                              return DropdownMenuItem<RazonSocial>(
                                value: tienda,
                                child: Text(
                                  tienda.nombre,
                                  overflow: TextOverflow.ellipsis,
                                )
                              );
                            }).toList(), 
                            onChanged: (value){
                              model.selectedRs = value;
                            }
                          ),
                        ),
                        SizedBox(width: 5,),
                        Expanded(
                          flex: 3,
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
                          flex: 3,
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
                        SizedBox(width: 10,),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            onPressed: ()async{
                              try {
                                await model.getVentas();
                              } catch (e) {
                                if (context.mounted){
                                  model.isLoading = false;
                                  model.safeNotifyListeners();
                                  Mensajes.error(context, e.toString());
                                }
                              }
                            }, 
                            icon: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Icon(Icons.search),
                            ),
                            style: IconButton.styleFrom(
                            side: const BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),),
                            
                          )
                        )
                      ],
                    ),
                    SizedBox(height: 25,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: totalVenta(title: 'Total facturado', total: model.facturado, symbol: 'c')
                        ),
                        Expanded(
                          flex: 1,
                          child: totalVenta(title: 'IVA', total: model.iva, symbol: 'c')
                        ),
                        Expanded(
                          flex: 1,
                          child: totalVenta(title: 'Colones', total: model.colones, symbol: 'c')
                        ),
                        Expanded(
                          flex: 1,
                          child: totalVenta(title: 'Dolares', total: model.dolares, symbol: 'd')
                        ),
                        Expanded(
                          flex: 1,
                          child: totalVenta(title: 'Descuento', total: model.descuento, symbol: 'c')
                        ),
                        Expanded(
                          flex: 1,
                          child: totalVenta(title: 'Credito', total: model.credito, symbol: 'c')
                        ),
                        Expanded(
                          flex: 1,
                          child: totalVenta(title: 'Sinpe Movil', total: model.sinpe, symbol: 'c')
                        ),
                        Expanded(
                          flex: 1,
                          child: totalVenta(title: 'NC', total: model.notasCredito, symbol: 'c')
                        ),
                        Expanded(
                          flex: 1,
                          child: totalVenta(title: 'Abonos', total: model.abonos, symbol: 'c')
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Encabezado(),
                    model.isLoading ? 
                    LoadingWidget() :
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
                                    child: Text('${model.ventas[index].compania?.razonComercial ?? ''} \n${model.ventas[index].compania?.razonSocial ?? ''}' ),
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
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(formatoMoneda.format(model.ventas[index].notasCredito)),
                                  )
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(formatoMoneda.format(model.ventas[index].abonos)),
                                  )
                                ),
                              ],
                            ),
                          );
                        }
                      ),
                    ),
                    Visibility(visible: model.isLoading, child: LinearProgressIndicator()),
                    Divider(),
                    GranTotal(model: model,)
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

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 15,),
          Text('Obteniendo datos...')
        ],
      )
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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 100, 150, 255),
            Color.fromARGB(255, 46, 100, 235),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
      ),
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
          Expanded(
            flex: 1,
            child: Text(
              'NC',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Abonos',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
class GranTotal extends StatelessWidget {
  const GranTotal({
    super.key,
    required this.model
  });

  final Ventasviewmodel model;

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Padding(
            padding: EdgeInsets.only(left: 8),
            child: Text(
              'Gran total',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            Helper.formatoMoneda(model.facturado),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            Helper.formatoMoneda(model.iva),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            Helper.formatoMoneda(model.colones),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            Helper.formatoMoneda(model.dolares),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            Helper.formatoMoneda(model.descuento),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            Helper.formatoMoneda(model.credito),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            Helper.formatoMoneda(model.sinpe),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            Helper.formatoMoneda(model.notasCredito),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            Helper.formatoMoneda(model.abonos),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}