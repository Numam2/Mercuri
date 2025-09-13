import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mercuri/Backend/database_service.dart';
import 'package:mercuri/Income%20and%20Expenses/create_transaction.dart';
import 'package:mercuri/Models/budgets.dart';
import 'package:mercuri/Settings/theme.dart';
import 'package:mercuri/loading.dart';
import 'package:provider/provider.dart';

class GoalsSummary extends StatefulWidget {
  final String uid;
  const GoalsSummary(this.uid, {super.key});

  @override
  State<GoalsSummary> createState() => _GoalsSummaryState();
}

class _GoalsSummaryState extends State<GoalsSummary> {
  final formatCurrency = NumberFormat.simpleCurrency();

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final budgets = Provider.of<List<Budgets>?>(context);

    if (budgets == null || budgets.isEmpty) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: SizedBox(
        height: 130,
        width: double.infinity,
        child: PageView.builder(
          controller: PageController(viewportFraction: 0.95),
          itemCount: budgets.length,
          itemBuilder: (context, index) {
            return LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              double maxWidth = constraints.maxWidth;
              return Transform.scale(
                scale: 0.95, // Slightly shrink non-selected items
                child: Container(
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
                              budgets[index].title!,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: theme.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 14),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.add,
                              size: 21,
                              color: theme.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            splashRadius: 5,
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return UpdateGoalDialog(
                                        budgets[index].title!,
                                        theme,
                                        widget.uid,
                                        budgets[index].docID!,
                                        budgets[index].currentAmount!);
                                  });
                            },
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 8,
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
                            width: (budgets[index].currentAmount! >
                                    budgets[index].budgetedAmount!)
                                ? maxWidth * 0.9
                                : (maxWidth *
                                            ((budgets[index].currentAmount! /
                                                    budgets[index]
                                                        .budgetedAmount!) -
                                                0.1) >
                                        0)
                                    ? maxWidth *
                                        ((budgets[index].currentAmount! /
                                                budgets[index]
                                                    .budgetedAmount!) -
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
                            '${formatCurrency.format((budgets[index].currentAmount!))} de ${formatCurrency.format((budgets[index].budgetedAmount!))}',
                            style: TextStyle(
                                color: theme.isDarkMode
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
          },
        ),
      ),
    );
  }
}

////// Update Budget
class UpdateGoalDialog extends StatefulWidget {
  final String title;
  final ThemeProvider theme;
  final String uid;
  final String docID;
  final num currentAmount;
  const UpdateGoalDialog(
      this.title, this.theme, this.uid, this.docID, this.currentAmount,
      {super.key});

  @override
  State<UpdateGoalDialog> createState() => _UpdateGoalDialogState();
}

class _UpdateGoalDialogState extends State<UpdateGoalDialog> {
  bool loading = false;
  num newAmount = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: SizedBox(
        height: 300,
        width: double.infinity,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: const Alignment(1.0, 0.0),
                    child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                        iconSize: 20.0),
                  ),
                  //Text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      "Agregar a ${widget.title}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //Amount
                  SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                      autofocus: true,
                      style: GoogleFonts.eczar(
                          color: widget.theme.isDarkMode
                              ? Colors.white
                              : Colors.black,
                          fontSize: 45),
                      textAlign: TextAlign.center,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      cursorColor: Colors.grey,
                      inputFormatters: [
                        CurrencyInputFormatter(),
                      ],
                      decoration: InputDecoration(
                        hintText: '\$0.00',
                        hintStyle:
                            GoogleFonts.eczar(color: Colors.grey, fontSize: 45),
                        focusColor: Colors.black,
                        errorStyle: TextStyle(
                            color: Colors.redAccent[700], fontSize: 12),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        // Remove formatting characters (dots and commas)
                        String rawValue = value.replaceAll(RegExp(r'[,]'), '');
                        setState(() {
                          newAmount = double.parse(rawValue);
                        });
                      },
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //Buttons
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0)),
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary),
                            onPressed: () async {
                              setState(() {
                                loading = true;
                              });
                              DatabaseService()
                                  .updateGoal(widget.uid, widget.docID, 'Meta',
                                      newAmount + widget.currentAmount)
                                  .then((v) {
                                Navigator.of(context).pop();
                              });
                            },
                            child: const Text(
                              'Actualizar',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: TextButton(
                            style: TextButton.styleFrom(
                                splashFactory: NoSplash.splashFactory,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0)),
                                backgroundColor: Colors.transparent,
                                side: BorderSide(
                                    color: widget.theme.isDarkMode
                                        ? Colors.grey
                                        : Colors.grey)),
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              'Volver',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: widget.theme.isDarkMode
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            (loading)
                ? Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.grey.withOpacity(0.5),
                    child: const Loading(),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
