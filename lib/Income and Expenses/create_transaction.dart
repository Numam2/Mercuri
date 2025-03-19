import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mercuri/Backend/database_service.dart';
import 'package:mercuri/Models/shared_accounts.dart';
import 'package:mercuri/PaymentMethods.dart/change_payment_method_dialog.dart';
import 'package:mercuri/PaymentMethods.dart/set_amortized_payment_dialog.dart';
import 'package:mercuri/Settings/icons_map.dart';
import 'package:mercuri/Settings/payments_map.dart';
import 'package:mercuri/loading.dart';
import 'package:mercuri/Settings/theme.dart';
import 'package:provider/provider.dart';

class CreateTransaction extends StatefulWidget {
  final String uid;
  final String transactionType;
  final List<dynamic> incomeCategories;
  final List<dynamic> expenseCategories;
  final String userName;
  final List paymentMethods;
  const CreateTransaction(this.uid, this.transactionType, this.incomeCategories,
      this.expenseCategories, this.userName, this.paymentMethods,
      {super.key});

  @override
  State<CreateTransaction> createState() => _CreateTransactionState();
}

class _CreateTransactionState extends State<CreateTransaction> {
  final List<String> meses = [
    'ene',
    'feb',
    'mar',
    'abr',
    'may',
    'jun',
    'jul',
    'ago',
    'sep',
    'oct',
    'nov',
    'dic'
  ];

  final controller = PageController(initialPage: 0);
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _amountFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();

  List<dynamic> expenseCategories = [];
  List<dynamic> incomeCategories = [];
  List paymentMethods = [];
  Map? selectedPaymentMethod;

  num amount = 0;
  Map selectedCategory = {};
  String description = '';
  bool loading = false;

  DateTime selectedDate = DateTime.now();

  void changePaymentMethod(Map newPaymentMethod) {
    setState(() {
      selectedPaymentMethod = newPaymentMethod;
      iconIndex = PaymentsMap()
          .paymentsMap
          .indexWhere((item) => item['Code'] == selectedPaymentMethod!['Icon']);
    });
    Navigator.of(context).pop();
    if (selectedPaymentMethod!['Accepts Amortization']) {
      showDialog(
          context: context,
          builder: (context) {
            return SetAmortizedPaymentDialog(setAmortizedPayment);
          });
    } else {
      setState(() {
        hasAmortizedPayment = false;
        repeatMonths = 0;
        monthlyPayment = 0;
      });
    }
  }

  void setAmortizedPayment(
      num amortizedAmount, num monthlyPmt, int repeatXMonths) {
    setState(() {
      _amountController.text = amortizedAmount.toString();
      amount = amortizedAmount;
      monthlyPayment = monthlyPmt;
      hasAmortizedPayment = true;
      repeatMonths = repeatXMonths;
    });
  }

  bool hasAmortizedPayment = false;
  num monthlyPayment = 0;
  int repeatMonths = 0;

  int iconIndex = 0;

  //SharedAccounts
  String assignedSharedAccounts = '';
  String assignedAcctName = '';
  Function assignAccount(String accountID, String acctName) {
    setState(() {
      assignedSharedAccounts = accountID;
      assignedAcctName = acctName;
    });
    return assignAccount;
  }

  @override
  void initState() {
    incomeCategories = widget.incomeCategories;
    expenseCategories = widget.expenseCategories;
    assignedSharedAccounts = '';
    paymentMethods = widget.paymentMethods;
    if (widget.transactionType == 'Gasto') {
      selectedPaymentMethod = widget.paymentMethods.first;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final sharedAccounts = Provider.of<List<SharedAccounts>?>(context);

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              widget.transactionType,
              style: TextStyle(
                  color: theme.isDarkMode ? Colors.white : Colors.black),
            ),
            leading: IconButton(
                splashRadius: 18,
                icon: Icon(
                  Icons.arrow_back,
                  color: (theme.isDarkMode) ? Colors.white : Colors.black,
                ),
                onPressed: () {
                  if (controller.page == 0) {
                    Navigator.of(context).pop();
                  } else if (controller.page == 1) {
                    setState(() {
                      selectedCategory = {};
                      description = '';
                    });
                    controller.previousPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease);
                  } else {
                    setState(() {
                      selectedCategory = {};
                      description = '';
                    });
                    controller.previousPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease);
                  }
                }),
            actions: [
              widget.transactionType == 'Ingreso'
                  ? const SizedBox()
                  : IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return ChangePaymentMethodDialog(
                                  paymentMethods, changePaymentMethod);
                            });
                      },
                      style: IconButton.styleFrom(
                          side: const BorderSide(color: Colors.grey, width: 1)),
                      icon: Icon(
                        PaymentsMap().paymentsMap[iconIndex]['Icon'],
                        color: theme.isDarkMode ? Colors.white : Colors.black,
                        size: 21,
                      )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      padding: const EdgeInsets.all(2),
                      side: const BorderSide(color: Colors.grey, width: 1)),
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        helpText: 'Fecha del gasto',
                        confirmText: 'Guardar',
                        cancelText: 'Cancelar',
                        initialDate: DateTime.now(),
                        firstDate:
                            DateTime.now().subtract(const Duration(days: 60)),
                        lastDate: DateTime.now(),
                        builder: ((context, child) {
                          return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary:
                                      Colors.black, // header background color
                                  onPrimary: Colors.white, // header text color
                                  onSurface: Colors.black, // body text color
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    foregroundColor:
                                        Colors.black, // button text color
                                  ),
                                ),
                              ),
                              child: child!);
                        }));
                    if (pickedDate != null) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                  child: Text(
                    '${selectedDate.day} ${meses[selectedDate.month - 1]}',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ]),
        body: Stack(
          children: [
            PageView(
              controller: controller,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                //Page 1
                Scaffold(
                    body: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Stack(
                    children: [
                      //Input amount
                      Center(
                        child: SizedBox(
                          width: double.infinity,
                          child: TextFormField(
                            autofocus: true,
                            style: GoogleFonts.eczar(
                                color: theme.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 45),
                            textAlign: TextAlign.center,
                            controller: _amountController,
                            focusNode: _amountFocusNode,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            cursorColor: Colors.grey,
                            inputFormatters: [
                              CurrencyInputFormatter(),
                            ],
                            decoration: InputDecoration(
                              hintText: '\$0.00',
                              hintStyle: GoogleFonts.eczar(
                                  color: Colors.grey, fontSize: 45),
                              focusColor: Colors.black,
                              errorStyle: TextStyle(
                                  color: Colors.redAccent[700], fontSize: 12),
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              // Remove formatting characters (dots and commas)
                              String rawValue =
                                  value.replaceAll(RegExp(r'[,]'), '');
                              setState(() {
                                amount = double.parse(rawValue);
                              });
                            },
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (String val) {
                              if (val != '' && amount != 0) {
                                controller.nextPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.ease);
                                _amountFocusNode.unfocus();
                              }
                            },
                          ),
                        ),
                      ),
                      //Button
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  splashFactory: NoSplash.splashFactory,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(18.0)),
                                  backgroundColor: Colors.transparent,
                                  side: BorderSide(
                                      color: theme.isDarkMode
                                          ? Colors.grey
                                          : Colors.grey)),
                              onPressed: () {
                                if (amount != 0) {
                                  controller.nextPage(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.ease);
                                  _amountFocusNode.unfocus();
                                }
                              },
                              child: Text(
                                'Siguiente',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: theme.isDarkMode
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          ))
                    ],
                  ),
                )),
                //Page 2
                Scaffold(
                    body: ListView.builder(
                        itemCount: (widget.transactionType == 'Ingreso')
                            ? incomeCategories.length
                            : expenseCategories.length,
                        itemBuilder: (context, i) {
                          IconData itemIcon;
                          String name;
                          int iconIndex = 0;
                          String iconCode = '';

                          if (widget.transactionType == 'Ingreso') {
                            name = incomeCategories[i]['Category'];
                            iconIndex = IconsMap().iconsMap.indexWhere((item) =>
                                item['Code'] == incomeCategories[i]['Icon']);
                            iconCode = incomeCategories[i]['Icon'];
                            itemIcon = IconsMap().iconsMap[iconIndex]['Icon'];
                          } else {
                            name = expenseCategories[i]['Category'];
                            iconIndex = IconsMap().iconsMap.indexWhere((item) =>
                                item['Code'] == expenseCategories[i]['Icon']);
                            iconCode = expenseCategories[i]['Icon'];
                            itemIcon = IconsMap().iconsMap[iconIndex]['Icon'];
                          }

                          return TextButton(
                            onPressed: () {
                              setState(() {
                                selectedCategory = {
                                  'Name': name,
                                  'Icon': itemIcon,
                                  'Icon Code': iconCode
                                };
                                description = selectedCategory['Name'];
                              });
                              controller.nextPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.ease);
                              _nameFocusNode.requestFocus();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 5),
                              child: Row(
                                children: [
                                  Icon(
                                    itemIcon,
                                    color: theme.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 15),
                                  Text(
                                    name,
                                    style: TextStyle(
                                      color: theme.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        })),
                // Page 3
                Scaffold(
                    body: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Stack(
                    children: [
                      //Description
                      Center(
                        child: SizedBox(
                          width: double.infinity,
                          child: TextFormField(
                            autofocus: true,
                            focusNode: _nameFocusNode,
                            style: TextStyle(
                                color: theme.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 24),
                            textAlign: TextAlign.center,
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(
                              hintText: selectedCategory['Name'],
                              hintStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 24),
                              focusColor: Colors.black,
                              errorStyle: TextStyle(
                                  color: Colors.redAccent[700], fontSize: 12),
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              setState(() {
                                description = value;
                              });
                            },
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (String val) {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ),
                      (sharedAccounts == null || sharedAccounts.isEmpty)
                          ? Align(
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0)),
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      loading = true;
                                    });
                                    await DatabaseService()
                                        .createTransaction(
                                            widget.uid,
                                            DateTime.now().toString(),
                                            selectedDate,
                                            widget.transactionType,
                                            selectedCategory['Name'],
                                            description,
                                            amount,
                                            selectedPaymentMethod!)
                                        .then((value) => DatabaseService()
                                            .updateStats(
                                                widget.uid,
                                                selectedDate,
                                                widget.transactionType,
                                                selectedCategory['Name'],
                                                amount,
                                                selectedPaymentMethod!))
                                        .then((value) =>
                                            Navigator.of(context).pop());
                                  },
                                  child: const Text(
                                    'Guardar',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                              ))
                          : //Button
                          Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                  //Associate shared account
                                  SizedBox(
                                    width: 200,
                                    child: (assignedSharedAccounts != '')
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.group_outlined,
                                                color: theme.isDarkMode
                                                    ? Colors.white
                                                    : Colors.black,
                                                size: 21,
                                              ),
                                              const SizedBox(width: 3),
                                              Text(
                                                assignedAcctName,
                                                style: TextStyle(
                                                    color: theme.isDarkMode
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontSize: 14),
                                              ),
                                              const SizedBox(width: 20),
                                              IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    assignedSharedAccounts = '';
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.close,
                                                  color: theme.isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                  size: 18,
                                                ),
                                              )
                                            ],
                                          )
                                        : TextButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AssignSharedAcctDialog(
                                                        sharedAccounts,
                                                        theme,
                                                        assignAccount,
                                                        widget.transactionType);
                                                  });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              padding: const EdgeInsets.all(5),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18.0)),
                                              backgroundColor:
                                                  Colors.grey.withOpacity(0.1),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.group_outlined,
                                                  size: 18,
                                                  color: theme.isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  'Asociar cuenta compartida',
                                                  style: TextStyle(
                                                      color: theme.isDarkMode
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize: 12),
                                                )
                                              ],
                                            )),
                                  ),
                                  const SizedBox(height: 10),
                                  //Button
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0)),
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      onPressed: () async {
                                        setState(() {
                                          loading = true;
                                        });
                                        if (hasAmortizedPayment) {
                                          DatabaseService()
                                              .createRecurrentTransaction(
                                                  widget.uid,
                                                  DateTime.now().toString(),
                                                  description,
                                                  widget.transactionType,
                                                  true,
                                                  amount,
                                                  DateTime.now(),
                                                  repeatMonths, {
                                            'Category':
                                                selectedCategory['Name'],
                                            'Icon':
                                                selectedCategory['Icon Code']
                                          }).then((v) {
                                            Navigator.of(context).pop();
                                          });
                                        } else {
                                          //Update shared accts if aplicable
                                          if (assignedSharedAccounts != '') {
                                            await DatabaseService()
                                                .createSharedTransaction(
                                                    assignedSharedAccounts,
                                                    DateTime.now().toString(),
                                                    selectedDate,
                                                    widget.userName,
                                                    widget.uid,
                                                    widget.transactionType,
                                                    selectedCategory['Name'],
                                                    description,
                                                    amount, {}).then((v) {
                                              //Update Shated Acct Stats
                                              DatabaseService()
                                                  .updateSharedTransactionsStats(
                                                      assignedSharedAccounts,
                                                      selectedDate,
                                                      widget.userName,
                                                      widget.transactionType,
                                                      selectedCategory['Name'],
                                                      amount);
                                            });
                                          }
                                          //Create transaction
                                          await DatabaseService()
                                              .createTransaction(
                                                  widget.uid,
                                                  DateTime.now().toString(),
                                                  selectedDate,
                                                  widget.transactionType,
                                                  selectedCategory['Name'],
                                                  description,
                                                  amount,
                                                  selectedPaymentMethod!)
                                              .then((value) => DatabaseService()
                                                  .updateStats(
                                                      widget.uid,
                                                      selectedDate,
                                                      widget.transactionType,
                                                      selectedCategory['Name'],
                                                      amount,
                                                      selectedPaymentMethod!))
                                              .then((value) =>
                                                  Navigator.of(context).pop());
                                        }
                                      },
                                      child: const Text(
                                        'Guardar',
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ]),
                    ],
                  ),
                )),
              ],
            ),
            //Loading
            (loading)
                ? Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.grey.withOpacity(0.5),
                    child: const Loading(),
                  )
                : const SizedBox()
          ],
        ));
  }
}

///////////////Input formatter//////////////////////
class CurrencyInputFormatter extends TextInputFormatter {
  final validationRegex = RegExp(r'^[\d,]*\.?\d*$');
  final replaceRegex = RegExp(r'[^\d\.]+');
  static const fractionalDigits = 2;
  static const thousandSeparator = ',';
  static const decimalSeparator = '.';

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (!validationRegex.hasMatch(newValue.text)) {
      return oldValue;
    }

    final newValueNumber = newValue.text.replaceAll(replaceRegex, '');

    var formattedText = newValueNumber;

    /// Add thousand separators.
    var index = newValueNumber.contains(decimalSeparator)
        ? newValueNumber.indexOf(decimalSeparator)
        : newValueNumber.length;

    while (index > 0) {
      index -= 3;

      if (index > 0) {
        formattedText = formattedText.substring(0, index) +
            thousandSeparator +
            formattedText.substring(index, formattedText.length);
      }
    }

    /// Limit the number of decimal digits.
    final decimalIndex = formattedText.indexOf(decimalSeparator);
    var removedDecimalDigits = 0;

    if (decimalIndex != -1) {
      var decimalText = formattedText.substring(decimalIndex + 1);

      if (decimalText.isNotEmpty && decimalText.length > fractionalDigits) {
        removedDecimalDigits = decimalText.length - fractionalDigits;
        decimalText = decimalText.substring(0, fractionalDigits);
        formattedText = formattedText.substring(0, decimalIndex) +
            decimalSeparator +
            decimalText;
      }
    }

    /// Check whether the text is unmodified.
    if (oldValue.text == formattedText) {
      return oldValue;
    }

    /// Handle moving cursor.
    final initialNumberOfPrecedingSeparators =
        oldValue.text.characters.where((e) => e == thousandSeparator).length;
    final newNumberOfPrecedingSeparators =
        formattedText.characters.where((e) => e == thousandSeparator).length;
    final additionalOffset =
        newNumberOfPrecedingSeparators - initialNumberOfPrecedingSeparators;

    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(
          offset: newValue.selection.baseOffset +
              additionalOffset -
              removedDecimalDigits),
    );
  }
}

///////////////Assign shared acct//////////////////////
class AssignSharedAcctDialog extends StatefulWidget {
  final List<SharedAccounts> sharedAccounts;
  final ThemeProvider theme;
  final Function assignAccount;
  final String transactionType;
  const AssignSharedAcctDialog(
      this.sharedAccounts, this.theme, this.assignAccount, this.transactionType,
      {super.key});

  @override
  State<AssignSharedAcctDialog> createState() => _AssignSharedAcctDialogState();
}

class _AssignSharedAcctDialogState extends State<AssignSharedAcctDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: SizedBox(
        height: 400,
        width: 400,
        child: Padding(
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
                  "Asignar cuenta compartida",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:
                        widget.theme.isDarkMode ? Colors.white : Colors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(
                  indent: 10,
                  endIndent: 10,
                  color: Colors.grey,
                  thickness: 1,
                ),
              ),
              //Accounts
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.sharedAccounts.length,
                    itemBuilder: (context, i) {
                      return StreamProvider<SharedAccounts?>.value(
                          initialData: null,
                          value: DatabaseService()
                              .sharedAcct(widget.sharedAccounts[i].accountID),
                          child: SharedAcctCard(
                              widget.theme, widget.assignAccount));
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///////////////Acct CARD//////////////////////
///
class SharedAcctCard extends StatelessWidget {
  final ThemeProvider theme;
  final Function assignAccount;
  const SharedAcctCard(this.theme, this.assignAccount, {super.key});

  @override
  Widget build(BuildContext context) {
    final sharedAccount = Provider.of<SharedAccounts?>(context);
    if (sharedAccount == null) {
      return const SizedBox(
        child: Text('Nada por aca'),
      );
    }
    return TextButton(
      style:
          TextButton.styleFrom(backgroundColor: Colors.grey.withOpacity(0.15)),
      onPressed: () {
        assignAccount(sharedAccount.accountID, sharedAccount.accountName);
        Navigator.of(context).pop();
      },
      child: SizedBox(
        width: double.infinity,
        child: Text(
          sharedAccount.accountName!,
          style: TextStyle(
            fontSize: 14,
            color: theme.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
