import 'package:comprassj/viewmodels/tiendaviewmodel.dart';
import 'package:flutter/material.dart';
import 'package:comprassj/helpers/mensajes.dart';
import 'package:comprassj/widgets/fondodegradado.dart';
import 'package:provider/provider.dart';

class NuevaTiendaView extends StatelessWidget {
  const NuevaTiendaView({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TiendaViewModel(),
      child: Consumer<TiendaViewModel>(
        builder: ((context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Nuevo punto de venta'),
              flexibleSpace: FondoDegradado(),
              actions: [
                IconButton(
                  onPressed: (){
                    model.clearControllers();
                  }, 
                  icon: Icon(Icons.cleaning_services_outlined)
                ),
                SizedBox(width: 15,),
                IconButton(
                  onPressed: ()async{
                    try {

                      await model.guardarTienda();

                      if (context.mounted){
                        Mensajes.exito(context, 'Tienda guardada correctamente');
                      }

                    } catch (e) {

                      if (context.mounted){
                        Mensajes.error(context,e.toString().replaceFirst('Exception: ', ''));
                      }
    
                    }
                  }, 
                  icon: Icon(Icons.save)
                ),
                SizedBox(width: 5,),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(height: 30,),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (value){
                            
                          },
                          controller: model.nombreController,
                          focusNode: model.nombreFocusNode,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Nombre'
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    onChanged: (value){
                      
                    },
                    controller: model.telefonoController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Telefono'
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    onChanged: (value){
                      
                    },
                    controller: model.direccionController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Direccion'
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    onChanged: (value){
                      
                    },
                    controller: model.correoController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Correo'
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: model.claveCorreoController,
                    obscureText: !model.mostrandoClave,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Clave correo',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: GestureDetector(
                        onTapDown: (_) {
                          model.mostrarClave(true);
                        },
                        onTapUp: (_) {
                          model.mostrarClave(false);
                        },
                        onTapCancel: () {
                          model.mostrarClave(false);
                        },
                        child: const Icon(Icons.visibility),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}