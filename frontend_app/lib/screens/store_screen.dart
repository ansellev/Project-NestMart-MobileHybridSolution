import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../favorites_state.dart';
import 'models.dart';
import '../services/api_service.dart';
import '../models/product_model.dart';

/// ============================================================================
/// SCREEN: StoreScreen (Detail Toko Pelapak)
/// ============================================================================
/// Menampilkan informasi profil lengkap mengenai pelapak/toko official atau biasa.
/// Mendukung fitur mengikut (Follow), stat obrolan, and tab katalog produk terlaris/semua
/// yang dijual oleh toko bersangkutan, terintegrasi sepenuhnya dengan state favorit & ulasan.
class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  String _activeTab = 'semua'; // 'semua' atau 'terpopuler'
  bool _isFollowing = false;
  

  @override
  Widget build(BuildContext context) {
    // Membaca argumen navigasi (StoreItem yang dikirim dari SearchScreen atau Product Detail)
    final store = ModalRoute.of(context)!.settings.arguments as StoreItem;

    // Filter produk yang dijual oleh toko ini
    final List<FavoriteProduct> storeProducts = store.getProducts();

    // Mengurutkan produk jika memilih tab 'terpopuler'
    final List<FavoriteProduct> displayedProducts = [...storeProducts];
    if (_activeTab == 'terpopuler') {
      displayedProducts.sort((a, b) {
        final aRating = FavoritesState.getProductAverageRating(a.id);
        final bRating = FavoritesState.getProductAverageRating(b.id);
        return bRating.compareTo(aRating);
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFFECEAE6), // Beige cream background matching theme
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // ============================================================================
            // 1. HEADER: Immersive Cover Image & Back / Share Button
            // ============================================================================
            Stack(
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: Image.network(
                    store.image,
                    fit: BoxFit.cover,
                    color: Colors.black.withOpacity(0.3),
                    colorBlendMode: BlendMode.darken,
                    errorBuilder: (context, err, stack) => const Icon(Icons.broken_image, size: 40),
                  ),
                ),
                // Buttons float
                Positioned(
                  top: 52,
                  left: 20,
                  right: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Colors.black38,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(Icons.arrow_back, color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Tautan toko berhasil disalin ke papan klip!'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Colors.black38,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(Icons.share, color: Colors.white, size: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // ============================================================================
            // 2. PROFILE CARD: Overlapping details container
            // ============================================================================
            Transform.translate(
              offset: const Offset(0, -50),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                        border: Border.all(color: Colors.black.withOpacity(0.03)),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Avatar Toko Melayang Keluar Sedikit
                              Transform.translate(
                                offset: const Offset(0, -32),
                                child: Container(
                                  width: 76,
                                  height: 76,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      )
                                    ],
                                    border: Border.all(color: Colors.white, width: 3),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      store.image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            store.name,
                                            style: GoogleFonts.inter(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.black,
                                              letterSpacing: -0.2,
                                            ),
                                          ),
                                        ),
                                        if (store.isOfficial) ...[
                                          const SizedBox(width: 4),
                                          const Icon(
                                            Icons.verified_rounded,
                                            color: Colors.blue,
                                            size: 16,
                                          )
                                        ]
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      store.category.toUpperCase(),
                                      style: GoogleFonts.inter(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.black45,
                                        letterSpacing: 0.5,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 4),

                          // Lokasi & Status Buka
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF7E4D2B)),
                              const SizedBox(width: 4),
                              Text(
                                store.location,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Container(
                                width: 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  color: store.isOpen ? Colors.green : Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                store.isOpen ? 'Buka Sekarang' : 'Tutup Sementara',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: store.isOpen ? FontWeight.w800 : FontWeight.w600,
                                  color: store.isOpen ? Colors.green[700] : Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Divider(height: 1, color: Color(0xFFEEEEEE)),
                          const SizedBox(height: 12),

                          // Deskripsi Bio Toko
                          Text(
                            store.description,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Banner Stat: Rating, Pengikut, Respons Chat
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0x3BECEAE6),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.black.withOpacity(0.01)),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.star_rounded, size: 12, color: Color(0xFFF59E0B)),
                                          const SizedBox(width: 2),
                                          Text(
                                            store.rating.toStringAsFixed(1),
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.black87,
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'RATING TOKO',
                                        style: GoogleFonts.inter(
                                          fontSize: 8,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black45,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(width: 1, height: 28, color: Colors.black12),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        '10.7RB',
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'PENGIKUT',
                                        style: GoogleFonts.inter(
                                          fontSize: 8,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black45,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(width: 1, height: 28, color: Colors.black12),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        '99%',
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900,
                                          color: const Color(0xFF7E4D2B),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'CHAT BALAS',
                                        style: GoogleFonts.inter(
                                          fontSize: 8,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black45,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Tombol Aksi: Follow & Hubungi
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      _isFollowing = !_isFollowing;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          _isFollowing
                                              ? 'Anda kini mengikuti ${store.name}!'
                                              : 'Batal mengikuti ${store.name}.',
                                        ),
                                        duration: const Duration(seconds: 1),
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    _isFollowing ? Icons.bookmark : Icons.bookmark_outline,
                                    size: 14,
                                    color: _isFollowing ? const Color(0xFF7E4D2B) : Colors.white,
                                  ),
                                  label: Text(
                                    _isFollowing ? 'MENGIKUTI' : 'IKUTI TOKO',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 11,
                                      color: _isFollowing ? const Color(0xFF7E4D2B) : Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _isFollowing ? const Color(0xFFECEAE6) : const Color(0xFF7E4D2B),
                                    elevation: 0,
                                    shadowColor: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(
                                        color: const Color(0xFF7E4D2B),
                                        width: _isFollowing ? 1.5 : 0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              GestureDetector(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Fitur obrolan langsung ke pelapak akan segera hadir!'),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE2DFDC),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.forum_outlined, size: 16, color: Colors.black87),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ============================================================================
                    // 3. CATALOGUE AREA: Sortable products list
                    // ============================================================================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Katalog Produk (${storeProducts.length})'.toUpperCase(),
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w900,
                            fontSize: 11,
                            color: Colors.black54,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2DFDC),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(2),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => setState(() => _activeTab = 'semua'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: _activeTab == 'semua' ? const Color(0xFF7E4D2B) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Semua',
                                    style: GoogleFonts.inter(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w900,
                                      color: _activeTab == 'semua' ? Colors.white : Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => setState(() => _activeTab = 'terpopuler'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: _activeTab == 'terpopuler' ? const Color(0xFF7E4D2B) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Terpopuler',
                                    style: GoogleFonts.inter(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w900,
                                      color: _activeTab == 'terpopuler' ? Colors.white : Colors.black54,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Catalogue Grid View list
                    displayedProducts.isNotEmpty
                        ? GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: displayedProducts.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.68,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                            ),
                            itemBuilder: (context, idx) {
                              final product = displayedProducts[idx];
                              return _buildProductGridCard(product);
                            },
                          )
                        : Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white38,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Column(
                              children: [
                                const Icon(Icons.shopping_bag_outlined, size: 28, color: Colors.black26),
                                const SizedBox(height: 8),
                                Text(
                                  'Katalog Masih Kosong',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black45,
                                  ),
                                )
                              ],
                            ),
                          ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Kartu Grid Item Produk untuk Toko
  Widget _buildProductGridCard(FavoriteProduct product) {
    return ValueListenableBuilder<Set<String>>(
      valueListenable: FavoritesState.favoriteIds,
      builder: (context, favoriteSet, child) {
        final isFav = favoriteSet.contains(product.id);

        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFFE2DFDC),
            borderRadius: BorderRadius.circular(24),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Gambar produk
                    Expanded(
                      flex: 4,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/product',
                            arguments: {
                              'id': product.id,
                              'name': product.name,
                              'price': product.price,
                              'rating': FavoritesState.getProductAverageRating(product.id).toString(),
                              'image': product.image,
                              'description': product.description,
                            },
                          );
                        },
                        child: Image.network(
                          product.image,
                          fit: BoxFit.cover,
                          errorBuilder: (context, err, stack) => Container(
                            color: Colors.grey,
                            child: const Icon(Icons.broken_image, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    // Informasi produk
                    Expanded(
                      flex: 5,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(24),
                            bottomRight: Radius.circular(24),
                          ),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/product',
                                  arguments: {
                                    'id': product.id,
                                    'name': product.name,
                                    'price': product.price,
                                    'rating': FavoritesState.getProductAverageRating(product.id).toString(),
                                    'image': product.image,
                                    'description': product.description,
                                  },
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  // Live dynamic rating display
                                  ValueListenableBuilder<List<ProductReview>>(
                                    valueListenable: FavoritesState.reviews,
                                    builder: (context, reviewList, c) {
                                      final dynamicRating = FavoritesState.getProductAverageRating(product.id);
                                      return Row(
                                        children: [
                                          Row(
                                            children: List.generate(5, (sIdx) {
                                              final isFilled = sIdx < dynamicRating.round();
                                              return Icon(
                                                Icons.star_rounded,
                                                size: 10,
                                                color: isFilled ? const Color(0xFFF59E0B) : Colors.grey[300],
                                              );
                                            }),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            dynamicRating.toStringAsFixed(1),
                                            style: GoogleFonts.inter(
                                              fontSize: 9,
                                              fontWeight: FontWeight.w900,
                                              color: const Color(0xFF7E4D2B),
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),

                            // Baris Harga & Tombol Tambah ke Keranjang
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  product.price,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900,
                                    color: const Color(0xFF7E4D2B),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('${product.name} telah berhasil ditambahkan ke Keranjang!'),
                                        duration: const Duration(seconds: 1),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF864F1F),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.add,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),

                // Tombol Favorit Melayang di Atas Gambar
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      FavoritesState.toggleFavorite(product.id);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFav ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                        size: 14,
                        color: const Color(0xFF7E4D2B),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
