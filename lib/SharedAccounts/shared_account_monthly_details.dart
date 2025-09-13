import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mercuri/Backend/database_service.dart';
import 'package:mercuri/Models/shared_accounts.dart';
import 'package:mercuri/Settings/theme.dart';
import 'package:mercuri/SharedAccounts/account_details_list.dart';
import 'package:mercuri/SharedAccounts/shared_account_transactions.dart';
import 'package:provider/provider.dart';

class SharedAccountMonthlyDetails extends StatefulWidget {
  final String acctID;
  final String acctName;
  final DateTime selectedDate;
  const SharedAccountMonthlyDetails(
      this.acctID, this.acctName, this.selectedDate,
      {super.key});

  @override
  State<SharedAccountMonthlyDetails> createState() =>
      _SharedAccountMonthlyDetailsState();
}

class _SharedAccountMonthlyDetailsState
    extends State<SharedAccountMonthlyDetails> {
  final formatCurrency = NumberFormat.simpleCurrency();

  final controller = PageController(initialPage: 0);
  bool seeExpenses = true;
  bool transactionsbyCategory = true;
  Map transactionsMap = {};

  @override
  Widget build(BuildContext context) {
    final accountStats = Provider.of<SharedAccountsStats?>(context);
    final accountTransactions =
        Provider.of<List<SharedAcctTransactions>?>(context);
    final theme = Provider.of<ThemeProvider>(context);
    Color textColor = theme.isDarkMode ? Colors.white : Colors.black;

    if (accountStats == null || accountTransactions == null) {
      return const SizedBox();
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Icome/expense
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Expneses
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: !seeExpenses ? 0 : 3,
                              color: !seeExpenses
                                  ? textColor
                                  : Theme.of(context).colorScheme.primary))),
                  child: TextButton(
                      onPressed: () {
                        setState(() {
                          seeExpenses = true;
                        });
                        controller.animateToPage(0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease);
                      },
                      style: ButtonStyle(
                        overlayColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                            if (states.contains(WidgetState.hovered)) {
                              return Colors.grey.withOpacity(
                                  0.2); // Customize the hover color here
                            }
                            return Colors.grey.withOpacity(
                                0.2); // Use default overlay color for other states
                          },
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          'Gastos',
                          style: TextStyle(
                              fontWeight: (seeExpenses)
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: (seeExpenses)
                                  ? Theme.of(context).colorScheme.primary
                                  : textColor),
                        ),
                      )),
                ),
                const SizedBox(width: 20),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: !seeExpenses ? 3 : 0,
                              color: !seeExpenses
                                  ? Theme.of(context).colorScheme.primary
                                  : textColor))),
                  child: TextButton(
                      onPressed: () {
                        setState(() {
                          seeExpenses = false;
                        });

                        controller.animateToPage(1,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease);
                      },
                      style: ButtonStyle(
                        overlayColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                            if (states.contains(WidgetState.hovered)) {
                              return Colors.grey.withOpacity(
                                  0.2); // Customize the hover color here
                            }
                            return Colors.grey.withOpacity(
                                0.2); // Use default overlay color for other states
                          },
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          'Ingresos',
                          style: TextStyle(
                              fontWeight: (!seeExpenses)
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: (!seeExpenses)
                                  ? Theme.of(context).colorScheme.primary
                                  : textColor),
                        ),
                      )),
                ),
              ]),
          const SizedBox(height: 15),
          //Transactions data
          SizedBox(
            width: double.infinity,
            height: 375,
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: controller,
              children: [
                //Expenses
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: theme.isDarkMode
                                ? Colors.black54
                                : Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(18)),
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
                              'Total de gastos',
                              style: TextStyle(
                                  color: theme.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal),
                            ),
                            const SizedBox(height: 10),
                            //Total amount
                            Text(
                              formatCurrency.format(accountStats.totalExpenses),
                              style: GoogleFonts.eczar(
                                  color: theme.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 48,
                                  fontWeight: FontWeight.normal),
                            ),
                            const SizedBox(height: 10),
                            //By user/category
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  //Expneses
                                  TextButton(
                                      onPressed: () {
                                        setState(() {
                                          transactionsbyCategory = true;
                                        });
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: WidgetStateProperty
                                            .resolveWith<Color>(
                                                (Set<WidgetState> states) {
                                          if (transactionsbyCategory) {
                                            return Theme.of(context)
                                                .colorScheme
                                                .primary;
                                          } else {
                                            return Colors.grey.shade400
                                                .withOpacity(0.25);
                                          }
                                        }),
                                        overlayColor: WidgetStateProperty
                                            .resolveWith<Color>(
                                          (Set<WidgetState> states) {
                                            if (states.contains(
                                                WidgetState.hovered)) {
                                              return Colors.grey.withOpacity(
                                                  0.2); // Customize the hover color here
                                            }
                                            return Colors.grey.withOpacity(
                                                0.2); // Use default overlay color for other states
                                          },
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                          'Categorías',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight:
                                                  (transactionsbyCategory)
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                              color: (transactionsbyCategory)
                                                  ? Colors.white
                                                  : textColor),
                                        ),
                                      )),
                                  const SizedBox(width: 15),
                                  TextButton(
                                      onPressed: () {
                                        setState(() {
                                          transactionsbyCategory = false;
                                        });
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: WidgetStateProperty
                                            .resolveWith<Color>(
                                                (Set<WidgetState> states) {
                                          if (!transactionsbyCategory) {
                                            return Theme.of(context)
                                                .colorScheme
                                                .primary;
                                          } else {
                                            return Colors.grey.shade400
                                                .withOpacity(0.25);
                                          }
                                        }),
                                        overlayColor: WidgetStateProperty
                                            .resolveWith<Color>(
                                          (Set<WidgetState> states) {
                                            if (states.contains(
                                                WidgetState.hovered)) {
                                              return Colors.grey.withOpacity(
                                                  0.2); // Customize the hover color here
                                            }
                                            return Colors.grey.withOpacity(
                                                0.2); // Use default overlay color for other states
                                          },
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                          'Usuarios',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight:
                                                  (!transactionsbyCategory)
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                              color: (!transactionsbyCategory)
                                                  ? Colors.white
                                                  : textColor),
                                        ),
                                      )),
                                ]),
                            const SizedBox(height: 15),
                            //List of users/Category
                            SizedBox(
                                height: 150,
                                child: AccountDetailsList(
                                    theme,
                                    transactionsbyCategory
                                        ? accountStats.expensesByCategory
                                        : accountStats.expensesByUser))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                //Income
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: theme.isDarkMode
                                ? Colors.black54
                                : Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(18)),
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
                              'Total de ingresos',
                              style: TextStyle(
                                  color: theme.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal),
                            ),
                            const SizedBox(height: 10),
                            //Total amount
                            Text(
                              formatCurrency.format(accountStats.totalIncome),
                              style: GoogleFonts.eczar(
                                  color: theme.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 48,
                                  fontWeight: FontWeight.normal),
                            ),
                            const SizedBox(height: 10),
                            //By user/category
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  //Expneses
                                  TextButton(
                                      onPressed: () {
                                        setState(() {
                                          transactionsbyCategory = true;
                                        });
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: WidgetStateProperty
                                            .resolveWith<Color>(
                                                (Set<WidgetState> states) {
                                          if (transactionsbyCategory) {
                                            return Theme.of(context)
                                                .colorScheme
                                                .primary;
                                          } else {
                                            return Colors.grey.shade400
                                                .withOpacity(0.25);
                                          }
                                        }),
                                        overlayColor: WidgetStateProperty
                                            .resolveWith<Color>(
                                          (Set<WidgetState> states) {
                                            if (states.contains(
                                                WidgetState.hovered)) {
                                              return Colors.grey.withOpacity(
                                                  0.2); // Customize the hover color here
                                            }
                                            return Colors.grey.withOpacity(
                                                0.2); // Use default overlay color for other states
                                          },
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                          'Categorías',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight:
                                                  (transactionsbyCategory)
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                              color: (transactionsbyCategory)
                                                  ? Colors.white
                                                  : textColor),
                                        ),
                                      )),
                                  const SizedBox(width: 15),
                                  TextButton(
                                      onPressed: () {
                                        setState(() {
                                          transactionsbyCategory = false;
                                        });
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: WidgetStateProperty
                                            .resolveWith<Color>(
                                                (Set<WidgetState> states) {
                                          if (!transactionsbyCategory) {
                                            return Theme.of(context)
                                                .colorScheme
                                                .primary;
                                          } else {
                                            return Colors.grey.shade400
                                                .withOpacity(0.25);
                                          }
                                        }),
                                        overlayColor: WidgetStateProperty
                                            .resolveWith<Color>(
                                          (Set<WidgetState> states) {
                                            if (states.contains(
                                                WidgetState.hovered)) {
                                              return Colors.grey.withOpacity(
                                                  0.2); // Customize the hover color here
                                            }
                                            return Colors.grey.withOpacity(
                                                0.2); // Use default overlay color for other states
                                          },
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                          'Usuarios',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight:
                                                  (!transactionsbyCategory)
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                              color: (!transactionsbyCategory)
                                                  ? Colors.white
                                                  : textColor),
                                        ),
                                      )),
                                ]),
                            const SizedBox(height: 15),
                            //List of users/Category
                            SizedBox(
                                height: 150,
                                child: AccountDetailsList(
                                    theme,
                                    transactionsbyCategory
                                        ? accountStats.incomeByCategory
                                        : accountStats.incomeByUser))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Movimientos',
              style: TextStyle(
                  color: theme.isDarkMode ? Colors.white : Colors.black,
                  fontSize: 21,
                  fontWeight: FontWeight.normal),
            ),
          ),
          //List of transactions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
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
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: accountTransactions.length,
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //Item
                            Expanded(
                              flex: 6,
                              child: SizedBox(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      accountTransactions[i].description!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: theme.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    Text(
                                      DateFormat.Hm()
                                          .format(accountTransactions[i]
                                              .transactionDate!)
                                          .toString(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            //Amount
                            Expanded(
                              flex: 5,
                              child: Text(
                                formatCurrency
                                    .format(accountTransactions[i].amount!),
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
                    },
                  ),
                  const SizedBox(height: 10),
                  //Button
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StreamProvider<
                                        List<SharedAcctTransactions>?>.value(
                                    value: DatabaseService()
                                        .sharedTransactionsList(
                                            widget.acctID, widget.selectedDate),
                                    initialData: null,
                                    child: Sharedaccounttransactions(
                                        widget.acctName,
                                        widget.selectedDate))));
                      },
                      child: Text(
                        'Ver más',
                        style: TextStyle(
                            color:
                                theme.isDarkMode ? Colors.white : Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
