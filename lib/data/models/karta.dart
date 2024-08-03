class Karta {
  final String id;
  final String fullName;
  final String cardNumber;
  final DateTime expiryDate;
  double balance;

  Karta({
    required this.id,
    required this.fullName,
    required this.cardNumber,
    required this.expiryDate,
    required this.balance,
  });
}
