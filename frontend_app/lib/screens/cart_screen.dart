import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import 'menu_screen.dart';
import '../favorites_state.dart';
import 'checkout_screen.dart';
import '../user_session.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final UserSession _session = UserSession();

  FavoriteProduct _getProductForCartItem(String name) {
    final cleanName = name.toLowerCase().replaceAll(' ', '');
    // Pencocokan id secara langsung untuk item keranjang bawaan
    if (cleanName.contains('luxury')) {
      return FavoritesState.allProducts.firstWhere(
        (p) => p.id == '8',
        orElse: () => FavoritesState.allProducts[0],
      );
    }
    if (cleanName.contains('urban')) {
      return FavoritesState.allProducts.firstWhere(
        (p) => p.id == '9',
        orElse: () => FavoritesState.allProducts[1],
      );
    }
    if (cleanName.contains('yamato')) {
      return FavoritesState.allProducts.firstWhere(
        (p) => p.id == '13',
        orElse: () => FavoritesState.allProducts[2],
      );
    }

    // Fallback pencarian teks jika nama item mengalami modifikasi
    for (var p in FavoritesState.allProducts) {
      final pName = p.name.toLowerCase().replaceAll(' ', '');
      if (pName.contains(cleanName) || cleanName.contains(pName)) {
        return p;
      }
    }
    return FavoritesState.allProducts[0];
  }

  @override
  Widget build(BuildContext context) {
    final cartList = _session.cartItems;

    // Hitung total harga dan jumlah barang secara dinamis
    double total = 0;
    int totalItems = 0;
    for (var item in cartList) {
      total += (item['price'] as double) * (item['qty'] as int);
      totalItems += item['qty'] as int;
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  'MY CART',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.merriweather(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: cartList.length,
                  itemBuilder: (context, index) {
                    return _buildCartItem(context, cartList[index], index);
                  },
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'TOTAL (3 ITEMS)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '\$79.48',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/checkout');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'CHECKOUT',
                          style: GoogleFonts.merriweather(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 72,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavTab(Icons.storefront_outlined, 'Shop', false, () {
              Navigator.pushReplacementNamed(context, '/menu');
            }),
            _buildNavTab(Icons.manage_search, 'Kategori', false, () {
              Navigator.pushReplacementNamed(context, '/category');
            }),
            _buildNavTab(Icons.shopping_cart_outlined, 'Cart', true, () {
              Navigator.pushReplacementNamed(context, '/cart');
            }),
            _buildNavTab(Icons.favorite_outline, 'Favourite', false, () {
              Navigator.pushReplacementNamed(context, '/favourite');
            }),
            _buildNavTab(Icons.person_outline, 'Account', false, () {
              Navigator.pushReplacementNamed(context, '/account');
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildNavTab(
    IconData icon,
    String label,
    bool active,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: active ? const Color(0xFF864F1F) : Colors.black45,
            size: 23,
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 9,
              fontWeight: active ? FontWeight.w900 : FontWeight.w700,
              color: active ? const Color(0xFF864F1F) : Colors.black45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(
    BuildContext context,
    Map<String, dynamic> item,
    int index,
  ) {
    final String name = item['name'] as String;
    final double price = (item['price'] as num).toDouble();
    final int qty = (item['qty'] as num).toInt();

    final prod = _getProductForCartItem(name);
    return Container(
      key: ValueKey(
        '${prod.id}_$index',
      ), // Unique key to guarantee clean state updates in Flutter list reconciliation
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Navigasi ke Halaman Detail hanya saat mengetuk Thumbnail Gambar
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/product',
                arguments: {
                  'id': prod.id,
                  'name': prod.name,
                  'price': prod.price,
                  'rating': FavoritesState.getProductAverageRating(
                    prod.id,
                  ).toStringAsFixed(1),
                  'image': prod.image,
                  'description': prod.description,
                },
              );
            },
            behavior: HitTestBehavior.opaque,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                prod.image,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama Produk dan tombol hapus
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Mengetuk Nama Produk juga mengarah ke halaman detail
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/product',
                            arguments: {
                              'id': prod.id,
                              'name': prod.name,
                              'price': prod.price,
                              'rating': FavoritesState.getProductAverageRating(
                                prod.id,
                              ).toStringAsFixed(1),
                              'image': prod.image,
                              'description': prod.description,
                            },
                          );
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Text(
                          prod.name.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    // Tombol Hapus (Tong Sampah) yang bersih, responsif, dan independen menggunakan Object Reference
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _session.cartItems.remove(item);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${prod.name} dihapus dari keranjang',
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: const EdgeInsets.all(
                          8.0,
                        ), // Generous tap target
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          LucideIcons.trash2,
                          size: 18,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Pengubah Kuantitas dan Harga Produk
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // Button MINUS
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              int currentQty = item['qty'] as int;
                              if (currentQty > 1) {
                                item['qty'] = currentQty - 1;
                              } else {
                                _session.cartItems.remove(item);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${prod.name} dihapus dari keranjang',
                                    ),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              }
                            });
                          },
                          behavior: HitTestBehavior.opaque,
                          child: _qtyBtn(LucideIcons.minus),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Text(
                            '${item['qty']}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        // Button PLUS
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              int currentQty = item['qty'] as int;
                              item['qty'] = currentQty + 1;
                            });
                          },
                          behavior: HitTestBehavior.opaque,
                          child: _qtyBtn(LucideIcons.plus),
                        ),
                      ],
                    ),
                    Text(
                      '\$${(price * (item['qty'] as int)).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(icon, size: 12),
    );
  }
}
