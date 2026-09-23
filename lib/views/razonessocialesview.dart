import 'package:comprassj/helpers/mensajes.dart';
import 'package:comprassj/viewmodels/razonessocialesviewmodel.dart';
import 'package:comprassj/views/nuevarazonsocialview.dart';
import 'package:comprassj/widgets/fondodegradado.dart';
import 'package:comprassj/widgets/menubutton.dart';
import 'package:comprassj/widgets/modelready.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RazonesSocialesView extends StatelessWidget {
  const RazonesSocialesView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RazonSocialViewModel(),
      child: ModelReady<RazonSocialViewModel>(
        onModelReady: (RazonSocialViewModel model) async{
          try {
            await model.init();
          } catch (e) {
            if (context.mounted){
              Mensajes.error(context, e.toString());
            }
          }
        },
        child: Consumer<RazonSocialViewModel>(
          builder: ((context, model, child) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Razones sociales'),
                elevation: 0,
                flexibleSpace: FondoDegradado(),
                actions: [
                  menuButton(
                    icon:  Icons.add_business, 
                    text: 'Nueva', 
                    onPressed: ()async {
                      final result = await Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (_) => NuevaRazonSocialView()
                        )
                      );
                      if (result!=null){
                        try {
                          model.getRazonesSociales();
                        } catch (e) {
                          if (context.mounted){
                            Mensajes.error(context, e.toString());
                          }
                        }
                      }
                    }
                  )
                ],
              ),
              body: SafeArea(
                child: ListView.builder(
                  itemCount: model.razonesSociales.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: ()async{
                        final result = await Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (_) => NuevaRazonSocialView(modificar: true, razonSocial: model.razonesSociales[index],)
                          )
                        );
                        if (result!=null){
                          try {
                            if (result){
                              model.getRazonesSociales();
                              if (context.mounted){
                                Mensajes.exito(context, 'Razon social modificada correctamente!!');
                              }
                            }
                          } catch (e) {
                            if (context.mounted){
                              Mensajes.error(context, e.toString());
                            }
                          }
                        }
                      },
                      child: Card(
                        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: ListTile(
                          title: Text(model.razonesSociales[index].nombre),
                          subtitle: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(model.razonesSociales[index].nombreComercial)
                              ),
                              Expanded(
                                flex: 1,
                                child: Text('Correo: ${model.razonesSociales[index].correo}')
                              ),
                              Expanded(
                                flex: 1,
                                child: Text('Cedula: ${model.razonesSociales[index].identificacion}')
                              ),
                              Expanded(
                                flex: 1,
                                child: Text('Telefono: ${model.razonesSociales[index].telefono}')
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                )
              ),
            );
          })
        ), 
      ),
    );
    
  }
}