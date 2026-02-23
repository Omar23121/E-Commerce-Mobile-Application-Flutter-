class Order {
  final String id;
  final double total;
  final DateTime eta;
  final DateTime createdAt;

  Order(this.id, this.total, this.eta, this.createdAt);

  Map<String, dynamic> toJson() => {
    "id": id,
    "total": total,
    "eta": eta.toIso8601String(),
    "createdAt": createdAt.toIso8601String(),
  };

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    json["id"],
    json["total"],
    DateTime.parse(json["eta"]),
    DateTime.parse(json["createdAt"]),
  );
}