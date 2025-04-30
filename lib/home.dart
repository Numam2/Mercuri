import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mercuri/Backend/auth_service.dart';
import 'package:mercuri/Backend/database_service.dart';
import 'package:mercuri/Budgets/budget_settings.dart';
import 'package:mercuri/Budgets/budget_summary.dart';
import 'package:mercuri/Income%20and%20Expenses/create_transaction.dart';
import 'package:mercuri/Models/budgets.dart';
import 'package:mercuri/Models/recurrent_transactions.dart';
import 'package:mercuri/Models/shared_accounts.dart';
import 'package:mercuri/Models/user.dart';
import 'package:mercuri/Categories/categories_settings.dart';
import 'package:mercuri/PaymentMethods.dart/payments_home.dart';
import 'package:mercuri/Recurrent%20Transactions/recurrent_transactions_page.dart';
import 'package:mercuri/Recurrent%20Transactions/recurrent_transactions_summary.dart';
import 'package:mercuri/SharedAccounts/invted_accounts_dialog.dart';
import 'package:mercuri/SharedAccounts/shared_accounts_page.dart';
import 'package:mercuri/Wrapper.dart';
import 'package:mercuri/loading.dart';
import 'package:mercuri/Settings/settings.dart';
import 'package:mercuri/Income%20and%20Expenses/summary.dart';
import 'package:mercuri/Settings/theme.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final String uid;
  Home(this.uid, {super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  Widget transactionButton(
      BuildContext context,
      bool isExpense,
      ThemeProvider theme,
      incomeCategories,
      expenseCategories,
      userName,
      List paymentMethods) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return StreamProvider<List<SharedAccounts>?>.value(
            value: DatabaseService().sharedAcctsList(uid),
            initialData: const [],
            child: CreateTransaction(uid, isExpense ? 'Gasto' : 'Ingreso',
                incomeCategories, expenseCategories, userName, paymentMethods),
          );
        }));
      },
      style: ElevatedButton.styleFrom(
          elevation: theme.isDarkMode ? 0 : 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          backgroundColor: theme.isDarkMode ? Colors.black54 : Colors.white),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8),
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
            const SizedBox(height: 60),
            //Text
            Text(
              isExpense ? 'Gasto' : 'Ingreso',
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
    final userData = Provider.of<UserData?>(context);

    if (userData == null) {
      return const Scaffold(body: Loading());
    }
    // else if (!userData.subscribed! &&
    //     !userData.freeTrial! &&
    //     userData.trialTo!.isBefore(DateTime.now())) {
    //   return const SubscriptionHome();
    // }

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
          actions: userData.invitedSharedAccount!.isEmpty
              ? const []
              : [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return InvitedAccountsDialog(userData.uid!,
                                        userData.invitedSharedAccount!, theme);
                                  });
                            },
                            child: Icon(
                              Icons.group_outlined,
                              size: 21,
                              color: theme.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
        ),
        drawer: Drawer(
          backgroundColor: theme.isDarkMode ? Colors.black : Colors.white,
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
              //Budgets
              TextButton(
                  style: TextButton.styleFrom(
                      fixedSize: const Size(double.infinity, 50)),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return BudgetSettings(
                          userData.uid!,
                          userData.expenseCategories!,
                          userData.budgetCategories);
                    }));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //Icon
                        Icon(
                          Icons.add_chart,
                          size: 16,
                          color: theme.isDarkMode ? Colors.white : Colors.black,
                        ),
                        const SizedBox(width: 15),
                        //Text
                        Text(
                          'Presupuestos y metas',
                          style: TextStyle(
                              color: theme.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                        )
                      ],
                    ),
                  )),
              //Shared Acct
              TextButton(
                  style: TextButton.styleFrom(
                      fixedSize: const Size(double.infinity, 50)),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return StreamProvider<List<SharedAccounts>?>.value(
                          value: DatabaseService().sharedAcctsList(uid),
                          initialData: const [],
                          child: SharedAccountsPage(
                              userData.uid!, userData.name!));
                    }));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //Icon
                        Icon(
                          Icons.group_outlined,
                          size: 16,
                          color: theme.isDarkMode ? Colors.white : Colors.black,
                        ),
                        const SizedBox(width: 15),
                        //Text
                        Text(
                          'Cuentas compartidas',
                          style: TextStyle(
                              color: theme.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                        )
                      ],
                    ),
                  )),
              //Recurrent transactions
              TextButton(
                  style: TextButton.styleFrom(
                      fixedSize: const Size(double.infinity, 50)),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return StreamProvider<List<RecurrentTransactions>?>.value(
                          value:
                              DatabaseService().recurrentTransactionsList(uid),
                          initialData: const [],
                          child: RecurrentTransactionsPage(
                              userData.uid!,
                              userData.name!,
                              userData.incomeCategories!,
                              userData.expenseCategories!,
                              userData.paymentMethods!));
                    }));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //Icon
                        Icon(
                          Icons.replay,
                          size: 16,
                          color: theme.isDarkMode ? Colors.white : Colors.black,
                        ),
                        const SizedBox(width: 15),
                        //Text
                        Text(
                          'Transacciones recurrentes',
                          style: TextStyle(
                              color: theme.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                        )
                      ],
                    ),
                  )),
              //Categories
              TextButton(
                  style: TextButton.styleFrom(
                      fixedSize: const Size(double.infinity, 50)),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return CategoriesSettings(userData.incomeCategories!,
                          userData.expenseCategories!, userData.uid!);
                    }));
                  },
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
                          'Categorías',
                          style: TextStyle(
                              color: theme.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                        )
                      ],
                    ),
                  )),
              //Payment methods
              TextButton(
                  style: TextButton.styleFrom(
                      fixedSize: const Size(double.infinity, 50)),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return StreamProvider<List<SharedAccounts>?>.value(
                          value: DatabaseService().sharedAcctsList(uid),
                          initialData: const [],
                          child: PaymentsHome(
                            userData.paymentMethods!,
                            userData.uid!,
                          ));
                    }));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //Icon
                        Icon(
                          Icons.account_balance_wallet_outlined,
                          size: 16,
                          color: theme.isDarkMode ? Colors.white : Colors.black,
                        ),
                        const SizedBox(width: 15),
                        //Text
                        Text(
                          'Medios de pago',
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
                          'Configuración',
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
                          'Salir',
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Hi
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Hola ${FirebaseAuth.instance.currentUser!.displayName}',
                  style: TextStyle(
                      color: theme.isDarkMode ? Colors.white : Colors.black,
                      fontSize: 35,
                      fontWeight: FontWeight.bold),
                ),
              ),
              //Add Income/Expense
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //Add Income
                    Expanded(
                        child: transactionButton(
                            context,
                            false,
                            theme,
                            userData.incomeCategories,
                            userData.expenseCategories,
                            userData.name,
                            userData.paymentMethods!)),
                    const SizedBox(
                      width: 35,
                    ),
                    //Add Expense
                    Expanded(
                        child: transactionButton(
                            context,
                            true,
                            theme,
                            userData.incomeCategories,
                            userData.expenseCategories,
                            userData.name,
                            userData.paymentMethods!)),
                  ],
                ),
              ),
              //Budget List
              StreamProvider<List<Budgets>?>.value(
                value: DatabaseService().budgetList(uid, 'Presupuesto'),
                initialData: null,
                child: BudgetSummary(userData.uid!),
              ),
              //Recurrent payments
              StreamProvider<List<RecurrentTransactions>?>.value(
                value:
                    DatabaseService().upcommingRecurrentTransactionsList(uid),
                initialData: null,
                child: RecurrentTransactionsSummary(
                    userData.uid!, userData.name!, userData.paymentMethods!),
              ),
              //List of expenses
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Summary(uid, userData.incomeCategories!,
                    userData.expenseCategories!, userData.paymentMethods!),
              ),
              const SizedBox(height: 20)
            ],
          ),
        ));
  }
}
