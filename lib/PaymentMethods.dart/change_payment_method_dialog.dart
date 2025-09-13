import 'package:flutter/material.dart';
import 'package:mercuri/Settings/payments_map.dart';
import 'package:mercuri/Settings/theme.dart';
import 'package:provider/provider.dart';

class ChangePaymentMethodDialog extends StatelessWidget {
  final List paymentMethods;
  final dynamic changePaymentMethod;
  const ChangePaymentMethodDialog(this.paymentMethods, this.changePaymentMethod,
      {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.4,
          width: (MediaQuery.of(context).size.width > 650)
              ? MediaQuery.of(context).size.width * 0.35
              : MediaQuery.of(context).size.width * 0.9,
          constraints: const BoxConstraints(minHeight: 350, minWidth: 200),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Close
              Container(
                alignment: const Alignment(1.0, 0.0),
                child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    iconSize: 20.0),
              ),
              const SizedBox(height: 15),
              //Selection
              Expanded(
                  child: ListView.builder(
                      itemCount: paymentMethods.length,
                      itemBuilder: (context, i) {
                        var iconIndex = PaymentsMap().paymentsMap.indexWhere(
                            (item) =>
                                item['Code'] == paymentMethods[i]['Icon']);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: TextButton(
                            onPressed: () {
                              changePaymentMethod(paymentMethods[i]);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  PaymentsMap().paymentsMap[iconIndex]['Icon'],
                                  color: theme.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  paymentMethods[i]['Name'],
                                  style: TextStyle(
                                      color: theme.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                        );
                      })),
            ],
          ),
        ));
  }
}
