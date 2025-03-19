import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mercuri/Models/transactions.dart';
import 'package:mercuri/Settings/payments_map.dart';
import 'package:provider/provider.dart';

class TransactionsListView extends StatelessWidget {
  final String transactionType;
  final Color textColor;
  final String selectedCategory;
  final String selectedPaymentMethod;
  TransactionsListView(this.transactionType, this.textColor,
      this.selectedCategory, this.selectedPaymentMethod,
      {super.key});

  final formatCurrency = NumberFormat.simpleCurrency();

  @override
  Widget build(BuildContext context) {
    final transactions = Provider.of<List<Transactions>>(context);

    if (transactions == []) {
      return const SizedBox();
    }

    List<Transactions> transactionList = [];

    //Transaction Type filter
    if (transactionType == 'Ingresos y gastos') {
      transactionList = List.from(transactions);
    } else {
      transactionList = List.from(transactions
          .where((element) => element.transactionType == transactionType));
    }

    //category
    if (selectedCategory != '') {
      transactionList = transactionList
          .where((element) => element.category == selectedCategory)
          .toList();
    }

    //paymentMethod
    if (selectedPaymentMethod != '') {
      transactionList = transactionList
          .where((element) =>
              element.paymentMethod!['Name'] == selectedPaymentMethod)
          .toList();
    }

    return SliverList(
        delegate: SliverChildBuilderDelegate((context, i) {
      int? iconIndex;
      if (transactionList[i].paymentMethod != null &&
          transactionList[i].paymentMethod!.isNotEmpty) {
        iconIndex = PaymentsMap().paymentsMap.indexWhere((item) =>
            item['Code'] == transactionList[i].paymentMethod!['Icon']);
      } else {
        iconIndex = null;
      }

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(5),
        height: 50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Type
            Expanded(
              flex: 1,
              child: Icon(
                (transactionList[i].paymentMethod != null &&
                        transactionList[i].paymentMethod!.isNotEmpty)
                    ? PaymentsMap().paymentsMap[iconIndex!]['Icon']
                    : (transactionList[i].transactionType == 'Ingresos')
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                color: textColor,
                size: 16,
              ),
            ),
            //Fecha
            Expanded(
              flex: 2,
              child: Text(
                DateFormat.MMMd().format(transactionList[i].date!).toString(),
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: textColor,
                    fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
            //CostType
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${transactionList[i].description}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.normal, color: textColor),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${transactionList[i].category}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            //Total
            Expanded(
              flex: 3,
              child: Text(
                (transactionList[i].transactionType == 'Ingresos')
                    ? '+${formatCurrency.format(transactionList[i].amount)}'
                    : '-${formatCurrency.format(transactionList[i].amount)}',
                style: GoogleFonts.eczar(
                    fontWeight: FontWeight.normal,
                    color: (transactionList[i].transactionType == 'Ingresos')
                        ? textColor
                        : Colors.red[900],
                    fontSize: 18),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }, childCount: transactionList.length));
  }
}
