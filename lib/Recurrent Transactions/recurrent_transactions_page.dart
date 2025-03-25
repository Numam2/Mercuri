import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mercuri/Backend/database_service.dart';
import 'package:mercuri/Models/recurrent_transactions.dart';
import 'package:mercuri/Models/shared_accounts.dart';
import 'package:mercuri/Recurrent%20Transactions/add_reccurrent_transaction.dart';
import 'package:mercuri/Recurrent%20Transactions/pay_reccurrent_transaction.dart';
import 'package:mercuri/Settings/icons_map.dart';
import 'package:mercuri/Settings/theme.dart';
import 'package:mercuri/loading.dart';
import 'package:provider/provider.dart';

class RecurrentTransactionsPage extends StatelessWidget {
  final String uid;
  final String userName;
  final List<dynamic> incomeCategories;
  final List<dynamic> expenseCategories;
  final List paymentTypes;
  RecurrentTransactionsPage(this.uid, this.userName, this.incomeCategories,
      this.expenseCategories, this.paymentTypes,
      {super.key});

  final formatCurrency = NumberFormat.simpleCurrency();

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final recurrentTransactions =
        Provider.of<List<RecurrentTransactions>?>(context);

    if (recurrentTransactions == null || recurrentTransactions.isEmpty) {
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Text('No hay transacciones para mostrar'),
      );
    }
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
          'Transacciones Recurrentes',
          style: TextStyle(
              color: theme.isDarkMode ? Colors.white : Colors.black,
              fontSize: 16),
        ),
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return StreamProvider<List<SharedAccounts>?>.value(
                      value: DatabaseService().sharedAcctsList(uid),
                      initialData: const [],
                      child: AddRecurrentTransaction(
                          incomeCategories, expenseCategories),
                    );
                  })),
              icon: Icon(Icons.add,
                  color: theme.isDarkMode ? Colors.white : Colors.black,
                  size: 21)),
        ],
      ),
      body: ListView.builder(
          itemCount: recurrentTransactions!.length,
          itemBuilder: (context, i) {
            var iconIndex = IconsMap().iconsMap.indexWhere(
                (x) => x['Code'] == recurrentTransactions[i].category!['Icon']);
            var itemIcon = IconsMap().iconsMap[iconIndex]['Icon'];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: TextButton(
                onPressed: () {
                  showModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15))),
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return PayRecurrentTransaction(uid, userName,
                            recurrentTransactions[i], paymentTypes);
                      });
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //Data
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //Icon
                          Icon(
                            itemIcon,
                            size: 30,
                            color:
                                theme.isDarkMode ? Colors.white : Colors.black,
                          ),
                          const SizedBox(width: 10),
                          //Data
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              //Name
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    recurrentTransactions[i].transactionName!,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: theme.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 21),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    '${recurrentTransactions[i].monthsPaid}/${recurrentTransactions[i].repeatxMonths}',
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                  ),
                                ],
                              ),
                              (recurrentTransactions[i].associatedSharedAcct !=
                                          null &&
                                      recurrentTransactions[i]
                                          .associatedSharedAcct!
                                          .isNotEmpty)
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.people_outline_outlined,
                                          size: 14,
                                          color: Colors.grey,
                                        ),
                                        Text(
                                          recurrentTransactions[i]
                                              .associatedSharedAcct!['Name'],
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 12),
                                        ),
                                      ],
                                    )
                                  : const SizedBox(),
                              //Amount
                              Text(
                                formatCurrency.format(
                                    recurrentTransactions[i].recurrentAmount!),
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 5),
                    IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return DeleteTransactionDialog(
                                    recurrentTransactions[i].transactionName!,
                                    theme,
                                    uid,
                                    recurrentTransactions[i]);
                              });
                        },
                        icon: Icon(
                          Icons.delete_outline,
                          size: 21,
                          color: theme.isDarkMode ? Colors.white : Colors.black,
                        ))
                  ],
                ),
              ),
            );
          }),
    );
  }
}

////// Delete
class DeleteTransactionDialog extends StatefulWidget {
  final String title;
  final ThemeProvider theme;
  final String uid;
  final RecurrentTransactions recurrentTransaction;
  const DeleteTransactionDialog(
      this.title, this.theme, this.uid, this.recurrentTransaction,
      {super.key});

  @override
  State<DeleteTransactionDialog> createState() =>
      _DeleteTransactionDialogState();
}

class _DeleteTransactionDialogState extends State<DeleteTransactionDialog> {
  bool loading = false;

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
                      "Eliminar -${widget.title}- de mis transacciones recurrentes",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: widget.theme.isDarkMode
                            ? Colors.white
                            : Colors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
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
                                  .deleteRecurrentTransaction(widget.uid,
                                      widget.recurrentTransaction.id!)
                                  .then((v) {
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
