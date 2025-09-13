class RecurrentTransactions {
  final String? id;
  final DateTime? dateCreated;
  final String? transactionType; //income or expense
  final bool? fromCreditPayment;
  final String? transactionName;
  final num? recurrentAmount;
  final DateTime? recurrentDate; //take only month and day
  final num? repeatxMonths; //Months: 1,3,6,9,12,18,24,forever
  final num? monthsPaid;
  final bool? active;
  final Map? category;
  final Map? associatedSharedAcct;
  final DateTime? lastPaid;
  final DateTime? nextPayment;

  RecurrentTransactions(
      {this.id,
      this.dateCreated,
      this.transactionType,
      this.fromCreditPayment,
      this.transactionName,
      this.recurrentAmount,
      this.recurrentDate,
      this.repeatxMonths,
      this.monthsPaid,
      this.active,
      this.category,
      this.associatedSharedAcct,
      this.lastPaid,
      this.nextPayment});
}
