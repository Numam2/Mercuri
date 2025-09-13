import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mercuri/Backend/database_service.dart';
import 'package:mercuri/Categories/create_category_dialog.dart';
import 'package:mercuri/Settings/icons_map.dart';
import 'package:mercuri/Settings/theme.dart';
import 'package:provider/provider.dart';

class CategoriesSettings extends StatefulWidget {
  final List<dynamic> incomeCategories;
  final List<dynamic> expenseCategories;
  final String uid;
  const CategoriesSettings(
      this.incomeCategories, this.expenseCategories, this.uid,
      {super.key});

  @override
  State<CategoriesSettings> createState() => _CategoriesSettingsState();
}

class _CategoriesSettingsState extends State<CategoriesSettings> {
  List<Map> incomeCategoriesList = [];
  List<Map> expenseCategoriesList = [];
  ValueKey redrawObject = const ValueKey('List');
  ValueKey redrawObject2 = const ValueKey('ListExp');
  void nothing(BuildContext context) {}
  String selectedType = 'Ingresos';
  final PageController _pageController = PageController();
  void addToList(String type, String category, String icon) {
    if (type == 'Ingresos') {
      setState(() {
        incomeCategoriesList.add({'Category': category, 'Icon': icon});
        listIsChanged = true;
      });
    } else {
      setState(() {
        expenseCategoriesList.add({'Category': category, 'Icon': icon});
        listIsChanged = true;
      });
    }
  }

  bool listIsChanged = false;

  @override
  void initState() {
    if (widget.incomeCategories.isNotEmpty) {
      for (var i = 0; i < widget.incomeCategories.length; i++) {
        incomeCategoriesList.add({
          'Category': widget.incomeCategories[i]['Category'],
          'Icon': widget.incomeCategories[i]['Icon'],
        });
      }
    } else {
      incomeCategoriesList = [];
    }
    if (widget.expenseCategories.isNotEmpty) {
      for (var i = 0; i < widget.expenseCategories.length; i++) {
        expenseCategoriesList.add({
          'Category': widget.expenseCategories[i]['Category'],
          'Icon': widget.expenseCategories[i]['Icon'],
        });
      }
    } else {
      expenseCategoriesList = [];
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
        title: //Select income/expense
            Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Income
            TextButton(
                onPressed: () {
                  setState(() {
                    selectedType = 'Ingresos';
                  });
                  _pageController.animateToPage(0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease);
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 2,
                              color: selectedType == 'Ingresos'
                                  ? Colors.green
                                  : Colors.transparent))),
                  child: Text(
                    'Ingresos',
                    style: TextStyle(
                        color: theme.isDarkMode ? Colors.white : Colors.black,
                        fontSize: 14),
                  ),
                )),
            const SizedBox(width: 10),
            //Expense
            TextButton(
                onPressed: () {
                  setState(() {
                    selectedType = 'Gastos';
                  });
                  _pageController.animateToPage(1,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease);
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 2,
                              color: selectedType == 'Gastos'
                                  ? Colors.green
                                  : Colors.transparent))),
                  child: Text(
                    'Gastos',
                    style: TextStyle(
                        color: theme.isDarkMode ? Colors.white : Colors.black,
                        fontSize: 14),
                  ),
                ))
          ],
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
            //PageView
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  //Ingresos
                  Column(
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
                                      return CreateCategoryDialog(
                                          'Ingresos', addToList);
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
                      (incomeCategoriesList.isEmpty)
                          ? const SizedBox()
                          : Expanded(
                              child: ReorderableListView.builder(
                                  itemCount: incomeCategoriesList.length,
                                  shrinkWrap: true,
                                  key: redrawObject,
                                  onReorder: (oldIndex, newIndex) {
                                    if (newIndex > oldIndex) {
                                      newIndex = newIndex - 1;
                                    }

                                    setState(() {
                                      listIsChanged = true;
                                      incomeCategoriesList.insert(
                                          newIndex,
                                          incomeCategoriesList
                                              .removeAt(oldIndex));
                                    });
                                  },
                                  itemBuilder: (context, i) {
                                    var iconIndex = IconsMap()
                                        .iconsMap
                                        .indexWhere((item) =>
                                            item['Code'] ==
                                            incomeCategoriesList[i]['Icon']);
                                    return Dismissible(
                                      key: ValueKey(i),
                                      confirmDismiss: (direction) {
                                        return showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Center(
                                                child: SingleChildScrollView(
                                                  child: Dialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0)),
                                                    child: Container(
                                                      width: 450,
                                                      height: 300,
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
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
                                                              "Eliminar ${incomeCategoriesList[i]['Category']} de mis categorías",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 20.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
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
                                                                  child: ElevatedButton(
                                                                      style: ElevatedButton.styleFrom(
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(18.0)),
                                                                        backgroundColor: Theme.of(context)
                                                                            .colorScheme
                                                                            .primary,
                                                                      ),
                                                                      onPressed: () {
                                                                        incomeCategoriesList
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
                                                                      child: const Padding(
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
                                                                  child:
                                                                      TextButton(
                                                                          style: TextButton.styleFrom(
                                                                              splashFactory: NoSplash.splashFactory,
                                                                              elevation: 0,
                                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
                                                                              backgroundColor: Colors.transparent,
                                                                              side: BorderSide(color: theme.isDarkMode ? Colors.grey : Colors.grey)),
                                                                          onPressed: () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child: Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                                                            child:
                                                                                Text(
                                                                              'No',
                                                                              style: TextStyle(color: theme.isDarkMode ? Colors.white : Colors.black),
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
                                          incomeCategoriesList.removeAt(i);

                                          final random = Random();
                                          const availableChars =
                                              'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
                                          final randomString = List.generate(
                                              10,
                                              (index) => availableChars[
                                                  random.nextInt(availableChars
                                                      .length)]).join();
                                          setState(() {
                                            listIsChanged = true;
                                            redrawObject =
                                                ValueKey(randomString);
                                          });
                                        }
                                      },
                                      child: SizedBox(
                                        key: ValueKey(i),
                                        child: ListTile(
                                          onTap: () {}, // Edit name or icon?
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Icon(
                                                IconsMap().iconsMap[iconIndex]
                                                    ['Icon'],
                                                color: theme.isDarkMode
                                                    ? Colors.white
                                                    : Colors.black,
                                                size: 24,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                incomeCategoriesList[i]
                                                    ['Category'],
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
                                                color: Colors.grey,
                                                fontSize: 11),
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
                  //Gastos
                  Column(
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
                                      return CreateCategoryDialog(
                                          'Gastos', addToList);
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
                      (expenseCategoriesList.isEmpty)
                          ? const SizedBox()
                          : Expanded(
                              child: ReorderableListView.builder(
                                  itemCount: expenseCategoriesList.length,
                                  shrinkWrap: true,
                                  key: redrawObject2,
                                  onReorder: (oldIndex, newIndex) {
                                    if (newIndex > oldIndex) {
                                      newIndex = newIndex - 1;
                                    }

                                    setState(() {
                                      listIsChanged = true;
                                      expenseCategoriesList.insert(
                                          newIndex,
                                          expenseCategoriesList
                                              .removeAt(oldIndex));
                                    });
                                  },
                                  itemBuilder: (context, i) {
                                    var iconIndex = IconsMap()
                                        .iconsMap
                                        .indexWhere((item) =>
                                            item['Code'] ==
                                            expenseCategoriesList[i]['Icon']);
                                    return Dismissible(
                                      key: ValueKey(i),
                                      confirmDismiss: (direction) {
                                        return showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Center(
                                                child: SingleChildScrollView(
                                                  child: Dialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0)),
                                                    child: Container(
                                                      width: 450,
                                                      height: 300,
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
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
                                                              "Eliminar ${expenseCategoriesList[i]['Category']} de mis categorías",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 20.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
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
                                                                  child: ElevatedButton(
                                                                      style: ElevatedButton.styleFrom(
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(18.0)),
                                                                        backgroundColor: Theme.of(context)
                                                                            .colorScheme
                                                                            .primary,
                                                                      ),
                                                                      onPressed: () {
                                                                        expenseCategoriesList
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
                                                                          redrawObject2 =
                                                                              ValueKey(randomString);
                                                                        });
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child: const Padding(
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
                                                                  child:
                                                                      TextButton(
                                                                          style: TextButton.styleFrom(
                                                                              splashFactory: NoSplash.splashFactory,
                                                                              elevation: 0,
                                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
                                                                              backgroundColor: Colors.transparent,
                                                                              side: BorderSide(color: theme.isDarkMode ? Colors.grey : Colors.grey)),
                                                                          onPressed: () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child: Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                                                            child:
                                                                                Text(
                                                                              'No',
                                                                              style: TextStyle(color: theme.isDarkMode ? Colors.white : Colors.black),
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
                                          expenseCategoriesList.removeAt(i);

                                          final random = Random();
                                          const availableChars =
                                              'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
                                          final randomString = List.generate(
                                              10,
                                              (index) => availableChars[
                                                  random.nextInt(availableChars
                                                      .length)]).join();
                                          setState(() {
                                            listIsChanged = true;
                                            redrawObject =
                                                ValueKey(randomString);
                                          });
                                        }
                                      },
                                      child: SizedBox(
                                        key: ValueKey(i),
                                        child: ListTile(
                                          onTap: () {}, // Edit name or icon?
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                IconsMap().iconsMap[iconIndex]
                                                    ['Icon'],
                                                color: theme.isDarkMode
                                                    ? Colors.white
                                                    : Colors.black,
                                                size: 24,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                expenseCategoriesList[i]
                                                    ['Category'],
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
                                                color: Colors.grey,
                                                fontSize: 11),
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
                  )
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
                    DatabaseService().updateUserCategories(widget.uid,
                        incomeCategoriesList, expenseCategoriesList);
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
