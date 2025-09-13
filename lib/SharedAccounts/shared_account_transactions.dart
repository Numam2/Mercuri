import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mercuri/Models/shared_accounts.dart';
import 'package:mercuri/Settings/theme.dart';
import 'package:provider/provider.dart';

class Sharedaccounttransactions extends StatefulWidget {
  final String accountName;
  final DateTime selectedDate;
  const Sharedaccounttransactions(this.accountName, this.selectedDate,
      {super.key});

  @override
  State<Sharedaccounttransactions> createState() =>
      _SharedaccounttransactionsState();
}

class _SharedaccounttransactionsState extends State<Sharedaccounttransactions> {
  final formatCurrency = NumberFormat.simpleCurrency();
  final List<String> months = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre'
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final transactionList = Provider.of<List<SharedAcctTransactions>?>(context);

    if (transactionList == null) {
      return const SizedBox();
    }

    Color textColor = theme.isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            splashRadius: 24,
            icon: Icon(Icons.arrow_back,
                size: 16,
                color: theme.isDarkMode ? Colors.white : Colors.black)),
        title: Text(
          widget.accountName,
          style: TextStyle(
              color: theme.isDarkMode ? Colors.white : Colors.black,
              fontSize: 16),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              '${months[widget.selectedDate.month - 1]} ${widget.selectedDate.year}',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
              delegate: SliverChildBuilderDelegate((context, i) {
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
                      (transactionList[i].type == 'Ingresos')
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      color: textColor,
                      size: 16,
                    ),
                  ),
                  //Fecha
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat.MMMd()
                              .format(transactionList[i].transactionDate!)
                              .toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: textColor,
                              fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          transactionList[i].userName!,
                          style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.grey,
                              fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
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
                      (transactionList[i].type == 'Ingresos')
                          ? '+${formatCurrency.format(transactionList[i].amount)}'
                          : '-${formatCurrency.format(transactionList[i].amount)}',
                      style: GoogleFonts.eczar(
                          fontWeight: FontWeight.normal,
                          color: (transactionList[i].type == 'Ingresos')
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
          }, childCount: transactionList.length))
        ],
      ),
    );
  }
}
