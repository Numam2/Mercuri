import 'package:flutter/material.dart';
import 'package:mercuri/Backend/database_service.dart';
import 'package:mercuri/Income%20and%20Expenses/change_date_options.dart';
import 'package:mercuri/Models/shared_accounts.dart';
import 'package:mercuri/Settings/theme.dart';
import 'package:mercuri/SharedAccounts/shared_account_monthly_details.dart';
import 'package:provider/provider.dart';

class SharedAccountActivity extends StatefulWidget {
  final String acctID;
  final String acctName;
  const SharedAccountActivity(this.acctID, this.acctName, {super.key});

  @override
  State<SharedAccountActivity> createState() => _SharedAccountActivityState();
}

class _SharedAccountActivityState extends State<SharedAccountActivity> {
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
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: theme.isDarkMode ? Colors.white : Colors.black,
              size: 21,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            widget.acctName,
            style: TextStyle(
                color: theme.isDarkMode ? Colors.white : Colors.black,
                fontSize: 16),
          ),
          actions: [
            IconButton(
                onPressed: () => showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15))),
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return ChangeDateOptions(changeDate, selectedDate);
                    }),
                icon: SizedBox(
                  child: Row(
                    children: [
                      Icon(Icons.calendar_month,
                          color: theme.isDarkMode ? Colors.white : Colors.black,
                          size: 21),
                      const SizedBox(
                        width: 3,
                      ),
                      Text(
                        '$currentMonth $currentYear',
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                )),
          ],
        ),
        body: MultiProvider(
            providers: [
              StreamProvider<SharedAccountsStats?>.value(
                  value: DatabaseService().sharedTransactionsfromSnapshot(
                      selectedDate, widget.acctID),
                  initialData: null),
              StreamProvider<List<SharedAcctTransactions>?>.value(
                  value: DatabaseService()
                      .shortSharedTransactionsList(widget.acctID, selectedDate),
                  initialData: null),
            ],
            child: SharedAccountMonthlyDetails(
                widget.acctID, widget.acctName, selectedDate)));
  }
}
