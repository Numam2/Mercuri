import 'package:flutter/material.dart';
import 'package:mercuri/Backend/database_service.dart';
import 'package:mercuri/Expenses/expense_summary.dart';
import 'package:mercuri/Income%20and%20Expenses/summary_dashboard.dart';
import 'package:mercuri/Income/income_summary.dart';
import 'package:mercuri/Models/stats.dart';
import 'package:mercuri/Models/transactions.dart';
import 'package:mercuri/theme.dart';
import 'package:provider/provider.dart';

class Summary extends StatefulWidget {
  final String uid;
  const Summary(this.uid, {super.key});

  @override
  State<Summary> createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
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

  @override
  void initState() {
    currentMonth = months[DateTime.now().month - 1];
    currentYear = DateTime.now().year;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '$currentMonth $currentYear',
              style: TextStyle(
                  color: theme.isDarkMode ? Colors.white : Colors.black,
                  fontSize: 21,
                  fontWeight: FontWeight.normal),
            ),
            IconButton(
                onPressed: () {},
                splashRadius: 18,
                icon: const Icon(
                  Icons.arrow_drop_down_sharp,
                  color: Colors.grey,
                )),
            const Spacer(),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SummaryDashboard(widget.uid)));
                },
                child: Text(
                  'View summary',
                  style: TextStyle(
                      color: theme.isDarkMode ? Colors.white : Colors.black,
                      fontSize: 12),
                ))
          ],
        ),
        const SizedBox(height: 18),
        //Income
        MultiProvider(providers: [
          StreamProvider<List<Transactions>>.value(
              value: DatabaseService()
                  .shortIncomeList(widget.uid, DateTime.now().year.toString()),
              initialData: const []),
          StreamProvider<Stats>.value(
              value: DatabaseService()
                  .monthlyStatsfromSnapshot(widget.uid, DateTime.now()),
              initialData: Stats(
                  monthlyIncome: 0,
                  monthlyExpenses: 0,
                  expensesByCategory: {},
                  incomeByCategory: {})),
        ], child: IncomeSummary(widget.uid)),
        const SizedBox(height: 20),
        //Expenses
        MultiProvider(providers: [
          StreamProvider<List<Transactions>>.value(
              value: DatabaseService()
                  .shortExpenseList(widget.uid, DateTime.now().year.toString()),
              initialData: const []),
          StreamProvider<Stats>.value(
              value: DatabaseService()
                  .monthlyStatsfromSnapshot(widget.uid, DateTime.now()),
              initialData: Stats(
                  monthlyIncome: 0,
                  monthlyExpenses: 0,
                  expensesByCategory: {},
                  incomeByCategory: {})),
        ], child: ExpensesSummary(widget.uid)),
      ],
    );
  }
}
