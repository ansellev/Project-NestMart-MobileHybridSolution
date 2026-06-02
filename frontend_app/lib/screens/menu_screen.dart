import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'search_screen.dart';
import 'notification_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ==========================================
    // 1. DATA KATEGORI
    // ==========================================
    final categories = [
      {'name': 'Elektronik', 'icon': Icons.devices_other_rounded},
      {'name': 'Pakaian', 'icon': Icons.checkroom_rounded},
      {'name': 'Olahraga', 'icon': Icons.fitness_center_rounded},
      {'name': 'Perabotan', 'icon': Icons.chair_rounded},
      {'name': 'Kecantikan', 'icon': Icons.spa_rounded},
    ];

    // ==========================================
    // 2. DATA PRODUK (Rekomendasi & Untuk Kamu)
    // ==========================================
    final recomendations = [
      {
        'id': '1',
        'name': 'Action Figure',
        'price': '\$10',
        'image': 'assets/images/action_figure.png',
      },
      {
        'id': '2',
        'name': 'Iphone 17 Pro Max',
        'price': '\$1.199',
        'image': 'assets/images/iphone.png',
      },
      {
        'id': '3',
        'name': 'Adidas training fullset',
        'price': '\$124',
        'image': 'assets/images/adidas.png',
      },
    ];

    final justForYou = [
      {
        'id': '4',
        'name': 'Nike dunk retro',
        'price': '\$60',
        'image': 'assets/images/nike.png',
      },
      {
        'id': '5',
        'name': 'Retro helmet',
        'price': '\$40',
        'image': 'assets/images/helmet.png',
      },
      {
        'id': '6',
        'name': 'Superman figure',
        'price': '\$35',
        'image': 'assets/images/superman.png',
      },
      {
        'id': '7',
        'name': 'Logitech Keyboard',
        'price': '\$50',
        'image': 'assets/images/keyboard.png',
      },
    ];

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
            // HEADER COKLAT MELENGKUNG
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
                top: 56,
                left: 24,
                right: 24,
                bottom: 28,
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
                              size: 28,
                            ),
                            Positioned(
                              top: 2,
                              right: 2,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.orange,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'HI ANDI',
                    style: GoogleFonts.merriweather(
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 18),
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
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Belanja sekarang...',
                            style: GoogleFonts.inter(
                              color: Colors.black45,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          const Icon(
                            Icons.search,
                            color: Colors.black54,
                            size: 24,
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
                horizontal: 20.0,
                vertical: 24.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SECTION KATEGORI
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Kategori',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/category'),
                        child: Text(
                          'See all',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // ==========================================
                  // KATEGORI BUTTON YANG SUDAH DIPERBESAR
                  // ==========================================
                  SizedBox(
                    height:
                        120, // Diperbesar dari 100 agar teks tidak terpotong
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, idx) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            right: 16.0,
                          ), // Spasi antar item diperlebar sedikit
                          child: GestureDetector(
                            onTap: () => Navigator.pushNamed(
                              context,
                              '/category',
                              arguments: categories[idx]['name'],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 72, // Diperbesar dari 58
                                  height: 72, // Diperbesar dari 58
                                  decoration: BoxDecoration(
                                    color: primaryBrown,
                                    borderRadius: BorderRadius.circular(
                                      24,
                                    ), // Disesuaikan agar melengkungnya pas
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    categories[idx]['icon'] as IconData,
                                    color: Colors.white,
                                    size: 34, // Ukuran ikon diperbesar dari 26
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  categories[idx]['name'] as String,
                                  style: GoogleFonts.inter(
                                    fontSize: 11, // Sedikit diperbesar dari 10
                                    fontWeight: FontWeight.w800,
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
                  const SizedBox(height: 16),

                  // SECTION REKOMENDASI PRODUK
                  Text(
                    'Rekomendasi Produk',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 210,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: recomendations.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, idx) {
                        final item = recomendations[idx];
                        return GestureDetector(
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/product',
                            arguments: item,
                          ),
                          child: Container(
                            width: 135,
                            margin: const EdgeInsets.only(
                              right: 14.0,
                              bottom: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2DFDC),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(24),
                                    ),
                                    child: Image.asset(
                                      item['image']!,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                                color: Colors.grey[300],
                                              ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['name']!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 11,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            item['price']!,
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 13,
                                              color: primaryBrown,
                                            ),
                                          ),
                                          Container(
                                            width: 24,
                                            height: 24,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF864F1F),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // PROMO BANNER
                  Text(
                    'Promo Special',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBEADB),
                      border: Border.all(
                        color: Colors.orange.withOpacity(0.18),
                        width: 1.2,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'DISKON SPESIAL',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                  color: primaryBrown,
                                  letterSpacing: 0.2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    'Hingga ',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    '20%',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 22,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // UNTUK KAMU GRID
                  Text(
                    'Untuk Kamu',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 20,
                          childAspectRatio: 0.76,
                        ),
                    itemCount: justForYou.length,
                    itemBuilder: (context, idx) {
                      final item = justForYou[idx];
                      return GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/product',
                          arguments: item,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2DFDC),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 6,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(24),
                                      ),
                                      child: Image.asset(
                                        item['image']!,
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                                  color: Colors.grey[300],
                                                ),
                                      ),
                                    ),
                                    const Positioned(
                                      top: 10,
                                      right: 10,
                                      child: Icon(
                                        Icons.favorite_border,
                                        color: primaryBrown,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(24),
                                      top: Radius.circular(20),
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['name']!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 10.5,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Row(
                                            children: List.generate(5, (
                                              starIdx,
                                            ) {
                                              return const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                                size: 11,
                                              );
                                            }),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            item['price']!,
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 13,
                                              color: primaryBrown,
                                            ),
                                          ),
                                          Container(
                                            width: 24,
                                            height: 24,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF864F1F),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: 14,
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
            _buildNavTab(Icons.storefront_outlined, 'Home', true, () {}),
            _buildNavTab(
              Icons.manage_search,
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
              Icons.favorite_outline,
              'Favorit',
              false,
              () => Navigator.pushNamed(context, '/favourite'),
            ),
            _buildNavTab(
              Icons.person_outline,
              'Akun',
              false,
              () => Navigator.pushNamed(context, '/account'),
            ),
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
            color: active ? const Color(0xFF7E4D2B) : Colors.black45,
            size: 24,
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 9,
              fontWeight: active ? FontWeight.w900 : FontWeight.w700,
              color: active ? const Color(0xFF7E4D2B) : Colors.black45,
            ),
          ),
        ],
      ),
    );
  }
}
