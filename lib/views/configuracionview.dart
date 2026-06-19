import 'package:comprassj/viewmodels/configuracionviewmodel.dart';
import 'package:comprassj/widgets/fondodegradado.dart';
import 'package:comprassj/widgets/modelready.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfiguracionView extends StatelessWidget {
  const ConfiguracionView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ConfiguracionViewModel(),
      child: ModelReady<ConfiguracionViewModel>(
        onModelReady: (model) async{
          model.init();
        },
        child: Consumer<ConfiguracionViewModel>(
          builder: (context, model, child) {
            return Scaffold(
              appBar: AppBar(
                flexibleSpace: FondoDegradado(),
                title: const Text('Configuracion'),
                actions: [
                  IconButton(
                    onPressed: (){
                      model.guardarParametros();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Parametros guardados!'),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 1),
                        ),
                      );
                    }, 
                    icon: Icon(Icons.save)
                  )
                ],
              ),
              body: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(top: 50),
                  width: 300,
                  height: 300,
                  child: Column(
                    children: [
                      TextField(
                        onChanged: (value){
                          
                        },
                        controller: model.txtHostController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Host',
                          labelText: 'Host'
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextField(
                        onChanged: (value){
                          
                        },
                        controller: model.txtPortController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Port',
                          labelText: 'Port'
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextField(
                        onChanged: (value){
                          
                        },
                        controller: model.txtCantidadCorreosController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Cantidad de correos',
                          labelText: 'Cantidad de correos'
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextField(
                        onChanged: (value){
                          
                        },
                        controller: model.txtDirectoryXml,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          //hintText: 'Directorio de facturas xml',
                          labelText: 'Directorio de facturas xml',
                          suffixIcon: IconButton(
                            onPressed: ()async{
                              await model.pickFolder();
                            }, 
                            icon: Icon(Icons.folder)
                          )
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}