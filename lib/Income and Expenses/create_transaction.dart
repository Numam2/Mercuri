import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mercuri/Backend/database_service.dart';
import 'package:mercuri/loading.dart';
import 'package:mercuri/theme.dart';
import 'package:provider/provider.dart';

class CreateTransaction extends StatefulWidget {
  final String uid;
  final String transactionType;
  const CreateTransaction(this.uid, this.transactionType, {super.key});

  @override
  State<CreateTransaction> createState() => _CreateTransactionState();
}

class _CreateTransactionState extends State<CreateTransaction> {
  final controller = PageController(initialPage: 0);
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _amountFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();

  List<Map> expenseCategories = [
    {
      'Name': 'Groceries',
      'Icon': Icons.local_grocery_store_outlined,
    },
    {
      'Name': 'Home',
      'Icon': Icons.home_outlined,
    },
    {
      'Name': 'Entertainment',
      'Icon': Icons.tv_outlined,
    },
    {
      'Name': 'Education',
      'Icon': Icons.school_outlined,
    },
    {
      'Name': 'Health & Wellness',
      'Icon': Icons.fitness_center,
    },
    {
      'Name': 'Eat out',
      'Icon': Icons.fastfood_outlined,
    },
    {'Name': 'Transportation', 'Icon': Icons.emoji_transportation_outlined},
    {'Name': 'Shopping', 'Icon': Icons.shopping_bag_outlined},
    {
      'Name': 'Others',
      'Icon': Icons.account_balance_wallet,
    },
  ];
  List<Map> incomeCategories = [
    {
      'Name': 'Salary',
      'Icon': Icons.money_sharp,
    },
    {
      'Name': 'Investment returns',
      'Icon': Icons.monetization_on_outlined,
    },
    {
      'Name': 'Others',
      'Icon': Icons.account_balance_wallet,
    },
  ];

  num amount = 0;
  Map selectedCategory = {};
  String description = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
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
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
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
                                'Next',
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
                        itemCount: (widget.transactionType == 'Income')
                            ? incomeCategories.length
                            : expenseCategories.length,
                        itemBuilder: (context, i) {
                          IconData itemIcon;
                          String name;

                          if (widget.transactionType == 'Income') {
                            itemIcon = incomeCategories[i]['Icon'];
                            name = incomeCategories[i]['Name'];
                          } else {
                            itemIcon = expenseCategories[i]['Icon'];
                            name = expenseCategories[i]['Name'];
                          }

                          return TextButton(
                            onPressed: () {
                              setState(() {
                                selectedCategory = {
                                  'Name': name,
                                  'Icon': itemIcon
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
                      //Button
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0)),
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
                                        DateTime.now(),
                                        widget.transactionType,
                                        selectedCategory['Name'],
                                        description,
                                        amount)
                                    .then((value) => DatabaseService()
                                        .updateStats(
                                            widget.uid,
                                            DateTime.now(),
                                            widget.transactionType,
                                            selectedCategory['Name'],
                                            amount))
                                    .then(
                                        (value) => Navigator.of(context).pop());
                              },
                              child: const Text(
                                'SAVE',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                          )),
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
