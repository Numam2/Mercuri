class AppUser {
  final String? uid;

  AppUser({this.uid});
}

class UserData {
  final String? uid;
  final String? name;
  final bool? freeTrial;
  final DateTime? trialFrom;
  final DateTime? trialTo;
  final bool? subscribed;
  final String? email;
  final List<dynamic>? expenseCategories;
  final List<dynamic>? incomeCategories;
  final List? invitedSharedAccount;
  final List<dynamic>? paymentMethods; //name, icon
  final List? budgetCategories;
  final List? searchName;
  final List? searchEmail;
  final List? sharedAccounts;

  UserData(
      {this.uid,
      this.name,
      this.freeTrial,
      this.trialFrom,
      this.trialTo,
      this.email,
      this.subscribed,
      this.expenseCategories,
      this.incomeCategories,
      this.invitedSharedAccount,
      this.paymentMethods,
      this.budgetCategories,
      this.searchName,
      this.searchEmail,
      this.sharedAccounts});
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
