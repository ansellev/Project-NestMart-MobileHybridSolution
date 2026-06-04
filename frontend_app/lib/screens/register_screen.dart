import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../user_session.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final TextEditingController _customUrlController = TextEditingController();

  final List<String> _presetAvatars = [
    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&auto=format&fit=crop&q=80', // Elegant Female Portrait
    'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=150&auto=format&fit=crop&q=80', // Crisp Male Portrait
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&auto=format&fit=crop&q=80', // Friendly Female Portrait
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&auto=format&fit=crop&q=80', // Cheerful Male Portrait
  ];

  late String _selectedPhoto;
  bool _showCustomInput = false;

  @override
  void initState() {
    super.initState();
    _selectedPhoto = _presetAvatars[0];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _customUrlController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    final session = UserSession();
    session.name = _nameController.text.trim().isEmpty
        ? 'ANDI'
        : _nameController.text.trim().toUpperCase();
    session.email = _emailController.text.trim().isEmpty
        ? 'ANDI@GMAIL.COM'
        : _emailController.text.trim().toUpperCase();
    session.photoUrl =
        _showCustomInput && _customUrlController.text.trim().startsWith('http')
        ? _customUrlController.text.trim()
        : _selectedPhoto;

    Navigator.pushNamed(context, '/welcome');
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
                vertical: 20.0,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 40,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Image.asset('assets/LOGO.png'),
                      const SizedBox(height: 20),

                      Text(
                        'CREATE ACCOUNT',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w800,
                          fontSize: 22,
                          letterSpacing: 0.5,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Lengkapi data akun dan pilih foto profile',
                        style: GoogleFonts.inter(
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 3. Profile custom photo uploader block
                      Text(
                        'FOTO PROFIL',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                          letterSpacing: 1.0,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Circle photo preview showing current photo state
                      Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFE2DFDC),
                            border: Border.all(
                              color: const Color(0xFF7E4D2B),
                              width: 2,
                            ),
                            image: DecorationImage(
                              image: NetworkImage(
                                _showCustomInput &&
                                        _customUrlController.text
                                            .trim()
                                            .startsWith('http')
                                    ? _customUrlController.text.trim()
                                    : _selectedPhoto,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      GestureDetector(
                        onTap: () {
                          setState(() {
                            // Simulate selecting customized photo
                            _selectedPhoto =
                                'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&auto=format&fit=crop&q=80';
                            _showCustomInput = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Foto profil berhasil diupload secara real-time!',
                              ),
                              backgroundColor: Color(0xFF7E4D2B),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFCF6F0),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFF7E4D2B).withOpacity(0.3),
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.cloud_upload_outlined,
                                size: 28,
                                color: Color(0xFF7E4D2B),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'AMBIL / PILIH FOTO DARI GALERI',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 11,
                                  color: const Color(0xFF7E4D2B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: Container(height: 1, color: Colors.black12),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'ATAU GUNAKAN URL',
                              style: GoogleFonts.inter(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Colors.black38,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(height: 1, color: Colors.black12),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2DFDC),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.black26, width: 1.0),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          controller: _customUrlController,
                          onChanged: (val) {
                            setState(() {
                              if (val.trim().startsWith('http')) {
                                _showCustomInput = true;
                              } else {
                                _showCustomInput = false;
                              }
                            });
                          },
                          style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Masukkan URL Gambar (https://...)',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Form Fields
                      _buildPillTextField(
                        hint: 'Nama pengguna',
                        controller: _nameController,
                      ),
                      const SizedBox(height: 12),
                      _buildPillTextField(
                        hint: 'Email',
                        controller: _emailController,
                        inputType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 12),
                      _buildPillTextField(
                        hint: 'Password',
                        controller: _passwordController,
                        isObscured: true,
                      ),
                      const SizedBox(height: 20),

                      // Create Account Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _handleRegister,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF864F1F),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            'Create Account',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const Spacer(),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Sudah punya akun?',
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
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
        color: const Color(0xFFE2DFDC),
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
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.inter(
            color: Colors.black54,
            fontWeight: FontWeight.w600,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}
