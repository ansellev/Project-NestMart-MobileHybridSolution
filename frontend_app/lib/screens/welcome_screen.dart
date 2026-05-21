import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../widgets/nestmart_logo.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF), // Beautiful exact off-white background matching the screenshots
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // 1. Reusable Nestmart Custom Logo
                
                const SizedBox(height: 36),

                // 2. Middle aesthetic natural flatlay image (organic packaging, cosmetics, home decor representing UMKM)
                ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'product.png'
                    ),
                  ),
                ),
                const SizedBox(height: 36),

                // 3. Welcome title
                Text(
                  'WELCOME TO NESMART',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                    letterSpacing: 0.5,
                    color: const Color(0xFF7E4D2B), // Distinct primary brown color
                  ),
                ),
                const SizedBox(height: 16),

                // 4. Exact localized subtitle string
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
                      backgroundColor: const Color(0xFF864F1F), // Earthy brown button color in screenshot
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Rounded pill button
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
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
