class CartModel {
  final int cartId;
  final int productId;
  final int sellerId;
  final int storeId;

  final String name;
  final String description;
  final String image;
  final String category;

  final double price;

  final int quantity;
  final int stock;

  final double subtotal;

  CartModel({
    required this.cartId,
    required this.productId,
    required this.sellerId,
    required this.storeId,
    required this.name,
    required this.description,
    required this.image,
    required this.category,
    required this.price,
    required this.quantity,
    required this.stock,
    required this.subtotal,
  });

  factory CartModel.fromJson(
      Map<String, dynamic> json) {
    return CartModel(
      cartId: json["cartId"],
      productId: json["productId"],
      sellerId: json["sellerId"],
      storeId: json["storeId"],
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      image: json["image"] ?? "",
      category: json["category"] ?? "",
      price: double.parse(
          json["price"].toString()),
      quantity: json["quantity"],
      stock: json["stock"],
      subtotal: double.parse(
          json["subtotal"].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "cartId": cartId,
      "productId": productId,
      "sellerId": sellerId,
      "storeId": storeId,
      "name": name,
      "description": description,
      "image": image,
      "category": category,
      "price": price,
      "quantity": quantity,
      "stock": stock,
      "subtotal": subtotal,
    };
  }
}