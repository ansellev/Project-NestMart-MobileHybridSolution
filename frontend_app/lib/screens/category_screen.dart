import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../favorites_state.dart';

class FlutterProduct {
  final String id;
  final String name;
  final double price;
  final double rating;
  final String category;
  final String description;
  final String image;

  FlutterProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.category,
    required this.description,
    required this.image,
  });
}

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String? _selectedCategory;
  bool _hasInitialArgument = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasInitialArgument) {
      final String? arg = ModalRoute.of(context)?.settings.arguments as String?;
      if (arg != null) {
        _selectedCategory = arg;
      }
      _hasInitialArgument = true;
    }
  }

  // ==========================================
  // 1. UBAH DATA URL KE FORMAT ASSETS LOKAL
  // ==========================================
  final List<Map<String, String>> _categories = [
    {'name': 'Elektronik', 'image': 'assets/elektronik.png'},
    {'name': 'Pakaian', 'image': 'assets/pakaian.png'},
    {'name': 'Fashion', 'image': 'assets/Fashion.png'},
    {'name': 'Kecantikan', 'image': 'assets/kecantikan.png'},
    {'name': 'Makanan', 'image': 'assets/Makanan.png'},
    {'name': 'Otomotif', 'image': 'assets/otomotif.png'},
    {'name': 'Hobi', 'image': 'assets/Hobi.png'},
    {'name': 'Minuman', 'image': 'assets/minuman.png'},
    {'name': 'Olahraga', 'image': 'assets/olahraga.png'},
    {'name': 'Perabotan', 'image': 'assets/perabotan.png'},
  ];

  // Fungsi ini tetap dipertahankan sebagai "Fallback" (cadangan)
  // jika gambar asset gagal dimuat atau belum ditambahkan ke pubspec.yaml
  IconData _getCategoryIcon(String name) {
    switch (name.toLowerCase()) {
      case 'elektronik':
        return Icons.devices_other_rounded;
      case 'pakaian':
        return Icons.checkroom_rounded;
      case 'fashion':
        return Icons.shopping_bag_outlined;
      case 'kecantikan':
        return Icons.spa_rounded;
      case 'makanan':
        return Icons.restaurant_menu_rounded;
      case 'otomotif':
        return Icons.directions_car_rounded;
      case 'hobi':
        return Icons.camera_alt_rounded;
      case 'minuman':
        return Icons.local_cafe_rounded;
      case 'olahraga':
        return Icons.fitness_center_rounded;
      case 'perabotan':
        return Icons.chair_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  List<FlutterProduct> get _products {
    return FavoritesState.allProducts.map((p) {
      final cleanPriceStr = p.price.replaceAll('\$', '').replaceAll('.', '');
      final priceVal = double.tryParse(cleanPriceStr) ?? 0.0;
      final ratingVal = FavoritesState.getProductAverageRating(p.id);
      return FlutterProduct(
        id: p.id,
        name: p.name,
        price: priceVal,
        rating: ratingVal,
        category: p.category,
        description: p.description,
        image: p.image,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedCategory == null
        ? <FlutterProduct>[]
        : _products
              .where(
                (p) =>
                    p.category.toLowerCase() ==
                    _selectedCategory!.toLowerCase(),
              )
              .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFECEAE6),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.only(
                top: 56,
                left: 16,
                right: 16,
                bottom: 12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (_selectedCategory != null) {
                        setState(() {
                          _selectedCategory = null;
                        });
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Color(0xFF864F1F),
                        size: 20,
                      ),
                    ),
                  ),
                  Text(
                    _selectedCategory ?? 'EXPLORE CATEGORIES',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.merriweather(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF864F1F),
                    ),
                  ),
                  const SizedBox(width: 44), // balance back button
                ],
              ),
            ),

            // Content body in standard white rounded panel
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: _selectedCategory == null
                        ? _buildCategoryGrid()
                        : _buildProductGrid(filtered),
                  ),
                ),
              ),
            ),
          ],
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
            _buildNavTab(Icons.storefront_outlined, 'Home', false, () {
              Navigator.pushReplacementNamed(context, '/menu');
            }),
            _buildNavTab(Icons.manage_search, 'Kategori', true, () {}),
            _buildNavTab(Icons.shopping_cart_outlined, 'Keranjang', false, () {
              Navigator.pushReplacementNamed(context, '/cart');
            }),
            _buildNavTab(Icons.favorite_outline, 'Favorit', false, () {
              Navigator.pushReplacementNamed(context, '/favourite');
            }),
            _buildNavTab(Icons.person_outline, 'Akun', false, () {
              Navigator.pushReplacementNamed(context, '/account');
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      itemCount: _categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 0.82,
      ),
      itemBuilder: (context, index) {
        final cat = _categories[index];
        final name = cat['name']!;
        final imageUrl = cat['image']!;

        return Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = name;
                });
              },
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFF864F1F,
                    ), // Background coklat dipertahankan
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  // ==========================================
                  // 2. GANTI ICON MENJADI IMAGE.ASSET DI SINI
                  // ==========================================
                  child: Padding(
                    padding: const EdgeInsets.all(
                      20.0,
                    ), // Jarak agar gambar tidak terlalu full menyentuh garis kotak
                    child: Center(
                      child: Image.asset(
                        imageUrl,
                        fit: BoxFit.contain,
                        // Jika gambar belum disiapkan di file, akan muncul icon sebagai fallback
                        errorBuilder: (context, error, stackTrace) => Icon(
                          _getCategoryIcon(name),
                          color: Colors.white54,
                          size: 48,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name.toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF111111),
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }

  Widget _buildProductGrid(List<FlutterProduct> filtered) {
    if (filtered.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Belum Ada Produk',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Produk untuk kategori ini akan segera hadir.',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ValueListenableBuilder<List<ProductReview>>(
      valueListenable: FavoritesState.reviews,
      builder: (context, reviewsList, child) {
        final refreshedProducts = filtered.map((p) {
          return FlutterProduct(
            id: p.id,
            name: p.name,
            price: p.price,
            rating: FavoritesState.getProductAverageRating(p.id),
            category: p.category,
            description: p.description,
            image: p.image,
          );
        }).toList();

        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          itemCount: refreshedProducts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.72,
          ),
          itemBuilder: (context, index) {
            final product = refreshedProducts[index];

            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/product',
                  arguments: {
                    'id': product.id,
                    'name': product.name,
                    'price':
                        '\$${product.price == 1199 ? "1.199" : product.price.toStringAsFixed(0)}',
                    'rating': product.rating.toStringAsFixed(1),
                    'image': product.image,
                    'description': product.description,
                  },
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0x0AECEAE6),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                        child: Image.network(
                          product.image,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                ),
                              ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Row(
                                children: List.generate(5, (starIdx) {
                                  final bool isFilled =
                                      starIdx < product.rating.round();
                                  return Icon(
                                    isFilled
                                        ? Icons.star_rounded
                                        : Icons.star_border_rounded,
                                    color: isFilled
                                        ? Colors.amber
                                        : Colors.grey.shade300,
                                    size: 12,
                                  );
                                }),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                product.rating.toStringAsFixed(1),
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  color: const Color(0xFF7E4D2B),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '\$${product.price == 1199 ? "1.199" : product.price.toStringAsFixed(0)}',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                  color: const Color(0xFF864F1F),
                                ),
                              ),
                              Container(
                                width: 28,
                                height: 28,
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
        );
      },
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
}
