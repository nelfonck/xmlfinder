import 'package:comprassj/viewmodels/configuracionviewmodel.dart';
import 'package:comprassj/widgets/fondodegradado.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfiguracionView extends StatelessWidget {
  const ConfiguracionView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ConfiguracionViewModel()
      ..init(),
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
                height: 200,
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
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}