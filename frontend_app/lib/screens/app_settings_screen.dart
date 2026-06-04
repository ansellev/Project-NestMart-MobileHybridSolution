import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  // State untuk mengontrol tombol Switch (On/Off)
  bool _pushNotification = true;
  bool _promoEmail = false;
  bool _faceIdEnabled = true;

  @override
  Widget build(BuildContext context) {
    const primaryBrown = Color.fromARGB(255, 94, 61, 37);
    const bgColor = Color(0xFFF8F6F4);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // ==========================================
            // HEADER (Judul & Tombol Kembali)
            // ==========================================
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black12),
                        color: Colors.white,
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        size: 20,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Pengaturan',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            // ==========================================
            // KONTEN PENGATURAN
            // ==========================================
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 8.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- BAGIAN 1: NOTIFIKASI ---
                    _buildSectionHeader('NOTIFIKASI'),
                    const SizedBox(height: 12),
                    _buildCardContainer([
                      _buildSwitchTile(
                        icon: Icons.notifications_active_outlined,
                        title: 'Notifikasi Push',
                        value: _pushNotification,
                        onChanged: (val) =>
                            setState(() => _pushNotification = val),
                      ),
                      _buildDivider(),
                      _buildSwitchTile(
                        icon: Icons.email_outlined,
                        title: 'Email Promo & Info',
                        value: _promoEmail,
                        onChanged: (val) => setState(() => _promoEmail = val),
                      ),
                    ]),
                    const SizedBox(height: 24),

                    // --- BAGIAN 2: PREFERENSI & KEAMANAN ---
                    _buildSectionHeader('PREFERENSI & KEAMANAN'),
                    const SizedBox(height: 12),
                    _buildCardContainer([
                      _buildListTile(
                        icon: Icons.language_rounded,
                        title: 'Bahasa',
                        trailingText: 'Indonesia',
                        onTap: () {
                          _showSnackBar(
                            context,
                            'Pilihan bahasa belum tersedia',
                          );
                        },
                      ),
                      _buildDivider(),
                      _buildListTile(
                        icon: Icons.lock_outline_rounded,
                        title: 'Ubah Password',
                        onTap: () {
                          _showSnackBar(
                            context,
                            'Navigasi ke halaman ubah password',
                          );
                        },
                      ),
                      _buildDivider(),
                      _buildSwitchTile(
                        icon: Icons.face_rounded,
                        title: 'Login dengan Face ID',
                        value: _faceIdEnabled,
                        onChanged: (val) =>
                            setState(() => _faceIdEnabled = val),
                      ),
                    ]),
                    const SizedBox(height: 24),

                    // --- BAGIAN 3: SISTEM & INFO ---
                    _buildSectionHeader('SISTEM & INFORMASI'),
                    const SizedBox(height: 12),
                    _buildCardContainer([
                      _buildListTile(
                        icon: Icons.delete_outline_rounded,
                        title: 'Bersihkan Cache',
                        trailingText: '24 MB',
                        onTap: () {
                          _showSnackBar(context, 'Cache berhasil dibersihkan!');
                        },
                      ),
                      _buildDivider(),
                      _buildListTile(
                        icon: Icons.description_outlined,
                        title: 'Syarat & Ketentuan',
                        onTap: () {},
                      ),
                      _buildDivider(),
                      _buildListTile(
                        icon: Icons.privacy_tip_outlined,
                        title: 'Kebijakan Privasi',
                        onTap: () {},
                      ),
                      _buildDivider(),
                      // Tampilan versi aplikasi tanpa tombol panah
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 16.0,
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3EBE6),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.info_outline_rounded,
                                size: 20,
                                color: Color(0xFF7E4D2B),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                'Versi Aplikasi',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Text(
                              'v1.0.0',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- KOMPONEN REUSABLE ---

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.inter()),
        backgroundColor: const Color(0xFF7E4D2B),
        duration: const Duration(seconds: 2),
      ),
    );
  }

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
    String? trailingText,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF3EBE6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: const Color(0xFF7E4D2B)),
            ),
            const SizedBox(width: 16),
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
            if (trailingText != null)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  trailingText,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black45,
                  ),
                ),
              ),
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

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF3EBE6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: const Color(0xFF7E4D2B)),
          ),
          const SizedBox(width: 16),
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
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF7E4D2B), // Warna cokelat aktif
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.black12,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
    );
  }
}
