import 'package:flutter/material.dart';

class PaymentsMap {
  final List<Map<String, dynamic>> paymentsMap = [
    {'Index': 0, 'Code': 'Efectivo', 'Icon': Icons.attach_money_outlined},
    {'Index': 1, 'Code': 'Tarjeta', 'Icon': Icons.credit_card_outlined},
    {'Index': 2, 'Code': 'Banco', 'Icon': Icons.account_balance_outlined},
    {'Index': 3, 'Code': 'Billetera', 'Icon': Icons.account_balance_wallet},
    {'Index': 4, 'Code': 'QR', 'Icon': Icons.qr_code},
  ];
}
