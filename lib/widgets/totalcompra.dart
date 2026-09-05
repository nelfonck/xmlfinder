import 'package:flutter/material.dart';

class TotalCompra extends StatelessWidget {
  const TotalCompra({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1F232C),
        borderRadius: BorderRadius.circular(16),
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
        children: [

          // =========================================================
          // INFORMACIÓN DE LA IZQUIERDA
          // =========================================================

          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                // SUB TOTAL
                Row(
                  children: [
                    _iconoTotal(
                      Icons.shopping_cart_outlined,
                    ),

                    const SizedBox(width: 15),

                    const Expanded(
                      child: Text(
                        'Sub total:',
                        style: TextStyle(
                          color: Color(0xFFB9BBC2),
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const Text(
                      '₡44.635,00',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // TOTAL IMPUESTO
                Row(
                  children: [
                    _iconoTotal(
                      Icons.description_outlined,
                    ),

                    const SizedBox(width: 15),

                    const Expanded(
                      child: Text(
                        'Total impuesto:',
                        style: TextStyle(
                          color: Color(0xFFB9BBC2),
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const Text(
                      '₡2.826,58',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // TOTAL COMPROBANTE
                Row(
                  children: [
                    _iconoTotal(
                      Icons.account_balance_wallet_outlined,
                    ),

                    const SizedBox(width: 15),

                    const Expanded(
                      child: Text(
                        'Total comprobante:',
                        style: TextStyle(
                          color: Color(0xFFB9BBC2),
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const Text(
                      '₡44.635,00',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // =========================================================
          // LINEA VERTICAL
          // =========================================================

          Container(
            width: 2,
            height: 155,
            margin: const EdgeInsets.symmetric(
              horizontal: 22,
            ),
            color: const Color(0xFF4DA3FF),
          ),

          // =========================================================
          // TOTAL A PAGAR
          // =========================================================

          Container(
            width: 315,
            padding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 15,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF182A43),
              borderRadius: BorderRadius.circular(17),
              border: Border.all(
                color: const Color(0xFF25466F),
              ),
            ),
            child: Column(
              children: [

                const Text(
                  'TOTAL A PAGAR',
                  style: TextStyle(
                    color: Color(0xFF4DA3FF),
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    const Text(
                      '₡44.635,00',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(width: 15),

                    // Icono de etiqueta
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFF303A48),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.sell_outlined,
                        color: Color(0xFF4DA3FF),
                        size: 26,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _iconoTotal(IconData icono) {
  return Container(
    width: 42,
    height: 42,
    decoration: BoxDecoration(
      color: const Color(0xFF303641),
      shape: BoxShape.circle,
    ),
    child: Icon(
      icono,
      color: const Color(0xFF55A9FF),
      size: 23,
    ),
  );
}