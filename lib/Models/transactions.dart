class Transactions {
  final DateTime? date;
  final String? transactionType;
  final String? category;
  final String? description;
  final num? amount;
  final Map? paymentMethod;

  Transactions(
      {this.date,
      this.transactionType,
      this.category,
      this.description,
      this.amount,
      this.paymentMethod});
}
