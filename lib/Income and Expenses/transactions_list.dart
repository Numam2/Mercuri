import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mercuri/Backend/database_service.dart';
import 'package:mercuri/Income%20and%20Expenses/transactions_list_view.dart';
import 'package:mercuri/Models/transactions.dart';
import 'package:mercuri/theme.dart';
import 'package:provider/provider.dart';

class TransactionList extends StatefulWidget {
  final String? uid;
  final bool? filtered;
  final String? transactionType;
  final DateTime? selectedDate;
  final String? selectedCategory;
  const TransactionList(
      {required this.uid,
      this.filtered,
      this.selectedDate,
      this.transactionType,
      this.selectedCategory,
      super.key});

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  //Date
  DateTime selectedDate = DateTime.now();
  List months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  List years = [2023, 2024, 2025, 2026, 2027, 2028, 2029, 2030];

  //Transaction type
  List<String> transactionTypeList = [
    'Expense',
    'Income',
    'Income and expenses'
  ];
  String transactionType = 'Income and expenses';
  bool transactionTypeFiltered = false;

  //Category
  String selectedCategory = '';

  @override
  void initState() {
    if (widget.filtered != null && widget.filtered == true) {
      selectedDate = widget.selectedDate!;
      transactionType = widget.transactionType!;
      transactionTypeFiltered = true;
      selectedCategory = widget.selectedCategory!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    Color textColor = theme.isDarkMode ? Colors.white : Colors.black;
    Color buttonColor =
        theme.isDarkMode ? Colors.black : Colors.grey.shade300.withOpacity(0.2);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            splashRadius: 24,
            icon: Icon(Icons.arrow_back,
                size: 16,
                color: theme.isDarkMode ? Colors.white : Colors.black)),
      ),
      body: CustomScrollView(
        slivers: [
          //Filters
          SliverAppBar(
            floating: true,
            backgroundColor: Colors.transparent,
            pinned: false,
            automaticallyImplyLeading: false,
            actions: <Widget>[Container()],
            expandedHeight: 60,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      //Month
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 5),
                        child: TextButton(
                          style: ButtonStyle(
                            overlayColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.hovered)) {
                                  return Colors.greenAccent.withOpacity(
                                      0.2); // Customize the hover color here
                                }
                                return Colors.greenAccent.withOpacity(
                                    0.2); // Use default overlay color for other states
                              },
                            ),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(buttonColor),
                          ),
                          onPressed: () {
                            var changeMonth = selectedDate.month - 1;
                            var changeYear = selectedDate.year;
                            showModalBottomSheet(
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15))),
                                isScrollControlled: true,
                                context: context,
                                builder: (context) {
                                  return SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.4,
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        //Title
                                        const Padding(
                                          padding: EdgeInsets.all(20.0),
                                          child: Text(
                                            "Select date",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
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
                                        //Selected date
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            //Month
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                //Text
                                                const Text(
                                                  "Month",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                                //Selected
                                                SizedBox(
                                                  height: 90,
                                                  width: 175,
                                                  child: Center(
                                                    child:
                                                        CupertinoPicker.builder(
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            itemExtent: 75,
                                                            childCount:
                                                                months.length,
                                                            onSelectedItemChanged:
                                                                (i) {
                                                              changeMonth =
                                                                  i + 1;
                                                            },
                                                            itemBuilder:
                                                                ((context,
                                                                    index) {
                                                              return Center(
                                                                child: Text(
                                                                    months[
                                                                        index]),
                                                              );
                                                            })),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(width: 15),
                                            //Year
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                //Text
                                                const Text(
                                                  "Year",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                                //Selected
                                                SizedBox(
                                                  height: 90,
                                                  width: 100,
                                                  child: Center(
                                                    child:
                                                        CupertinoPicker.builder(
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            itemExtent: 75,
                                                            childCount:
                                                                years.length,
                                                            onSelectedItemChanged:
                                                                (i) {
                                                              changeYear =
                                                                  years[i];
                                                            },
                                                            itemBuilder:
                                                                ((context,
                                                                    index) {
                                                              return Center(
                                                                child: Text(
                                                                    '${years[index]}'),
                                                              );
                                                            })),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        //Button
                                        Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Align(
                                              alignment: Alignment.bottomCenter,
                                              child: SizedBox(
                                                width: double.infinity,
                                                height: 50,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        18.0)),
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      selectedDate = DateTime(
                                                        changeYear,
                                                        changeMonth,
                                                      );
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text(
                                                    'Save',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              )),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.today_outlined,
                                size: 16,
                                color: textColor,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                DateFormat.yMMM().format(selectedDate),
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: textColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //Transaction Tyrpe
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: TextButton(
                          style: ButtonStyle(
                            overlayColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.hovered)) {
                                  return Colors.greenAccent.withOpacity(
                                      0.2); // Customize the hover color here
                                }
                                return Colors.greenAccent.withOpacity(
                                    0.2); // Use default overlay color for other states
                              },
                            ),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(buttonColor),
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    backgroundColor: theme.isDarkMode
                                        ? Colors.black
                                        : Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0)),
                                    child: Container(
                                        width: 400,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.6,
                                        padding: const EdgeInsets.all(20),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              //Cancel Icon
                                              Container(
                                                alignment:
                                                    const Alignment(1.0, 0.0),
                                                child: IconButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    icon:
                                                        const Icon(Icons.close),
                                                    color: textColor,
                                                    iconSize: 20.0),
                                              ),
                                              const SizedBox(height: 10),
                                              //Title
                                              SizedBox(
                                                width: double.infinity,
                                                child: Text(
                                                  'Transaction type',
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: true,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: textColor,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              //Payment Methods
                                              ListView.builder(
                                                  itemCount: transactionTypeList
                                                      .length,
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemBuilder: (context, i) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 10.0),
                                                      child: OutlinedButton(
                                                        style: OutlinedButton
                                                            .styleFrom(
                                                                shape: const RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.all(Radius.circular(
                                                                            12))),
                                                                side:
                                                                    BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade300,
                                                                )),
                                                        onPressed: () {
                                                          setState(() {
                                                            transactionTypeFiltered =
                                                                true;
                                                            transactionType =
                                                                transactionTypeList[
                                                                    i];
                                                          });
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(12.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              //Name
                                                              Text(
                                                                transactionTypeList[
                                                                    i],
                                                                style: TextStyle(
                                                                    color:
                                                                        textColor,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                            ],
                                          ),
                                        )),
                                  );
                                });
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.account_balance_wallet_outlined,
                                size: 16,
                                color: textColor,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                transactionType,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: textColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //Categories
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: TextButton(
                          style: ButtonStyle(
                            overlayColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.hovered)) {
                                  return Colors.greenAccent.withOpacity(
                                      0.2); // Customize the hover color here
                                }
                                return Colors.greenAccent.withOpacity(
                                    0.2); // Use default overlay color for other states
                              },
                            ),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(buttonColor),
                          ),
                          onPressed: () {},
                          child: Row(
                            children: [
                              Icon(
                                Icons.category,
                                size: 16,
                                color: textColor,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'All categories',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: textColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //Remove
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: TextButton(
                          style: ButtonStyle(
                            overlayColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.hovered)) {
                                  return Colors.greenAccent.withOpacity(
                                      0.2); // Customize the hover color here
                                }
                                return Colors.greenAccent.withOpacity(
                                    0.2); // Use default overlay color for other states
                              },
                            ),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(buttonColor),
                          ),
                          onPressed: () {
                            setState(() {
                              selectedDate = DateTime.now();
                              selectedCategory = '';
                              transactionType = 'Income and expenses';
                              transactionTypeFiltered = false;
                            });
                          },
                          child: Icon(
                            Icons.filter_alt_off_outlined,
                            size: 16,
                            color: textColor,
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
          //List
          StreamProvider<List<Transactions>>.value(
              value:
                  DatabaseService().transactionsList(widget.uid, selectedDate),
              initialData: const [],
              child: TransactionsListView(transactionType, textColor))
        ],
      ),
    );
  }
}
