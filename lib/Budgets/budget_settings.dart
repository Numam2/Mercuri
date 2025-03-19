import 'package:flutter/material.dart';
import 'package:mercuri/Backend/database_service.dart';
import 'package:mercuri/Budgets/budgets_list.dart';
import 'package:mercuri/Budgets/create_budget.dart';
import 'package:mercuri/Models/budgets.dart';
import 'package:mercuri/Settings/theme.dart';
import 'package:provider/provider.dart';

class BudgetSettings extends StatefulWidget {
  final String uid;
  final List<dynamic> expenseCategories;
  final List? budgetCategories;
  const BudgetSettings(this.uid, this.expenseCategories, this.budgetCategories,
      {super.key});

  @override
  State<BudgetSettings> createState() => _BudgetSettingsState();
}

class _BudgetSettingsState extends State<BudgetSettings> {
  @override
  void initState() {
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
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Presupuestos',
          style: TextStyle(
              color: theme.isDarkMode ? Colors.white : Colors.black,
              fontSize: 16),
        ),
        actions: [
          Container(
            width: 70,
            color: Colors.transparent,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ////////Budgets
            ///Title + Create
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Mis presupuestos',
                  style: TextStyle(
                      color: theme.isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                const Spacer(),
                TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CreateBudget(widget.uid, 'Presupuesto',
                            widget.expenseCategories, widget.budgetCategories);
                      }));
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.add,
                          color: theme.isDarkMode ? Colors.white : Colors.black,
                          size: 14,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'crear',
                          style: TextStyle(
                              color: theme.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 12),
                        ),
                      ],
                    ))
              ],
            ),

            ///List of current Budgets
            StreamProvider<List<Budgets>?>.value(
              value: DatabaseService().budgetList(widget.uid, 'Presupuesto'),
              initialData: null,
              child: BudgetsList(widget.uid, widget.budgetCategories ?? []),
            ),
            const SizedBox(height: 25),
            ////////Goals
            ///Title + Create
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Mis metas',
                  style: TextStyle(
                      color: theme.isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                const Spacer(),
                TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CreateBudget(
                            widget.uid, 'Meta', widget.expenseCategories, null);
                      }));
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.add,
                          color: theme.isDarkMode ? Colors.white : Colors.black,
                          size: 14,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'crear',
                          style: TextStyle(
                              color: theme.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 12),
                        ),
                      ],
                    ))
              ],
            ),

            ///List of current Goals
            StreamProvider<List<Budgets>?>.value(
              value: DatabaseService().budgetList(widget.uid, 'Meta'),
              initialData: null,
              child: BudgetsList(widget.uid, widget.budgetCategories ?? []),
            ),
          ],
        ),
      ),
    );
  }
}
