import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32.0,
              vertical: 24.0,
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // 1. Logo Nestmart
                // Tinggi dikurangi agar tidak memakan ruang kosong
                Image.asset(
                  'assets/LOGO.png',
                  height: 220, // Sebelumnya 180
                  fit: BoxFit.contain,
                ),

                // 2. Konten Produk & Teks
                // Menggunakan Transform.translate untuk menarik semua elemen ke atas
                Transform.translate(
                  offset: const Offset(
                    0,
                    -30,
                  ), // GANTI angka -30 menjadi lebih besar (misal -50 atau -60) jika ingin lebih dekat lagi
                  child: Column(
                    children: [
                      // Gambar Produk
                      Image.asset(
                        'assets/product.png',
                        width: double.infinity,
                        height: 260,
                        fit: BoxFit.contain,
                      ),

                      const SizedBox(
                        height: 16,
                      ), // Jarak antara gambar dan teks judul
                      // 3. Welcome title
                      Text(
                        'WELCOME TO NESMART',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w900,
                          fontSize: 22,
                          letterSpacing: 0.5,
                          color: const Color(0xFF7E4D2B),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 4. Subtitle
                      Text(
                        'Temukan kebutuhan harian,produk favorit\ndan penawaran terbaik hanya untuk mu',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // 5. Start Shopping button capsule
                      SizedBox(
                        width: 240,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/menu');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF864F1F),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            'Start Shopping',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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
        ),
      ),
    );
  }
}
