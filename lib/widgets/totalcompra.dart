import 'package:comprassj/viewmodels/comprasviewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TotalCompra extends StatelessWidget {
  const TotalCompra({super.key, required this.model});
  final ComprasViewModel model;

  @override
  Widget build(BuildContext context) {
    final formatoMoneda = NumberFormat('#,##0.00', 'es_CR');

    return Container(
      //margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        //color: Color(0xFF34373D),
        //borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.30),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

          _iconoTotal(
            Icons.shopping_cart_outlined,
          ),
                
          const SizedBox(width: 15),
                
          Text(
            'Sub total: ',
            style: TextStyle(
              color: Color(0xFFB9BBC2),
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
          ),
                
          Text(
            formatoMoneda.format(model.subTotal) ,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
                    
          const SizedBox(width: 50),
                    
          // TOTAL IMPUESTO
          _iconoTotal(
            Icons.description_outlined,
          ),
                
          const SizedBox(width: 15),
                
          Text(
            'Total impuesto: ',
            style: TextStyle(
              color: Color(0xFFB9BBC2),
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            formatoMoneda.format(model.totalImpuesto),
            textAlign: TextAlign.end,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 50),   
                          
          // TOTAL COMPROBANTE
          _iconoTotal(
            Icons.account_balance_wallet_outlined,
          ),
                
          const SizedBox(width: 15),
                
          Text(
            'Total: ',
            style: TextStyle(
              color: Color(0xFFB9BBC2),
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
          ),
                
          Text(
            formatoMoneda.format(model.total),
            textAlign: TextAlign.end,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),

          // =========================================================
          // LINEA VERTICAL
          // =========================================================

        ],
      ),
    );
  }
}

Widget _iconoTotal(IconData icono) {
  return Container(
    width: 32,
    height: 32,
    decoration: BoxDecoration(
      color: const Color(0xFF303641),
      shape: BoxShape.circle,
    ),
    child: Icon(
      icono,
      color: const Color(0xFF55A9FF),
      size: 24,
    ),
  );
}