import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'search_screen.dart';
import 'notification_screen.dart';
import '../favorites_state.dart';
import '../widgets/cart_state.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ==========================================
    // 1. DATA KATEGORI
    // ==========================================
    final List<Map<String, String>> categories = [
      {'name': 'Elektronik', 'image': 'assets/elektronik.png'},
      {'name': 'Pakaian', 'image': 'assets/pakaian.png'},
      {'name': 'Olahraga', 'image': 'assets/olahraga.png'},
      {'name': 'Perabotan', 'image': 'assets/perabotan.png'},
      {'name': 'Kecantikan', 'image': 'assets/kecantikan.png'},
    ];

    // ==========================================
    // 2. DATA PRODUK — sumber tunggal: FavoritesState.allProducts
    //    Menjamin produk di home konsisten dengan hasil search bar
    // ==========================================
    Map<String, String> _toMap(FavoriteProduct p) => {
      'id': p.id,
      'name': p.name,
      'price': p.price,
      'image': p.image,
      'description': p.description,
    };

    final recomendations = FavoritesState.allProducts
        .where((p) => ['2', '3', '4', '8'].contains(p.id))
        .map(_toMap)
        .toList();

    final justForYou = FavoritesState.allProducts
        .where((p) => ['1', '5', '7', '10'].contains(p.id))
        .map(_toMap)
        .toList();

    const bgColor = Color(0xFFECEAE6);
    const primaryBrown = Color(0xFF7E4D2B);

    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================
            // HEADER COKLAT
            // ==========================================
            Container(
              decoration: const BoxDecoration(
                color: primaryBrown,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              padding: const EdgeInsets.only(
                top: 64,
                left: 24,
                right: 24,
                bottom: 32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationScreen(),
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            const Icon(
                              Icons.notifications_none_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                            Positioned(
                              top: 2,
                              right: 2,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: Colors.orangeAccent,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: primaryBrown,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'HI ANDI',
                    style: GoogleFonts.merriweather(
                      fontWeight: FontWeight.w900,
                      fontSize: 26,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Search Bar
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SearchScreen(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Cari barang impianmu...',
                            style: GoogleFonts.inter(
                              color: Colors.black38,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          const Icon(
                            Icons.search_rounded,
                            color: Colors.black54,
                            size: 26,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ==========================================
            // KONTEN UTAMA
            // ==========================================
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 28.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- SECTION KATEGORI ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Kategori',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/category'),
                        child: Text(
                          'Lihat Semua',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: primaryBrown,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    height: 110,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, idx) {
                        final String imagePath = categories[idx]['image'] ?? '';
                        return Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: GestureDetector(
                            onTap: () => Navigator.pushNamed(
                              context,
                              '/category',
                              arguments: categories[idx]['name'],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: primaryBrown,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: primaryBrown.withValues(
                                          alpha: 0.3,
                                        ),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: imagePath.isNotEmpty
                                      ? Image.asset(
                                          imagePath,
                                          fit: BoxFit.contain,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Icon(
                                                    Icons.broken_image_rounded,
                                                    color: Colors.white54,
                                                  ),
                                        )
                                      : const Icon(
                                          Icons.category_rounded,
                                          color: Colors.white54,
                                        ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  categories[idx]['name'] as String,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 28),

                  // --- SECTION REKOMENDASI PRODUK ---
                  Text(
                    'Rekomendasi Produk',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    height: 230,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: recomendations.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, idx) {
                        return _buildProductCard(
                          context: context,
                          item: recomendations[idx],
                          width: 150,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),

                  // --- PROMO BANNER ---
                  Text(
                    'Promo Spesial',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ), // DI SINI: Jarak diperkecil agar gambar promo naik
                  Container(
                    width: double.infinity,
                    height: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        'assets/promo.png',
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: const Color(0xFFFBEADB),
                          child: const Center(
                            child: Text(
                              'Promo Image Not Found',
                              style: TextStyle(color: Colors.orange),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),

                  // --- SECTION UNTUK KAMU ---
                  Text(
                    'Untuk Kamu',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(
                    height: 0,
                  ), // DI SINI: Jarak diperkecil agar grid kotak produk naik
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 20,
                          childAspectRatio: 0.70,
                        ),
                    itemCount: justForYou.length,
                    itemBuilder: (context, idx) {
                      return _buildProductCard(
                        context: context,
                        item: justForYou[idx],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // ==========================================
      // BOTTOM NAVIGATION BAR
      // ==========================================
      bottomNavigationBar: Container(
        height: 76,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 15,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavTab(Icons.storefront_rounded, 'Home', true, () {}),
            _buildNavTab(
              Icons.manage_search_rounded,
              'Kategori',
              false,
              () => Navigator.pushNamed(context, '/category'),
            ),
            _buildNavTab(
              Icons.shopping_cart_outlined,
              'Keranjang',
              false,
              () => Navigator.pushNamed(context, '/cart'),
            ),
            _buildNavTab(
              Icons.favorite_outline_rounded,
              'Favorit',
              false,
              () => Navigator.pushNamed(context, '/favourite'),
            ),
            _buildNavTab(
              Icons.person_outline_rounded,
              'Akun',
              false,
              () => Navigator.pushNamed(context, '/account'),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // WIDGET REUSABLE: PRODUCT CARD
  // =========================================================================
  Widget _buildProductCard({
    required BuildContext context,
    required Map<String, String> item,
    double? width,
  }) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/product', arguments: item),
      child: Container(
        width: width,
        margin: width != null
            ? const EdgeInsets.only(right: 16.0, bottom: 8.0)
            : null,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF6F4F2),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: item['image']!.startsWith('http')
                            ? Image.network(
                                item['image']!,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.broken_image_rounded,
                                  color: Colors.black26,
                                  size: 40,
                                ),
                              )
                            : Image.asset(
                                item['image']!,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.broken_image_rounded,
                                  color: Colors.black26,
                                  size: 40,
                                ),
                              ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: ValueListenableBuilder<Set<String>>(
                        valueListenable: FavoritesState.favoriteIds,
                        builder: (_, favIds, __) {
                          final isFav = favIds.contains(item['id']!);
                          return GestureDetector(
                            onTap: () =>
                                FavoritesState.toggleFavorite(item['id']!),
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: Icon(
                                isFav
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                color: isFav
                                    ? Colors.red
                                    : const Color(0xFF7E4D2B),
                                size: 18,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14.0,
                  vertical: 12.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name']!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: List.generate(
                            5,
                            (index) => const Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            item['price']!,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w900,
                              fontSize: 13,
                              color: const Color(0xFF7E4D2B),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            CartState.addToCart(CartItem(
                              id: item['id']!,
                              name: item['name']!,
                              price: CartState.parsePrice(item['price']!),
                              image: item['image']!,
                              quantity: 1,
                            ));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    '${item['name']} ditambahkan ke keranjang!'),
                                duration: const Duration(seconds: 1),
                                backgroundColor: const Color(0xFF7E4D2B),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xFF864F1F),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // WIDGET REUSABLE: BOTTOM NAVIGATION TAB
  // =========================================================================
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
            color: active ? const Color(0xFF7E4D2B) : Colors.black38,
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: active ? FontWeight.w800 : FontWeight.w600,
              color: active ? const Color(0xFF7E4D2B) : Colors.black38,
            ),
          ),
        ],
      ),
    );
  }
}
