import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mercuri/Backend/database_service.dart';
import 'package:mercuri/PaymentMethods.dart/create_payment_dialog.dart';
import 'package:mercuri/Settings/payments_map.dart';
import 'package:mercuri/Settings/theme.dart';
import 'package:provider/provider.dart';

class PaymentsHome extends StatefulWidget {
  final List paymentMethods;
  final String uid;
  const PaymentsHome(this.paymentMethods, this.uid, {super.key});

  @override
  State<PaymentsHome> createState() => _PaymentsHomeState();
}

class _PaymentsHomeState extends State<PaymentsHome> {
  List<Map> paymentMethods = [];
  ValueKey redrawObject = const ValueKey('List');
  void nothing(BuildContext context) {}
  void addToList(String name, String icon, bool acceptsAmortization) {
    setState(() {
      paymentMethods.add({
        'Name': name,
        'Icon': icon,
        'Accepts Amortization': acceptsAmortization
      });
      listIsChanged = true;
    });
  }

  bool listIsChanged = false;

  @override
  void initState() {
    if (widget.paymentMethods.isNotEmpty) {
      for (var i = 0; i < widget.paymentMethods.length; i++) {
        paymentMethods.add({
          'Name': widget.paymentMethods[i]['Name'],
          'Icon': widget.paymentMethods[i]['Icon'],
          'Accepts Amortization': widget.paymentMethods[i]
              ['Accepts Amortization'],
        });
      }
    } else {
      paymentMethods = [];
    }

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
          'Medios de pago',
          style: TextStyle(
              color: theme.isDarkMode ? Colors.white : Colors.black,
              fontSize: 14),
        ),
        actions: [
          Container(
            width: 70,
            color: Colors.transparent,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //Title and Add
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //Add
                      TextButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return CreatePaymentDialog(addToList);
                                });
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.add,
                                color: theme.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                size: 14,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                'Agregar',
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
                  const SizedBox(height: 20),
                  //List of Categories
                  (paymentMethods.isEmpty)
                      ? const SizedBox()
                      : Expanded(
                          child: ReorderableListView.builder(
                              itemCount: paymentMethods.length,
                              shrinkWrap: true,
                              key: redrawObject,
                              onReorder: (oldIndex, newIndex) {
                                if (newIndex > oldIndex) {
                                  newIndex = newIndex - 1;
                                }

                                setState(() {
                                  listIsChanged = true;
                                  paymentMethods.insert(newIndex,
                                      paymentMethods.removeAt(oldIndex));
                                });
                              },
                              itemBuilder: (context, i) {
                                var iconIndex = PaymentsMap()
                                    .paymentsMap
                                    .indexWhere((item) =>
                                        item['Code'] ==
                                        paymentMethods[i]['Icon']);
                                return Dismissible(
                                  key: ValueKey(i),
                                  confirmDismiss: (direction) {
                                    return showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Center(
                                            child: SingleChildScrollView(
                                              child: Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0)),
                                                child: Container(
                                                  width: 450,
                                                  height: 300,
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          30.0, 20.0, 30.0, 20),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      //Title
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          "Eliminar ${paymentMethods[i]['Name']} de mis medios de pago",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 20.0,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 25,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          //Yes
                                                          Expanded(
                                                            child: SizedBox(
                                                              height: 45,
                                                              child:
                                                                  ElevatedButton(
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(18.0)),
                                                                        backgroundColor: Theme.of(context)
                                                                            .colorScheme
                                                                            .primary,
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        paymentMethods
                                                                            .removeAt(i);

                                                                        final random =
                                                                            Random();
                                                                        const availableChars =
                                                                            'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
                                                                        final randomString = List.generate(
                                                                            10,
                                                                            (index) =>
                                                                                availableChars[random.nextInt(availableChars.length)]).join();
                                                                        setState(
                                                                            () {
                                                                          listIsChanged =
                                                                              true;
                                                                          redrawObject =
                                                                              ValueKey(randomString);
                                                                        });
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child:
                                                                          const Padding(
                                                                        padding: EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                5,
                                                                            vertical:
                                                                                5),
                                                                        child:
                                                                            Text(
                                                                          'Eliminar',
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        ),
                                                                      )),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 15,
                                                          ),
                                                          //No
                                                          Expanded(
                                                            child: SizedBox(
                                                              height: 45,
                                                              child: TextButton(
                                                                  style: TextButton.styleFrom(
                                                                      splashFactory:
                                                                          NoSplash
                                                                              .splashFactory,
                                                                      elevation:
                                                                          0,
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(
                                                                              18.0)),
                                                                      backgroundColor:
                                                                          Colors
                                                                              .transparent,
                                                                      side: BorderSide(
                                                                          color: theme.isDarkMode
                                                                              ? Colors.grey
                                                                              : Colors.grey)),
                                                                  onPressed: () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child: Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            5,
                                                                        vertical:
                                                                            5),
                                                                    child: Text(
                                                                      'No',
                                                                      style: TextStyle(
                                                                          color: theme.isDarkMode
                                                                              ? Colors.white
                                                                              : Colors.black),
                                                                    ),
                                                                  )),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 25),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  onDismissed: (direction) {
                                    if (direction ==
                                        DismissDirection.endToStart) {
                                      paymentMethods.removeAt(i);

                                      final random = Random();
                                      const availableChars =
                                          'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
                                      final randomString = List.generate(
                                              10,
                                              (index) => availableChars[
                                                  random.nextInt(
                                                      availableChars.length)])
                                          .join();
                                      setState(() {
                                        listIsChanged = true;
                                        redrawObject = ValueKey(randomString);
                                      });
                                    }
                                  },
                                  child: SizedBox(
                                    key: ValueKey(i),
                                    child: ListTile(
                                      onTap: () {}, // Edit name or icon?
                                      title: i == 0
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  PaymentsMap().paymentsMap[
                                                      iconIndex]['Icon'],
                                                  color: theme.isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                  size: 24,
                                                ),
                                                const SizedBox(width: 8),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      paymentMethods[i]['Name'],
                                                      style: TextStyle(
                                                          color: theme
                                                                  .isDarkMode
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    Text(
                                                      '[Predefinido]',
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          fontSize: 12,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  PaymentsMap().paymentsMap[
                                                      iconIndex]['Icon'],
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
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              ],
                                            ),
                                      leading: Text(
                                        '${i + 1}° ',
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 11),
                                      ),
                                      trailing: const Icon(
                                        Icons.menu,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            //Save
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0)),
                    backgroundColor: listIsChanged
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey),
                onPressed: () async {
                  if (listIsChanged) {
                    DatabaseService()
                        .updatePaymentMethods(widget.uid, paymentMethods);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text(
                  'Guardar',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
