class Stats {
  final num? monthlyIncome;
  final num? monthlyExpenses;
  final Map<String, dynamic>? incomeByCategory;
  final Map<String, dynamic>? expensesByCategory;
  final Map<String, dynamic>? expensesByPaymentType;

  Stats(
      {this.monthlyIncome,
      this.monthlyExpenses,
      this.incomeByCategory,
      this.expensesByCategory,
      this.expensesByPaymentType});
}
