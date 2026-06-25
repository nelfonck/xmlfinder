import 'package:comprassj/viewmodels/proveedorviewmodel.dart';
import 'package:flutter/material.dart';
import 'package:comprassj/helpers/mensajes.dart';
import 'package:comprassj/widgets/fondodegradado.dart';
import 'package:provider/provider.dart';

class NuevoProveedorView extends StatelessWidget {
  const NuevoProveedorView({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProveedorViewModel(),
      child: Consumer<ProveedorViewModel>(
        builder: ((context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Nuevo proveedor'),
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
                      if (model.tipoSeleccionado==null){
                        Mensajes.error(context, "Debe seleccionar un tipo de identificacion");
                        return;
                      }
                      await model.guardarProveedor();

                      if (context.mounted){
                        Mensajes.exito(context, 'Proveedor guardado correctamente');
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
                        flex: 2,
                        child: TextField(
                          onChanged: (value){
                            
                          },
                          controller: model.identificacionController,
                          focusNode: model.nombreFocusNode,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Identificacion'
                          ),
                        ),
                      ),
                      SizedBox(width: 20,),
                      Expanded(
                        flex: 1,
                        child: LayoutBuilder(
                          builder: ((context, constraints) {
                            return DropdownMenu<String>(
                              width: constraints.maxWidth,
                              label: const Text('Tipo de identificación'),
                              dropdownMenuEntries: model.tiposIdentificacion.entries
                                .map( 
                                  (entry) => DropdownMenuEntry<String>(
                                    value: entry.key,
                                    label: entry.value,
                                  )
                                ).toList(),
                              onSelected: (value) {
                                model.tipoSeleccionado = value;
                              },
                            );
                          }),
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
                    controller: model.nombreController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nombre'
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    onChanged: (value){
                      
                    },
                    controller: model.nombreComercialController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nombre comercial'
                    ),
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
                    controller: model.correoController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Correo'
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}