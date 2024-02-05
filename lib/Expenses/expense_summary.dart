import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mercuri/Models/stats.dart';
import 'package:mercuri/Models/transactions.dart';
import 'package:mercuri/theme.dart';
import 'package:provider/provider.dart';

import '../Income and Expenses/transactions_list.dart';

class ExpensesSummary extends StatelessWidget {
  final String uid;
  ExpensesSummary(this.uid, {super.key});

  final formatCurrency = NumberFormat.simpleCurrency();

  final List<Map> expensesList = [
    {
      'Category': 'Home',
      'Description': 'Rent',
      'Amount': 2500,
      'Date': DateTime(2024, 1, 2),
    },
    {
      'Category': 'Food',
      'Description': 'Groceries',
      'Amount': 3510,
      'Date': DateTime(2024, 1, 15),
    },
    {
      'Category': 'Eat out',
      'Description': 'Delivery',
      'Amount': 250,
      'Date': DateTime(2024, 1, 15),
    },
    {
      'Category': 'Food',
      'Description': 'Groceries',
      'Amount': 2500,
      'Date': DateTime(2024, 1, 15),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final transactions = Provider.of<List<Transactions>>(context);
    final stats = Provider.of<Stats>(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: theme.isDarkMode ? Colors.black54 : Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(18)),
          boxShadow: theme.isDarkMode
              ? []
              : [
                  BoxShadow(
                      color: Colors.grey.shade300,
                      offset: const Offset(-5, 5),
                      blurRadius: 20)
                ]),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Text
            Text(
              'Expenses',
              style: TextStyle(
                  color: theme.isDarkMode ? Colors.white : Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 10),
            //Amount
            Text(
              formatCurrency.format(stats.monthlyExpenses),
              style: GoogleFonts.eczar(
                  color: theme.isDarkMode ? Colors.white : Colors.black,
                  fontSize: 48,
                  fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 10),
            //List
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transactions.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //Description/date
                        Expanded(
                          flex: 5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Desc
                              Text(
                                transactions[i].category!,
                                style: TextStyle(
                                    color: theme.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              //Date
                              Text(
                                DateFormat.Hm()
                                    .format(transactions[i].date!)
                                    .toString(),
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        //Amount
                        Expanded(
                          flex: 5,
                          child: Text(
                            formatCurrency.format(transactions[i].amount),
                            textAlign: TextAlign.end,
                            style: GoogleFonts.eczar(
                                color: theme.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 21,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            const SizedBox(height: 10),
            //Button
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return TransactionList(
                      uid: uid,
                    );
                  }));
                },
                child: Text(
                  'See all',
                  style: TextStyle(
                      color: theme.isDarkMode ? Colors.white : Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                ),
              ),
            )
          ]),
    );
  }
}
