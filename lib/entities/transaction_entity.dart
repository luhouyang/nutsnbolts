class TransactionEntity {
  final String type;
  final String username;
  final String description;
  final double amount;

  TransactionEntity(
      {required this.type,
      required this.username,
      required this.description,
      required this.amount});
}
