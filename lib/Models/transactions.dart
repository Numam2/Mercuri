class Transactions {
  final DateTime? date;
  final String? transactionType;
  final String? category;
  final String? description;
  final num? amount;

  Transactions(
      {this.date,
      this.transactionType,
      this.category,
      this.description,
      this.amount});
}
