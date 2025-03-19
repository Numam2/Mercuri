import 'package:flutter/material.dart';
import 'package:mercuri/PaymentMethods.dart/payment_icon_selection_dialog.dart';
import 'package:mercuri/Settings/theme.dart';
import 'package:provider/provider.dart';

class CreatePaymentDialog extends StatefulWidget {
  final addToList;
  const CreatePaymentDialog(this.addToList, {super.key});

  @override
  State<CreatePaymentDialog> createState() => _CreatePaymentDialogState();
}

class _CreatePaymentDialogState extends State<CreatePaymentDialog> {
  var newPaymentMethod = '';
  IconData selectedIcon = Icons.attach_money_outlined;
  String selectedIconCode = 'Efectivo';
  int selectedIconIndex = 0;
  bool allowAmortization = false;
  void selectIcon(index, icon, iconCode) {
    setState(() {
      selectedIcon = icon;
      selectedIconIndex = index;
      selectedIconCode = iconCode;
    });
  }

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
                children: [
                  Text(
                    "Nuevo medio de pago",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: theme.isDarkMode ? Colors.white : Colors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      iconSize: 20.0),
                ],
              ),
              const SizedBox(height: 8),
              //Icon
              Icon(
                selectedIcon,
                color: theme.isDarkMode ? Colors.white : Colors.black,
                size: 35,
              ),
              TextButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return PaymentIconSelectionDialog(selectIcon);
                        });
                  },
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit, color: Colors.grey, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'cambiar',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  )),
              const SizedBox(height: 8),
              //Name
              SizedBox(
                width: double.infinity,
                child: TextFormField(
                  autofocus: false,
                  style: TextStyle(
                      color: theme.isDarkMode ? Colors.white : Colors.black,
                      fontSize: 16),
                  textAlign: TextAlign.left,
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                    label: const Text('Nombre'),
                    focusColor: Colors.black,
                    errorStyle:
                        TextStyle(color: Colors.redAccent[700], fontSize: 12),
                    border: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 1)),
                  ),
                  onChanged: (value) {
                    setState(() => newPaymentMethod = value);
                  },
                ),
              ),
              const SizedBox(height: 20),
              //Allow amortized payments
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Permite cuotas',
                    style: TextStyle(
                        color: theme.isDarkMode ? Colors.white : Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                  const Spacer(),
                  //Available Button
                  Switch(
                    splashRadius: 18,
                    value: allowAmortization,
                    onChanged: (value) {
                      setState(() {
                        allowAmortization = value;
                      });
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
              const Spacer(),
              //Confirm Button
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
                    widget.addToList(
                        newPaymentMethod, selectedIconCode, allowAmortization);
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
