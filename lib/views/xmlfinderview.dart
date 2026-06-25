import 'package:comprassj/helpers/mensajes.dart';
import 'package:comprassj/viewmodels/xmlfinderviewmodel.dart';
import 'package:comprassj/widgets/fondodegradado.dart';
import 'package:comprassj/widgets/menubutton.dart';
import 'package:comprassj/widgets/modelready.dart';
import 'package:comprassj/widgets/popmenubutton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class XmlFinderView extends StatefulWidget {
  const XmlFinderView({super.key});

  @override
  State<XmlFinderView> createState() => _XmlFinderViewState();
}

class _XmlFinderViewState extends State<XmlFinderView> {

  @override
  Widget build(BuildContext context) {
    TextEditingController txtController = TextEditingController();
    // Razones Sociales
    const Color colorRazonSocial = Colors.lightBlueAccent;
    // Tiendas
    const Color colorTienda = Colors.blue;

    return ChangeNotifierProvider(
      create: (_) => Xmlfinderviewmodel(),
      child: ModelReady<Xmlfinderviewmodel>(
        onModelReady: (model)async{
   
          if (!model.configuracionLista()){
            Navigator.of(context).pushNamed('configuracion');
            return;
          }
          await model.cargarTiendas().onError(((error, stackTrace) {
            Mensajes.error(context, error.toString());
          }));
          await model.cargarRazonesSociales().onError(((error, stackTrace) {
            Mensajes.error(context, error.toString());
          }));
        },
        child: Consumer<Xmlfinderviewmodel>(
        builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            flexibleSpace: FondoDegradado(),
            title: const Text('Descargas de facturas xml'),
            elevation: 0,
            actions: [
              menuButton(
                icon: Icons.business, 
                text: 'Razones Sociales', 
                onPressed: () {
                  Navigator.pushNamed(context, 'razon_social');
                },
              ),
              menuButton(
                icon: Icons.store, 
                text: 'Tiendas', 
                onPressed: () {
                  Navigator.pushNamed(context, 'nueva_tienda');
                },
              ),
              menuButton(
                icon: Icons.local_shipping, 
                text: 'Proveedores', 
                onPressed: () {
                  Navigator.pushNamed(context, 'nuevo_proveedor');
                },
              ),
              menuButton(
                icon: Icons.file_download, 
                text: 'Descargas xml', 
                onPressed: () {
  
                },
              ),
              reportesButton(
                onProveedor: (){},
                onPuntoVenta: (){},
                onRazonSocial: (){}
              ),
              menuButton(
                icon: Icons.settings,
                text: 'Configuracion',
                onPressed: () {
                  Navigator.pushNamed(context, 'configuracion');
                },
              ),
            ],
          ),
          body: Column(
            children: [
              SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: model.razonesSociales.length,
                  itemBuilder: (context, index){
                    final seleccionada = model.razonSocialSeleccionada == index;
                    return GestureDetector(
                      onTap: () async{
                        if (model.razonSocialSeleccionada != index){
                          try {
                            model.seleccionarRazonSocial(index);
                            await model.conectar(model.razonesSociales[index].correo, model.razonesSociales[index].claveCorreo);
                            await model.cargarFacturas();
                          } catch (e) {
                            if (context.mounted){
                              Mensajes.error(context,e.toString().replaceFirst('Exception: ', ''));
                            }
                          }
                        }
                      },
                      child: Container(
                        width: 100,
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: seleccionada ? colorRazonSocial : Colors.transparent,
                          border: Border.all(
                            color: seleccionada ? Colors.transparent : colorRazonSocial,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            model.razonesSociales[index].nombre,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: seleccionada ? Colors.white : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: model.tiendas.length,
                        itemBuilder: (context, index){
                          final seleccionada = model.tiendaSeleccionada == index;
                          return GestureDetector(
                            onTap: () {
                              model.seleccionarTienda(index);
                            },
                            child: Container(
                              width: 100,
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: seleccionada ? colorTienda : Colors.transparent,
                                border: Border.all(
                                  color: seleccionada ? Colors.transparent : colorTienda,
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  model.tiendas[index].nombre,
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: seleccionada ? Colors.white : Colors.white ,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      ),
                    ),
                  ),
                  SizedBox(
                      width: 300,
                      child: TextField(
                        onChanged: (value){
                          model.encontrarFacturas(value);
                        },
                        controller: txtController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          hintText: 'Numero de facura'
                        ),
                      ),
                    ),
                    SizedBox(width: 10,)
                ],
              ),
              Divider(height: 1,color: Colors.white,),
              Expanded(
                child:  model.correosBusqueda.isEmpty ?
                Center(
                  child: const Text('No hay datos para mostrar'),
                ):
                ListView.builder(
                  itemCount: model.correosBusqueda.length,
                  itemBuilder: (context, index) {
                    final correo = model.correosBusqueda[index];
                
                    return Card(
                      child: ListTile(
                        title: Text(correo.asunto),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(correo.remitente ?? ''),
                            Text(correo.fecha?.toString() ?? ''),
                            Text(correo.fileNames!.join(', ')),
                          ],
                        ),
                        onTap: () {
                        },
                        trailing: IconButton(
                          onPressed: ()async{
                            try {
                              if(model.tiendaSeleccionada==null){
                                if (context.mounted){
                                  Mensajes.error(context,'Debe seleccionar una tienda');
                                  return;
                              }
                              }
                              await model.descargarAdjuntos(model.correosBusqueda[index]);
                              if(context.mounted){
                                Mensajes.exito(context, 'Factura descargada!!');
                              }
                            } catch (e) {
                              if (context.mounted){
                                //print(e.toString().replaceFirst('Exception: ', ''));
                                Mensajes.error(context,e.toString().replaceFirst('Exception: ', ''));
                              }
                            }
                          }, 
                          icon: const Icon(Icons.download),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 5,),
              !model.obteniendoMensajes ? Container() : LinearProgressIndicator(),
            ],
          ),
        ),
      ),
      )
      
    );
  }
}