import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mercuri/Backend/database_service.dart';
import 'package:mercuri/Income%20and%20Expenses/transactions_list_view.dart';
import 'package:mercuri/Models/transactions.dart';
import 'package:mercuri/Income%20and%20Expenses/change_date_options.dart';
import 'package:mercuri/Settings/icons_map.dart';
import 'package:mercuri/Settings/payments_map.dart';
import 'package:mercuri/Settings/theme.dart';
import 'package:provider/provider.dart';

class TransactionList extends StatefulWidget {
  final String? uid;
  final bool? filtered;
  final String? transactionType;
  final DateTime? selectedDate;
  final String? selectedCategory;
  final List<dynamic> incomeCategories;
  final List<dynamic> expenseCategories;
  final List<dynamic> paymentMethods;
  const TransactionList(
      {required this.uid,
      this.filtered,
      this.selectedDate,
      this.transactionType,
      this.selectedCategory,
      required this.incomeCategories,
      required this.expenseCategories,
      required this.paymentMethods,
      super.key});

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  //Date
  DateTime selectedDate = DateTime.now();

  //Transaction type
  List<String> transactionTypeList = ['Gasto', 'Ingreso', 'Ingresos y gastos'];
  String transactionType = 'Ingresos y gastos';
  bool transactionTypeFiltered = false;

  //Category
  String selectedCategory = '';
  IconData? selectedCategoryIcon;

  void changeDate(int year, int month) {
    setState(() {
      selectedDate = DateTime(
        year,
        month,
      );
    });
    Navigator.of(context).pop();
  }

  //PaymentMethod
  String selectedPaymentMethod = '';
  IconData selectedPaymentIcon = Icons.attach_money_outlined;

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
                                WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                                if (states.contains(WidgetState.hovered)) {
                                  return Colors.greenAccent.withOpacity(
                                      0.2); // Customize the hover color here
                                }
                                return Colors.greenAccent.withOpacity(
                                    0.2); // Use default overlay color for other states
                              },
                            ),
                            backgroundColor:
                                WidgetStateProperty.all<Color>(buttonColor),
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
                                WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                                if (states.contains(WidgetState.hovered)) {
                                  return Colors.greenAccent.withOpacity(
                                      0.2); // Customize the hover color here
                                }
                                return Colors.greenAccent.withOpacity(
                                    0.2); // Use default overlay color for other states
                              },
                            ),
                            backgroundColor:
                                WidgetStateProperty.all<Color>(buttonColor),
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
                                                  'Tipo de transacción',
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
                                              //Transaction Type
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
                                                            selectedCategory =
                                                                '';
                                                            selectedCategoryIcon =
                                                                null;
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
                      transactionType == 'Ingresos y gastos'
                          ? const SizedBox()
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: TextButton(
                                style: ButtonStyle(
                                  overlayColor:
                                      WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                      if (states
                                          .contains(WidgetState.hovered)) {
                                        return Colors.greenAccent.withOpacity(
                                            0.2); // Customize the hover color here
                                      }
                                      return Colors.greenAccent.withOpacity(
                                          0.2); // Use default overlay color for other states
                                    },
                                  ),
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          buttonColor),
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
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
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
                                                          const Alignment(
                                                              1.0, 0.0),
                                                      child: IconButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context),
                                                          icon: const Icon(
                                                              Icons.close),
                                                          color: textColor,
                                                          iconSize: 20.0),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    //Title
                                                    SizedBox(
                                                      width: double.infinity,
                                                      child: Text(
                                                        'Categoría',
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        softWrap: true,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: textColor,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 20),
                                                    //Categories
                                                    ListView.builder(
                                                        itemCount: transactionType ==
                                                                'Ingreso'
                                                            ? widget
                                                                .incomeCategories
                                                                .length
                                                            : widget
                                                                .expenseCategories
                                                                .length,
                                                        shrinkWrap: true,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        itemBuilder:
                                                            (context, i) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    bottom:
                                                                        10.0),
                                                            child:
                                                                OutlinedButton(
                                                              style: OutlinedButton
                                                                  .styleFrom(
                                                                      shape: const RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.all(Radius.circular(
                                                                              12))),
                                                                      side:
                                                                          BorderSide(
                                                                        width:
                                                                            1,
                                                                        color: Colors
                                                                            .grey
                                                                            .shade300,
                                                                      )),
                                                              onPressed: () {
                                                                setState(() {
                                                                  if (transactionType ==
                                                                      'Ingreso') {
                                                                    selectedCategory =
                                                                        widget.incomeCategories[i]
                                                                            [
                                                                            'Category'];
                                                                    var iconFromMap = IconsMap()
                                                                        .iconsMap
                                                                        .indexWhere((item) =>
                                                                            item['Code'] ==
                                                                            widget.incomeCategories[i]['Icon']);
                                                                    selectedCategoryIcon =
                                                                        IconsMap().iconsMap[iconFromMap]
                                                                            [
                                                                            'Icon'];
                                                                  } else {
                                                                    selectedCategory =
                                                                        widget.expenseCategories[i]
                                                                            [
                                                                            'Category'];
                                                                    var iconFromMap = IconsMap()
                                                                        .iconsMap
                                                                        .indexWhere((item) =>
                                                                            item['Code'] ==
                                                                            widget.expenseCategories[i]['Icon']);
                                                                    selectedCategoryIcon =
                                                                        IconsMap().iconsMap[iconFromMap]
                                                                            [
                                                                            'Icon'];
                                                                  }
                                                                });
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        12.0),
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
                                                                      transactionType ==
                                                                              'Ingreso'
                                                                          ? widget.incomeCategories[i]
                                                                              [
                                                                              'Category']
                                                                          : widget.expenseCategories[i]
                                                                              [
                                                                              'Category'],
                                                                      style: TextStyle(
                                                                          color:
                                                                              textColor,
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.normal),
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
                                      selectedCategory == ''
                                          ? Icons.category
                                          : selectedCategoryIcon,
                                      size: 16,
                                      color: textColor,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      selectedCategory != ''
                                          ? selectedCategory
                                          : 'Todas las categorías',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: textColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      transactionType == 'Gasto'
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: TextButton(
                                style: ButtonStyle(
                                  overlayColor:
                                      WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                      if (states
                                          .contains(WidgetState.hovered)) {
                                        return Colors.greenAccent.withOpacity(
                                            0.2); // Customize the hover color here
                                      }
                                      return Colors.greenAccent.withOpacity(
                                          0.2); // Use default overlay color for other states
                                    },
                                  ),
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          buttonColor),
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
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
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
                                                          const Alignment(
                                                              1.0, 0.0),
                                                      child: IconButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context),
                                                          icon: const Icon(
                                                              Icons.close),
                                                          color: textColor,
                                                          iconSize: 20.0),
                                                    ),
                                                    //Title
                                                    SizedBox(
                                                      width: double.infinity,
                                                      child: Text(
                                                        'Medio de pago',
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        softWrap: true,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: textColor,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 20),
                                                    //Categories
                                                    ListView.builder(
                                                        itemCount: widget
                                                            .paymentMethods
                                                            .length,
                                                        shrinkWrap: true,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        itemBuilder:
                                                            (context, i) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    bottom:
                                                                        10.0),
                                                            child:
                                                                OutlinedButton(
                                                              style: OutlinedButton
                                                                  .styleFrom(
                                                                      shape: const RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.all(Radius.circular(
                                                                              12))),
                                                                      side:
                                                                          BorderSide(
                                                                        width:
                                                                            1,
                                                                        color: Colors
                                                                            .grey
                                                                            .shade300,
                                                                      )),
                                                              onPressed: () {
                                                                setState(() {
                                                                  selectedPaymentMethod =
                                                                      widget.paymentMethods[
                                                                              i]
                                                                          [
                                                                          'Name'];
                                                                  var iconFromMap = PaymentsMap()
                                                                      .paymentsMap
                                                                      .indexWhere((item) =>
                                                                          item[
                                                                              'Code'] ==
                                                                          widget.paymentMethods[i]
                                                                              [
                                                                              'Icon']);
                                                                  selectedPaymentIcon =
                                                                      PaymentsMap()
                                                                              .paymentsMap[iconFromMap]
                                                                          [
                                                                          'Icon'];
                                                                });
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        12.0),
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
                                                                      widget.paymentMethods[
                                                                              i]
                                                                          [
                                                                          'Name'],
                                                                      style: TextStyle(
                                                                          color:
                                                                              textColor,
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.normal),
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
                                      selectedPaymentIcon,
                                      size: 16,
                                      color: textColor,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      selectedPaymentMethod != ''
                                          ? selectedPaymentMethod
                                          : 'Todos los medios de pago',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: textColor),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox(),
                      //Remove
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: TextButton(
                          style: ButtonStyle(
                            overlayColor:
                                WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                                if (states.contains(WidgetState.hovered)) {
                                  return Colors.greenAccent.withOpacity(
                                      0.2); // Customize the hover color here
                                }
                                return Colors.greenAccent.withOpacity(
                                    0.2); // Use default overlay color for other states
                              },
                            ),
                            backgroundColor:
                                WidgetStateProperty.all<Color>(buttonColor),
                          ),
                          onPressed: () {
                            setState(() {
                              selectedDate = DateTime.now();
                              selectedCategory = '';
                              transactionType = 'Ingresos y gastos';
                              transactionTypeFiltered = false;
                              selectedPaymentMethod = '';
                              selectedPaymentIcon = Icons.attach_money_outlined;
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
              child: TransactionsListView(transactionType, textColor,
                  selectedCategory, selectedPaymentMethod))
        ],
      ),
    );
  }
}
