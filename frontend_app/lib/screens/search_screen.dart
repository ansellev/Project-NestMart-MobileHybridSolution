import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../favorites_state.dart';
import '../widgets/cart_state.dart';
import 'models.dart';
import '../seller_state.dart';

/// ============================================================================
/// SCREEN: SearchScreen (Pencarian Dinamis Barang & Toko)
/// ============================================================================
/// Menghadirkan pencarian real-time untuk barang/produk maupun toko pelapak.
/// Dilengkapi dengan pencarian populer, pemisahan tab responsif, filter kategori,
/// serta sinkronisasi state ulasan & favorit secara 100% reaktif.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _activeTab = 'barang'; // 'barang' atau 'toko'
  String _selectedCategory = 'Semua';

  final List<String> _categories = [
    'Semua',
    'Elektronik',
    'Pakaian',
    'Fashion',
    'Kecantikan',
    'Makanan'
  ];

  final List<String> _popularSearches = [
    'Iphone',
    'Nike dunk',
    'Retro helmet',
    'Action Figure',
    'NestMart Official',
    'Kecantikan'
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSelectPopular(String query) {
    _searchController.text = query;
    if (query.toLowerCase().contains('nestmart') || query.toLowerCase().contains('official') || query.toLowerCase().contains('gadget') || query.toLowerCase().contains('store')) {
      setState(() {
        _activeTab = 'toko';
      });
    } else {
      setState(() {
        _activeTab = 'barang';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Filter produk berdasar kata kunci & kategori
    final searchedProducts = FavoritesState.allProducts.where((product) {
      final matchesSearch = product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.category.toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesCategory = _selectedCategory == 'Semua' ||
          product.category.toLowerCase() == _selectedCategory.toLowerCase() ||
          (_selectedCategory == 'Fashion' && (product.category.toLowerCase() == 'pakaian' || product.category.toLowerCase() == 'fashion'));
      
      return matchesSearch && matchesCategory;
    }).toList();

    // 2. Filter toko berdasar kata kunci & kategori
    final searchedStores = STORES.where((store) {
      final matchesSearch = store.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          store.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          store.category.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesCategory = _selectedCategory == 'Semua' ||
          store.category.toLowerCase().contains(_selectedCategory.toLowerCase());

      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFECEAE6), // Beige cream background
      body: Column(
        children: [
          // ============================================================================
          // 1. HEADER: Curved NestMart Header with Search & Tabs Toggle
          // ============================================================================
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF7E4D2B), // Brown accent
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            padding: const EdgeInsets.only(top: 56, left: 24, right: 24, bottom: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
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
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                style: GoogleFonts.inter(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Cari barang atau nama toko...',
                                  hintStyle: GoogleFonts.inter(
                                    color: const Color(0xA6A69C95),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                            _searchQuery.isNotEmpty
                                ? GestureDetector(
                                    onTap: () {
                                      _searchController.clear();
                                    },
                                    child: const Icon(
                                      Icons.close_rounded,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                  )
                                : const Icon(
                                    Icons.search_rounded,
                                    color: Color(0xFF5A3821),
                                    size: 22,
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // TAB TOGGLE: BARANG VS TOKO
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF683F21),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: [
                      // Tab Barang
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _activeTab = 'barang'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: _activeTab == 'barang' ? const Color(0xFFECEAE6) : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.shopping_bag_outlined,
                                  size: 14,
                                  color: _activeTab == 'barang' ? const Color(0xFF7E4D2B) : Colors.white70,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'BARANG',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 11,
                                    color: _activeTab == 'barang' ? const Color(0xFF7E4D2B) : Colors.white70,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Tab Toko
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _activeTab = 'toko'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: _activeTab == 'toko' ? const Color(0xFFECEAE6) : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.store_outlined,
                                  size: 14,
                                  color: _activeTab == 'toko' ? const Color(0xFF7E4D2B) : Colors.white70,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'TOKO',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 11,
                                    color: _activeTab == 'toko' ? const Color(0xFF7E4D2B) : Colors.white70,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
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

          // ============================================================================
          // 2. MAIN BODY: Categories Slider and Search Results listing
          // ============================================================================
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Silder Kategori
                  SizedBox(
                    height: 38,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      itemBuilder: (context, idx) {
                        final catName = _categories[idx];
                        final isSelected = _selectedCategory == catName;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategory = catName;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF7E4D2B) : const Color(0xFFE2DFDC),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                catName,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                  color: isSelected ? Colors.white : Colors.black87,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 18),

                  // LOGIKA VIEW: KOSONG VS HASIL CARI
                  _searchQuery.isEmpty && _selectedCategory == 'Semua'
                      ? _buildEmptySearchState()
                      : _buildSearchResultsState(searchedProducts, searchedStores),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Membangun State Awal Pencarian (Pencarian Populer & Panduan Ringkas)
  Widget _buildEmptySearchState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.history_toggle_off_rounded, size: 16, color: Colors.black54),
            const SizedBox(width: 6),
            Text(
              'PENCARIAN POPULER',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w900,
                fontSize: 11,
                color: Colors.black54,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _popularSearches.map((term) {
            return GestureDetector(
              onTap: () => _handleSelectPopular(term),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2DFDC),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    )
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.search_rounded, size: 12, color: Colors.black38),
                    const SizedBox(width: 6),
                    Text(
                      term,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 28),

        // Banner Tips Belanja Cantik
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0x3DFFFFFF),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white24, width: 1.5),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.auto_awesome_outlined,
                color: Color(0xFF7E4D2B),
                size: 26,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cari Kebutuhan Belanja Anda',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ketik nama barang seperti "Iphone 17" atau temukan toko terpercaya Anda seperti "NestMart" secara cepat and mudah.',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                        color: Colors.black54,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  /// Membangun Hasil Pencarian Secara Dinamis
  Widget _buildSearchResultsState(
      List<FavoriteProduct> products, List<StoreItem> stores) {
    if (_activeTab == 'barang') {
      // Sektor Hasil Cari Produk
      if (products.isEmpty) {
        return _buildNoResultsState(Icons.shopping_bag_outlined, 'Barang Tidak Ditemukan');
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildResultHeader('Hasil Pencarian Barang (${products.length})'),
          const SizedBox(height: 12),
          // 2-Column Product Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.68,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
            ),
            itemBuilder: (context, idx) {
              final product = products[idx];
              return _buildProductGridCard(product);
            },
          ),
        ],
      );
    } else {
      // Sektor Hasil Cari Toko
      if (stores.isEmpty) {
        return _buildNoResultsState(Icons.store_outlined, 'Toko Tidak Ditemukan');
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildResultHeader('Hasil Pencarian Toko (${stores.length})'),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: stores.length,
            separatorBuilder: (context, sIdx) => const SizedBox(height: 12),
            itemBuilder: (context, idx) {
              final store = stores[idx];
              return _buildStoreListCard(store);
            },
          )
        ],
      );
    }
  }

  Widget _buildResultHeader(String label) {
    return Text(
      label.toUpperCase(),
      style: GoogleFonts.inter(
        fontWeight: FontWeight.w900,
        fontSize: 11,
        color: Colors.black54,
        letterSpacing: 0.5,
      ),
    );
  }

  /// UI Kosong / Pencarian Gagal
  Widget _buildNoResultsState(IconData icon, String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white38,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.black.withOpacity(0.04)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0x1F7E4D2B),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 28, color: const Color(0xFF7E4D2B)),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w900,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Waduh, hasil pencarian nihil. Silakan coba kata kunci lain atau bersihkan filter di atas!',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 11,
              color: Colors.black45,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  /// Kartu Item Produk Grid
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
                                    CartState.addToCart(CartItem(
                                      id: product.id,
                                      name: product.name,
                                      price: CartState.parsePrice(product.price),
                                      image: product.image,
                                      quantity: 1,
                                    ));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('${product.name} ditambahkan ke keranjang!'),
                                        duration: const Duration(seconds: 1),
                                        backgroundColor: const Color(0xFF7E4D2B),
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

  /// Membangun baris list toko pencarian
  Widget _buildStoreListCard(StoreItem store) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.black.withOpacity(0.04)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo/Avatar Toko
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.network(
                  store.image,
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                  errorBuilder: (context, err, stack) => Container(
                    width: 72,
                    height: 72,
                    color: Colors.grey[200],
                    child: const Icon(Icons.store, color: Colors.grey),
                  ),
                ),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: store.isOpen ? Colors.green : Colors.redAccent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    store.isOpen ? 'BUKA' : 'TUTUP',
                    style: GoogleFonts.inter(
                      fontSize: 7,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(width: 14),

          // Deskripsi metadata Toko
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        store.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    if (store.isOfficial) ...[
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue[600],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'OFFICIAL',
                          style: GoogleFonts.inter(
                            fontSize: 7,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      )
                    ]
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  store.category.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: Colors.black54,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  store.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.black45,
                  ),
                ),
                const SizedBox(height: 10),

                // Baris Rating, Lokasi & Tombol Kunjungan
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 12, color: Color(0xFFF59E0B)),
                        const SizedBox(width: 2),
                        Text(
                          store.rating.toStringAsFixed(1),
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.location_on_outlined, size: 11, color: Colors.black38),
                        const SizedBox(width: 2),
                        Text(
                          store.location,
                          style: GoogleFonts.inter(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigasi ke Halaman Store detail (StoreScreen)
                        Navigator.pushNamed(
                          context,
                          '/store',
                          arguments: store,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0x2E7E4D2B),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Kunjungi',
                              style: GoogleFonts.inter(
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFF7E4D2B),
                              ),
                            ),
                            const SizedBox(width: 2),
                            const Icon(
                              Icons.chevron_right_rounded,
                              size: 10,
                              color: Color(0xFF7E4D2B),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
