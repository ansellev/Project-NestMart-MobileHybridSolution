import 'package:flutter/material.dart';

// Model untuk menyimpan data per item di keranjang
class CartItem {
  final String id;
  final String name;
  final double price; // Harga disimpan dalam bentuk angka asli
  final String image;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    this.quantity = 1,
  });
}

class CartState {
  // ValueNotifier agar UI otomatis ter-update saat data keranjang berubah
  static final ValueNotifier<List<CartItem>> cartItems = ValueNotifier([]);

  // Fungsi mengubah String "Rp15.999.000" menjadi angka 15999000.0
  static double parsePrice(String priceStr) {
    String cleanPrice = priceStr.replaceAll(RegExp(r'[^0-9]'), '');
    return double.tryParse(cleanPrice) ?? 0.0;
  }

  // Fungsi memformat angka 15999000.0 kembali menjadi "Rp15.999.000"
  static String formatRupiah(double number) {
    String str = number.toStringAsFixed(0);
    String result = '';
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      result = str[i] + result;
      count++;
      if (count % 3 == 0 && i != 0) {
        result = '.$result';
      }
    }
    return 'Rp$result';
  }

  // Menambahkan produk ke keranjang
  static void addToCart(CartItem newItem) {
    final List<CartItem> currentCart = List.from(cartItems.value);

    // Cek apakah barang sudah ada di keranjang
    int existingIndex = currentCart.indexWhere((item) => item.id == newItem.id);

    if (existingIndex >= 0) {
      // Jika sudah ada, tambahkan quantity-nya saja
      currentCart[existingIndex].quantity += newItem.quantity;
    } else {
      // Jika belum ada, masukkan sebagai barang baru
      currentCart.add(newItem);
    }

    cartItems.value = currentCart;
  }

  // Mengubah jumlah barang (Plus / Minus) di keranjang
  static void updateQuantity(String id, int delta) {
    final List<CartItem> currentCart = List.from(cartItems.value);
    int index = currentCart.indexWhere((item) => item.id == id);

    if (index >= 0) {
      currentCart[index].quantity += delta;
      // Jika quantity jadi 0, hapus dari keranjang
      if (currentCart[index].quantity <= 0) {
        currentCart.removeAt(index);
      }
      cartItems.value = currentCart;
    }
  }

  // Menghitung total harga semua barang di keranjang
  static double getTotalPrice() {
    double total = 0;
    for (var item in cartItems.value) {
      total += (item.price * item.quantity);
    }
    return total;
  }
}
