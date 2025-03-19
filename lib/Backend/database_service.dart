import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mercuri/Models/budgets.dart';
import 'package:mercuri/Models/recurrent_transactions.dart';
import 'package:mercuri/Models/shared_accounts.dart';
import 'package:mercuri/Models/stats.dart';
import 'package:mercuri/Models/transactions.dart';
import 'package:mercuri/Models/user.dart';

class DatabaseService {
  //////////////////////// USER /////////////////////
  //Create User
  Future createUser(String uid, String name, String email,
      List<String> searchName, List<String> searchEmail) async {
    return await FirebaseFirestore.instance.collection('Users').doc(uid).set({
      'User ID': uid,
      'Name': name,
      'Free Trial': true,
      'Subscribed': false,
      'Email': email,
      'Trial Beginning': DateTime.now(),
      'Trial End': DateTime.now().add(const Duration(days: 14)),
      'Seacrh Name': searchName,
      'Search email': searchEmail,
      'Expense Categories': [
        {'Category': 'Mercado', 'Icon': 'Mercado'},
        {'Category': 'Casa', 'Icon': 'Casa'},
        {'Category': 'Restaurantes', 'Icon': 'Comida'},
        {'Category': 'Educación', 'Icon': 'Educación'},
        {'Category': 'Entretenimiento', 'Icon': 'TV'},
        {'Category': 'Bienestar y estética', 'Icon': 'Ejercicio'},
        {'Category': 'Transporte', 'Icon': 'Bus'},
        {'Category': 'Compras', 'Icon': 'Compras'},
        {'Category': 'Otros', 'Icon': 'Gift Card'}
      ],
      'Income Categories': [
        {'Category': 'Salarios', 'Icon': 'Billete'},
        {'Category': 'Inversiones', 'Icon': 'Dinero'}
      ],
      'Invited Shared Accounts': [],
      'Payment Methods': [
        {'Accepts Amortization': false, 'Icon': 'Efectivo', 'Name': 'Efectivo'},
        {'Accepts Amortization': false, 'Icon': 'Tarjeta', 'Name': 'Tarjeta'},
        {'Accepts Amortization': false, 'Icon': 'QR', 'Name': 'Billetera'},
      ],
      'Shared Accounts': []
    });
  }

  //Edit User Subscription Status
  Future subscribeUser(String uid) async {
    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .update({
      'Free Trial': false,
      'Subscribed': true,
    });
  }

  UserData? _userFromSnapshot(DocumentSnapshot snapshot) {
    try {
      return UserData(
        uid: snapshot.data().toString().contains('User ID')
            ? snapshot['User ID']
            : '',
        name:
            snapshot.data().toString().contains('Name') ? snapshot['Name'] : '',
        email: snapshot.data().toString().contains('Email')
            ? snapshot['Email']
            : '',
        searchName: snapshot.data().toString().contains('Search Name')
            ? snapshot['Search Name']
            : [],
        searchEmail: snapshot.data().toString().contains('Search email')
            ? snapshot['Search email']
            : [],
        subscribed: snapshot.data().toString().contains('Subscribed')
            ? snapshot['Subscribed']
            : false,
        freeTrial: snapshot.data().toString().contains('Free Trial')
            ? snapshot['Free Trial']
            : false,
        trialFrom: snapshot.data().toString().contains('Date')
            ? snapshot['Trial Beginning'].toDate()
            : DateTime(1999, 1, 1),
        trialTo: snapshot.data().toString().contains('Date')
            ? snapshot['Trial End'].toDate()
            : DateTime.now(),
        expenseCategories:
            snapshot.data().toString().contains('Expense Categories')
                ? snapshot['Expense Categories']
                : [
                    {'Category': 'Mercado', 'Icon': 'Mercado'},
                    {'Category': 'Casa', 'Icon': 'Casa'},
                    {'Category': 'Restaurantes', 'Icon': 'Comida'},
                    {'Category': 'Educación', 'Icon': 'Educación'},
                    {'Category': 'Entretenimiento', 'Icon': 'TV'},
                    {'Category': 'Bienestar y estética', 'Icon': 'Ejercicio'},
                    {'Category': 'Transporte', 'Icon': 'Bus'},
                    {'Category': 'Compras', 'Icon': 'Compras'},
                    {'Category': 'Otros', 'Icon': 'Gift Card'}
                  ],
        incomeCategories:
            snapshot.data().toString().contains('Income Categories')
                ? snapshot['Income Categories']
                : [
                    {'Category': 'Salarios', 'Icon': 'Billete'},
                    {'Category': 'Inversiones', 'Icon': 'Dinero'}
                  ],
        invitedSharedAccount:
            snapshot.data().toString().contains('Invited Shared Accounts')
                ? snapshot['Invited Shared Accounts']
                : [],
        paymentMethods: snapshot.data().toString().contains('Payment Methods')
            ? snapshot['Payment Methods']
            : [],
        sharedAccounts: snapshot.data().toString().contains('Shared Accounts')
            ? snapshot['Shared Accounts']
            : [],
      );
    } catch (e) {
      return null;
    }
  }

  List<UserData> _usersListFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        return UserData(
          uid: doc.data().toString().contains('User ID') ? doc['User ID'] : '',
          name: doc.data().toString().contains('Name') ? doc['Name'] : '',
          email: doc.data().toString().contains('Email') ? doc['Email'] : '',
          searchName: doc.data().toString().contains('Search Name')
              ? doc['Search Name']
              : [],
          searchEmail: doc.data().toString().contains('Search email')
              ? doc['Search email']
              : [],
          subscribed: doc.data().toString().contains('Subscribed')
              ? doc['Subscribed']
              : false,
          freeTrial: doc.data().toString().contains('Free Trial')
              ? doc['Free Trial']
              : false,
          trialFrom: doc.data().toString().contains('Date')
              ? doc['Trial Beginning'].toDate()
              : DateTime(1999, 1, 1),
          trialTo: doc.data().toString().contains('Date')
              ? doc['Trial End'].toDate()
              : DateTime.now(),
          expenseCategories:
              doc.data().toString().contains('Expense Categories')
                  ? doc['Expense Categories']
                  : [],
          incomeCategories: doc.data().toString().contains('Income Categories')
              ? doc['Income Categories']
              : [],
          invitedSharedAccount:
              doc.data().toString().contains('Invited Shared Accounts')
                  ? doc['Invited Shared Accounts']
                  : [],
          paymentMethods: doc.data().toString().contains('Payment Methods')
              ? doc['Payment Methods']
              : [],
          sharedAccounts: doc.data().toString().contains('Shared Accounts')
              ? doc['Shared Accounts']
              : [],
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Stream<UserData?> userData(uid) async* {
    yield* FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .snapshots()
        .map(_userFromSnapshot);
  }

  Stream<List<UserData>>? usersList(String searchName) async* {
    yield* FirebaseFirestore.instance
        .collection('Users')
        .where(Filter.or(Filter('Search Name', arrayContains: searchName),
            Filter('Search email', arrayContains: searchName)))
        .snapshots()
        .map(_usersListFromSnapshot);
  }

  Future updateUserCategories(
      String uid, incomeCategories, expenseCategories) async {
    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .update({
      'Income Categories': incomeCategories,
      'Expense Categories': expenseCategories
    });
  }

  Future updateBudgetCategories(String uid, List budgetCategories) async {
    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .update({
      'Budget Categories': budgetCategories,
    });
  }

  Future updatePaymentMethods(String uid, paymentMethods) async {
    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .update({
      'Payment Methods': paymentMethods,
    });
  }

  //////////////////////// Shared Accounts //////////////////

  Future addSharedAccountToUser(String uid, List sharedAcctID) async {
    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .update({
      'Shared Accounts': sharedAcctID,
    });
  }

  Future sendShareAcctInvite(String uid, List sharedAcctID) async {
    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .update({
      'Invited Shared Accounts': sharedAcctID,
    });
  }

  //Shared Accts from Firestore}

  Future createSharedAcct(String uid, String sharedAcctID, String acctName,
      String acctType, List<String> pendingMembers) async {
    return await FirebaseFirestore.instance
        .collection('Shared Accounts')
        .doc(sharedAcctID)
        .set({
      'Created Date': DateTime.now(),
      'ID': sharedAcctID,
      'Name': acctName,
      'Type': acctType,
      'Miembros': [uid],
      'Miembros Pendientes': pendingMembers,
      'Created By': uid
    });
  }

  Future inviteSharedAcct(
      String sharedAcctID, List<String> pendingMembers) async {
    return await FirebaseFirestore.instance
        .collection('Shared Accounts')
        .doc(sharedAcctID)
        .update({
      'Miembros Pendientes': pendingMembers,
    });
  }

  Future deleteSharedAcct(String sharedAcctID) async {
    return await FirebaseFirestore.instance
        .collection('Shared Accounts')
        .doc(sharedAcctID)
        .delete();
  }

  Future leaveSharedAcct(String sharedAcctID, List newMembersList) async {
    return await FirebaseFirestore.instance
        .collection('Shared Accounts')
        .doc(sharedAcctID)
        .update({
      'Miembros': newMembersList,
    });
  }

  Future removeInvitedAcctonUser(String uid, List<String> newList) async {
    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .update({
      'Invited Shared Accounts': newList,
    });
  }

  Future removeUserFromSharedAcct(
      String sharedAcctID, List<String> newList) async {
    return await FirebaseFirestore.instance
        .collection('Shared Accounts')
        .doc(sharedAcctID)
        .update({
      'Miembros Pendientes': newList,
    });
  }

  Future addUsertoSharedAcct(String sharedAcctID, List<String> newList) async {
    return await FirebaseFirestore.instance
        .collection('Shared Accounts')
        .doc(sharedAcctID)
        .update({
      'Miembros': newList,
    });
  }

  List<SharedAccounts> _sharedAcctsListFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        return SharedAccounts(
          createdDate: doc.data().toString().contains('Created Date')
              ? doc['Created Date'].toDate()
              : DateTime(1999, 1, 1),
          accountID: doc.data().toString().contains('ID') ? doc['ID'] : '',
          accountName:
              doc.data().toString().contains('Name') ? doc['Name'] : '',
          accountType:
              doc.data().toString().contains('Type') ? doc['Type'] : 'Gasto',
          members:
              doc.data().toString().contains('Miembros') ? doc['Miembros'] : [],
          pendingMembers: doc.data().toString().contains('Miembros Pendientes')
              ? doc['Miembros Pendientes']
              : [],
          createdBy: doc.data().toString().contains('Created By')
              ? doc['Created By']
              : '',
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Stream<List<SharedAccounts>>? sharedAcctsList(String uid) async* {
    yield* FirebaseFirestore.instance
        .collection('Shared Accounts')
        .where('Miembros', arrayContains: uid)
        .snapshots()
        .map(_sharedAcctsListFromSnapshot);
  }

  SharedAccounts? _sharedAcctFromSnapshot(DocumentSnapshot snapshot) {
    try {
      return SharedAccounts(
        createdDate: snapshot.data().toString().contains('Created Date')
            ? snapshot['Created Date'].toDate()
            : DateTime(1999, 1, 1),
        accountID:
            snapshot.data().toString().contains('ID') ? snapshot['ID'] : '',
        accountName:
            snapshot.data().toString().contains('Name') ? snapshot['Name'] : '',
        accountType: snapshot.data().toString().contains('Type')
            ? snapshot['Type']
            : 'Gasto',
        members: snapshot.data().toString().contains('Miembros')
            ? snapshot['Miembros']
            : [],
        pendingMembers:
            snapshot.data().toString().contains('Miembros Pendientes')
                ? snapshot['Miembros Pendientes']
                : [],
        createdBy: snapshot.data().toString().contains('Created By')
            ? snapshot['Created By']
            : '',
      );
    } catch (e) {
      return null;
    }
  }

  Stream<SharedAccounts?> sharedAcct(accountID) async* {
    yield* FirebaseFirestore.instance
        .collection('Shared Accounts')
        .doc(accountID)
        .snapshots()
        .map(_sharedAcctFromSnapshot);
  }

  //Create transactions
  Future createSharedTransaction(
      String acctID,
      String docID,
      DateTime date,
      String userName,
      String userUID,
      String type,
      String category,
      String description,
      num amount,
      Map paymentMethod) async {
    return await FirebaseFirestore.instance
        .collection('Shared Accounts')
        .doc(acctID)
        .collection(date.year.toString())
        .doc(docID)
        .set({
      'ID': docID,
      'Created by': userName,
      'Creator UID': userUID,
      'Date Created': DateTime.now(),
      'Transaction Date': date,
      'Type': type,
      'Category': category,
      'Description': description,
      'Amount': amount,
      'Payment Method': paymentMethod,
    });
  }

  List<SharedAcctTransactions> _sharedtransactionsListFromSnapshot(
      QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        return SharedAcctTransactions(
          dateCreated: doc.data().toString().contains('Date Created')
              ? doc['Date Created'].toDate()
              : DateTime(1999, 1, 1),
          transactionDate: doc.data().toString().contains('Transaction Date')
              ? doc['Transaction Date'].toDate()
              : DateTime(1999, 1, 1),
          docID: doc.data().toString().contains('ID') ? doc['ID'] : '',
          userName: doc.data().toString().contains('Created by')
              ? doc['Created by']
              : '',
          userUID: doc.data().toString().contains('Creator UID')
              ? doc['Creator UID']
              : '',
          type: doc.data().toString().contains('Type') ? doc['Type'] : 'Gasto',
          category: doc.data().toString().contains('Category')
              ? doc['Category']
              : 'Category',
          description: doc.data().toString().contains('Description')
              ? doc['Description']
              : 'Description',
          amount: doc.data().toString().contains('Amount') ? doc['Amount'] : 0,
          paymentMethod: doc.data().toString().contains('Payment Method')
              ? doc['Payment Method']
              : {},
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Stream<List<SharedAcctTransactions>> shortSharedTransactionsList(
      acctID, DateTime date) async* {
    yield* FirebaseFirestore.instance
        .collection('Shared Accounts')
        .doc(acctID)
        .collection(date.year.toString())
        .where('Transaction Date',
            isGreaterThan: DateTime(date.year, date.month, 1, 0, 0, 0))
        .where('Transaction Date',
            isLessThan: DateTime(date.year, date.month + 1, 0))
        .orderBy('Transaction Date', descending: true)
        .limit(5)
        .snapshots()
        .map(_sharedtransactionsListFromSnapshot);
  }

  Stream<List<SharedAcctTransactions>> sharedTransactionsList(
      acctID, DateTime date) async* {
    yield* FirebaseFirestore.instance
        .collection('Shared Accounts')
        .doc(acctID)
        .collection(date.year.toString())
        .where('Transaction Date',
            isGreaterThan: DateTime(date.year, date.month, 1, 0, 0, 0))
        .where('Transaction Date',
            isLessThan: DateTime(date.year, date.month + 1, 0))
        .orderBy('Transaction Date', descending: true)
        .snapshots()
        .map(_sharedtransactionsListFromSnapshot);
  }

  //Shared transaction stats

  //Update Stats
  Future updateSharedTransactionsStats(
    String acctID,
    DateTime date,
    String user,
    String type,
    String category,
    num amount,
  ) async {
    //Increment stats
    var monthStatsRef = FirebaseFirestore.instance
        .collection('Shared Accounts')
        .doc(acctID)
        .collection('Stats')
        .doc('Monthly Stats')
        .collection(date.year.toString())
        .doc(date.month.toString());

    //Update STATS for MONTH

    try {
      final monthStatsdoc = await monthStatsRef.get();

      if (monthStatsdoc.exists) {
        //MONTHLY Stats
        if (type == 'Ingreso') {
          monthStatsRef.update({
            'Number of transactions': FieldValue.increment(1),
            'Total Income': FieldValue.increment(amount),
            'Income by Category.$category': FieldValue.increment(amount),
            'Income by User.$user': FieldValue.increment(amount),
          });
        } else {
          monthStatsRef.update({
            'Number of transactions': FieldValue.increment(1),
            'Total Expenses': FieldValue.increment(amount),
            'Expenses by Category.$category': FieldValue.increment(amount),
            'Expenses by User.$user': FieldValue.increment(amount),
          });
        }
      } else {
        if (type == 'Ingreso') {
          Map<String, dynamic> orderStats = {
            'Number of transactions': 1,
            'Total Income': 0,
            'Income by Category': {},
            'Income by User': {},
          };
          orderStats['Total Income'] = amount;
          orderStats['Income by Category'] = {category: amount};
          orderStats['Income by User'] = {user: amount};
          await monthStatsRef.set(orderStats);
        } else {
          Map<String, dynamic> orderStats = {
            'Number of transactions': 1,
            'Total Expenses': 0,
            'Expenses by Category': {},
            'Expenses by User': {},
          };
          orderStats['Total Expenses'] = amount;
          orderStats['Expenses by Category'] = {category: amount};
          orderStats['Expenses by User'] = {user: amount};
          await monthStatsRef.set(orderStats);
        }
      }
    } catch (error) {
      print('Error updating Monthly Stats: $error');
    }
  }

  //Stats from Firestore
  SharedAccountsStats _sharedTransactionsStats(DocumentSnapshot snapshot) {
    try {
      return SharedAccountsStats(
        numberOfTransaction:
            snapshot.data().toString().contains('Number of Transactions')
                ? snapshot['Number of Transactions']
                : 0,
        totalIncome: snapshot.data().toString().contains('Total Income')
            ? snapshot['Total Income']
            : 0,
        totalExpenses: snapshot.data().toString().contains('Total Expenses')
            ? snapshot['Total Expenses']
            : 0,
        expensesByCategory:
            snapshot.data().toString().contains('Expenses by Category')
                ? snapshot['Expenses by Category']
                : {},
        expensesByUser: snapshot.data().toString().contains('Expenses by User')
            ? snapshot['Expenses by User']
            : {},
        incomeByCategory:
            snapshot.data().toString().contains('Income by Category')
                ? snapshot['Income by Category']
                : {},
        incomeByUser: snapshot.data().toString().contains('Income by User')
            ? snapshot['Income by User']
            : {},
      );
    } catch (e) {
      return SharedAccountsStats(
        numberOfTransaction: 0,
        totalIncome: 0,
        totalExpenses: 0,
        expensesByCategory: {},
        expensesByUser: {},
        incomeByCategory: {},
        incomeByUser: {},
      );
    }
  }

  //Stats Stream
  Stream<SharedAccountsStats> sharedTransactionsfromSnapshot(
      DateTime date, String acctID) async* {
    yield* FirebaseFirestore.instance
        .collection('Shared Accounts')
        .doc(acctID)
        .collection('Stats')
        .doc('Monthly Stats')
        .collection(date.year.toString())
        .doc(date.month.toString())
        .snapshots()
        .map(_sharedTransactionsStats);
  }

  //////////////////////// TRANSACTIONS /////////////////////

  //Create Transaction
  Future createTransaction(
      String uid,
      String docID,
      DateTime date,
      String type,
      String category,
      String description,
      num amount,
      Map paymentMethod) async {
    return await FirebaseFirestore.instance
        .collection('Transactions')
        .doc(uid)
        .collection(date.year.toString())
        .doc(docID)
        .set({
      'Date': date,
      'Type': type,
      'Category': category,
      'Description': description,
      'Amount': amount,
      'Payment Method': paymentMethod
    });
  }

  //Transactions from Firestore
  List<Transactions> _transactionsListFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        return Transactions(
          date: doc.data().toString().contains('Date')
              ? doc['Date'].toDate()
              : DateTime(1999, 1, 1),
          transactionType:
              doc.data().toString().contains('Type') ? doc['Type'] : 'Expense',
          category: doc.data().toString().contains('Category')
              ? doc['Category']
              : 'Category',
          description: doc.data().toString().contains('Description')
              ? doc['Description']
              : 'Description',
          amount: doc.data().toString().contains('Amount') ? doc['Amount'] : 0,
          paymentMethod: doc.data().toString().contains('Payment Method')
              ? doc['Payment Method']
              : {},
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  //Short list of Income
  Stream<List<Transactions>> shortIncomeList(uid, DateTime date) async* {
    yield* FirebaseFirestore.instance
        .collection('Transactions')
        .doc(uid)
        .collection(date.year.toString())
        .where('Type', isEqualTo: 'Ingreso')
        .where('Date',
            isGreaterThan: DateTime(date.year, date.month, 1, 0, 0, 0))
        .where('Date', isLessThan: DateTime(date.year, date.month + 1, 0))
        .orderBy('Date', descending: true)
        .limit(3)
        .snapshots()
        .map(_transactionsListFromSnapshot);
  }

  //Short list of Income
  Stream<List<Transactions>> shortExpenseList(uid, DateTime date) async* {
    yield* FirebaseFirestore.instance
        .collection('Transactions')
        .doc(uid)
        .collection(date.year.toString())
        .where('Type', isEqualTo: 'Gasto')
        .where('Date',
            isGreaterThan: DateTime(date.year, date.month, 1, 0, 0, 0))
        .where('Date', isLessThan: DateTime(date.year, date.month + 1, 0))
        .orderBy('Date', descending: true)
        .limit(3)
        .snapshots()
        .map(_transactionsListFromSnapshot);
  }

  //All transactions
  Stream<List<Transactions>> transactionsList(uid, DateTime date) async* {
    yield* FirebaseFirestore.instance
        .collection('Transactions')
        .doc(uid)
        .collection(date.year.toString())
        .where('Date',
            isGreaterThan: DateTime(date.year, date.month, 1, 0, 0, 0))
        .where('Date', isLessThan: DateTime(date.year, date.month + 1, 0))
        .orderBy('Date', descending: true)
        .snapshots()
        .map(_transactionsListFromSnapshot);
  }

  //Transactions by category
  Stream<List<Transactions>> transactionsbyCategory(
      uid, DateTime date, String category) async* {
    yield* FirebaseFirestore.instance
        .collection('Transactions')
        .doc(uid)
        .collection(date.year.toString())
        .where('Date',
            isGreaterThan: DateTime(date.year, date.month, 1, 0, 0, 0))
        .where('Date', isLessThan: DateTime(date.year, date.month + 1, 0))
        .where('Category', isEqualTo: category)
        .snapshots()
        .map(_transactionsListFromSnapshot);
  }

  ///////////////////////////// STATS ///////////////////////////////////////

  //Update Stats
  Future updateStats(String uid, DateTime date, String type, String category,
      num amount, Map paymentMethod) async {
    //Increment stats
    var monthStatsRef = FirebaseFirestore.instance
        .collection('Stats')
        .doc(uid)
        .collection(date.year.toString())
        .doc(date.month.toString());

    //Update STATS for MONTH
    try {
      final monthStatsdoc = await monthStatsRef.get();

      if (monthStatsdoc.exists) {
        //MONTHLY Stats
        if (type == 'Income') {
          monthStatsRef.update({
            'Total Income': FieldValue.increment(amount),
            'Income by Category.$category': FieldValue.increment(amount),
          });
        } else {
          monthStatsRef.update({
            'Total Expenses': FieldValue.increment(amount),
            'Expenses by Category.$category': FieldValue.increment(amount),
            'Expenses by Payment Method.${paymentMethod['Name']}':
                FieldValue.increment(amount),
          });
        }
      } else {
        if (type == 'Income') {
          Map<String, dynamic> orderStats = {
            'Total Income': 0,
            'Income by Category': {},
          };
          orderStats['Total Income'] = amount;
          orderStats['Income by Category'] = {category: amount};
          await monthStatsRef.set(orderStats);
        } else {
          Map<String, dynamic> orderStats = {
            'Total Expenses': 0,
            'Expenses by Category': {},
          };
          orderStats['Total Expenses'] = amount;
          orderStats['Expenses by Category'] = {category: amount};
          orderStats['Expenses by Payment Method'] = {
            paymentMethod['Name']: amount
          };
          await monthStatsRef.set(orderStats);
        }
      }
    } catch (error) {
      print('Error updating Monthly Stats: $error');
    }
  }

  //Stats from Firestore
  Stats _monthlyStats(DocumentSnapshot snapshot) {
    try {
      return Stats(
        monthlyIncome: snapshot.data().toString().contains('Total Income')
            ? snapshot['Total Income']
            : 0,
        monthlyExpenses: snapshot.data().toString().contains('Total Expenses')
            ? snapshot['Total Expenses']
            : 0,
        incomeByCategory:
            snapshot.data().toString().contains('Income by Category')
                ? snapshot['Income by Category']
                : {},
        expensesByCategory:
            snapshot.data().toString().contains('Expenses by Category')
                ? snapshot['Expenses by Category']
                : {},
      );
    } catch (e) {
      return Stats(
        monthlyIncome: 0,
        monthlyExpenses: 0,
        incomeByCategory: {},
        expensesByCategory: {},
      );
    }
  }

  //Stats Stream
  Stream<Stats> monthlyStatsfromSnapshot(String uid, DateTime date) async* {
    yield* FirebaseFirestore.instance
        .collection('Stats')
        .doc(uid)
        .collection(date.year.toString())
        .doc(date.month.toString())
        .snapshots()
        .map(_monthlyStats);
  }

  ///////////////////////////// BUDGETS ///////////////////////////////////////

  //Create Transaction
  Future createBudget(String uid, String docID, DateTime date, String type,
      String title, num budgetedAmount, num currentAmount) async {
    return await FirebaseFirestore.instance
        .collection('Budgets')
        .doc(uid)
        .collection(type)
        .doc(docID)
        .set({
      'Created Date': date,
      'Type': type,
      'Title': title,
      'Budgeted Amount': budgetedAmount,
      'Current Amount': currentAmount,
      'Doc ID': docID
    });
  }

  //Create Transaction
  Future updateBudgetAmount(
    String uid,
    String docID,
    String type,
    num currentAmount,
  ) async {
    return await FirebaseFirestore.instance
        .collection('Budgets')
        .doc(uid)
        .collection(type)
        .doc(docID)
        .set({
      'Current Amount': currentAmount,
    });
  }

  //Transactions from Firestore
  List<Budgets> _budgetsListFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        return Budgets(
          type: doc.data().toString().contains('Type') ? doc['Type'] : 'Budget',
          createdDate: doc.data().toString().contains('Created Date')
              ? doc['Created Date'].toDate()
              : DateTime(1999, 1, 1),
          title: doc.data().toString().contains('Title') ? doc['Title'] : '',
          budgetedAmount: doc.data().toString().contains('Budgeted Amount')
              ? doc['Budgeted Amount']
              : 0,
          currentAmount: doc.data().toString().contains('Current Amount')
              ? doc['Current Amount']
              : 0,
          docID: doc.data().toString().contains('Doc ID') ? doc['Doc ID'] : '',
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  //Short list of Income
  Stream<List<Budgets>> budgetList(uid, String type) async* {
    yield* FirebaseFirestore.instance
        .collection('Budgets')
        .doc(uid)
        .collection(type)
        .orderBy('Created Date', descending: true)
        .snapshots()
        .map(_budgetsListFromSnapshot);
  }

  //Delete Budget
  Future deleteBudget(String uid, String docID, String type) async {
    return await FirebaseFirestore.instance
        .collection('Budgets')
        .doc(uid)
        .collection(type)
        .doc(docID)
        .delete();
  }

  //Updated Budgeted amount
  Future updateBudget(
      String uid, String docID, String type, num budgetAmount) async {
    return await FirebaseFirestore.instance
        .collection('Budgets')
        .doc(uid)
        .collection(type)
        .doc(docID)
        .update({
      'Budgeted Amount': budgetAmount,
    });
  }

  Future updateGoal(
      String uid, String docID, String type, num budgetAmount) async {
    return await FirebaseFirestore.instance
        .collection('Budgets')
        .doc(uid)
        .collection(type)
        .doc(docID)
        .update({
      'Current Amount': budgetAmount,
    });
  }

  ///////////////////////////// RECURRENT TRANSACTIONS ///////////////////////////////////////

  //Create recurrent transactions
  Future createRecurrentTransaction(
      String userUID,
      String docID,
      String transactionName,
      String type,
      bool fromCreditPayment,
      num amount,
      DateTime recurrentDate,
      num repeatMonths,
      Map category) async {
    return await FirebaseFirestore.instance
        .collection('Transactions')
        .doc(userUID)
        .collection('Recurrent Transactions')
        .doc(docID)
        .set({
      'ID': docID,
      'Date Created': DateTime.now(),
      'Type': type,
      'Name': transactionName,
      'From Credit Payment': fromCreditPayment,
      'Recurrent Amount': amount,
      'Recurrent Date': recurrentDate,
      'Repeat Months': repeatMonths,
      'Months Paid': 0,
      'Active': true,
      'Category': category
    });
  }

  //Update recurrent transaction months paid
  Future updateRecurrentTransaction(
      String userUID, String docID, num amount, num monthsPaid) async {
    return await FirebaseFirestore.instance
        .collection('Transactions')
        .doc(userUID)
        .collection('Recurrent Transactions')
        .doc(docID)
        .update({
      'Recurrent Amount': amount,
      'Months Paid': monthsPaid,
    });
  }

  //Update and deactivate
  Future updateandDeactivateRecurrentTransaction(
      String userUID, String docID, num amount, num monthsPaid) async {
    return await FirebaseFirestore.instance
        .collection('Transactions')
        .doc(userUID)
        .collection('Recurrent Transactions')
        .doc(docID)
        .update({
      'Recurrent Amount': amount,
      'Months Paid': monthsPaid,
      'Active': false
    });
  }

  //Delete recurrent trs
  Future deleteRecurrentTransaction(
    String userUID,
    String docID,
  ) async {
    return await FirebaseFirestore.instance
        .collection('Transactions')
        .doc(userUID)
        .collection('Recurrent Transactions')
        .doc(docID)
        .delete();
  }

  List<RecurrentTransactions> _recurrenttransactionsListFromSnapshot(
      QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        return RecurrentTransactions(
          dateCreated: doc.data().toString().contains('Date Created')
              ? doc['Date Created'].toDate()
              : DateTime(1999, 1, 1),
          id: doc.data().toString().contains('ID') ? doc['ID'] : '',
          transactionType:
              doc.data().toString().contains('Type') ? doc['Type'] : '',
          transactionName:
              doc.data().toString().contains('Name') ? doc['Name'] : '',
          fromCreditPayment:
              doc.data().toString().contains('From Credit Payment')
                  ? doc['From Credit Payment']
                  : false,
          recurrentAmount: doc.data().toString().contains('Recurrent Amount')
              ? doc['Recurrent Amount']
              : 0,
          recurrentDate: doc.data().toString().contains('Recurrent Date')
              ? doc['Recurrent Date'].toDate()
              : DateTime(1999, 1, 1),
          repeatxMonths: doc.data().toString().contains('Repeat Months')
              ? doc['Repeat Months']
              : 0,
          monthsPaid: doc.data().toString().contains('Months Paid')
              ? doc['Months Paid']
              : 0,
          active:
              doc.data().toString().contains('Active') ? doc['Active'] : false,
          category:
              doc.data().toString().contains('Category') ? doc['Category'] : {},
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Stream<List<RecurrentTransactions>> recurrentTransactionsList(
    uid,
  ) async* {
    yield* FirebaseFirestore.instance
        .collection('Transactions')
        .doc(uid)
        .collection('Recurrent Transactions')
        .where('Active', isEqualTo: true)
        .orderBy('Date Created', descending: true)
        .snapshots()
        .map(_recurrenttransactionsListFromSnapshot);
  }
}
