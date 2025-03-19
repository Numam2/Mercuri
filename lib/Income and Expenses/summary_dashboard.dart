import 'package:flutter/material.dart';
import 'package:mercuri/Backend/database_service.dart';
import 'package:mercuri/Income%20and%20Expenses/monthly_expense_summary.dart';
import 'package:mercuri/Income%20and%20Expenses/monthly_income_summary.dart';
import 'package:mercuri/Models/stats.dart';
import 'package:mercuri/Income%20and%20Expenses/change_date_options.dart';
import 'package:mercuri/Settings/theme.dart';
import 'package:provider/provider.dart';

class SummaryDashboard extends StatefulWidget {
  final String uid;
  final DateTime? selectedDate;
  const SummaryDashboard(this.uid, this.selectedDate, {super.key});

  @override
  State<SummaryDashboard> createState() => _SummaryDashboardState();
}

class _SummaryDashboardState extends State<SummaryDashboard> {
  late DateTime selectedDate;

  final controller = PageController(initialPage: 0);
  bool seeExpenses = true;

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

  String currentMonth = '';
  int currentYear = 0;

  void changeDate(int year, int month) {
    setState(() {
      selectedDate = DateTime(
        year,
        month,
      );
      currentMonth = months[selectedDate.month - 1];
      currentYear = selectedDate.year;
    });
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    if (widget.selectedDate != null) {
      selectedDate = widget.selectedDate!;
      currentMonth = months[widget.selectedDate!.month - 1];
      currentYear = widget.selectedDate!.year;
    } else {
      selectedDate = DateTime.now();
      currentMonth = months[selectedDate.month - 1];
      currentYear = selectedDate.year;
    }

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
            'Mi resumen',
            style: TextStyle(
                color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {
                  showModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15))),
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return ChangeDateOptions(changeDate, selectedDate);
                      });
                },
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
            //PageView
            StreamProvider<Stats>.value(
              value: DatabaseService()
                  .monthlyStatsfromSnapshot(widget.uid, selectedDate),
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
