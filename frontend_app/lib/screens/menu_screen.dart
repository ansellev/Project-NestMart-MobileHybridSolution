import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../favorites_state.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Exact list of category options from screenshots
    final categories = [
      {'name': 'Elektronik', 'icon': Icons.devices_other_rounded},
      {'name': 'Pakaian', 'icon': Icons.checkroom_rounded},
      {'name': 'Olahraga', 'icon': Icons.fitness_center_rounded},
      {'name': 'Perabotan', 'icon': Icons.chair_rounded},
      {'name': 'Kecantikan', 'icon': Icons.spa_rounded},
    ];

    // Horizontally scrollable product recommendations from screenshots
    final recomendations = [
      {
        'id': '1',
        'name': 'Action Figure',
        'price': '\$10',
        'rating': '5.0',
        'image': 'https://images.unsplash.com/photo-1608889174637-3c44f6326f1a?w=400&auto=format&fit=crop',
        'description': 'Mainan figur pahlawan Superman berkualitas premium dengan detail kostum, jubah, dan anatomi yang sangat presisi. Sangat cocok sebagai koleksi atau pajangan meja para penggemar komik dan film pahlawan super.',
      },
      {
        'id': '2',
        'name': 'Iphone 17 Pro Max',
        'price': '\$1.199',
        'rating': '5.0',
        'image': 'https://images.unsplash.com/photo-1616348436168-de43ad0db179?w=400&auto=format&fit=crop',
        'description': 'Smartphone flagship masa depan dengan kamera telefoto beresolusi super tinggi, layar dinamis tajam, chipset mutakhir penunjang aktivitas multitasking harian Anda, serta baterai tahan lama sepanjang hari.',
      },
      {
        'id': '3',
        'name': 'Adidas training fullset',
        'price': '\$124',
        'rating': '5.0',
        'image': 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=400&auto=format&fit=crop',
        'description': 'Satu set lengkap jaket training dan celana olahraga Adidas berbahan serat premium yang breathable dan nyaman digunakan untuk segala kegiatan aktif luar ruangan maupun santai sehari-hari.',
      },
    ];

    // Grid feed "Just for you" products from screenshots
    final justForYou = [
      {
        'id': '4',
        'name': 'Nike dunk retro',
        'price': '\$60',
        'rating': '5.0',
        'image': 'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=400&auto=format&fit=crop',
        'description': 'Sepatu kasual legendaris Nike Dunk Retro dengan kombinasi warna hitam dan putih yang kontras and ikonik, kenyamanan maksimal untuk melengkapi penampilan kasual trendi Anda sepanjang hari.',
      },
      {
        'id': '5',
        'name': 'Retro helmet',
        'price': '\$40',
        'rating': '5.0',
        'image': 'https://images.unsplash.com/photo-1558981806-ec527fa84c39?w=400',
        'description': 'Helm premium bergaya retro klasik matte dengan visor antik dan busa bagian dalam yang tebal serta empuk demi keselamatan tinggi and kenyamanan maksimal saat berkendara di jalan raya.',
      },
      {
        'id': '6',
        'name': 'Superman figure',
        'price': '\$35',
        'rating': '5.0',
        'image': 'https://images.unsplash.com/photo-1608889174637-3c44f6326f1a?w=400&auto=format&fit=crop',
        'description': 'Action figure Superman berskala kolektor dalam pose aksi ikonik lengkap dengan jubah kain premium serta dudukan eksklusif untuk mempercantik lemari etalase pajangan Anda.',
      },
      {
        'id': '7',
        'name': 'Logitech Keyboard',
        'price': '\$50',
        'rating': '5.0',
        'image': 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=400&auto=format&fit=crop',
        'description': 'Keyboard mekanikal gaming Logitech dengan respon pengetikan instan, lampu latar RGB yang dapat dip kustomisasi, serta tata letak tombol ergonomis yang awet untuk penggunaan mengetik and bermain game jangka panjang.',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFECEAE6), // Beige cream background matching physical layout
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Organic top gold-brown curve header with logo elements
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF7E4D2B), // Exact warm brown color
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              padding: const EdgeInsets.only(top: 56, left: 24, right: 24, bottom: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.black, // Dark outline inside mockup
                          size: 26,
                        ),
                      ),
                      Stack(
                        children: [
                          const Icon(
                            Icons.notifications_none_rounded,
                            color: Colors.black,
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
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'HI ANDI',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 18),
                  // Search Pill Container as in mockup
                  Container(
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
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'What do you mostly like?',
                              hintStyle: GoogleFonts.inter(
                                color: Colors.black45,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
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
                ],
              ),
            ),

            // 2. Sections Container
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CATEGORY SECTION
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Category',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/category');
                        },
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
                  // Horizontal Circle of 5 icons
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, idx) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/category',
                              arguments: categories[idx]['name'] as String,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 14.0),
                            child: Column(
                              children: [
                                Container(
                                  width: 58,
                                  height: 58,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF7E4D2B), // Distinct brown background matching screenshots
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    categories[idx]['icon'] as IconData,
                                    color: Colors.white,
                                    size: 26,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  categories[idx]['name'] as String,
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
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

                  // PRODUCT RECOMMENDATION
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Product Recommendation',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'See all',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Horizontal recommendations grid
                  SizedBox(
                    height: 210,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: recomendations.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, idx) {
                        final item = recomendations[idx];
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/product', arguments: item);
                          },
                          child: Container(
                            width: 135,
                            margin: const EdgeInsets.only(right: 14.0, bottom: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2DFDC), // Light grey background matching screenshot design
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Top half image
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                                    child: Image.network(
                                      item['image']!,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                // Bottom section text/price/plus
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            item['price']!,
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 13,
                                              color: const Color(0xFF7E4D2B),
                                            ),
                                          ),
                                          Container(
                                            width: 24,
                                            height: 24,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF864F1F), // Brown button matching screenshots
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

                  // SPECIAL PROMO BANNER AS REQUESTED
                  Text(
                    'Special Promo',
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
                      color: const Color(0xFFFBEADB), // Delicate light orange background banner from screenshot
                      border: Border.all(color: Colors.orange.withOpacity(0.18), width: 1.2),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 12,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'DISKON SPESIAL',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                  color: const Color(0xFF7E4D2B), // Brown accent text to match
                                  letterSpacing: 0.2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                              const SizedBox(height: 12),
                              // Belanja sekarang button capsule
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF864F1F),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                child: Text(
                                  'Belanja sekarang >',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 9,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Grocery item mockup graphics side-to-side
                        Expanded(
                          flex: 11,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Nested visual packs
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=200',
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  'https://images.unsplash.com/photo-1544816155-12df9643f363?w=200',
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // JUST FOR YOU SECTION
                  Text(
                    'Just For You',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Detailed Grid for Just For You items matching screens perfectly
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 20,
                      childAspectRatio: 0.76, // Elegant aspect ratio
                    ),
                    itemCount: justForYou.length,
                    itemBuilder: (context, idx) {
                      final item = justForYou[idx];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/product', arguments: item);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2DFDC), // Light grey upper half/background
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top image box (grey frame with loving floating heart icon)
                              Expanded(
                                flex: 6,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                                      child: Image.network(
                                        item['image']!,
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: ValueListenableBuilder<Set<String>>(
                                        valueListenable: FavoritesState.favoriteIds,
                                        builder: (context, favIds, child) {
                                          final isFav = favIds.contains(item['id']);
                                          return GestureDetector(
                                            onTap: () {
                                              FavoritesState.toggleFavorite(item['id'] as String);
                                            },
                                            child: Icon(
                                              isFav ? Icons.favorite : Icons.favorite_border,
                                              color: const Color(0xFF7E4D2B), // Pure elegant icon badge outline color
                                              size: 20,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Bottom metadata box styled exactly as screen mockup with a curved white card
                              Expanded(
                                flex: 5,
                                child: Container(
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(24),
                                      bottomRight: Radius.circular(24),
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                              fontSize: 10.5,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Row(
                                            children: List.generate(5, (starIdx) {
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
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            item['price']!,
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 13,
                                              color: const Color(0xFF7E4D2B),
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
      // 3. Persistent customized bottom navigation bar mapping to screenshots
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
            _buildNavTab(Icons.storefront_outlined, 'Shop', true, () {}),
            _buildNavTab(Icons.manage_search, 'Kategori', false, () {
              Navigator.pushNamed(context, '/category');
            }),
            _buildNavTab(Icons.shopping_cart_outlined, 'Cart', false, () {
              Navigator.pushNamed(context, '/cart');
            }),
            _buildNavTab(Icons.favorite_outline, 'Favourite', false, () {
              Navigator.pushNamed(context, '/favourite');
            }),
            _buildNavTab(Icons.person_outline, 'Account', false, () {
              Navigator.pushNamed(context, '/account');
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildNavTab(IconData icon, String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: active ? const Color(0xFF7E4D2B) : Colors.black45,
            size: 23,
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
