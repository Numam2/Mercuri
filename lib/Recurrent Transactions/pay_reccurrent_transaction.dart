import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mercuri/Backend/database_service.dart';
import 'package:mercuri/Income%20and%20Expenses/create_transaction.dart';
import 'package:mercuri/Models/recurrent_transactions.dart';
import 'package:mercuri/Settings/icons_map.dart';
import 'package:mercuri/Settings/theme.dart';
import 'package:provider/provider.dart';

class PayRecurrentTransaction extends StatefulWidget {
  final String uid;
  final RecurrentTransactions recurrentTransaction;
  const PayRecurrentTransaction(this.uid, this.recurrentTransaction,
      {super.key});

  @override
  State<PayRecurrentTransaction> createState() =>
      _PayRecurrentTransactionState();
}

class _PayRecurrentTransactionState extends State<PayRecurrentTransaction> {
  num amount = 0;
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _amountFocusNode = FocusNode();

  @override
  void initState() {
    amount = widget.recurrentTransaction.recurrentAmount!;
    _amountController.text =
        widget.recurrentTransaction.recurrentAmount.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    var iconIndex = IconsMap().iconsMap.indexWhere(
        (x) => x['Code'] == widget.recurrentTransaction.category!['Icon']);
    var itemIcon = IconsMap().iconsMap[iconIndex]['Icon'];

    return SizedBox(
      height: _amountFocusNode.hasFocus
          ? MediaQuery.of(context).size.height * 0.65
          : MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //Title
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              widget.recurrentTransaction.transactionType == 'Ingreso'
                  ? "Registrar ingreso de ${widget.recurrentTransaction.transactionName}"
                  : "Registrar cuota de ${widget.recurrentTransaction.transactionName}",
              textAlign: TextAlign.center,
              maxLines: 3,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(
            color: Colors.grey,
            indent: 20,
            endIndent: 20,
            thickness: 0.5,
          ),
          const SizedBox(height: 15),
          //Category // Period/Months
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Category
                Icon(
                  itemIcon,
                  size: 21,
                  color: Colors.black,
                ),
                const SizedBox(width: 2),
                Text(widget.recurrentTransaction.category!['Category'],
                    style: const TextStyle(color: Colors.black, fontSize: 14)),
                const Spacer(),
                //Payment Type
                //TODO: Payment type + associate shared acct,
                //Months
                Text(
                    '${widget.recurrentTransaction.monthsPaid} de ${widget.recurrentTransaction.repeatxMonths}',
                    style: const TextStyle(color: Colors.grey, fontSize: 14)),
              ],
            ),
          ),
          const SizedBox(height: 15),
          //Amount
          Center(
            child: SizedBox(
              width: double.infinity,
              child: TextFormField(
                autofocus: false,
                style: GoogleFonts.eczar(
                    color: theme.isDarkMode ? Colors.white : Colors.black,
                    fontSize: 45),
                textAlign: TextAlign.center,
                focusNode: _amountFocusNode,
                controller: _amountController,
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
                  errorStyle:
                      TextStyle(color: Colors.redAccent[700], fontSize: 12),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  // Remove formatting characters (dots and commas)
                  String rawValue = value.replaceAll(RegExp(r'[,]'), '');
                  setState(() {
                    amount = double.parse(rawValue);
                  });
                },
                textInputAction: TextInputAction.done,
              ),
            ),
          ),
          //Button
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0)),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      if (widget.recurrentTransaction.monthsPaid! + 1 ==
                          widget.recurrentTransaction.repeatxMonths) {
                        DatabaseService()
                            .updateandDeactivateRecurrentTransaction(
                                widget.uid,
                                widget.recurrentTransaction.id!,
                                amount,
                                widget.recurrentTransaction.monthsPaid! + 1);
                      } else {
                        DatabaseService().updateRecurrentTransaction(
                            widget.uid,
                            widget.recurrentTransaction.id!,
                            amount,
                            widget.recurrentTransaction.monthsPaid! + 1);
                      }
                      //Create transaction
                      DatabaseService()
                          .createTransaction(
                              widget.uid,
                              DateTime.now().toString(),
                              DateTime.now(),
                              widget.recurrentTransaction.transactionType!,
                              widget.recurrentTransaction.category!['Category'],
                              widget.recurrentTransaction.transactionName!,
                              amount,
                              selectedPaymentMethod!)
                          .then((value) => DatabaseService().updateStats(
                              widget.uid,
                              DateTime.now(),
                              widget.recurrentTransaction.transactionType!,
                              widget.recurrentTransaction.category!['Category'],
                              amount,
                              selectedPaymentMethod!))
                          .then((value) => Navigator.of(context).pop());

                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Registrar',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
