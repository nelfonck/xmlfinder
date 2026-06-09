import 'package:comprassj/viewmodels/xmlfinderviewmodel.dart';
import 'package:comprassj/widgets/menubutton.dart';
import 'package:comprassj/widgets/popmenubutton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class XmlFinderView extends StatelessWidget {
  const XmlFinderView({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController txtController = TextEditingController(text: '40500249010000048907');

    return ChangeNotifierProvider(
      create: (_) => Xmlfinderviewmodel(),
      child: Consumer<Xmlfinderviewmodel>(
        builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            title: const Text('Descargas de facturas xml'),
            elevation: 0,
            actions: [
              menuButton(
                icon: Icons.business, 
                text: 'Razones Sociales', 
                onPressed: () {},
              ),
              menuButton(
                icon: Icons.store, 
                text: 'Tiendas', 
                onPressed: () {},
              ),
              menuButton(
                icon: Icons.local_shipping, 
                text: 'Proveedores', 
                onPressed: () {},
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
                onPressed: () {},
              ),
            ],
          ),
          body: Column(
            children: [
              TextButton(
                onPressed: () async {
                  await model.conectar();
                }, 
                child: const Text('Conectar')
              ),
              TextButton(
                onPressed: () async {
                  await model.cargarFacturas();
                }, 
                child: const Text('Cargar facturas')
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  onChanged: (value){
                    model.encontrarFacturas(value);
                  },
                  controller: txtController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Numero de facura'
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                   model.encontrarFacturas(txtController.text);
                }, 
                child: const Text('Encontrar factura')
              ),
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
                            await model.descargarAdjuntos(model.correos[index]);
                          }, 
                          icon: const Icon(Icons.download),
                        ),
                      ),
                    );
                  },
                ),
              ),
              !model.obteniendoMensajes ? Container() : LinearProgressIndicator()
            ],
          ),
        ),
      ),
    );
  }
}