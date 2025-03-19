import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mercuri/Settings/theme.dart';
import 'package:provider/provider.dart';

class SetAmortizedPaymentDialog extends StatefulWidget {
  final setAmortizedPayment;
  const SetAmortizedPaymentDialog(this.setAmortizedPayment, {super.key});

  @override
  State<SetAmortizedPaymentDialog> createState() =>
      _SetAmortizedPaymentDialogState();
}

class _SetAmortizedPaymentDialogState extends State<SetAmortizedPaymentDialog> {
  final formatCurrency = NumberFormat.simpleCurrency();
  int? numberOfPayments = 0;
  num? monthlyPayment = 0;
  num? totalPayment = 0;
  TextEditingController totalPaymentController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Container(
        padding: const EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height * 0.5,
        width: (MediaQuery.of(context).size.width > 650)
            ? MediaQuery.of(context).size.width * 0.35
            : MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(minHeight: 350, minWidth: 200),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Close
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      iconSize: 20.0),
                ],
              ),
              const SizedBox(height: 8),
              //Cuptas y monto
              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    //Number of payments
                    Expanded(
                      child: TextFormField(
                        autofocus: false,
                        style: TextStyle(
                            color:
                                theme.isDarkMode ? Colors.white : Colors.black,
                            fontSize: 16),
                        textAlign: TextAlign.left,
                        cursorColor: Colors.grey,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          label: const Text('Número de cuotas'),
                          focusColor: Colors.black,
                          errorStyle: TextStyle(
                              color: Colors.redAccent[700], fontSize: 12),
                          border: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.green, width: 1)),
                        ),
                        onChanged: (value) {
                          setState(() {
                            numberOfPayments = int.parse(value);
                            totalPayment =
                                (numberOfPayments! * monthlyPayment!);
                            totalPaymentController.text = '$totalPayment';
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    //Monthly amount
                    Expanded(
                      child: TextFormField(
                        autofocus: false,
                        style: TextStyle(
                            color:
                                theme.isDarkMode ? Colors.white : Colors.black,
                            fontSize: 16),
                        textAlign: TextAlign.left,
                        cursorColor: Colors.grey,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          label: const Text('Monto por cuota'),
                          focusColor: Colors.black,
                          errorStyle: TextStyle(
                              color: Colors.redAccent[700], fontSize: 12),
                          border: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.green, width: 1)),
                        ),
                        onChanged: (value) {
                          setState(() {
                            monthlyPayment = double.parse(value);
                            totalPayment =
                                (numberOfPayments! * monthlyPayment!);
                            totalPaymentController.text = '$totalPayment';
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              //Total
              SizedBox(
                width: double.infinity,
                child: TextFormField(
                  autofocus: false,
                  enabled: false,
                  style: TextStyle(
                      color: theme.isDarkMode ? Colors.white : Colors.black,
                      fontSize: 16),
                  textAlign: TextAlign.left,
                  cursorColor: Colors.grey,
                  controller: totalPaymentController,
                  decoration: InputDecoration(
                    label: Text('Total en $numberOfPayments pagos'),
                    labelStyle: TextStyle(
                        color: theme.isDarkMode ? Colors.white : Colors.black),
                    focusColor: Colors.black,
                    errorStyle:
                        TextStyle(color: Colors.redAccent[700], fontSize: 12),
                    border: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 1)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              //Confirm Button
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: TextButton(
                  style: TextButton.styleFrom(
                      splashFactory: NoSplash.splashFactory,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0)),
                      backgroundColor: Colors.transparent,
                      side: BorderSide(
                          color: theme.isDarkMode ? Colors.grey : Colors.grey)),
                  onPressed: () {
                    widget.setAmortizedPayment(
                        totalPayment, monthlyPayment, numberOfPayments);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Agregar',
                    style: TextStyle(
                        fontSize: 18,
                        color: theme.isDarkMode ? Colors.white : Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 25),
            ]),
      ),
    );
  }
}
