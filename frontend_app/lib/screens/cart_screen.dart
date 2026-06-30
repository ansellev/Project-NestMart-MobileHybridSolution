import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// Jalur impor disesuaikan dengan folder widgets sesuai struktur proyek Anda
import '../widgets/cart_state.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryBrown = Color(0xFF864F1F);
    const bgColor = Color(0xFFECEAE6);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: primaryBrown,
            size: 20,
          ),
        ),
        title: Text(
          'KERANJANG SAYA',
          style: GoogleFonts.merriweather(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: primaryBrown,
          ),
        ),
      ),
      // Menggunakan ValueListenableBuilder agar layar otomatis refresh saat item ditambah/dikurangi
      body: ValueListenableBuilder<List<CartItem>>(
        valueListenable: CartState.cartItems,
        builder: (context, cartItems, child) {
          // ==========================================
          // KONDISI 1: JIKA KERANJANG KOSONG
          // ==========================================
          if (cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.remove_shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Keranjang Belanja Kosong',
                    style: GoogleFonts.merriweather(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Belum ada produk yang kamu tambahkan.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/menu'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBrown,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Text(
                      'BELANJA SEKARANG',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          // ==========================================
          // KONDISI 2: JIKA KERANJANG TERISI PRODUK
          // ==========================================
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  itemCount: cartItems.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    // Kalkulasi otomatis: harga asli dikali kuantitas jumlah beli
                    final double itemTotalPrice = item.price * item.quantity;

                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Gambar Produk (Mendukung asset lokal maupun network internet)
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F0ED),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: item.image.startsWith('http')
                                  ? Image.network(
                                      item.image,
                                      fit: BoxFit.contain,
                                    )
                                  : Image.asset(
                                      item.image,
                                      fit: BoxFit.contain,
                                    ),
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Informasi detail produk & tombol pengubah quantity
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  CartState.formatRupiah(itemTotalPrice),
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 15,
                                    color: primaryBrown,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                // Tombol Tambah (+) / Kurang (-) Kuantitas
                                Row(
                                  children: [
                                    _buildQtyBtn(Icons.remove, () {
                                      CartState.updateQuantity(item.id, -1);
                                    }),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: Text(
                                        '${item.quantity}',
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    _buildQtyBtn(Icons.add, () {
                                      CartState.updateQuantity(item.id, 1);
                                    }),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Ringkasan Pembayaran & Tombol navigasi ke Checkout Halaman berikutnya
              Container(
                padding: const EdgeInsets.only(
                  top: 24,
                  left: 24,
                  right: 24,
                  bottom: 32,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Pembayaran',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          CartState.formatRupiah(CartState.getTotalPrice()),
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                            color: primaryBrown,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          // Aksi berpindah ke halaman checkout yang sudah kita buat sebelumnya
                          Navigator.pushNamed(context, '/checkout');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBrown,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: Text(
                          'CHECKOUT SEKARANG',
                          style: GoogleFonts.merriweather(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: Container(
        height: 76,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 15,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavTab(
              Icons.storefront_rounded,
              'Home',
              false,
              () => Navigator.pushNamedAndRemoveUntil(
                  context, '/menu', (route) => false),
            ),
            _buildNavTab(
              Icons.manage_search_rounded,
              'Kategori',
              false,
              () => Navigator.pushNamed(context, '/category'),
            ),
            _buildNavTab(
              Icons.shopping_cart_rounded,
              'Keranjang',
              true,
              () {},
            ),
            _buildNavTab(
              Icons.favorite_outline_rounded,
              'Favorit',
              false,
              () => Navigator.pushNamed(context, '/favourite'),
            ),
            _buildNavTab(
              Icons.person_outline_rounded,
              'Akun',
              false,
              () => Navigator.pushNamed(context, '/account'),
            ),
          ],
        ),
      ),
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
            color: active ? const Color(0xFF7E4D2B) : Colors.black38,
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: active ? FontWeight.w800 : FontWeight.w600,
              color: active ? const Color(0xFF7E4D2B) : Colors.black38,
            ),
          ),
        ],
      ),
    );
  }

  // Widget pembantu untuk membuat desain tombol kuantitas
  Widget _buildQtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F0ED),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: Colors.black87),
      ),
    );
  }
}