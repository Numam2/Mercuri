class SharedAccounts {
  final String? accountID;
  final String? accountName;
  final String? accountType; //Income or expense
  final List? members; //UIDs
  final List? pendingMembers;
  final DateTime? createdDate;
  final String? createdBy;

  SharedAccounts(
      {this.accountID,
      this.accountName,
      this.accountType,
      this.members, //UID of members
      this.pendingMembers,
      this.createdDate,
      this.createdBy});
}

class SharedAcctTransactions {
  final String? docID;
  final String? userName;
  final String? userUID;
  final DateTime? dateCreated;
  final DateTime? transactionDate;
  final num? amount;
  final String? description;
  final String? category;
  final String? type;
  final Map? paymentMethod; //{Method name, method icon}

  SharedAcctTransactions(
      {this.docID,
      this.userName,
      this.userUID,
      this.dateCreated,
      this.transactionDate,
      this.amount,
      this.description,
      this.category,
      this.type,
      this.paymentMethod});
}

class SharedAccountsStats {
  final int? numberOfTransaction;
  final num? totalIncome;
  final num? totalExpenses;
  final Map<String, dynamic>? expensesByCategory;
  final Map<String, dynamic>? expensesByUser;
  final Map<String, dynamic>? incomeByCategory;
  final Map<String, dynamic>? incomeByUser;

  SharedAccountsStats(
      {this.numberOfTransaction,
      this.totalIncome,
      this.totalExpenses,
      this.expensesByCategory,
      this.expensesByUser,
      this.incomeByCategory,
      this.incomeByUser});
}
