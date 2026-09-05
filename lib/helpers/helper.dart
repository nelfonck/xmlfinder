import 'package:flutter/material.dart';

class Helper {

  static Future<DateTime?>  pickupDate(BuildContext context)async{
    final fecha = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
    return fecha;
  } 
}
