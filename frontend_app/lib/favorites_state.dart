import 'package:flutter/material.dart';
import 'user_session.dart';

/// ============================================================================
/// MODEL DATA: FavoriteProduct
/// ============================================================================
/// Representasi terstandarisasi untuk data produk di NestMart.
/// Menyimpan informasi inti seperti ID, nama, kategori, harga, deskripsi, gambar,
/// dan rating awal agar konsisten di setiap layar.
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

/// ============================================================================
/// MODEL DATA: ProductReview
/// ============================================================================
/// Representasi untuk ulasan produk yang diberikan oleh pembeli/pengguna.
/// Ulasan ini terhubung dengan ID produk secara dinamis untuk menghitung average rating.
class ProductReview {
  final String id;
  final String productId;
  final String userName;
  final String userPhotoUrl;
  final double rating;
  final String comment;
  final String date;

  ProductReview({
    required this.id,
    required this.productId,
    required this.userName,
    required this.userPhotoUrl,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

/// ============================================================================
/// STATE MANAGEMENT: FavoritesState (Global Controller)
/// ============================================================================
/// Berfungsi sebagai 'Single Source of Truth' yang menyatukan seluruh produk,
/// status favorit, daftar ulasan (reviews), beserta perhitungan nilai rating dinamis.
///
/// Menggunakan `ValueNotifier` agar UI dapat melakukan rebuild secara otomatis
/// saat ada ulasan baru atau perubahan status favorit menggunakan `ValueListenableBuilder`.
class FavoritesState {
  /// Master list produk mandiri yang disinkronkan dengan desain visual React.
  static final List<FavoriteProduct> allProducts = [
    FavoriteProduct(
      id: '1',
      name: 'Action Figure',
      price: 'Rp35.000',
      rating: '5.0',
      category: 'Hobi',
      description:
          'Mainan figur pahlawan Superman berkualitas premium dengan detail kostum, jubah, dan anatomi yang sangat presisi. Sangat cocok sebagai koleksi atau pajangan meja para penggemar komik dan film pahlawan super.',
      image:
          'https://images.unsplash.com/photo-1702138129392-364adea0ad00?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8YWN0aW9uJTIwZmlndXJlfGVufDB8fDB8fHww',
    ),
    FavoriteProduct(
      id: '2',
      name: 'Iphone 17 Pro Max',
      price: 'Rp17.999.000',
      rating: '5.0',
      category: 'Elekronik',
      description:
          'Smartphone flagship masa depan dengan kamera telefoto beresolusi super tinggi, layar dinamis tajam, chipset mutakhir penunjang aktivitas multitasking harian Anda, serta baterai tahan lama sepanjang hari.',
      image:
          'https://images.unsplash.com/photo-1616348436168-de43ad0db179?w=400&auto=format&fit=crop',
    ),
    FavoriteProduct(
      id: '3',
      name: 'Adidas training fullset',
      price: 'Rp824.000',
      rating: '5.0',
      category: 'Pakaian',
      description:
          'Satu set lengkap jaket training dan celana olahraga Adidas berbahan serat premium yang breathable dan nyaman digunakan untuk segala kegiatan aktif luar ruangan maupun santai sehari-hari.',
      image:
          'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=400&auto=format&fit=crop',
    ),
    FavoriteProduct(
      id: '4',
      name: 'Nike dunk retro',
      price: 'Rp1.200.000',
      rating: '5.0',
      category: 'Fashion',
      description:
          'Sepatu kasual legendaris Nike Dunk Retro dengan kombinasi warna hitam dan putih yang kontras and ikonik, kenyamanan maksimal untuk melengkapi penampilan kasual trendi Anda sepanjang hari.',
      image:
          'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=400&auto=format&fit=crop',
    ),
    FavoriteProduct(
      id: '5',
      name: 'Retro helmet',
      price: 'Rp440.000',
      rating: '5.0',
      category: 'Hobi',
      description:
          'Helm premium bergaya retro klasik matte dengan visor antik dan busa bagian dalam yang tebal serta empuk demi keselamatan tinggi and kenyamanan maksimal saat berkendara di jalan raya.',
      image: 'https://images.unsplash.com/photo-1558981806-ec527fa84c39?w=400',
    ),
    FavoriteProduct(
      id: '6',
      name: 'Superman figure',
      price: 'Rp35.000',
      rating: '5.0',
      category: 'Hobi',
      description:
          'Action figure Superman berskala kolektor dalam pose aksi ikonik lengkap dengan jubah kain premium serta dudukan eksklusif untuk mempercantik lemari etalase pajangan Anda.',
      image:
          'https://images.unsplash.com/photo-1608889174637-3c44f6326f1a?w=400&auto=format&fit=crop',
    ),
    FavoriteProduct(
      id: '7',
      name: 'Logitech Keyboard',
      price: 'Rp150.000',
      rating: '5.0',
      category: 'Elekronik',
      description:
          'Keyboard mekanikal gaming Logitech dengan respon pengetikan instan, lampu latar RGB yang dapat dip kustomisasi, serta tata letak tombol ergonomis yang awet untuk penggunaan mengetik and bermain game jangka panjang.',
      image:
          'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=400&auto=format&fit=crop',
    ),
    FavoriteProduct(
      id: '8',
      name: 'Luxury Leather Handbag',
      price: 'Rp1.500.000',
      rating: '4.9',
      category: 'Fashion',
      description:
          'Tas genggam wanita berbahan kulit sapi asli berkualitas tinggi dengan jahitan tangan yang rapi, kompartemen luas, dan aksen logam emas yang mewah untuk menyempurnakan hari penting Anda.',
      image:
          'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=400&auto=format&fit=crop',
    ),
    FavoriteProduct(
      id: '9',
      name: 'Sleek Black Duffle Bag',
      price: 'Rp850.000',
      rating: '4.8',
      category: 'Fashion',
      description:
          'Tas travel duffle olahraga modis tahan air dengan kapasitas penyimpanan besar dan tempat sepatu terpisah, sangat praktis untuk gym maupun bepergian akhir pekan.',
      image:
          'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400&auto=format&fit=crop',
    ),
    FavoriteProduct(
      id: '10',
      name: 'Esthetic Skincare Serum Set',
      price: 'Rp450.000',
      rating: '5.0',
      category: 'Kecantikan',
      description:
          'Paket serum wajah organik premium yang mengandung Hyaluronic Acid dan Niacinamide murni untuk hidrasi mendalam, mencerahkan bintik hitam, dan memberikan efek glowing alami sepanjang hari.',
      image:
          'https://images.unsplash.com/photo-1580870069867-74c57ee1bb07?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8c2tpbmNhcmV8ZW58MHx8MHx8fDA%3D',
    ),
    FavoriteProduct(
      id: '11',
      name: 'Organic Matte Lip Cream',
      price: 'Rp240.000',
      rating: '4.7',
      category: 'Kecantikan',
      description:
          'Lip cream matte dengan formula super ringan tidak lengket yang diperkaya dengan Vitamin E dan Jojoba Oil untuk menjaga kelembapan bibir serta memberikan pigmen warna tahan lama sampai 12 jam.',
      image:
          'https://images.unsplash.com/photo-1556228453-efd6c1ff04f6?w=400&auto=format&fit=crop',
    ),
    FavoriteProduct(
      id: '12',
      name: 'Premium Oat & Nut Salad Pack',
      price: 'Rp150.000',
      rating: '4.9',
      category: 'Makanan',
      description:
          'Camilan sehat kemasan kedap udara berisi campuran oat panggang renyah, kacang almond gurih, mete, kismis, serta buah-buahan kering pilihan tanpa bahan pengawet buatan.',
      image:
          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&auto=format&fit=crop',
    ),
    FavoriteProduct(
      id: '13',
      name: 'Sleek Remote Car Key Fob',
      price: 'Rp280.000',
      rating: '4.8',
      category: 'Otomotif',
      description:
          'Gantungan kunci mobil pintar premium berlapis kulit asli dan campuran logam zinc, dirancang eksklusif untuk melindung alat pelacak maupun kunci pintar kendaraan kesayangan Anda dari goresan.',
      image:
          'https://images.unsplash.com/photo-1542282088-fe8426682b8f?w=400&auto=format&fit=crop',
    ),
    FavoriteProduct(
      id: '14',
      name: 'Pro Mirrorless Leather Straps',
      price: 'Rp390.000',
      rating: '5.0',
      category: 'Hobi',
      description:
          'Tali bahu kamera mirrorless buatan pengrajin lokal berbahan kulit asli premium. Memberikan kenyamanan maksimum dan tampilan klasik retro estetik saat Anda melakukan aktivitas fotografi luar ruangan.',
      image:
          'https://images.unsplash.com/photo-1511556532299-8f662fc26c06?w=400&auto=format&fit=crop',
    ),
    FavoriteProduct(
      id: '15',
      name: 'Specialty Cold Brew Bottle',
      price: 'Rp18.000',
      rating: '4.9',
      category: 'Minuman',
      description:
          'Espresso cold brew organik segar siap minum, diekstrak perlahan selama 18 jam penuh dari biji kopi Arabika pilihan untuk rasa lembut tanpa pahit berlebih dan keasaman rendah yang nyaman di perut.',
      image:
          'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=400&auto=format&fit=crop',
    ),
    FavoriteProduct(
      id: '16',
      name: 'Iphone 17 Pro',
      price: 'Rp15.999.000',
      rating: '5',
      category: 'Elektronik',
      description:
          'Smartphone flagship terbaru dengan performa chip tercanggih, kamera resolusi tinggi untuk fotografi profesional, dan daya tahan baterai seharian penuh.',
      image:
          'assets/IPhone17pm.png',
    ),
  ];

  /// Menyimpan set ID produk yang difavoritkan pembeli.
  /// Berupa ValueNotifier agar UI Favourites Screen langsung terupdate jika diganti.
  static final ValueNotifier<Set<String>> favoriteIds =
      ValueNotifier<Set<String>>({'4', '5'});

  /// Kumpulan ulasan (reviews) statis awal yang selaras dengan implementasi React.
  /// Berupa ValueNotifier agar penambahan ulasan baru dapat langsung mentrigger
  /// pembaruan rata-rata rating di halaman utama, kategori, maupun detail produk.
  static final ValueNotifier<List<ProductReview>>
  reviews = ValueNotifier<List<ProductReview>>([
    // Product 1 reviews
    ProductReview(
      id: 'r1_1',
      productId: '1',
      userName: 'Arman',
      userPhotoUrl:
          'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100',
      rating: 5.0,
      comment:
          'Detail figure Sempurna! Sangat mirip dengan yang ada di film, bahan kokoh and catnya rapih.',
      date: '12 MEI 2026',
    ),
    ProductReview(
      id: 'r1_2',
      productId: '1',
      userName: 'Siti Aminah',
      userPhotoUrl:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
      rating: 5.0,
      comment:
          'Pesanan sampai dengan selamat. Box luar mulus tidak penyok karena bubble wrap-nya tebal banget. Makasih NestMart!',
      date: '14 MEI 2026',
    ),

    // Product 2 reviews
    ProductReview(
      id: 'r2_1',
      productId: '2',
      userName: 'Rian Wijaya',
      userPhotoUrl:
          'https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=100',
      rating: 5.0,
      comment:
          'Desain elegan, layar ultra tajam, dan responnya cepet banget tanpa lag. Worth the upgrade!',
      date: '15 MEI 2026',
    ),
    ProductReview(
      id: 'r2_2',
      productId: '2',
      userName: 'Nadia Saputri',
      userPhotoUrl:
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
      rating: 5.0,
      comment:
          'Barang dijamin original 100%. Kelengkapan lengkap, IMEI aman terdaftar di Kemenperin.',
      date: '16 MEI 2026',
    ),

    // Product 3 reviews
    ProductReview(
      id: 'r3_1',
      productId: '3',
      userName: 'Budi Santoso',
      userPhotoUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
      rating: 5.0,
      comment:
          'Sangat nyaman untuk berolahraga harian, bahan tidak panas and adem di kulit.',
      date: '13 MEI 2026',
    ),
    ProductReview(
      id: 'r3_2',
      productId: '3',
      userName: 'Arman',
      userPhotoUrl:
          'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100',
      rating: 5.0,
      comment:
          'Kualitas kain Adidas original ga perlu diragukan lagi. Jahitan presisi and pas sekali di badan.',
      date: '15 MEI 2026',
    ),

    // Product 4 reviews
    ProductReview(
      id: 'r4_1',
      productId: '4',
      userName: 'Siti Aminah',
      userPhotoUrl:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
      rating: 5.0,
      comment:
          'Modelnya everlasting banget. Sangat gampang dicocokkan dengan outfit apapun.',
      date: '14 MEI 2026',
    ),
    ProductReview(
      id: 'r4_2',
      productId: '4',
      userName: 'Nadia Saputri',
      userPhotoUrl:
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
      rating: 5.0,
      comment:
          'Sepatunya empuk and ringan. Ukurannya pas sesuai size chart global. Highly recommended!',
      date: '17 MEI 2026',
    ),

    // Product 5 reviews
    ProductReview(
      id: 'r5_1',
      productId: '5',
      userName: 'Rian Wijaya',
      userPhotoUrl:
          'https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=100',
      rating: 5.0,
      comment:
          'Tampilan retro klasiknya dapet banget, nambah keren pas pakai motor custom.',
      date: '10 MEI 2026',
    ),
    ProductReview(
      id: 'r5_2',
      productId: '5',
      userName: 'Budi Santoso',
      userPhotoUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
      rating: 5.0,
      comment:
          'Busa dalamnya lembut, menyerap keringat, and bisa dilepas untuk dicuci. Mantap!',
      date: '12 MEI 2026',
    ),

    // Product 6 reviews
    ProductReview(
      id: 'r6_1',
      productId: '6',
      userName: 'Arman',
      userPhotoUrl:
          'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100',
      rating: 5.0,
      comment:
          'Pose aksi supermannya ikonik sekali. Cocok ditaruh di meja belajar atau kerja.',
      date: '11 MEI 2026',
    ),
    ProductReview(
      id: 'r6_2',
      productId: '6',
      userName: 'Rian Wijaya',
      userPhotoUrl:
          'https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=100',
      rating: 5.0,
      comment:
          'Action figure superman paling detail untuk ukuran harganya. Suka sekali dengan bahan jubahnya.',
      date: '13 MEI 2026',
    ),

    // Product 7 reviews
    ProductReview(
      id: 'r7_1',
      productId: '7',
      userName: 'Nadia Saputri',
      userPhotoUrl:
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
      rating: 5.0,
      comment:
          'Feedback taktil keyboard mekanikalnya enak banget, suara klik memuaskan, and RGB asik.',
      date: '15 MEI 2026',
    ),
    ProductReview(
      id: 'r7_2',
      productId: '7',
      userName: 'Budi Santoso',
      userPhotoUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
      rating: 5.0,
      comment:
          'Baterai keyboard-nya luar biasa awet, koneksi Bluetooth super lurus dan ga ada delay.',
      date: '16 MEI 2026',
    ),

    // Product 8 reviews
    ProductReview(
      id: 'r8_1',
      productId: '8',
      userName: 'Nadia Saputri',
      userPhotoUrl:
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
      rating: 5.0,
      comment:
          'Kulit aslinya sangat wangi and teksturnya mewah sekali. Suka detail warna emasnya.',
      date: '16 MEI 2026',
    ),
    ProductReview(
      id: 'r8_2',
      productId: '8',
      userName: 'Siti Aminah',
      userPhotoUrl:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
      rating: 5.0,
      comment:
          'Sangat cocok untuk kondangan formal. Ringan and muat handphone serta lip cream.',
      date: '18 MEI 2026',
    ),
    ProductReview(
      id: 'r8_3',
      productId: '8',
      userName: 'Budi Santoso',
      userPhotoUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
      rating: 4.0,
      comment:
          'Barang indah, tapi tali rantainya agak terasa sedikit berat kalau digantung di pundak kelamaan.',
      date: '19 MEI 2026',
    ),

    // Product 9 reviews
    ProductReview(
      id: 'r9_1',
      productId: '9',
      userName: 'Arman',
      userPhotoUrl:
          'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100',
      rating: 5.0,
      comment:
          'Ukuran jumbo muat pakaian untuk 3 hari. Ada sekat basah terpisah untuk toiletries.',
      date: '11 MEI 2026',
    ),
    ProductReview(
      id: 'r9_2',
      productId: '9',
      userName: 'Rian Wijaya',
      userPhotoUrl:
          'https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=100',
      rating: 4.0,
      comment:
          'Bahannya tebal and waterproofing bekerja dengan baik saat kehujanan di jalan.',
      date: '13 MEI 2026',
    ),
    ProductReview(
      id: 'r9_3',
      productId: '9',
      userName: 'Siti Aminah',
      userPhotoUrl:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
      rating: 5.0,
      comment:
          'Desain kasual sporty, selain buat gym asik juga dipakai mudik singgah sebentar.',
      date: '14 MEI 2026',
    ),

    // Product 10 reviews
    ProductReview(
      id: 'r10_1',
      productId: '10',
      userName: 'Siti Aminah',
      userPhotoUrl:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
      rating: 5.0,
      comment:
          'Serumnya beneran ajaib! Beruntusan di jidat hilang dan kulit terasa jauh lebih lembab.',
      date: '15 MEI 2026',
    ),
    ProductReview(
      id: 'r10_2',
      productId: '10',
      userName: 'Nadia Saputri',
      userPhotoUrl:
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
      rating: 5.0,
      comment:
          'Niacinamide-nya beneran bikin noda hitam bekas jerawat memudar. Baunya juga soft menyegarkan.',
      date: '17 MEI 2026',
    ),

    // Product 11 reviews
    ProductReview(
      id: 'r11_1',
      productId: '11',
      userName: 'Nadia Saputri',
      userPhotoUrl:
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
      rating: 5.0,
      comment:
          'Sangat enteng di bibir tidak berasa tebal. Tahan seharian ga langsung ilang pas makan bakso.',
      date: '14 MEI 2026',
    ),
    ProductReview(
      id: 'r11_2',
      productId: '11',
      userName: 'Siti Aminah',
      userPhotoUrl:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
      rating: 4.0,
      comment:
          'Warnanya cantik natural nude, cuma agak kering sedikittt di ujung bibir saya, solusinya harus pakai lipbalm dulu.',
      date: '16 MEI 2026',
    ),
    ProductReview(
      id: 'r11_3',
      productId: '11',
      userName: 'Arman',
      userPhotoUrl:
          'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100',
      rating: 5.0,
      comment:
          'Istri saya seneng bgt pas dikadoin ini, katanya warnanya pas buat kulit sawo matang.',
      date: '17 MEI 2026',
    ),

    // Product 12 reviews
    ProductReview(
      id: 'r12_1',
      productId: '12',
      userName: 'Budi Santoso',
      userPhotoUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
      rating: 5.0,
      comment:
          'Cemilan sehat andalan saya, kacang almond melimpah and kismisnya manis alami.',
      date: '12 MEI 2026',
    ),
    ProductReview(
      id: 'r12_2',
      productId: '12',
      userName: 'Siti Aminah',
      userPhotoUrl:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
      rating: 5.0,
      comment:
          'Cocok dicampur susu hangat atau dimakan langsung. Kenyangnya tahan lama, ngebantu diet banget!',
      date: '14 MEI 2026',
    ),
    ProductReview(
      id: 'r12_3',
      productId: '12',
      userName: 'Rian Wijaya',
      userPhotoUrl:
          'https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=100',
      rating: 4.0,
      comment:
          'Ukurannya agak sedikit kecil tapi rasanya enak gurih and bernutrisi tinggi.',
      date: '15 MEI 2026',
    ),

    // Product 13 reviews
    ProductReview(
      id: 'r13_1',
      productId: '13',
      userName: 'Rian Wijaya',
      userPhotoUrl:
          'https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=100',
      rating: 5.0,
      comment:
          'Sangat rapat and presisi untuk kunci mobil pintar saya. Gantungan logamnya kokoh.',
      date: '11 MEI 2026',
    ),
    ProductReview(
      id: 'r13_2',
      productId: '13',
      userName: 'Budi Santoso',
      userPhotoUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
      rating: 4.0,
      comment:
          'Jahitan kulitnya rapi, logam zinc-nya tebal ga abal-abal. Keren digantung di celana.',
      date: '12 MEI 2026',
    ),
    ProductReview(
      id: 'r13_3',
      productId: '13',
      userName: 'Arman',
      userPhotoUrl:
          'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100',
      rating: 5.0,
      comment:
          'Kemasan mewah, sangat cocok dijadikan hadiah buat kawan yang baru beli mobil baru.',
      date: '14 MEI 2026',
    ),

    // Product 14 reviews
    ProductReview(
      id: 'r14_1',
      productId: '14',
      userName: 'Rian Wijaya',
      userPhotoUrl:
          'https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=100',
      rating: 5.0,
      comment:
          'Strap kamera kulit asli terbaik! Bau kulitnya premium, makin lama dipakai makin mengkilap.',
      date: '15 MEI 2026',
    ),
    ProductReview(
      id: 'r14_2',
      productId: '14',
      userName: 'Nadia Saputri',
      userPhotoUrl:
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
      rating: 5.0,
      comment:
          'Lebar strap pas di bahu, ga bikin pegel walau bawa lensa zoom berat seharian.',
      date: '17 MEI 2026',
    ),

    // Product 15 reviews
    ProductReview(
      id: 'r15_1',
      productId: '15',
      userName: 'Budi Santoso',
      userPhotoUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
      rating: 5.0,
      comment:
          'Rasa kopi cold brew-nya beneran luar biasa smooth. Rasa coklat and buah keringnya dapet bgt!',
      date: '11 MEI 2026',
    ),
    ProductReview(
      id: 'r15_2',
      productId: '15',
      userName: 'Siti Aminah',
      userPhotoUrl:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
      rating: 5.0,
      comment:
          'Rendah asam jadi lambung aman sentosa meskipun minum sebelum makan siang.',
      date: '13 MEI 2026',
    ),
    ProductReview(
      id: 'r15_3',
      productId: '15',
      userName: 'Arman',
      userPhotoUrl:
          'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100',
      rating: 4.0,
      comment:
          'Porsinya pas and botol kacanya estetik. Enak diminum dingin seger.',
      date: '14 MEI 2026',
    ),

    ProductReview(
      id: 'r16_1',
      productId: '16',
      userName: 'Budi Santoso',
      userPhotoUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
      rating: 5.0,
      comment:
          'Performa mantap',
      date: '11 MEI 2026',
    ),
  ]);

  /// Membantu mengecek secara cepat apakah suatu produk adalah favorit.
  static bool isFavorite(String id) {
    return favoriteIds.value.contains(id);
  }

  /// Menemukan objek produk berdasarkan nama barang dari pesanan lama
  static FavoriteProduct getProductByOrderName(String productName) {
    final nameClean = productName.trim().toLowerCase();

    if (nameClean.contains('luxury bag') || nameClean.contains('handbag')) {
      return allProducts.firstWhere(
        (p) => p.id == '8',
        orElse: () => allProducts[7],
      );
    }
    if (nameClean.contains('iphone')) {
      return allProducts.firstWhere(
        (p) => p.id == '2',
        orElse: () => allProducts[1],
      );
    }
    if (nameClean.contains('yamato')) {
      return allProducts.firstWhere(
        (p) => p.id == '14',
        orElse: () => allProducts[13],
      );
    }
    if (nameClean.contains('retro helmet') || nameClean.contains('helmet')) {
      return allProducts.firstWhere(
        (p) => p.id == '5',
        orElse: () => allProducts[4],
      );
    }

    for (var p in allProducts) {
      if (p.name.toLowerCase().contains(nameClean) ||
          nameClean.contains(p.name.toLowerCase())) {
        return p;
      }
    }
    return allProducts[0];
  }

  /// Menambah atau menghapus produk dari daftar favorit,
  /// kemudian memberi tahu seluruh listener yang sedang mengamati set favoriteIds.
  static void toggleFavorite(String id) {
    final current = Set<String>.from(favoriteIds.value);
    if (current.contains(id)) {
      current.remove(id);
    } else {
      current.add(id);
    }
    favoriteIds.value = current;
  }

  /// Mengembalikan list objek FavoriteProduct yang terdaftar sebagai favorit.
  static List<FavoriteProduct> getFavoriteProducts() {
    return allProducts.where((p) => favoriteIds.value.contains(p.id)).toList();
  }

  /// KUNCI REAKTIVITAS RATING:
  /// Menghitung skor rata-rata ulasan secara real-time berdasarkan productID.
  /// Jika belum ada ulasan baru dari pembeli, rating fallback ke nilai bawaan produk.
  /// Nilai rata-rata dibulatkan ke 1 tempat desimal.
  static double getProductAverageRating(String productId) {
    final prodReviews = reviews.value
        .where((r) => r.productId == productId)
        .toList();
    if (prodReviews.isEmpty) {
      final defProduct = allProducts.firstWhere(
        (p) => p.id == productId,
        orElse: () => allProducts[0],
      );
      return double.tryParse(defProduct.rating) ?? 5.0;
    }
    final double sum = prodReviews.fold(0.0, (acc, r) => acc + r.rating);
    return double.parse((sum / prodReviews.length).toStringAsFixed(1));
  }

  /// KUNCI REAKTIVITAS REVIEW & KOMENTAR:
  /// Menambahkan ulasan baru ke bagian paling atas daftar (index 0) agar langsung tampak.
  /// Membaca nama pengguna and avatar-nya secara aman dari `UserSession`.
  /// Setelah ditambahkan, ia akan mengganti seluruh instansi `reviews.value`,
  /// memicu notifikasi re-render otomatis pada ValueListenableBuilder di mana-mana!
  static void addReview(String productId, double rating, String comment) {
    final session = UserSession();
    final String dateString = _getFormattedDate();
    final newReview = ProductReview(
      id: 'r_user_${DateTime.now().millisecondsSinceEpoch}',
      productId: productId,
      userName: session.name.toUpperCase(),
      userPhotoUrl: session.photoUrl,
      rating: rating,
      comment: comment,
      date: dateString,
    );
    reviews.value = [newReview, ...reviews.value];
  }

  /// Helper untuk mengambil format tanggal lokal mandiri seperti "23 MEI 2026".
  static String _getFormattedDate() {
    final months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MEI',
      'JUN',
      'JUL',
      'AGU',
      'SEP',
      'OKT',
      'NOV',
      'DES',
    ];
    final now = DateTime.now();
    return '${now.day} ${months[now.month - 1]} ${now.year}';
  }
}
