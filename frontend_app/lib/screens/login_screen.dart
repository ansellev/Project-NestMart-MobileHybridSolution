import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/nestmart_checkbox.dart';
import '../user_session.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = true;
  bool _loading = false;
  late TextEditingController _emailController;
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
  setState(() {
    _loading = true;
  });

  final result = await UserSession.instance.login(
    email: _emailController.text.trim(),
    password: _passwordController.text,
  );

  setState(() {
    _loading = false;
  });

  if (!mounted) return;

  if (result["success"] == true) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/welcome',
      (route) => false,
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result["message"] ?? "Login failed",
        ),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 24.0,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 48,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // Jarak atas agar tidak terlalu mentok SafeArea
                      const SizedBox(height: 20),

                      // --- GRUP 1: HEADER (Logo & Judul yang rapat) ---
                      Image.asset(
                        'assets/LOGO.png',
                        height: 200, // Ukuran logo dipertahankan
                      ),
                      const SizedBox(
                        height: 8,
                      ), // Jarak sangat dekat agar menempel ke logo
                      Text(
                        'WELCOME BACK',
                        style: GoogleFonts.merriweather(
                          fontWeight:
                              FontWeight.w900, // Dipertebal seperti Figma
                          fontSize: 22,
                          letterSpacing: 0.5,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ), // Jarak sangat dekat ke subjudul
                      Text(
                        'Masukkan email dan password',
                        style: GoogleFonts.inter(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.5,
                        ),
                      ),

                      // Jarak pemisah yang tegas antara Header dan Form
                      const SizedBox(height: 40),

                      // --- GRUP 2: FORM INPUT & LOGIN ---
                      _buildPillTextField(
                        hint: 'email',
                        controller: _emailController,
                        inputType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16), // Jarak seragam antar kolom
                      _buildPillTextField(
                        hint: 'Password',
                        controller: _passwordController,
                        isObscured: true,
                      ),
                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          NestmartCheckbox(
                            initialValue: _rememberMe,
                            label: 'Remember me',
                            onChanged: (val) {
                              setState(() {
                                _rememberMe = val;
                              });
                            },
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              'Forgot password?',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF5C54A4),
                                fontWeight: FontWeight.bold,
                                fontSize: 12.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28), // Jarak ke tombol Login

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _handleSignIn,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF864F1F),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: _loading
                              ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                              ),
                            )
                              : Text(
                                'LOG IN',
                                style: GoogleFonts.merriweather(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),

                      // Jarak pemisah yang tegas untuk opsi "Grup Alternatif"
                      const SizedBox(height: 36),

                      const Spacer(),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0, top: 24.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: Text(
                            'Belum punya akun?',
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontWeight: FontWeight.w900, // Dipertegas
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPillTextField({
    required String hint,
    required TextEditingController controller,
    bool isObscured = false,
    TextInputType inputType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black, width: 1.2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
      child: TextField(
        controller: controller,
        obscureText: isObscured,
        keyboardType: inputType,
        style: GoogleFonts.inter(
          color: Colors.black,
          fontWeight: FontWeight.w700, // Teks isian lebih tegas
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.inter(
            color: Colors.black87,
            fontWeight:
                FontWeight.w800, // Hint text tebal seperti desain Genshin
            fontSize: 13,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
          ), // Padding diperbesar sedikit agar proporsional dengan tinggi 56
        ),
      ),
    );
  }
}
