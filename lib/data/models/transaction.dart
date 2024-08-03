class Transaction {
  final String id;
  final String fromCard;
  final String toCard;
  final num amount;

  Transaction({
    required this.id,
    required this.fromCard,
    required this.toCard,
    required this.amount,
  });
}
