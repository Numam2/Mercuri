import 'package:flutter/material.dart';
import 'package:mercuri/Backend/database_service.dart';
import 'package:mercuri/Income%20and%20Expenses/monthly_expense_summary.dart';
import 'package:mercuri/Income%20and%20Expenses/monthly_income_summary.dart';
import 'package:mercuri/Models/stats.dart';
import 'package:mercuri/theme.dart';
import 'package:provider/provider.dart';

class SummaryDashboard extends StatefulWidget {
  final String uid;
  const SummaryDashboard(this.uid, {super.key});

  @override
  State<SummaryDashboard> createState() => _SummaryDashboardState();
}

class _SummaryDashboardState extends State<SummaryDashboard> {
  final controller = PageController(initialPage: 0);
  bool seeExpenses = true;

  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'Octobrer',
    'November',
    'December'
  ];

  String currentMonth = '';
  int currentYear = 0;

  final List<Map> incomeList = [
    {
      'Category': 'Salary',
      'Amount': 20000,
      'Date': DateTime(2024, 1, 2),
    },
    {
      'Category': 'Investments',
      'Amount': 5063.5,
      'Date': DateTime(2024, 1, 15),
    },
  ];

  @override
  void initState() {
    currentMonth = months[DateTime.now().month - 1];
    currentYear = DateTime.now().year;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
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
            'My summary',
            style: TextStyle(
                color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {},
                child: Text(
                  '$currentMonth $currentYear',
                  style: TextStyle(
                      color: theme.isDarkMode ? Colors.white : Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.normal),
                ),
              ),
            )
          ],
          centerTitle: true,
        ),
        body: Column(
          children: [
            //Select Income/Expenses
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
                                    : Colors.greenAccent))),
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
                          overlayColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered)) {
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
                            'Expenses',
                            style: TextStyle(
                                fontWeight: (seeExpenses)
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: (seeExpenses)
                                    ? Colors.greenAccent
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
                                    ? Colors.greenAccent
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
                          overlayColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered)) {
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
                            'Income',
                            style: TextStyle(
                                fontWeight: (!seeExpenses)
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: (!seeExpenses)
                                    ? Colors.greenAccent
                                    : textColor),
                          ),
                        )),
                  ),
                ]),
            const SizedBox(height: 15),
            //PageView
            StreamProvider<Stats>.value(
              value: DatabaseService()
                  .monthlyStatsfromSnapshot(widget.uid, DateTime.now()),
              initialData: Stats(
                  monthlyIncome: 0,
                  monthlyExpenses: 0,
                  expensesByCategory: {},
                  incomeByCategory: {}),
              child: Expanded(
                child: PageView(
                  controller: controller,
                  children: [
                    //Expenses
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: MonthlyExpenseSummary(),
                      ),
                    ),
                    //Income
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: MonthlyIncomeSummary(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
