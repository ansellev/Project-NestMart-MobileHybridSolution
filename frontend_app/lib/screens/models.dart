import '../favorites_state.dart';

/// ============================================================================
/// MODEL DATA: StoreItem
/// ============================================================================
/// Menyimpan data detail mengenai mitra pelapak / toko merchant di NestMart.
/// Dilengkapi dengan metadata penunjang seperti status buka, lencana official,
/// lokasi fisik, rating toko, and persentase seberapa cepat membalas pesan obrolan.
class StoreItem {
  final String id;
  final String name;
  final String category;
  final double rating;
  final String image;
  final String location;
  final String description;
  final bool isOpen;
  final bool isOfficial;

  const StoreItem({
    required this.id,
    required this.name,
    required this.category,
    required this.rating,
    required this.image,
    required this.location,
    required this.description,
    required this.isOpen,
    required this.isOfficial,
  });

  /// Mengambil daftar koordinasi produk yang dijual oleh toko bersangkutan
  List<FavoriteProduct> getProducts() {
    return FavoritesState.allProducts.where((p) => getStoreIdForProduct(p.id) == id).toList();
  }
}

/// Helper pemetaan statis id produk ke id tokonya (Store ID Mapper)
String getStoreIdForProduct(String productId) {
  // Produk seller memiliki prefix 'sp_' — petakan ke ID toko seller
  if (productId.startsWith('sp_')) return 'seller_owned_store';
  switch (productId) {
    case '1': return 's1';
    case '2': return 's2';
    case '3': return 's3';
    case '4': return 's3';
    case '5': return 's4';
    case '6': return 's1';
    case '7': return 's2';
    case '8': return 's3';
    case '9': return 's3';
    case '10': return 's6';
    case '11': return 's6';
    case '12': return 's5';
    case '13': return 's4';
    case '14': return 's3';
    case '15': return 's5';
    default: return 's1';
  }
}

/// Menemukan objek toko berdasarkan ID toko
StoreItem getStoreById(String storeId) {
  return STORES.firstWhere((s) => s.id == storeId, orElse: () => STORES[0]);
}

/// Menemukan objek toko tempat produk terdaftar
StoreItem getStoreForProduct(String productId) {
  final storeId = getStoreIdForProduct(productId);
  return getStoreById(storeId);
}

/// ============================================================================
/// DATA STATIS: STORES (Daftar Toko Terpercaya)
/// ============================================================================
// ignore: non_constant_identifier_names
final List<StoreItem> STORES = [
  StoreItem(
    id: 's1',
    name: 'NestMart Official Store',
    category: 'Elektronik & Rumah Tangga',
    rating: 4.9,
    image: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400&auto=format&fit=crop&q=80',
    location: 'Jakarta Barat',
    description: 'Toko resmi NestMart. Menyediakan peralatan elektronik dan perlengkapan harian terbaik dengan jaminan asli.',
    isOpen: true,
    isOfficial: true,
  ),
  StoreItem(
    id: 's2',
    name: 'IndoTech Gadget',
    category: 'Elektronik',
    rating: 4.8,
    image: 'https://images.unsplash.com/photo-1531403009284-440f080d1e12?w=400&auto=format&fit=crop&q=80',
    location: 'Bandung',
    description: 'Spesialis gawai terbaru, smartphone, laptop, casing premium, dan aksesoris audio nirkabel bergaransi resmi.',
    isOpen: true,
    isOfficial: false,
  ),
  StoreItem(
    id: 's3',
    name: 'GayaKeren Fashion',
    category: 'Fashion & Pakaian',
    rating: 4.7,
    image: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=400&auto=format&fit=crop&q=80',
    location: 'Jakarta Selatan',
    description: 'Menyediakan fashion modern, jaket, sepatu kasual, dan aksesoris penunjang penampilan hits kamu.',
    isOpen: true,
    isOfficial: true,
  ),
  StoreItem(
    id: 's4',
    name: 'SportyLife Outlet',
    category: 'Olahraga',
    rating: 4.9,
    image: 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?w=400&auto=format&fit=crop&q=80',
    location: 'Surabaya',
    description: 'Distributor alat olahraga berkelas seperti sepatu lari, rasket, tumbler, dan pakaian olahraga berkualitas tinggi.',
    isOpen: false,
    isOfficial: false,
  ),
  StoreItem(
    id: 's5',
    name: 'Dapur Organik Bunda',
    category: 'Makanan & Minuman',
    rating: 4.6,
    image: 'https://images.unsplash.com/photo-1498837167922-ddd27525d352?w=400&auto=format&fit=crop&q=80',
    location: 'Sleman, Yogyakarta',
    description: 'Menjual sayur mayur bebas pestisida, bumbu organik, buah segar, dan aneka jajanan tradisional sehat.',
    isOpen: true,
    isOfficial: false,
  ),
  StoreItem(
    id: 's6',
    name: 'Cantika Glow Beauty Store',
    category: 'Kecantikan',
    rating: 4.8,
    image: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=400&auto=format&fit=crop&q=80',
    location: 'Tangerang',
    description: 'Skincare dan makeup natural terbaik, serum wajah pilihan, serta aneka masker pemutih berkualitas terjamin.',
    isOpen: true,
    isOfficial: true,
  ),
];

