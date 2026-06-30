import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../favorites_state.dart';
import '../models/product_model.dart';
import '../seller_state.dart';
import '../widgets/cart_state.dart';
import '../services/api_service.dart';
import 'models.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  int _myRating = 5;
  final TextEditingController _commentController = TextEditingController();

  String getStoreName(String productId) {
    // Produk seller memiliki prefix 'sp_' — kembalikan nama toko seller yang sebenarnya
    if (productId.startsWith('sp_')) {
      return SellerState().hasStore
          ? SellerState().storeName
          : 'NestMart Premium Seller';
    }
    switch (productId) {
      case '1':
        return 'Megatoy Store Official';
      case '2':
        return 'iStore Indonesia';
      case '3':
        return 'Adidas Sport Hall';
      case '4':
        return 'Nike Official Store';
      case '5':
        return 'Biker Club Accessories';
      case '6':
        return 'Megatoy Store Official';
      case '7':
        return 'Logitech Gaming Lab';
      case '8':
        return 'Hermes Heritage';
      case '9':
        return 'Duffle Co';
      case '10':
        return 'Esthetic Beauty Lab';
      case '11':
        return 'Lip Co Cosmetics';
      case '12':
        return 'FitNutrition Store';
      case '13':
        return 'KeyMaster Pro';
      case '14':
        return 'CamShop Craft';
      case '15':
        return 'Espresso Lab Jakarta';
      default:
        return 'NestMart Premium Seller';
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Object? routeArgs = ModalRoute.of(context)?.settings.arguments;
    final Map<String, dynamic>? args = routeArgs is ProductModel
        ? {
            'id': routeArgs.id.toString(),
            'name': routeArgs.name,
            'price': 'Rp ${routeArgs.price.toStringAsFixed(0)}',
            'rating': '5.0',
            'image': routeArgs.image,
            'description': routeArgs.description,
          }
        : routeArgs is Map<String, dynamic>
            ? routeArgs
            : null;

    final String id = args?['id']?.toString() ?? '4';
    final String name = args?['name']?.toString() ?? 'URBAN BAG';
    final String price = args?['price']?.toString() ?? 'Rp200.000';
    final String image =
        args?['image'] ??
        'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=800';
    final String description =
        args?['description']?.toString() ??
        'Urban Bag hadir dengan desain modern dan minimalis menggunakan material premium yang tahan air serta nyaman digunakan sehari-hari.';

    final bool canReview = args?['canReview'] ?? false;

    return Scaffold(
      backgroundColor: const Color(0xFFECEAE6),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Top Image Card (Desain asli dipertahankan)
                Container(
                  width: double.infinity,
                  height: 310,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F0ED),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 14,
                        left: 14,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          behavior: HitTestBehavior.opaque,
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Color(0xFF864F1F),
                              size: 26,
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        top: 45,
                        bottom: 40,
                        left: 20,
                        right: 20,
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: image.startsWith('http')
                                ? Image.network(
                                    image,
                                    fit: BoxFit.contain,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return const Center(
                                            child: CircularProgressIndicator(
                                              color: Color(0xFF864F1F),
                                            ),
                                          );
                                        },
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                              Icons.inventory_2_outlined,
                                              size: 64,
                                              color: Colors.black26,
                                            ),
                                  )
                                : Image.asset(
                                    image,
                                    fit: BoxFit.contain,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                              Icons.inventory_2_outlined,
                                              size: 64,
                                              color: Colors.black26,
                                            ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // 2. Product Name and Favourites row (Desain asli)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          name.toUpperCase(),
                          style: GoogleFonts.inter(
                            fontSize: 21,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      ValueListenableBuilder<Set<String>>(
                        valueListenable: FavoritesState.favoriteIds,
                        builder: (context, favIds, child) {
                          final isFav = favIds.contains(id);
                          return GestureDetector(
                            onTap: () => FavoritesState.toggleFavorite(id),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(
                                isFav
                                    ? Icons.favorite
                                    : Icons.favorite_border_rounded,
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

                // 3. Price
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

                // 4. Reactive Yellow Stars Rating (Desain asli)
                ValueListenableBuilder<List<ProductReview>>(
                  valueListenable: FavoritesState.reviews,
                  builder: (context, reviewsList, child) {
                    final double dynamicRating =
                        FavoritesState.getProductAverageRating(id);
                    final productReviews = reviewsList
                        .where((r) => r.productId == id)
                        .toList();

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Row(
                        children: [
                          Row(
                            children: List.generate(5, (starIdx) {
                              return Icon(
                                starIdx < dynamicRating.round()
                                    ? Icons.star_rounded
                                    : Icons.star_border_rounded,
                                color: starIdx < dynamicRating.round()
                                    ? const Color(0xFFFFB300)
                                    : Colors.grey.shade300,
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

                // 5. Description and checkout card (Desain asli dipertahankan)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 24.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DESKRIPSI',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        description,
                        style: GoogleFonts.inter(
                          color: Colors.black.withValues(alpha: 0.85),
                          fontSize: 12.5,
                          height: 1.6,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      // --- TOKO PENJUAL ---
                      const SizedBox(height: 28),
                      Text(
                        'TOKO PENJUAL',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9F8F6),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            final storeItem = getStoreForProduct(id);
                            Navigator.pushNamed(
                              context,
                              '/store',
                              arguments: storeItem,
                            );
                          },
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
                            const Icon(
                              Icons.chevron_right_rounded,
                              color: Color(0xFF7E4D2B),
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),

                      // --- PENILAIAN PRODUK ---
                      const SizedBox(height: 28),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'PENILAIAN PRODUK',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w900,
                              fontSize: 13,
                              color: Colors.black,
                            ),
                          ),
                          ValueListenableBuilder<List<ProductReview>>(
                            valueListenable: FavoritesState.reviews,
                            builder: (context, reviewsList, child) {
                              final productReviews = reviewsList
                                  .where((r) => r.productId == id)
                                  .toList();
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
                          final productReviews = reviewsList
                              .where((r) => r.productId == id)
                              .toList();
                          if (productReviews.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
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
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: productReviews.length,
                            separatorBuilder: (context, idx) =>
                                const Divider(height: 24, thickness: 0.6),
                            itemBuilder: (context, idx) {
                              final rev = productReviews[idx];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 14,
                                        backgroundColor: const Color(
                                          0xFF7E4D2B,
                                        ).withValues(alpha: 0.1),
                                        backgroundImage:
                                            rev.userPhotoUrl.isNotEmpty
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
                                      return Icon(
                                        starIdx < rev.rating.round()
                                            ? Icons.star_rounded
                                            : Icons.star_border_rounded,
                                        color: starIdx < rev.rating.round()
                                            ? Colors.amber
                                            : Colors.grey.shade300,
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

                      // --- FORMULIR BERI ULASAN ---
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
                              Row(
                                children: List.generate(5, (starIdx) {
                                  final int starWeight = starIdx + 1;
                                  final bool isSelected =
                                      starWeight <= _myRating;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _myRating = starWeight;
                                      });
                                    },
                                    child: Icon(
                                      isSelected
                                          ? Icons.star_rounded
                                          : Icons.star_border_rounded,
                                      color: isSelected
                                          ? Colors.amber
                                          : Colors.grey.shade400,
                                      size: 32,
                                    ),
                                  );
                                }),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _commentController,
                                maxLines: 2,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: InputDecoration(
                                  hintText:
                                      'Tulis komentar atau pengalaman belanja Anda...',
                                  hintStyle: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black38,
                                  ),
                                  contentPadding: const EdgeInsets.all(12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF7E4D2B),
                                      width: 1.5,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 14),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    final comment = _commentController.text
                                        .trim();
                                    if (comment.isEmpty) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Tolong isi komentar ulasan Anda terlebih dahulu.',
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }
                                    final prodId = int.tryParse(id) ?? 1;
                                    await ApiService.instance.createReview({
                                      "productId": prodId,
                                      "rating": _myRating,
                                      "comment": comment,
                                    });
                                    FavoritesState.addReview(
                                      id,
                                      _myRating.toDouble(),
                                      comment,
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Terima kasih! Ulasan Anda telah berhasil disimpan.',
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
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
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
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

                      // ============================================================================
                      // ACTION BUTTONS BAR (Hanya menambah ikon Keranjang tanpa merubah tombol Checkout)
                      // ============================================================================
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2DFDC),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (_quantity > 1) {
                                      setState(() => _quantity--);
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 2.0,
                                    ),
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
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                  ),
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
                                  onTap: () => setState(() => _quantity++),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 2.0,
                                    ),
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
                          const SizedBox(width: 12),

                          GestureDetector(
                            onTap: () async {
                              final prodId = int.tryParse(id) ?? 1;
                              await ApiService.instance.addToCart(prodId, _quantity);
                              CartState.addToCart(
                                CartItem(
                                  id: id,
                                  name: name,
                                  price: CartState.parsePrice(price),
                                  image: image,
                                  quantity: _quantity,
                                ),
                              );
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '$_quantity unit $name masuk ke keranjang!',
                                  ),
                                  backgroundColor: const Color(0xFF864F1F),
                                ),
                              );
                            },
                            child: Container(
                              height: 52,
                              width: 52,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: const Color(0xFF864F1F),
                                  width: 1.5,
                                ),
                              ),
                              child: const Icon(
                                Icons.shopping_cart_outlined,
                                color: Color(0xFF864F1F),
                                size: 22,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          Expanded(
                            child: Container(
                              height: 52,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF864F1F,
                                    ).withValues(alpha: 0.24),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: () async {
                                  final prodId = int.tryParse(id) ?? 1;
                                  await ApiService.instance.addToCart(prodId, _quantity);
                                  CartState.addToCart(
                                    CartItem(
                                      id: id,
                                      name: name,
                                      price: CartState.parsePrice(price),
                                      image: image,
                                      quantity: _quantity,
                                    ),
                                  );
                                  if (!mounted) return;
                                  Navigator.pushNamed(context, '/checkout');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF864F1F),
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
