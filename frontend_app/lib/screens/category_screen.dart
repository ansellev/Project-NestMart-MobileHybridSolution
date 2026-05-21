import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  final List<Map<String, String>> _categories = [
    {
      'name': 'Elektronik',
      'image': 'https://images.unsplash.com/photo-1496181130204-755241524eab?w=400&auto=format&fit=crop&q=80'
    },
    {
      'name': 'Pakaian',
      'image': 'https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?w=400&auto=format&fit=crop&q=80'
    },
    {
      'name': 'Fashion',
      'image': 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400&auto=format&fit=crop&q=80'
    },
    {
      'name': 'Kecantikan',
      'image': 'https://images.unsplash.com/photo-1608248597481-496100c8c836?w=400&auto=format&fit=crop&q=80'
    },
    {
      'name': 'Makanan',
      'image': 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&auto=format&fit=crop&q=80'
    },
    {
      'name': 'Otomotif',
      'image': 'https://images.unsplash.com/photo-1542282088-fe8426682b8f?w=400&auto=format&fit=crop&q=80'
    },
    {
      'name': 'Hobi',
      'image': 'https://images.unsplash.com/photo-1511556532299-8f662fc26c06?w=400&auto=format&fit=crop&q=80'
    },
    {
      'name': 'Minuman',
      'image': 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=400&auto=format&fit=crop&q=80'
    }
  ];

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

  final List<FlutterProduct> _products = [
    FlutterProduct(
      id: '1',
      name: 'Action Figure',
      price: 10.0,
      rating: 5.0,
      category: 'Elektronik',
      description: 'Mainan figur pahlawan Superman berkualitas premium dengan detail kostum, jubah, dan anatomi yang sangat presisi. Sangat cocok sebagai koleksi atau pajangan meja para penggemar komik dan film pahlawan super.',
      image: 'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full//85/MTA-11006803/gentleman_car_pajangan_action_figure_one_piece_luffy-_zoro-_sanji-_ace_-_anime_onepiece_full01_oiugs38u.jpg'
    ),
    FlutterProduct(
      id: '2',
      name: 'Iphone 17 Pro Max',
      price: 1199.0,
      rating: 5.0,
      category: 'Elektronik',
      description: 'Smartphone flagship masa depan dengan kamera telefoto beresolusi super tinggi, layar dinamis tajam, chipset mutakhir penunjang aktivitas multitasking harian Anda, serta baterai tahan lama sepanjang hari.',
      image: 'https://images.unsplash.com/photo-1616348436168-de43ad0db179?w=400&auto=format&fit=crop'
    ),
    FlutterProduct(
      id: '3',
      name: 'Adidas training fullset',
      price: 124.0,
      rating: 5.0,
      category: 'Pakaian',
      description: 'Satu set lengkap jaket training dan celana olahraga Adidas berbahan serat premium yang breathable dan nyaman digunakan untuk segala kegiatan aktif luar ruangan maupun santai sehari-hari.',
      image: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=400&auto=format&fit=crop'
    ),
    FlutterProduct(
      id: '4',
      name: 'Nike dunk retro',
      price: 60.0,
      rating: 5.0,
      category: 'Pakaian',
      description: 'Sepatu kasual legendaris Nike Dunk Retro dengan kombinasi warna hitam dan putih yang kontras and ikonik, kenyamanan maksimal untuk melengkapi penampilan kasual trendi Anda sepanjang hari.',
      image: 'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=400&auto=format&fit=crop'
    ),
    FlutterProduct(
      id: '5',
      name: 'Retro helmet',
      price: 40.0,
      rating: 5.0,
      category: 'Fashion',
      description: 'Helm premium bergaya retro klasik matte dengan visor antik dan busa bagian dalam yang tebal serta empuk demi keselamatan tinggi and kenyamanan maksimal saat berkendara di jalan raya.',
      image: 'https://images.unsplash.com/photo-1558981806-ec527fa84c39?w=400'
    ),
    FlutterProduct(
      id: '6',
      name: 'Superman figure',
      price: 35.0,
      rating: 5.0,
      category: 'Elektronik',
      description: 'Action figure Superman berskala kolektor dalam pose aksi ikonik lengkap dengan jubah kain premium serta dudukan eksklusif untuk mempercantik lemari etalase pajangan Anda.',
      image: 'https://images.unsplash.com/photo-1608889174637-3c44f6326f1a?w=400&auto=format&fit=crop'
    ),
    FlutterProduct(
      id: '7',
      name: 'Logitech Keyboard',
      price: 50.0,
      rating: 5.0,
      category: 'Elektronik',
      description: 'Keyboard mekanikal gaming Logitech dengan respon pengetikan instan, lampu latar RGB yang dapat dip kustomisasi, serta tata letak tombol ergonomis yang awet untuk penggunaan mengetik and bermain game jangka panjang.',
      image: 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=400&auto=format&fit=crop'
    ),
    FlutterProduct(
      id: '8',
      name: 'Luxury Leather Handbag',
      price: 150.0,
      rating: 4.9,
      category: 'Fashion',
      description: 'Tas genggam wanita berbahan kulit sapi asli berkualitas tinggi dengan jahitan tangan yang rapi, kompartemen luas, dan aksen logam emas yang mewah untuk menyempurnakan hari penting Anda.',
      image: 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=400&auto=format&fit=crop'
    ),
    FlutterProduct(
      id: '9',
      name: 'Sleek Black Duffle Bag',
      price: 85.0,
      rating: 4.8,
      category: 'Fashion',
      description: 'Tas travel duffle olahraga modis tahan air dengan kapasitas penyimpanan besar dan tempat sepatu terpisah, sangat praktis untuk gym maupun bepergian akhir pekan.',
      image: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400&auto=format&fit=crop'
    ),
    FlutterProduct(
      id: '10',
      name: 'Esthetic Skincare Serum Set',
      price: 45.0,
      rating: 5.0,
      category: 'Kecantikan',
      description: 'Paket serum wajah organik premium yang mengandung Hyaluronic Acid dan Niacinamide murni untuk hidrasi mendalam, mencerahkan bintik hitam, dan memberikan efek glowing alami sepanjang hari.',
      image: 'https://images.unsplash.com/photo-1608248597481-496100c8c836?w=400&auto=format&fit=crop'
    ),
    FlutterProduct(
      id: '11',
      name: 'Organic Matte Lip Cream',
      price: 24.0,
      rating: 4.7,
      category: 'Kecantikan',
      description: 'Lip cream matte dengan formula super ringan tidak lengket yang diperkaya dengan Vitamin E dan Jojoba Oil untuk menjaga kelembapan bibir serta memberikan pigmen warna tahan lama sampai 12 jam.',
      image: 'https://images.unsplash.com/photo-1556228453-efd6c1ff04f6?w=400&auto=format&fit=crop'
    ),
    FlutterProduct(
      id: '12',
      name: 'Premium Oat & Nut Salad Pack',
      price: 15.0,
      rating: 4.9,
      category: 'Makanan',
      description: 'Camilan sehat kemasan kedap udara berisi campuran oat panggang renyah, kacang almond gurih, mete, kismis, serta buah-buahan kering pilihan tanpa bahan pengawet buatan.',
      image: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&auto=format&fit=crop'
    ),
    FlutterProduct(
      id: '13',
      name: 'Sleek Remote Car Key Fob',
      price: 28.0,
      rating: 4.8,
      category: 'Otomotif',
      description: 'Gantungan kunci mobil pintar premium berlapis kulit asli dan campuran logam zinc, dirancang eksklusif untuk melindung alat pelacak maupun kunci pintar kendaraan kesayangan Anda dari goresan.',
      image: 'https://images.unsplash.com/photo-1542282088-fe8426682b8f?w=400&auto=format&fit=crop'
    ),
    FlutterProduct(
      id: '14',
      name: 'Pro Mirrorless Leather Straps',
      price: 39.0,
      rating: 5.0,
      category: 'Hobi',
      description: 'Tali bahu kamera mirrorless buatan pengrajin lokal berbahan kulit asli premium. Memberikan kenyamanan maksimum dan tampilan klasik retro estetik saat Anda melakukan aktivitas fotografi luar ruangan.',
      image: 'https://images.unsplash.com/photo-1511556532299-8f662fc26c06?w=400&auto=format&fit=crop'
    ),
    FlutterProduct(
      id: '15',
      name: 'Specialty Cold Brew Bottle',
      price: 18.0,
      rating: 4.9,
      category: 'Minuman',
      description: 'Espresso cold brew organik segar siap minum, diekstrak perlahan selama 18 jam penuh dari biji kopi Arabika pilihan untuk rasa lembut tanpa pahit berlebih dan keasaman rendah yang nyaman di perut.',
      image: 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=400&auto=format&fit=crop'
    )
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedCategory == null
        ? <FlutterProduct>[]
        : _products.where((p) => p.category.toLowerCase() == _selectedCategory!.toLowerCase()).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFECEAE6),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.only(top: 56, left: 16, right: 16, bottom: 12),
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
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 26,
                      ),
                    ),
                  ),
                  Text(
                    _selectedCategory ?? 'EXPLORE CATEGORIES',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
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
            _buildNavTab(Icons.storefront_outlined, 'Shop', false, () {
              Navigator.pushReplacementNamed(context, '/menu');
            }),
            _buildNavTab(Icons.manage_search, 'Kategori', true, () {}),
            _buildNavTab(Icons.shopping_cart_outlined, 'Cart', false, () {
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
                    color: const Color(0xFF864F1F),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      _getCategoryIcon(name),
                      color: Colors.white,
                      size: 48,
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

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      itemCount: filtered.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) {
        final product = filtered[index];

        return Container(
          decoration: BoxDecoration(
            color: const Color(0x0AECEAE6),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Product Image
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  child: Image.network(
                    product.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                  ),
                ),
              ),

              // Product Info
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
                        const Icon(Icons.star, color: Colors.amber, size: 12),
                        const SizedBox(width: 2),
                        Text(
                          product.rating.toStringAsFixed(1),
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: Colors.grey,
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
        );
      },
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
