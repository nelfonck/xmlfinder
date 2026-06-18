import 'package:comprassj/helpers/mensajes.dart';
import 'package:comprassj/viewmodels/razonsocialviewmodel.dart';
import 'package:comprassj/widgets/fondodegradado.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NuevaRazonSocialView extends StatelessWidget {
  const NuevaRazonSocialView({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NuevaRazonSocialViewModel(),
      child: Consumer<NuevaRazonSocialViewModel>(
        builder: ((context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Nueva razon social'),
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

                      await model.guardarRazonSocial();

                      if (context.mounted){
                        Mensajes.exito(context, 'Razón social guardada correctamente');
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
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (value){
                            
                          },
                          controller: model.identificacionController,
                          focusNode: model.identificacionFocusNode,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Identificacion'
                          ),
                        ),
                      ),
                      SizedBox(width: 20,),
                      DropdownMenu<String>(
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
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    onChanged: (value){
                      
                    },
                    controller: model.razonSocialController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Razon social'
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
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          onChanged: (value){
                            
                          },
                          controller: model.correoController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Correo'
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 1,
                        child: TextField(
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
                        ),
                      ),
                    ],
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