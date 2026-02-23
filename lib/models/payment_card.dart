class PaymentCard {
  final String cardHolder;
  final String cardNumber;

  PaymentCard(this.cardHolder, this.cardNumber);

  Map<String, dynamic> toJson() => {
    "cardHolder": cardHolder,
    "cardNumber": cardNumber,
  };

  factory PaymentCard.fromJson(Map<String, dynamic> json) =>
      PaymentCard(
        json["cardHolder"],
        json["cardNumber"],
      );
}