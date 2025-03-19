import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mercuri/Backend/database_service.dart';
import 'package:mercuri/Income%20and%20Expenses/create_transaction.dart';
import 'package:mercuri/Models/budgets.dart';
import 'package:mercuri/Settings/theme.dart';
import 'package:mercuri/loading.dart';
import 'package:provider/provider.dart';

class BudgetsList extends StatelessWidget {
  final String uid;
  final List budgetCategories;
  BudgetsList(this.uid, this.budgetCategories, {super.key});

  final formatCurrency = NumberFormat.simpleCurrency();

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final budgets = Provider.of<List<Budgets>?>(context);

    if (budgets == null || budgets.isEmpty) {
      return Text(
        'Nada aún por mostrar',
        style: TextStyle(
            color: theme.isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.normal,
            fontSize: 14),
      );
    }

    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: budgets.length,
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Text and money
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Title
                    Text(
                      budgets[i].title!,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: theme.isDarkMode ? Colors.white : Colors.black,
                          fontSize: 14),
                    ),
                    const SizedBox(height: 5),
                    //Money
                    Text(
                      budgets[i].type == 'Presupuesto'
                          ? '(${formatCurrency.format(budgets[i].budgetedAmount!)} /mes)'
                          : '${formatCurrency.format(budgets[i].currentAmount)} de ${formatCurrency.format(budgets[i].budgetedAmount)}',
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
                const Spacer(),
                //Options
                PopupMenuButton<int>(
                  itemBuilder: (context) {
                    List<PopupMenuItem<int>> items = [
                      const PopupMenuItem<int>(
                          value: 1, child: Text('Actualizar monto')),
                      PopupMenuItem<int>(
                          value: 2,
                          child: Text(budgets[i].type == 'Presupuesto'
                              ? 'Eliminar presupuesto'
                              : 'Eliminar meta')),
                    ];
                    return items;
                  },
                  onSelected: (value) {
                    switch (value) {
                      case 1:
                        showDialog(
                            context: context,
                            builder: (context) {
                              return UpdateBudgetDialog(
                                budgets[i].title!,
                                theme,
                                uid,
                                budgets[i].docID!,
                                budgets[i].type!,
                                budgets[i].budgetedAmount!,
                              );
                            });
                        break;
                      case 2:
                        showDialog(
                            context: context,
                            builder: (context) {
                              return DeleteBudgetDialog(
                                budgets[i].title!,
                                theme,
                                uid,
                                budgets[i].docID!,
                                budgets[i].type!,
                                budgetCategories,
                              );
                            });
                        break;
                    }
                  },
                  child: Icon(
                    Icons.more_vert,
                    size: 21,
                    color: theme.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          );
        });
  }
}

////// Delete budget
class DeleteBudgetDialog extends StatefulWidget {
  final String title;
  final ThemeProvider theme;
  final String uid;
  final String docID;
  final String type;
  final List budgetCategories;
  const DeleteBudgetDialog(this.title, this.theme, this.uid, this.docID,
      this.type, this.budgetCategories,
      {super.key});

  @override
  State<DeleteBudgetDialog> createState() => _DeleteBudgetDialogState();
}

class _DeleteBudgetDialogState extends State<DeleteBudgetDialog> {
  bool loading = false;
  List budgetCategories = [];

  @override
  void initState() {
    budgetCategories = List.from(widget.budgetCategories);
    budgetCategories.removeWhere((item) => item == widget.title);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: SizedBox(
        height: 200,
        width: 250,
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
                      widget.type == 'Presupuesto'
                          ? "Eliminar presupuesto de"
                          : "Eliminar meta",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
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
                                  .deleteBudget(
                                      widget.uid, widget.docID, widget.type)
                                  .then((v) {
                                DatabaseService().updateBudgetCategories(
                                    widget.uid, budgetCategories);
                              }).then((v) {
                                Navigator.of(context).pop();
                              });
                            },
                            child: const Text(
                              'Eliminar',
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

////// Update Budget
class UpdateBudgetDialog extends StatefulWidget {
  final String title;
  final ThemeProvider theme;
  final String uid;
  final String docID;
  final String type;
  final num budgetAmount;
  const UpdateBudgetDialog(this.title, this.theme, this.uid, this.docID,
      this.type, this.budgetAmount,
      {super.key});

  @override
  State<UpdateBudgetDialog> createState() => _UpdateBudgetDialogState();
}

class _UpdateBudgetDialogState extends State<UpdateBudgetDialog> {
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
                      widget.type == 'Presupuesto'
                          ? "Presupuesto mensual de"
                          : "Actualizar monto de mi meta",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
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
                                  .updateBudget(widget.uid, widget.docID,
                                      widget.type, newAmount)
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
