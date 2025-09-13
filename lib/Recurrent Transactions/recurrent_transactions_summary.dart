import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mercuri/Backend/database_service.dart';
import 'package:mercuri/Models/recurrent_transactions.dart';
import 'package:mercuri/Models/user.dart';
import 'package:mercuri/Recurrent%20Transactions/pay_reccurrent_transaction.dart';
import 'package:mercuri/Settings/icons_map.dart';
import 'package:mercuri/Settings/theme.dart';
import 'package:provider/provider.dart';

class RecurrentTransactionsSummary extends StatefulWidget {
  final String uid;
  final String userName;
  final List paymentTypes;
  const RecurrentTransactionsSummary(this.uid, this.userName, this.paymentTypes,
      {super.key});

  @override
  State<RecurrentTransactionsSummary> createState() =>
      _RecurrentTransactionsSummaryState();
}

class _RecurrentTransactionsSummaryState
    extends State<RecurrentTransactionsSummary> {
  final formatCurrency = NumberFormat.simpleCurrency();

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final recurrentTransactions =
        Provider.of<List<RecurrentTransactions>?>(context);

    if (recurrentTransactions == null || recurrentTransactions.isEmpty) {
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
                  'Recurrentes',
                  style: TextStyle(
                      color: theme.isDarkMode ? Colors.white : Colors.black,
                      fontSize: 21,
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              constraints: const BoxConstraints(maxHeight: 400),
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
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recurrentTransactions.length,
                  itemBuilder: (context, i) {
                    var iconIndex = IconsMap().iconsMap.indexWhere((x) =>
                        x['Code'] ==
                        recurrentTransactions[i].category!['Icon']);
                    var itemIcon = IconsMap().iconsMap[iconIndex]['Icon'];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //Description/date
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //Icon
                                Icon(
                                  itemIcon,
                                  size: 21,
                                  color: Colors.black,
                                ),
                                const SizedBox(width: 5),
                                //Desc
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //Desc
                                    Text(
                                      recurrentTransactions[i].transactionName!,
                                      style: TextStyle(
                                          color: theme.isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    //Date
                                    Text(
                                        '${recurrentTransactions[i].monthsPaid} de ${recurrentTransactions[i].repeatxMonths}',
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 14)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 5),
                          //Buttton
                          TextButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15))),
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) {
                                    return StreamProvider<UserData?>.value(
                                      initialData: null,
                                      value: DatabaseService()
                                          .userData(widget.uid),
                                      child: PayRecurrentTransaction(
                                          widget.uid,
                                          widget.userName,
                                          recurrentTransactions[i],
                                          widget.paymentTypes),
                                    );
                                  });
                            },
                            child: const Text(
                              'Registrar',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal),
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }
}
