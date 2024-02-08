import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mercuri/Backend/database_service.dart';
import 'package:mercuri/Income%20and%20Expenses/transactions_list_view.dart';
import 'package:mercuri/Models/transactions.dart';
import 'package:mercuri/change_date_options.dart';
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

  void changeDate(int year, int month) {
    setState(() {
      selectedDate = DateTime(
        year,
        month,
      );
    });
    Navigator.of(context).pop();
  }

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
                            showModalBottomSheet(
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15))),
                                isScrollControlled: true,
                                context: context,
                                builder: (context) {
                                  return ChangeDateOptions(
                                      changeDate, selectedDate);
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
