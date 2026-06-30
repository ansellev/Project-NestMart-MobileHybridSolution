import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../user_session.dart';
import '../seller_state.dart';
import 'app_settings_screen.dart'; // Pastikan Anda memiliki file ini untuk navigasi ke pengaturan aplikasi
import 'seller_register_screen.dart';
import 'seller_dashboard_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  // Fungsi bawaan Anda untuk mengganti avatar (tetap dipertahankan)
  void _showAvatarPicker() {
    final TextEditingController urlController = TextEditingController();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            20,
            24,
            MediaQuery.of(context).viewInsets.bottom + 40,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'UBAH FOTO PROFIL',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const CircleAvatar(
                      radius: 14,
                      backgroundColor: Color(0xFFF3F4F6),
                      child: Icon(Icons.close, size: 16, color: Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // ... (isi picker sama seperti sebelumnya)
              GestureDetector(
                onTap: () {
                  setState(() {
                    UserSession.instance.photoUrl =
                        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400&auto=format&fit=crop&q=80';
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCF6F0),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF7E4D2B).withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.cloud_upload_outlined,
                        size: 36,
                        color: Color(0xFF7E4D2B),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'PILIH FOTO DARI PERANGKAT',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                          color: const Color(0xFF7E4D2B),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = UserSession.instance;
    const primaryBrown = Color(0xFF7E4D2B);
    const bgColor = Color(0xFFF8F6F4); // Abu-abu krem terang khas Nestmart

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // ==========================================
            // HEADER (Akun & Tombol Close)
            // ==========================================
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Akun Saya',
                    style: GoogleFonts.merriweather(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF7E4D2B),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black12),
                        color: Colors.white,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Color(0xFF864F1F),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ==========================================
                    // KARTU PROFIL UTAMA
                    // ==========================================
                    GestureDetector(
                      onTap:
                          _showAvatarPicker, // Mengubah foto profil saat card di-klik
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: primaryBrown, // Warna cokelat Nestmart
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: primaryBrown.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(session.photoUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    session.name,
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    session.email,
                                    style: GoogleFonts.inter(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // ==========================================
                    // BAGIAN 1: AKUN & PESANAN
                    // ==========================================
                    _buildSectionHeader('AKUN & PESANAN'),
                    const SizedBox(height: 12),
                    _buildCardContainer([
                      _buildListTile(
                        icon: Icons.inventory_2_outlined,
                        title: 'Pesanan Saya',
                        
                        onTap: () => Navigator.pushNamed(context, '/orders'),
                      ),
                      _buildDivider(),
                      _buildListTile(
                        icon: Icons.person_outline,
                        title: 'Detail Akun',
                        onTap: () =>
                            Navigator.pushNamed(context, '/my_details'),
                      ),
                      _buildDivider(),
                      _buildListTile(
                        icon: Icons.location_on_outlined,
                        title: 'Daftar Alamat',
                        onTap: () =>
                            Navigator.pushNamed(context, '/delivery_address'),
                      ),
                    ]),
                    const SizedBox(height: 24),

                    // ==========================================
                    // BAGIAN 2: BERJUALAN DI NESTMART
                    // ==========================================
                    _buildSectionHeader('BERJUALAN DI NESTMART'),
                    const SizedBox(height: 12),
                    _buildCardContainer([
                      _buildSellerTile(),
                    ]),
                    const SizedBox(height: 24),

                    // ==========================================
                    // BAGIAN 3: PENGATURAN
                    // ==========================================
                    _buildSectionHeader('PENGATURAN'),
                    const SizedBox(height: 12),
                    _buildCardContainer([
                      _buildListTile(
                        icon: Icons.settings_outlined,
                        title: 'Pengaturan Aplikasi',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AppSettingsScreen(),
                            ),
                          );
                          // Contoh menambahkan fungsi kustom
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Menu Pengaturan belum tersedia'),
                            ),
                          );
                        },
                      ),
                      _buildDivider(),
                      _buildListTile(
                        icon: Icons.help_outline_rounded,
                        title: 'Pusat Bantuan',
                        onTap: () =>
                            Navigator.pushNamed(context, '/help_support'),
                      ),
                    ]),
                    const SizedBox(height: 32),

                    // ==========================================
                    // TOMBOL LOGOUT
                    // ==========================================
                    GestureDetector(
                      onTap: () => Navigator.pushReplacementNamed(
                        context,
                        '/',
                      ), // Fungsi Logout
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFFFF5F5,
                          ), // Background merah super muda
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.redAccent.withOpacity(0.5),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.logout_rounded,
                              color: Colors.redAccent,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Keluar dari Akun',
                              style: GoogleFonts.inter(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            // ==========================================
            // BOTTOM NAVIGATION BAR
            // ==========================================
            Container(
              height: 72,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.black12, width: 0.5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavTab(
                    Icons.storefront_outlined,
                    'Home',
                    false,
                    () => Navigator.pushReplacementNamed(context, '/menu'),
                  ),
                  _buildNavTab(
                    Icons.manage_search,
                    'Kategori',
                    false,
                    () => Navigator.pushReplacementNamed(context, '/category'),
                  ),
                  _buildNavTab(
                    Icons.shopping_cart_outlined,
                    'Keranjang',
                    false,
                    () => Navigator.pushReplacementNamed(context, '/cart'),
                  ),
                  _buildNavTab(
                    Icons.favorite_border_outlined,
                    'Favorit',
                    false,
                    () => Navigator.pushReplacementNamed(context, '/favourite'),
                  ),
                  _buildNavTab(Icons.person, 'Akun', true, () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- KOMPONEN WIDGET REUSABLE ---

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.black54,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildCardContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    int badgeCount = 0,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Row(
          children: [
            // Ikon Kotak
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF3EBE6), // Background ikon krem
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: const Color(0xFF7E4D2B)),
            ),
            const SizedBox(width: 16),
            // Teks Label
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            // Badge Notifikasi (opsional)
            if (badgeCount > 0)
              Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  badgeCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            // Ikon Panah
            const Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: Colors.black38,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
    );
  }

  // Tile khusus untuk akses dashboard penjual dengan preview status toko
  Widget _buildSellerTile() {
    // ValueListenableBuilder memastikan tile ini rebuild otomatis
    // setiap kali hasStore berubah, termasuk saat kembali dari register/dashboard
    return ValueListenableBuilder<bool>(
      valueListenable: SellerState.hasStoreNotifier,
      builder: (context, hasToko, _) {
        final seller = SellerState();
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => hasToko
                    ? const SellerDashboardScreen()
                    : const SellerRegisterScreen(),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            child: Row(
              children: [
                // Icon box
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3EBE6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.storefront_outlined,
                      size: 20, color: Color(0xFF7E4D2B)),
                ),
                const SizedBox(width: 16),
                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Toko Saya',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        hasToko ? seller.storeName : 'Daftar sebagai penjual',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: hasToko
                              ? const Color(0xFF7E4D2B)
                              : Colors.black38,
                        ),
                      ),
                    ],
                  ),
                ),
                // Badge "BARU" hanya jika belum punya toko
                if (!hasToko)
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3EBE6),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'BARU',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF7E4D2B),
                      ),
                    ),
                  ),
                const Icon(Icons.chevron_right_rounded,
                    size: 20, color: Colors.black38),
              ],
            ),
          ),
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
            color: active ? const Color(0xFF7E4D2B) : Colors.black45,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: active ? FontWeight.w800 : FontWeight.w600,
              color: active ? const Color(0xFF7E4D2B) : Colors.black45,
            ),
          ),
        ],
      ),
    );
  }
}
