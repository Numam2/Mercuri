import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mercuri/Backend/auth_service.dart';
import 'package:mercuri/Income%20and%20Expenses/create_transaction.dart';
import 'package:mercuri/Wrapper.dart';
import 'package:mercuri/settings.dart';
import 'package:mercuri/summary.dart';
import 'package:mercuri/theme.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final String uid;
  Home(this.uid, {super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  Widget transactionButton(
      BuildContext context, bool isExpense, ThemeProvider theme) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return CreateTransaction(uid, isExpense ? 'Expense' : 'Income');
        }));
      },
      style: ElevatedButton.styleFrom(
          elevation: theme.isDarkMode ? 0 : 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          backgroundColor: theme.isDarkMode ? Colors.black54 : Colors.white),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  isExpense
                      ? Icons.arrow_downward_outlined
                      : Icons.arrow_upward_outlined,
                  color: theme.isDarkMode ? Colors.white : Colors.black54,
                  size: 24,
                  grade: 10,
                ),
              ],
            ),
            const SizedBox(height: 50),
            //Text
            Text(
              isExpense ? 'Expense' : 'Income',
              style: TextStyle(
                  color: theme.isDarkMode ? Colors.white : Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors
              .transparent, //theme.isDarkMode ? Colors.black38 : Colors.white,
          centerTitle: true,
          leading: IconButton(
              onPressed: openDrawer,
              splashRadius: 24,
              icon: Icon(Icons.menu,
                  size: 16,
                  color: theme.isDarkMode ? Colors.white : Colors.black)),
        ),
        drawer: Drawer(
          backgroundColor: theme.isDarkMode ? Colors.black45 : Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //User
              Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 100,
                    child: Center(
                      child: Text(
                        'Numa',
                        style: TextStyle(
                            color:
                                theme.isDarkMode ? Colors.white : Colors.black),
                      ),
                    ),
                  )),
              //Categories
              TextButton(
                  style: TextButton.styleFrom(
                      fixedSize: const Size(double.infinity, 50)),
                  onPressed: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //Icon
                        Icon(
                          Icons.category_outlined,
                          size: 16,
                          color: theme.isDarkMode ? Colors.white : Colors.black,
                        ),
                        const SizedBox(width: 15),
                        //Text
                        Text(
                          'Categories',
                          style: TextStyle(
                              color: theme.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                        )
                      ],
                    ),
                  )),
              //Settings
              TextButton(
                  style: TextButton.styleFrom(
                      fixedSize: const Size(double.infinity, 50)),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const Settings();
                    }));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //Icon
                        Icon(
                          Icons.settings_outlined,
                          size: 16,
                          color: theme.isDarkMode ? Colors.white : Colors.black,
                        ),
                        const SizedBox(width: 15),
                        //Text
                        Text(
                          'Settings',
                          style: TextStyle(
                              color: theme.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                        )
                      ],
                    ),
                  )),
              const Spacer(),
              //Signout
              Container(
                height: 120,
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Column(children: [
                  const Divider(
                    indent: 5,
                    endIndent: 5,
                    thickness: 1,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    style: TextButton.styleFrom(
                        fixedSize: const Size(double.infinity, 50)),
                    onPressed: () {
                      AuthService().signOut();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Wrapper()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //Icon
                        Icon(
                          Icons.exit_to_app,
                          size: 25,
                          color: theme.isDarkMode ? Colors.white : Colors.black,
                        ),
                        const SizedBox(width: 10),
                        //Text
                        Text(
                          'Sign out',
                          style: TextStyle(
                              fontSize: 11,
                              color: theme.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ]),
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Hi
                Text(
                  'Hi ${FirebaseAuth.instance.currentUser!.displayName}',
                  style: TextStyle(
                      color: theme.isDarkMode ? Colors.white : Colors.black,
                      fontSize: 35,
                      fontWeight: FontWeight.bold),
                ),
                //Add Income/Expense
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //Add Income
                      Expanded(child: transactionButton(context, false, theme)),
                      const SizedBox(
                        width: 35,
                      ),
                      //Add Expense
                      Expanded(child: transactionButton(context, true, theme)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                //List of expenses
                Summary(uid)
              ],
            ),
          ),
        ));
  }
}
