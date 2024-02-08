import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mercuri/Models/stats.dart';
import 'package:mercuri/Models/transactions.dart';

class DatabaseService {
  //Create Transaction
  Future createTransaction(String uid, String docID, DateTime date, String type,
      String category, String description, num amount) async {
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
      'Amount': amount
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
        .where('Type', isEqualTo: 'Income')
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
        .where('Type', isEqualTo: 'Expense')
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

  ///////////////////////////// STATS ///////////////////////////////////////

  //Update Stats
  Future updateStats(
    String uid,
    DateTime date,
    String type,
    String category,
    num amount,
  ) async {
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
}
