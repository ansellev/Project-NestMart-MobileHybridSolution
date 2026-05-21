import 'package:flutter/material.dart';

class FavoriteProduct {
  final String id;
  final String name;
  final String price;
  final String rating;
  final String category;
  final String description;
  final String image;

  FavoriteProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.category,
    required this.description,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'rating': rating,
      'category': category,
      'description': description,
      'image': image,
    };
  }

  factory FavoriteProduct.fromMap(Map<String, dynamic> map) {
    return FavoriteProduct(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      price: map['price'] ?? '',
      rating: map['rating'] ?? '',
      category: map['category'] ?? '',
      description: map['description'] ?? '',
      image: map['image'] ?? '',
    );
  }
}

class FavoritesState {
  static final List<FavoriteProduct> allProducts = [
    FavoriteProduct(
      id: '1',
      name: 'Action Figure',
      price: '\$10',
      rating: '5.0',
      category: 'Hobi', // Matches "Hobi" screen filter
      description: 'Mainan figur pahlawan Superman berkualitas premium dengan detail kostum, jubah, dan anatomi yang sangat presisi. Sangat cocok sebagai koleksi atau pajangan meja para penggemar komik dan film pahlawan super.',
      image: 'https://images.unsplash.com/photo-1608889174637-3c44f6326f1a?w=400&auto=format&fit=crop',
    ),
    FavoriteProduct(
      id: '2',
      name: 'Iphone 17 Pro Max',
      price: '\$1.199',
      rating: '5.0',
      category: 'Elekronik',
      description: 'Smartphone flagship masa depan dengan kamera telefoto beresolusi super tinggi, layar dinamis tajam, chipset mutakhir penunjang aktivitas multitasking harian Anda, serta baterai tahan lama sepanjang hari.',
      image: 'https://images.unsplash.com/photo-1616348436168-de43ad0db179?w=400&auto=format&fit=crop',
    ),
    FavoriteProduct(
      id: '3',
      name: 'Adidas training fullset',
      price: '\$124',
      rating: '5.0',
      category: 'Pakaian',
      description: 'Satu set lengkap jaket training dan celana olahraga Adidas berbahan serat premium yang breathable dan nyaman digunakan untuk segala kegiatan aktif luar ruangan maupun santai sehari-hari.',
      image: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=400&auto=format&fit=crop',
    ),
    FavoriteProduct(
      id: '4',
      name: 'Nike dunk retro',
      price: '\$60',
      rating: '5.0',
      category: 'Fashion', // Matches "Fashion" screen filter
      description: 'Sepatu kasual legendaris Nike Dunk Retro dengan kombinasi warna hitam dan putih yang kontras and ikonik, kenyamanan maksimal untuk melengkapi penampilan kasual trendi Anda sepanjang hari.',
      image: 'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=400&auto=format&fit=crop',
    ),
    FavoriteProduct(
      id: '5',
      name: 'Retro helmet',
      price: '\$40',
      rating: '5.0',
      category: 'Hobi', // Matches "Hobi" screen filter
      description: 'Helm premium bergaya retro klasik matte dengan visor antik dan busa bagian dalam yang tebal serta empuk demi keselamatan tinggi and kenyamanan maksimal saat berkendara di jalan raya.',
      image: 'https://images.unsplash.com/photo-1558981806-ec527fa84c39?w=400',
    ),
    FavoriteProduct(
      id: '6',
      name: 'Superman figure',
      price: '\$35',
      rating: '5.0',
      category: 'Hobi',
      description: 'Action figure Superman berskala kolektor dalam pose aksi ikonik lengkap dengan jubah kain premium serta dudukan eksklusif untuk mempercantik lemari etalase pajangan Anda.',
      image: 'https://images.unsplash.com/photo-1608889174637-3c44f6326f1a?w=400&auto=format&fit=crop',
    ),
    FavoriteProduct(
      id: '7',
      name: 'Logitech Keyboard',
      price: '\$50',
      rating: '5.0',
      category: 'Elekronik',
      description: 'Keyboard mekanikal gaming Logitech dengan respon pengetikan instan, lampu latar RGB yang dapat dip kustomisasi, serta tata letak tombol ergonomis yang awet untuk penggunaan mengetik and bermain game jangka panjang.',
      image: 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=400&auto=format&fit=crop',
    ),
  ];

  // Store pre-favorited items ID list ('4' is Nike dunk retro, '5' is Retro helmet)
  static final ValueNotifier<Set<String>> favoriteIds = ValueNotifier<Set<String>>({'4', '5'});

  static bool isFavorite(String id) {
    return favoriteIds.value.contains(id);
  }

  static void toggleFavorite(String id) {
    final current = Set<String>.from(favoriteIds.value);
    if (current.contains(id)) {
      current.remove(id);
    } else {
      current.add(id);
    }
    favoriteIds.value = current;
  }

  static List<FavoriteProduct> getFavoriteProducts() {
    return allProducts.where((p) => favoriteIds.value.contains(p.id)).toList();
  }
}
