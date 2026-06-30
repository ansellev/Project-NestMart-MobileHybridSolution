import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  ApiService._();

  static final ApiService instance = ApiService._();

  static String get baseUrl {
    if (kIsWeb) return "http://localhost:3000";
    if (defaultTargetPlatform == TargetPlatform.android) return "http://10.0.2.2:3000";
    return "http://localhost:3000";
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
  }

  Future<Map<String, String>> _headers({
  bool auth = false,
}) async {
  final headers = {
    "Content-Type": "application/json",
  };

  if (auth) {
    final token = await getToken();

    print("TOKEN = $token");

    if (token != null) {
      headers["Authorization"] = "Bearer $token";
    }
  }

  print(headers);

  return headers;
}

  // ===========================
  // AUTH
  // ===========================

  Future<dynamic> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/register"),
      headers: await _headers(),
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
      }),
    );

    return jsonDecode(response.body);
  }

  Future<dynamic> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      headers: await _headers(),
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 &&
        data["access_token"] != null) {
      await saveToken(data["access_token"]);
    }

    return data;
  }

  Future<dynamic> getProfile() async {
    final response = await http.get(
      Uri.parse("$baseUrl/auth/profile"),
      headers: await _headers(auth: true),
    );

    return jsonDecode(response.body);
  }

  // ===========================
  // PRODUCTS
  // ===========================

  Future<dynamic> getProducts() async {
    final response = await http.get(
      Uri.parse("$baseUrl/products"),
    );

    return jsonDecode(response.body);
  }

  Future<dynamic> getProduct(int id) async {
    final response = await http.get(
      Uri.parse("$baseUrl/products/$id"),
    );

    return jsonDecode(response.body);
  }

  Future<dynamic> createProduct(
      Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse("$baseUrl/products"),
      headers: await _headers(auth: true),
      body: jsonEncode(body),
    );

    return jsonDecode(response.body);
  }

  Future<dynamic> updateProduct(
      int id,
      Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse("$baseUrl/products/$id"),
      headers: await _headers(auth: true),
      body: jsonEncode(body),
    );

    return jsonDecode(response.body);
  }

  Future<dynamic> deleteProduct(int id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/products/$id"),
      headers: await _headers(auth: true),
    );

    return jsonDecode(response.body);
  }

  // ===========================
  // STORE
  // ===========================

  Future<dynamic> createStore(
      Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse("$baseUrl/store"),
      headers: await _headers(auth: true),
      body: jsonEncode(body),
    );

    return jsonDecode(response.body);
  }

  Future<dynamic> getMyStore() async {
    final response = await http.get(
      Uri.parse("$baseUrl/store/me/profile"),
      headers: await _headers(auth: true),
    );

    return jsonDecode(response.body);
  }

  Future<dynamic> getStores() async {
    final response = await http.get(
      Uri.parse("$baseUrl/store"),
    );

    return jsonDecode(response.body);
  }

  Future<dynamic> updateStore(
      Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse("$baseUrl/store"),
      headers: await _headers(auth: true),
      body: jsonEncode(body),
    );

    return jsonDecode(response.body);
  }

  // ===========================
  // CART
  // ===========================

  Future<dynamic> getCart() async {
    final response = await http.get(
      Uri.parse("$baseUrl/cart"),
      headers: await _headers(auth: true),
    );

    return jsonDecode(response.body);
  }

  Future<dynamic> addToCart(
      int productId,
      int quantity) async {
    final response = await http.post(
      Uri.parse("$baseUrl/cart"),
      headers: await _headers(auth: true),
      body: jsonEncode({
        "productId": productId,
        "quantity": quantity,
      }),
    );

    return jsonDecode(response.body);
  }

  Future<dynamic> updateCart(
      int cartId,
      int quantity) async {
    final response = await http.put(
      Uri.parse("$baseUrl/cart/$cartId"),
      headers: await _headers(auth: true),
      body: jsonEncode({
        "quantity": quantity,
      }),
    );

    return jsonDecode(response.body);
  }

  Future<dynamic> removeCart(int cartId) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/cart/$cartId"),
      headers: await _headers(auth: true),
    );

    return jsonDecode(response.body);
  }

  // ===========================
  // ORDERS
  // ===========================

  Future<dynamic> checkout() async {
    final response = await http.post(
      Uri.parse("$baseUrl/orders/checkout"),
      headers: await _headers(auth: true),
    );

    return jsonDecode(response.body);
  }

  Future<dynamic> getOrders() async {
    final response = await http.get(
      Uri.parse("$baseUrl/orders/my"),
      headers: await _headers(auth: true),
    );

    return jsonDecode(response.body);
  }

  Future<dynamic> getOrderDetail(int id) async {
    final response = await http.get(
      Uri.parse("$baseUrl/orders/$id"),
      headers: await _headers(auth: true),
    );

    return jsonDecode(response.body);
  }

  // ===========================
  // FAVORITES
  // ===========================

  Future<dynamic> getFavorites() async {
    final response = await http.get(
      Uri.parse("$baseUrl/favorites"),
      headers: await _headers(auth: true),
    );

    return jsonDecode(response.body);
  }

  Future<dynamic> addFavorite(int productId) async {
    final response = await http.post(
      Uri.parse("$baseUrl/favorites/$productId"),
      headers: await _headers(auth: true),
    );

    return jsonDecode(response.body);
  }

  Future<dynamic> removeFavorite(int productId) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/favorites/$productId"),
      headers: await _headers(auth: true),
    );

    return jsonDecode(response.body);
  }

  // ===========================
  // REVIEWS
  // ===========================

  Future<dynamic> getReviews(int productId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/reviews/$productId"),
    );

    return jsonDecode(response.body);
  }

  Future<dynamic> createReview(
      Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse("$baseUrl/reviews"),
      headers: await _headers(auth: true),
      body: jsonEncode(body),
    );

    return jsonDecode(response.body);
  }

  Future<dynamic> updateReview(
      int reviewId,
      Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse("$baseUrl/reviews/$reviewId"),
      headers: await _headers(auth: true),
      body: jsonEncode(body),
    );

    return jsonDecode(response.body);
  }

  Future<dynamic> deleteReview(int reviewId) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/reviews/$reviewId"),
      headers: await _headers(auth: true),
    );

    return jsonDecode(response.body);
  }

  Future<dynamic> updateProfile({
  String? name,
  String? email,
  String? password,
}) async {
  final response = await http.patch(
    Uri.parse("$baseUrl/auth/profile"),
    headers: await _headers(auth: true),
    body: jsonEncode({
      if (name != null) "name": name,
      if (email != null) "email": email,
      if (password != null) "password": password,
    }),
  );

  print("STATUS : ${response.statusCode}");
  print("BODY : ${response.body}");

  return jsonDecode(response.body);
}
}
