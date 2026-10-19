import 'package:comprassj/helpers/helper.dart';
import 'package:comprassj/helpers/mensajes.dart';
import 'package:comprassj/helpers/reporteventaspdf.dart';
import 'package:comprassj/models/razonsocial.dart';
import 'package:comprassj/viewmodels/ventasviewmodel.dart';
import 'package:comprassj/widgets/fondodegradado.dart';
import 'package:comprassj/widgets/guiacolumna.dart';
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
            if (Helper.configuracionLista()){
              await model.getRazonesSociales();
            }
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
                      if (model.isLoading) return;

                      if (model.ventas.isEmpty) {
                        Mensajes.error(
                          context,
                          'No hay ventas para generar el reporte',
                        );
                        return;
                      }

                      try {
                        final bytes = await crearReporteVentas(model);
                        abrirPdf(bytes);
                      } catch (e) {
                        if (context.mounted){
                          Mensajes.error(context, e.toString());
                        }
                      }
                    }, 
                    icon: Icon(Icons.print)
                  ),
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
                padding: const EdgeInsets.only(top: 8, left: 4, right: 4),
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
                                  await Helper.pickupDesdeDate(context,model.desde);
                        
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
                                  await Helper.pickupHastaDate(context, model.hasta);
                        
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
                          child: totalVenta(title: 'Colones', total: model.colones, symbol: 'c')
                        ),
                        Expanded(
                          flex: 1,
                          child: totalVenta(title: 'Dolares', total: model.dolares, symbol: 'd')
                        ),
                        Expanded(
                          flex: 1,
                          child: totalVenta(title: 'IVA', total: model.iva, symbol: 'c')
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
                          child: totalVenta(title: 'Tarjeta', total: model.tarjeta, symbol: 'c')
                        ),
                        Expanded(
                          flex: 1,
                          child: totalVenta(title: 'Sinpe Movil', total: model.sinpe, symbol: 'c')
                        ),
                        Expanded(
                          flex: 1,
                          child: totalVenta(title: 'Abonos', total: model.abonos, symbol: 'c')
                        ),
                        Expanded(
                          flex: 1,
                          child: totalVenta(title: 'NC', total: 0-model.notasCredito, symbol: 'c')
                        ),
                        Expanded(
                          flex: 1,
                          child: totalVenta(title: 'Facturado', total: model.facturado, symbol: 'c')
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Encabezado(),
                    model.isLoading ? 
                    LoadingWidget() :
                    Expanded(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                        IgnorePointer(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              guiaColumna(flex: 3), // Comercio
                              guiaColumna(),        // Colones
                              guiaColumna(),        // Dólares
                              guiaColumna(),        // IVA
                              guiaColumna(),        // Descuento
                              guiaColumna(),        // Crédito
                              guiaColumna(),        // Tarjeta
                              guiaColumna(),        // Sinpe Móvil
                              guiaColumna(),        // Abonos
                              guiaColumna(),        // NC
                              guiaColumna(),        // Facturado
                            ],
                          ),
                         ),
                         ListView.builder(
                          itemCount: model.ventas.length,
                          itemBuilder: (context, index) {
                            final venta = model.ventas[index];
                        
                            final colorFila = index == model.filaSeleccionada
                            ? const Color.fromARGB(255, 0, 165, 55)
                            : index.isEven
                            ? const Color.fromARGB(255, 90, 90, 90)
                            : Colors.grey.shade700;
                        
                            Widget monto(double valor) {
                              return Expanded(
                                flex: 1,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                  decoration: BoxDecoration(
                                    border: Border(right: BorderSide(color: Colors.grey))
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      formatoMoneda.format(valor),
                                    ),
                                  ),
                                ),
                              );
                            }
                        
                            return InkWell(
                              onTap: (){
                                model.setFilaSeleccionada(model.filaSeleccionada == index ? -1 : index);
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 1),
                                color: colorFila,
                                child: IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border(right: BorderSide(color: Colors.grey))
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 8,
                                              right: 6,
                                              top: 4,
                                              bottom: 4,
                                            ),
                                            child: Text(
                                              '${venta.compania?.razonComercial ?? ''}\n'
                                              '${venta.compania?.razonSocial ?? ''}',
                                            ),
                                          ),
                                        ),
                                      ),
                                                                
                                      monto(venta.colones ?? 0),
                                      monto(venta.dolares ?? 0),
                                      monto(venta.iva ?? 0),
                                      monto(venta.descuento ?? 0),
                                      monto(venta.credito ?? 0),
                                      monto(venta.tarjeta ?? 0),
                                      monto(venta.sinpe ?? 0),
                                      monto(venta.abonos ?? 0),
                                      monto(0-(venta.notasCredito ?? 0)),
                                      monto(venta.facturado ?? 0),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        ],
                      ),
                    ),
                    Visibility(visible: model.isLoading, child: LinearProgressIndicator()),
                    Divider(color: Colors.grey,height: 1,),
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
  const Encabezado({super.key});

  Widget titulo(String texto) {
    return Expanded(
      flex: 1,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: const BoxDecoration(
          border: Border(
            right: BorderSide(color: Colors.grey),
          ),
        ),
        child: Text(
          texto,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 100, 150, 255),
            Color.fromARGB(255, 46, 100, 235),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(8),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                ),
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(color: Colors.grey),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text(
                    'Comercio',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            titulo('Colones'),
            titulo('Dolares'),
            titulo('IVA'),
            titulo('Descuento'),
            titulo('Credito'),
            titulo('Tarjeta'),
            titulo('Sinpe Movil'),
            titulo('Abonos'),
            titulo('NC'),
            titulo('Facturado'),
          ],
        ),
      ),
    );
  }
}


class GranTotal extends StatelessWidget {
  const GranTotal({
    super.key,
    required this.model,
  });

  final Ventasviewmodel model;

Widget monto(double valor) {
  return Expanded(
    flex: 1,
    child: Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.grey),
        ),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerRight,
        child: Text(
          Helper.formatoMoneda(valor),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.grey))
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  'Gran total',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      
          monto(model.colones),
          monto(model.dolares),
          monto(model.iva),
          monto(model.descuento),
          monto(model.credito),
          monto(model.tarjeta),
          monto(model.sinpe),
          monto(model.abonos),
          monto(0-model.notasCredito),
          monto(model.facturado),
        ],
      ),
    );
  }
}