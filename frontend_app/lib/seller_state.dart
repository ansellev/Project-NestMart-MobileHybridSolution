import 'package:flutter/material.dart';
import 'favorites_state.dart';

// ──────────────────────────────────────────────────────────────────────────────
// MODEL: SellerProduct
// ──────────────────────────────────────────────────────────────────────────────

class SellerProduct {
  String id;
  String name;
  String description;
  String price;
  String category;
  String image;

  SellerProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.image,
  });
}

// ──────────────────────────────────────────────────────────────────────────────
// MODEL: SellerOrder
// ──────────────────────────────────────────────────────────────────────────────

class SellerOrder {
  final String id;
  final String productName;
  final String productImage;
  final String buyerName;
  final int quantity;
  final String totalPrice;
  final String date;
  String status; // BARU | DIPROSES | DIKIRIM | SELESAI

  SellerOrder({
    required this.id,
    required this.productName,
    required this.productImage,
    required this.buyerName,
    required this.quantity,
    required this.totalPrice,
    required this.date,
    this.status = 'BARU',
  });
}

// ──────────────────────────────────────────────────────────────────────────────
// STATE: SellerState  (singleton + static ValueNotifiers)
// ──────────────────────────────────────────────────────────────────────────────

class SellerState {
  // Singleton
  static final SellerState _instance = SellerState._internal();
  factory SellerState() => _instance;
  SellerState._internal();

  // ID unik toko seller — digunakan saat add/remove dari STORES global
  static const sellerStoreId = 'seller_owned_store';

  // ValueNotifier agar AccountScreen bisa reactive terhadap perubahan hasStore
  static final ValueNotifier<bool> hasStoreNotifier =
      ValueNotifier<bool>(false);

  bool get hasStore => hasStoreNotifier.value;
  set hasStore(bool v) => hasStoreNotifier.value = v;
  String storeName = '';
  String storeAddress = '';
  String storeCategory = 'Umum';
  String storeImage = '';

  // Reactive lists
  static final ValueNotifier<List<SellerProduct>> products =
      ValueNotifier<List<SellerProduct>>([]);

  static final ValueNotifier<List<SellerOrder>> orders =
      ValueNotifier<List<SellerOrder>>([]);

  // ── Statistics ────────────────────────────────────────────

  static double get totalRevenue {
    double total = 0;
    for (final o in orders.value) {
      total +=
          double.tryParse(o.totalPrice.replaceAll(RegExp(r'[^0-9]'), '')) ??
              0;
    }
    return total;
  }

  static String formatRupiah(double amount) {
    final str = amount.toStringAsFixed(0);
    String result = '';
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      result = str[i] + result;
      count++;
      if (count % 3 == 0 && i != 0) result = '.$result';
    }
    return 'Rp$result';
  }

  // ── Product CRUD ──────────────────────────────────────────

  /// Konversi SellerProduct → FavoriteProduct agar bisa masuk allProducts
  static FavoriteProduct _toFavoriteProduct(SellerProduct p) {
    return FavoriteProduct(
      id: p.id,
      name: p.name,
      price: p.price,
      rating: '5.0',
      category: p.category,
      description: p.description,
      image: p.image,
    );
  }

  static void addProduct(SellerProduct p) {
    products.value = [...products.value, p];
    // Sync → produk seller langsung bisa ditemukan di search bar pembeli
    FavoritesState.allProducts.add(_toFavoriteProduct(p));
  }

  static void updateProduct(SellerProduct updated) {
    products.value =
        products.value.map((p) => p.id == updated.id ? updated : p).toList();
    // Sync → hapus versi lama, tambah versi baru yang sudah diupdate
    FavoritesState.allProducts.removeWhere((fp) => fp.id == updated.id);
    FavoritesState.allProducts.add(_toFavoriteProduct(updated));
  }

  static void deleteProduct(String id) {
    products.value = products.value.where((p) => p.id != id).toList();
    // Sync → hapus dari allProducts agar tidak muncul di search bar
    FavoritesState.allProducts.removeWhere((fp) => fp.id == id);
  }

  // ── Mock seed data (called once after store registration) ─

  static void initMockOrders() {
    if (orders.value.isNotEmpty) return;
    const months = [
      'JAN', 'FEB', 'MAR', 'APR', 'MEI', 'JUN',
      'JUL', 'AGU', 'SEP', 'OKT', 'NOV', 'DES'
    ];
    final now = DateTime.now();
    final date = '${now.day} ${months[now.month - 1]} ${now.year}';

    orders.value = [
      SellerOrder(
        id: 'so_001',
        productName: 'Produk Terlaris',
        productImage:
            'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=400&auto=format&fit=crop',
        buyerName: 'Rudi Hartono',
        quantity: 2,
        totalPrice: 'Rp140.000',
        date: date,
        status: 'BARU',
      ),
      SellerOrder(
        id: 'so_002',
        productName: 'Produk Premium',
        productImage:
            'https://images.unsplash.com/photo-1472851294608-062f824d29cc?w=400&auto=format&fit=crop',
        buyerName: 'Siti Rahayu',
        quantity: 1,
        totalPrice: 'Rp250.000',
        date: date,
        status: 'DIPROSES',
      ),
      SellerOrder(
        id: 'so_003',
        productName: 'Produk Eksklusif',
        productImage:
            'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400&auto=format&fit=crop',
        buyerName: 'Budi Setiawan',
        quantity: 3,
        totalPrice: 'Rp450.000',
        date: date,
        status: 'DIKIRIM',
      ),
    ];
  }

  // ── Reset (called when seller closes their store) ─────────

  static void reset() {
    final s = SellerState();
    s.hasStore = false; // triggers hasStoreNotifier listeners
    s.storeName = '';
    s.storeAddress = '';
    s.storeCategory = 'Umum';
    s.storeImage = '';
    // Bersihkan semua produk seller dari allProducts (ID dimulai dengan 'sp_')
    FavoritesState.allProducts.removeWhere((fp) => fp.id.startsWith('sp_'));
    // Bersihkan juga dari favoriteIds jika ada yang sempat difavoritkan
    final cleanedFavs = Set<String>.from(FavoritesState.favoriteIds.value)
      ..removeWhere((id) => id.startsWith('sp_'));
    FavoritesState.favoriteIds.value = cleanedFavs;
    products.value = [];
    orders.value = [];
  }
}
