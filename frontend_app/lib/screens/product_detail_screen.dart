import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../favorites_state.dart';
import 'orders_screen.dart';
import 'models.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  bool _isFavourite = false;

  /// ============================================================================
  /// STATE ULASAN PRODUK (Review & Feedback Form State)
  /// ============================================================================
  /// `_myRating` menyimpan jumlah bintang yang dipilih pengguna di form ulasan (1 s.d 5).
  /// `_commentController` menangkap input teks tanggapan belanja dari pengguna.
  int _myRating = 5;
  final TextEditingController _commentController = TextEditingController();

  /// ============================================================================
  /// HELPER: Toko Penjual Dinamis (Store Mapper)
  /// ============================================================================
  /// Menghubungkan ID produk secara langsung ke toko official pelapak terpercaya
  /// agar tampilan informasi penjual selaras dengan yang ada pada mockup fungsional.
  String getStoreName(String productId) {
    switch (productId) {
      case '1': return 'Megatoy Store Official';
      case '2': return 'iStore Indonesia';
      case '3': return 'Adidas Sport Hall';
      case '4': return 'Nike Official Store';
      case '5': return 'Biker Club Accessories';
      case '6': return 'Megatoy Store Official';
      case '7': return 'Logitech Gaming Lab';
      case '8': return 'Hermes Heritage';
      case '9': return 'Duffle Co';
      case '10': return 'Esthetic Beauty Lab';
      case '11': return 'Lip Co Cosmetics';
      case '12': return 'FitNutrition Store';
      case '13': return 'KeyMaster Pro';
      case '14': return 'CamShop Craft';
      case '15': return 'Espresso Lab Jakarta';
      default: return 'NestMart Premium Seller';
    }
  }

  @override
  void dispose() {
    // Dipanggil untuk membersihkan controller memori saat berpindah halaman
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Dynamic arguments from navigation parameters
    final Map<String, dynamic>? args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    final String id = args?['id'] ?? '4';
    final String name = args?['name'] ?? 'URBAN BAG';
    final String price = args?['price'] ?? '\$20.16';
    final String rating = args?['rating'] ?? '5.0';
    final String image = args?['image'] ?? 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=800';
    
    // Exact long description from the screenshot
    final String description = args?['description'] ?? 
        'Urban Bag hadir dengan desain modern dan minimalis menggunakan material premium yang tahan air serta nyaman digunakan sehari-hari. Dilengkapi ruang penyimpanan yang luas dan beberapa kompartemen multifungsi untuk membawa laptop, gadget, maupun perlengkapan pribadi. Cocok digunakan untuk aktivitas kerja, kuliah, traveling, hingga kebutuhan harian dengan tampilan stylish dan elegan.';

    final bool canReview = args?['canReview'] ?? false;

    return Scaffold(
      backgroundColor: const Color(0xFFECEAE6), // Beige cream background
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Top Image Card (White-gray rounded card with Back arrow, Backpack, Carousel dots)
                Container(
                  width: double.infinity,
                  height: 310,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F0ED), // Off-white/light gray image card matching screenshot
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Stack(
                    children: [
                      // Back Arrow
                      Positioned(
                        top: 14,
                        left: 14,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          behavior: HitTestBehavior.opaque,
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.arrow_back_rounded,
                              color: Colors.black,
                              size: 26,
                            ),
                          ),
                        ),
                      ),
                      
                      // Centered product image
                      Positioned.fill(
                        top: 45,
                        bottom: 40,
                        left: 20,
                        right: 20,
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              image,
                              fit: BoxFit.contain,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF864F1F),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.inventory_2_outlined,
                                  size: 64,
                                  color: Colors.black26,
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      // Horizontal selection indicators centered at the bottom
                      Positioned(
                        bottom: 18,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(4, (index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4.5),
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                color: index == 0 ? const Color(0xFF864F1F) : const Color(0xFFC4BDB5),
                                shape: BoxShape.circle,
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // 2. Product Name and Favourites row matching layout
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          name.toUpperCase(),
                          style: GoogleFonts.inter(
                            fontSize: 21,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ),
                      ValueListenableBuilder<Set<String>>(
                        valueListenable: FavoritesState.favoriteIds,
                        builder: (context, favIds, child) {
                          final isFav = favIds.contains(id);
                          return GestureDetector(
                            onTap: () {
                              FavoritesState.toggleFavorite(id);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border_rounded,
                                color: isFav ? Colors.red : Colors.black,
                                size: 26,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 4),

                // 3. Gold-brown Price matching layout
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    price,
                    style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF864F1F),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // 4. Reactive Yellow Stars Rating matching layout
                // Menggunakan ValueListenableBuilder agar saat pembeli menulis ulasan di bawah,
                // skor rata-rata bintang dan total ulasan di atas langsung terupdate seketika sacara reaktif.
                ValueListenableBuilder<List<ProductReview>>(
                  valueListenable: FavoritesState.reviews,
                  builder: (context, reviewsList, child) {
                    final double dynamicRating = FavoritesState.getProductAverageRating(id);
                    final productReviews = reviewsList.where((r) => r.productId == id).toList();

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Row(
                        children: [
                          Row(
                            children: List.generate(5, (starIdx) {
                              final bool isFilled = starIdx < dynamicRating.round();
                              return Icon(
                                isFilled ? Icons.star_rounded : Icons.star_border_rounded,
                                color: isFilled ? const Color(0xFFFFB300) : Colors.grey.shade300,
                                size: 19,
                              );
                            }),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            dynamicRating.toStringAsFixed(1),
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '(${productReviews.length} ulasan)',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 18),

                // 5. White Rounded floated description and checkout card
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DESKRIPSI',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                          letterSpacing: 0.2,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        description,
                        style: GoogleFonts.inter(
                          color: Colors.black.withOpacity(0.85),
                          fontSize: 12.5,
                          height: 1.6,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      
                      // ============================================================================
                      // SEKSI TOKO PENJUAL (Store Info Section)
                      // ============================================================================
                      // Menampilkan nama toko yang dinamis berdasarkan ID produk.
                      // Dilengkapi lencana verifikasi biru "Verified" untuk menambah estetika.
                      const SizedBox(height: 28),
                      Text(
                        'TOKO PENJUAL',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                          letterSpacing: 0.2,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          final store = getStoreForProduct(id);
                          Navigator.pushNamed(
                            context,
                            '/store',
                            arguments: store,
                          );
                        },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9F8F6),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: const BoxDecoration(
                                color: Color(0xFF7E4D2B),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.storefront_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        getStoreName(id),
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 12.5,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons.verified_rounded,
                                        color: Colors.blue,
                                        size: 14,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Pelapak Terpercaya • Respons Chat 100%',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                      // ============================================================================
                      // SEKSI PENILAIAN PRODUK (Dynamic Reviews Listing Section)
                      // ============================================================================
                      // Menggunakan ValueListenableBuilder untuk mengamati daftar ulasan global.
                      // Jika ada ulasan baru yang ditambahkan, widget ini akan melakukan re-render
                      // daftar ulasan secara lokal tanpa me-refresh seluruh halaman.
                      const SizedBox(height: 28),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'PENILAIAN PRODUK',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w900,
                              fontSize: 13,
                              letterSpacing: 0.2,
                              color: Colors.black,
                            ),
                          ),
                          ValueListenableBuilder<List<ProductReview>>(
                            valueListenable: FavoritesState.reviews,
                            builder: (context, reviewsList, child) {
                              final productReviews = reviewsList.where((r) => r.productId == id).toList();
                              return Text(
                                '${productReviews.length} Ulasan',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black54,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ValueListenableBuilder<List<ProductReview>>(
                        valueListenable: FavoritesState.reviews,
                        builder: (context, reviewsList, child) {
                          final productReviews = reviewsList.where((r) => r.productId == id).toList();
                          if (productReviews.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                'Belum ada penilaian untuk produk ini. Jadilah yang pertama memberikan ulasan!',
                                style: GoogleFonts.inter(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black45,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            );
                          }
                          // Membangun daftar ulasan dengan pemisah tipis ramah mata
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: productReviews.length,
                            separatorBuilder: (context, idx) => const Divider(height: 24, thickness: 0.6),
                            itemBuilder: (context, idx) {
                              final rev = productReviews[idx];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 14,
                                        backgroundColor: const Color(0xFF7E4D2B).withOpacity(0.1),
                                        backgroundImage: rev.userPhotoUrl.isNotEmpty
                                        ? NetworkImage(rev.userPhotoUrl)
                                        : null,
                                        child: rev.userPhotoUrl.isEmpty
                                        ? const Icon(Icons.person, size: 14)
                                        : null,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        rev.userName,
                                        style: GoogleFonts.inter(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        rev.date,
                                        style: GoogleFonts.inter(
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black45,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: List.generate(5, (starIdx) {
                                      final bool isFilled = starIdx < rev.rating.round();
                                      return Icon(
                                        isFilled ? Icons.star_rounded : Icons.star_border_rounded,
                                        color: isFilled ? Colors.amber : Colors.grey.shade300,
                                        size: 13,
                                      );
                                    }),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    rev.comment,
                                    style: GoogleFonts.inter(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      // ============================================================================
                      // SEKSI FORMULIR BERI ULASAN (Write Review Form)
                      // ============================================================================
                      // Memberi kebebasan bagi pembeli untuk menuliskan ulasan dan memilih bintang.
                      // Saat tombol kirim ditekan, ulasan baru dikirim ke state manager global `FavoritesState`.
                      if (canReview) ...[
                        const SizedBox(height: 32),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F5F2),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'BERI ULASAN KAMU',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 11.5,
                                  letterSpacing: 0.5,
                                  color: const Color(0xFF7E4D2B),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Pilih Rating Masukan Anda:',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 6),
                              
                              // Row pemilihan bintang interaktif
                              Row(
                                children: List.generate(5, (starIdx) {
                                  final int starWeight = starIdx + 1;
                                  final bool isSelected = starWeight <= _myRating;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _myRating = starWeight; // Mengubah state ulasan lokal bintang
                                      });
                                    },
                                    child: Icon(
                                      isSelected ? Icons.star_rounded : Icons.star_border_rounded,
                                      color: isSelected ? Colors.amber : Colors.grey.shade400,
                                      size: 32,
                                    ),
                                  );
                                }),
                              ),
                              const SizedBox(height: 16),
                              
                              // Input isi ulasan komentar pembeli
                              TextField(
                                controller: _commentController,
                                maxLines: 2,
                                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                                decoration: InputDecoration(
                                  hintText: 'Tulis komentar atau pengalaman belanja Anda...',
                                  hintStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.black38),
                                  contentPadding: const EdgeInsets.all(12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(color: Color(0xFF7E4D2B), width: 1.5),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 14),
                              
                              // Tombol Submit "KIRIM ULASAN"
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    final comment = _commentController.text.trim();
                                    if (comment.isEmpty) {
                                      // Validasi ulasan wajib diisi
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Tolong isi komentar ulasan Anda terlebih dahulu.'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }

                                    // 1. Simpan ulasan baru secara reaktif ke State Manager
                                    FavoritesState.addReview(
                                      id,
                                      _myRating.toDouble(),
                                      comment,
                                    );

                                    // 2. Beri umpan balik berupa SnackBar kesuksesan yang manis
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Terima kasih! Ulasan Anda telah berhasil disimpan.'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );

                                    // 3. Reset input form lokal agar siap dipakai kembali
                                    setState(() {
                                      _commentController.clear();
                                      _myRating = 5;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF7E4D2B),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                  child: Text(
                                    'KIRIM ULASAN',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          // Quantity interactive controls styled identically (light grey bagground)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2DFDC), // Light grey matching screenshots
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (_quantity > 1) {
                                      setState(() {
                                        _quantity--;
                                      });
                                    }
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                                    child: Text(
                                      '-',
                                      style: GoogleFonts.inter(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 14),
                                  child: Text(
                                    '$_quantity',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 14.5,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _quantity++;
                                    });
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                                    child: Text(
                                      '+',
                                      style: GoogleFonts.inter(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 14),
                          
                          // checkout golden brown button
                          Expanded(
                            child: Container(
                              height: 52,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF864F1F).withOpacity(0.24),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Ditambahkan ke Keranjang ($_quantity unit): $name'),
                                      backgroundColor: const Color(0xFF864F1F),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF864F1F),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                                child: Text(
                                  'CHECKOUT',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 15,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
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
        ),
      ),
    );
  }
}
