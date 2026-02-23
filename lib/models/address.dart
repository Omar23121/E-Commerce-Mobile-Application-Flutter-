class Address {
  final String fullName;
  final String street;
  final String city;
  final String zip;
  final String phone;
  final String email;

  Address(
      this.fullName,
      this.street,
      this.city,
      this.zip,
      this.phone,
      this.email,
      );

  Map<String, dynamic> toJson() => {
    "fullName": fullName,
    "street": street,
    "city": city,
    "zip": zip,
    "phone": phone,
    "email": email,
  };

  factory Address.fromJson(Map<String, dynamic> json) =>
      Address(
        json["fullName"],
        json["street"],
        json["city"],
        json["zip"],
        json["phone"] ?? "",
        json["email"] ?? "",
      );
}