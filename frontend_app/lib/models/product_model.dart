class ProductModel {
  final int id;
  final int sellerId;
  final int storeId;

  final String name;
  final String description;
  final String image;
  final String category;

  final double price;

  final int stock;
  final int sold;

  final bool isActive;

  ProductModel({
    required this.id,
    required this.sellerId,
    required this.storeId,
    required this.name,
    required this.description,
    required this.image,
    required this.category,
    required this.price,
    required this.stock,
    required this.sold,
    required this.isActive,
  });

  factory ProductModel.fromJson(
      Map<String, dynamic> json) {
    return ProductModel(
      id: json["id"],
      sellerId: json["sellerId"],
      storeId: json["storeId"],
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      image: json["image"] ?? "",
      category: json["category"] ?? "",
      price: double.parse(
          json["price"].toString()),
      stock: json["stock"],
      sold: json["sold"],
      isActive: json["isActive"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "sellerId": sellerId,
      "storeId": storeId,
      "name": name,
      "description": description,
      "image": image,
      "category": category,
      "price": price,
      "stock": stock,
      "sold": sold,
      "isActive": isActive,
    };
  }
}