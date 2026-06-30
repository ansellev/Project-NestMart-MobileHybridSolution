class OrderModel {
  final int id;
  final int userId;

  final double total;

  final String status;

  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.total,
    required this.status,
    required this.createdAt,
  });

  factory OrderModel.fromJson(
      Map<String, dynamic> json) {
    return OrderModel(
      id: json["id"],
      userId: json["userId"],
      total: double.parse(
          json["total"].toString()),
      status: json["status"] ?? "",
      createdAt: DateTime.parse(
        json["createdAt"],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "total": total,
      "status": status,
      "createdAt":
          createdAt.toIso8601String(),
    };
  }
}