class AppUser {
  final String? uid;

  AppUser({this.uid});
}

class UserData {
  final String? uid;
  final String? name;
  final String? email;
  final List<dynamic>? expenseCategories;
  final List<dynamic>? incomeCategories;
  final List? invitedSharedAccount;
  final List<dynamic>? paymentMethods; //name, icon
  final List? budgetCategories;
  final List? searchName;
  final List? searchEmail;
  final List? sharedAccounts;
  final bool? freeUser;

  UserData(
      {this.uid,
      this.name,
      this.email,
      this.expenseCategories,
      this.incomeCategories,
      this.invitedSharedAccount,
      this.paymentMethods,
      this.budgetCategories,
      this.searchName,
      this.searchEmail,
      this.sharedAccounts,
      this.freeUser});
}

class UserCreditTransactions {
  final String? transactionTitle;
  final DateTime? transactionDate;
  final num? transactionTotal;
  final bool? amortized;
  final num? amortizationMonths;
  final num? amortizationMonthlyAmount;
  final num? amortizedTotal;
  final num? amortizedMonthsPaid;

  UserCreditTransactions(
      {this.transactionTitle,
      this.transactionDate,
      this.transactionTotal,
      this.amortized,
      this.amortizationMonths,
      this.amortizationMonthlyAmount,
      this.amortizedTotal,
      this.amortizedMonthsPaid});
}
