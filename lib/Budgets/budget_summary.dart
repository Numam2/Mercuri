import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mercuri/Backend/database_service.dart';
import 'package:mercuri/Budgets/goals_summary.dart';
import 'package:mercuri/Models/budgets.dart';
import 'package:mercuri/Models/transactions.dart';
import 'package:mercuri/Settings/theme.dart';
import 'package:provider/provider.dart';

class BudgetSummary extends StatefulWidget {
  final String uid;
  const BudgetSummary(this.uid, {super.key});

  @override
  State<BudgetSummary> createState() => _BudgetSummaryState();
}

class _BudgetSummaryState extends State<BudgetSummary> {
  final formatCurrency = NumberFormat.simpleCurrency();

  String selectedType = 'Presupuestos';

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final budgets = Provider.of<List<Budgets>?>(context);

    if (budgets == null || budgets.isEmpty) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  selectedType,
                  style: TextStyle(
                      color: theme.isDarkMode ? Colors.white : Colors.black,
                      fontSize: 21,
                      fontWeight: FontWeight.normal),
                ),
                const SizedBox(width: 5),
                PopupMenuButton<int>(
                  itemBuilder: (context) {
                    List<PopupMenuItem<int>> items = [
                      const PopupMenuItem<int>(
                          value: 1, child: Text('Presupuestos')),
                      const PopupMenuItem<int>(value: 2, child: Text('Metas')),
                    ];
                    return items;
                  },
                  onSelected: (value) {
                    switch (value) {
                      case 1:
                        setState(() {
                          selectedType = 'Presupuestos';
                        });
                        break;
                      case 2:
                        setState(() {
                          selectedType = 'Metas';
                        });
                        break;
                    }
                  },
                  child: const Icon(
                    Icons.arrow_drop_down_sharp,
                    size: 21,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          selectedType == 'Presupuestos'
              ? SizedBox(
                  height: 130,
                  width: double.infinity,
                  child: PageView.builder(
                    controller: PageController(viewportFraction: 0.95),
                    itemCount: budgets.length,
                    itemBuilder: (context, index) {
                      return StreamProvider<List<Transactions>?>.value(
                          value: DatabaseService().transactionsbyCategory(
                              widget.uid,
                              DateTime.now(),
                              budgets[index].title!),
                          initialData: null,
                          child: BudgetCard(theme, budgets[index]));
                    },
                  ),
                )
              : StreamProvider<List<Budgets>?>.value(
                  value: DatabaseService().budgetList(widget.uid, 'Meta'),
                  initialData: null,
                  child: GoalsSummary(widget.uid))
        ],
      ),
    );
  }
}

class BudgetCard extends StatefulWidget {
  final ThemeProvider theme;
  final Budgets budget;
  const BudgetCard(this.theme, this.budget, {super.key});

  @override
  State<BudgetCard> createState() => _BudgetCardState();
}

class _BudgetCardState extends State<BudgetCard> {
  final formatCurrency = NumberFormat.simpleCurrency();
  num currentTotal = 0;

  @override
  Widget build(BuildContext context) {
    final transactions = Provider.of<List<Transactions>?>(context);

    if (transactions == null || transactions.isEmpty) {
      currentTotal = 0;
    } else {
      currentTotal = 0;
      for (var x = 0; x < transactions.length; x++) {
        currentTotal += transactions[x].amount!;
      }
    }

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      double maxWidth = constraints.maxWidth;
      return Transform.scale(
        scale: 0.95, // Slightly shrink non-selected items
        child: Container(
          decoration: BoxDecoration(
              color: widget.theme.isDarkMode ? Colors.black54 : Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(18)),
              boxShadow: widget.theme.isDarkMode
                  ? []
                  : [
                      BoxShadow(
                          color: Colors.grey.shade300,
                          offset: const Offset(-5, 5),
                          blurRadius: 20)
                    ]),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Title
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      widget.budget.title!,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: widget.theme.isDarkMode
                              ? Colors.white
                              : Colors.black,
                          fontSize: 14),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    formatCurrency.format(currentTotal),
                    textAlign: TextAlign.end,
                    style: GoogleFonts.eczar(
                        color: widget.theme.isDarkMode
                            ? Colors.white
                            : Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              //Graph
              Stack(
                children: [
                  Container(
                    width: maxWidth * 0.9,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  Container(
                    width: (currentTotal > widget.budget.budgetedAmount!)
                        ? maxWidth * 0.9
                        : (maxWidth *
                                    ((currentTotal /
                                            widget.budget.budgetedAmount!) -
                                        0.1) >
                                0)
                            ? maxWidth *
                                ((currentTotal /
                                        widget.budget.budgetedAmount!) -
                                    0.1)
                            : 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              //Amount left
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${formatCurrency.format((widget.budget.budgetedAmount! - currentTotal))} remanentes',
                    style: TextStyle(
                        color: widget.theme.isDarkMode
                            ? Colors.white54
                            : Colors.grey,
                        fontSize: 12),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
