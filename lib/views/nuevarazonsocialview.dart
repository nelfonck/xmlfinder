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
                  onPressed: (){}, 
                  icon: Icon(Icons.save)
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      Text(model.activo ? 'Activo' : 'Inactivo'),
                      Switch(
                        value: model.activo, 
                        onChanged: ((value) {
                          model.setActivo(value);
                        }
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (value){
                            
                          },
                          controller: model.identificacionController,
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
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}