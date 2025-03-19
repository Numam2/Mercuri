import 'package:flutter/material.dart';
import 'package:mercuri/Backend/database_service.dart';
import 'package:mercuri/Expenses/expense_summary.dart';
import 'package:mercuri/Income%20and%20Expenses/summary_dashboard.dart';
import 'package:mercuri/Income/income_summary.dart';
import 'package:mercuri/Models/stats.dart';
import 'package:mercuri/Models/transactions.dart';
import 'package:mercuri/Income%20and%20Expenses/change_date_options.dart';
import 'package:mercuri/Settings/theme.dart';
import 'package:provider/provider.dart';

class Summary extends StatefulWidget {
  final String uid;
  final List<dynamic> incomeCategories;
  final List<dynamic> expenseCategories;
  final List<dynamic> paymentMethod;

  const Summary(this.uid, this.incomeCategories, this.expenseCategories,
      this.paymentMethod,
      {super.key});

  @override
  State<Summary> createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  DateTime selectedDate = DateTime.now();

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
    currentMonth = months[selectedDate.month - 1];
    currentYear = selectedDate.year;
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
                          builder: (context) =>
                              SummaryDashboard(widget.uid, selectedDate)));
                },
                child: Text(
                  'Ver resumen',
                  style: TextStyle(
                      color: theme.isDarkMode ? Colors.white : Colors.black,
                      fontSize: 12),
                ))
          ],
        ),
        const SizedBox(height: 18),
        //Income
        MultiProvider(
            providers: [
              StreamProvider<List<Transactions>>.value(
                  value: DatabaseService()
                      .shortIncomeList(widget.uid, selectedDate),
                  initialData: const []),
              StreamProvider<Stats>.value(
                  value: DatabaseService()
                      .monthlyStatsfromSnapshot(widget.uid, selectedDate),
                  initialData: Stats(
                      monthlyIncome: 0,
                      monthlyExpenses: 0,
                      expensesByCategory: {},
                      incomeByCategory: {})),
            ],
            child: IncomeSummary(
                widget.uid,
                selectedDate,
                widget.incomeCategories,
                widget.expenseCategories,
                widget.paymentMethod)),
        const SizedBox(height: 20),
        //Expenses
        MultiProvider(
            providers: [
              StreamProvider<List<Transactions>>.value(
                  value: DatabaseService()
                      .shortExpenseList(widget.uid, selectedDate),
                  initialData: const []),
              StreamProvider<Stats>.value(
                  value: DatabaseService()
                      .monthlyStatsfromSnapshot(widget.uid, selectedDate),
                  initialData: Stats(
                      monthlyIncome: 0,
                      monthlyExpenses: 0,
                      expensesByCategory: {},
                      incomeByCategory: {})),
            ],
            child: ExpensesSummary(
                widget.uid,
                selectedDate,
                widget.incomeCategories,
                widget.expenseCategories,
                widget.paymentMethod)),
      ],
    );
  }
}
