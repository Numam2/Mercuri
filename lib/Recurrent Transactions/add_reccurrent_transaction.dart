import 'package:flutter/material.dart';
import 'package:mercuri/Backend/auth_service.dart';
import 'package:mercuri/Backend/database_service.dart';
import 'package:mercuri/Models/shared_accounts.dart';
import 'package:mercuri/Settings/icons_map.dart';
import 'package:mercuri/Settings/theme.dart';
import 'package:mercuri/loading.dart';
import 'package:provider/provider.dart';

import '../Income and Expenses/create_transaction.dart';

class AddRecurrentTransaction extends StatefulWidget {
  final List<dynamic> incomeCategories;
  final List<dynamic> expenseCategories;
  const AddRecurrentTransaction(this.incomeCategories, this.expenseCategories,
      {super.key});

  @override
  State<AddRecurrentTransaction> createState() =>
      _AddRecurrentTransactionState();
}

class _AddRecurrentTransactionState extends State<AddRecurrentTransaction> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String type = 'Gasto';
  String? selectedCategory;
  String? selectedCategoryIconString;
  IconData? selectedCategoryIconData;
  num? repeatMonths;
  List<num> repeatMonthsOptions = [3, 6, 12, 18, 24, 36, 48];
  List<String> typesList = ['Ingreso', 'Gasto'];
  List<Map> membersList = [];
  bool loading = false;

  String? uid;

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
    AuthService().getcurrentUID().then((v) {
      setState(() {
        uid = v!;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final sharedAccounts = Provider.of<List<SharedAccounts>?>(context);

    if (sharedAccounts == null) {
      return const SizedBox();
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
          'Crear transacción recurrente',
          style: TextStyle(
              color: theme.isDarkMode ? Colors.white : Colors.black,
              fontSize: 16),
        ),
        actions: [
          Container(
            width: 70,
            color: Colors.transparent,
          )
        ],
      ),
      body: uid == null
          ? const SizedBox()
          : Stack(
              children: [
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                //Type
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: DropdownButton(
                                    isExpanded: true,
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      size: 21,
                                      color: theme.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    hint: Text(
                                      type,
                                      style: TextStyle(
                                          color: theme.isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 16),
                                    ),
                                    items: typesList.map((item) {
                                      return DropdownMenuItem(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: TextStyle(
                                              color: theme.isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 14),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        type = value!.toString();
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20),
                                //Name
                                SizedBox(
                                  width: double.infinity,
                                  child: TextFormField(
                                    autofocus: false,
                                    validator: (value) =>
                                        (value == null || value == '')
                                            ? 'Agrega un título'
                                            : null,
                                    style: TextStyle(
                                        color: theme.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 16),
                                    textAlign: TextAlign.left,
                                    cursorColor: Colors.grey,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      label: const Text('Nombre o descripción'),
                                      focusColor: Colors.black,
                                      errorStyle: TextStyle(
                                          color: Colors.redAccent[700],
                                          fontSize: 12),
                                      border: const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.green, width: 1)),
                                    ),
                                    onChanged: (value) {
                                      setState(() => name = value);
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20),
                                //Category
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: DropdownButton(
                                    isExpanded: true,
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      size: 21,
                                      color: theme.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    hint: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          selectedCategory == null
                                              ? Icons.category
                                              : selectedCategoryIconData,
                                          size: 21,
                                          color: theme.isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          selectedCategory == null
                                              ? 'Categoría'
                                              : selectedCategory!,
                                          style: TextStyle(
                                              color: theme.isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    items: type == 'Gasto'
                                        ? widget.expenseCategories.map((item) {
                                            var iconIndex = IconsMap()
                                                .iconsMap
                                                .indexWhere((x) =>
                                                    x['Code'] == item['Icon']);
                                            var itemIcon = IconsMap()
                                                .iconsMap[iconIndex]['Icon'];
                                            return DropdownMenuItem<Map>(
                                              value: item,
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    itemIcon,
                                                    size: 21,
                                                    color: theme.isDarkMode
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    item['Category'],
                                                    style: TextStyle(
                                                        color: theme.isDarkMode
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontSize: 14),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList()
                                        : widget.incomeCategories.map((item) {
                                            var iconIndex = IconsMap()
                                                .iconsMap
                                                .indexWhere((x) =>
                                                    x['Code'] == item['Icon']);
                                            var itemIcon = IconsMap()
                                                .iconsMap[iconIndex]['Icon'];
                                            return DropdownMenuItem<Map>(
                                              value: item,
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    itemIcon,
                                                    size: 21,
                                                    color: theme.isDarkMode
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    item['Category'],
                                                    style: TextStyle(
                                                        color: theme.isDarkMode
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontSize: 14),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                    onChanged: (value) {
                                      var iconIndex = IconsMap()
                                          .iconsMap
                                          .indexWhere((x) =>
                                              x['Code'] == value!['Icon']);
                                      var itemIcon = IconsMap()
                                          .iconsMap[iconIndex]['Icon'];
                                      setState(() {
                                        selectedCategory = value!['Category'];
                                        selectedCategoryIconString =
                                            value['Icon'];
                                        selectedCategoryIconData = itemIcon;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20),
                                //Repeat
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: DropdownButton(
                                    isExpanded: true,
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      size: 21,
                                      color: theme.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    hint: Text(
                                      repeatMonths == null
                                          ? 'Cantidad de meses a repetir'
                                          : '$repeatMonths meses',
                                      style: TextStyle(
                                          color: theme.isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 16),
                                    ),
                                    items: repeatMonthsOptions.map((item) {
                                      return DropdownMenuItem(
                                        value: item,
                                        child: Text(
                                          '$item meses',
                                          style: TextStyle(
                                              color: theme.isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 14),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        repeatMonths = value;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20),
                                //Associate shared account
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 200,
                                      child: (assignedSharedAccounts != '')
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
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
                                                      assignedSharedAccounts =
                                                          '';
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
                                                          type);
                                                    });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18.0)),
                                                backgroundColor: Colors.grey
                                                    .withOpacity(0.1),
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        //Button
                        const SizedBox(height: 10),
                        Align(
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
                                  if (_formKey.currentState!.validate() &&
                                      repeatMonths != null &&
                                      selectedCategory != null) {
                                    setState(() {
                                      loading = true;
                                    });
                                    DatabaseService()
                                        .createRecurrentTransaction(
                                            uid.toString(),
                                            DateTime.now().toString(),
                                            name,
                                            type,
                                            false,
                                            0,
                                            DateTime.now(),
                                            repeatMonths!,
                                            {
                                              'Category': selectedCategory,
                                              'Icon': selectedCategoryIconString
                                            },
                                            (assignedSharedAccounts != '')
                                                ? {
                                                    'ID':
                                                        assignedSharedAccounts,
                                                    'Name': assignedAcctName
                                                  }
                                                : {})
                                        .then((v) {
                                      Navigator.of(context).pop();
                                    });
                                  }
                                },
                                child: const Text(
                                  'Crear',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                            )),
                      ],
                    ),
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
    );
  }
}
