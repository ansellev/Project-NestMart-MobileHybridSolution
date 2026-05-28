import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../user_session.dart';
import '../theme.dart';

class MyDetailsScreen extends StatefulWidget {
  const MyDetailsScreen({super.key});

  @override
  State<MyDetailsScreen> createState() => _MyDetailsScreenState();
}

class _MyDetailsScreenState extends State<MyDetailsScreen> {
  final _session = UserSession();

  bool _isEditingName = false;
  bool _isEditingEmail = false;
  bool _isEditingPassword = false;

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _session.name);
    _emailController = TextEditingController(text: _session.email);
    _passwordController = TextEditingController(text: _session.password);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _saveField(String field) {
    setState(() {
      if (field == 'name') {
        _session.name = _nameController.text.trim().toUpperCase();
        _isEditingName = false;
      } else if (field == 'email') {
        _session.email = _emailController.text.trim().toLowerCase();
        _isEditingEmail = false;
      } else if (field == 'password') {
        _session.password = _passwordController.text.trim();
        _isEditingPassword = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4CEB4), // Peach background matching React environment structure
      body: SafeArea(
        bottom: false,
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFEFEFEF), // Sleek grey inner page wrapper matching mockup
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.0),
              topRight: Radius.circular(40.0),
            ),
          ),
          child: Column(
            children: [
              // Top Header with back arrow and Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/account');
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.black,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'DETAIL AKUN',
                      style: GoogleFonts.merriweather(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        color: const Color(0xFF7E4D2B),
                      ),
                    ),
                  ],
                ),
              ),

              // White Card container where item boxes live
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // NAME FIELD
                        _buildFieldLabel('NAME'),
                        const SizedBox(height: 8),
                        _buildEditableContainer(
                          isEditing: _isEditingName,
                          controller: _nameController,
                          displayValue: _session.name,
                          onEditToggle: () {
                            if (_isEditingName) {
                              _saveField('name');
                            } else {
                              setState(() => _isEditingName = true);
                            }
                          },
                          keyboardType: TextInputType.name,
                        ),
                        const SizedBox(height: 24),

                        // EMAIL FIELD
                        _buildFieldLabel('EMAIL'),
                        const SizedBox(height: 8),
                        _buildEditableContainer(
                          isEditing: _isEditingEmail,
                          controller: _emailController,
                          displayValue: _session.email.toLowerCase(),
                          onEditToggle: () {
                            if (_isEditingEmail) {
                              _saveField('email');
                            } else {
                              setState(() => _isEditingEmail = true);
                            }
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 24),

                        // PASSWORD FIELD
                        _buildFieldLabel('PASSWORD'),
                        const SizedBox(height: 8),
                        _buildEditableContainer(
                          isEditing: _isEditingPassword,
                          controller: _passwordController,
                          displayValue: '*' * (_session.password.length > 8 ? _session.password.length : 12),
                          onEditToggle: () {
                            if (_isEditingPassword) {
                              _saveField('password');
                            } else {
                              setState(() => _isEditingPassword = true);
                            }
                          },
                          obscureText: !_isEditingPassword,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Persistent Bottom navigation bar matching screenshots
              Container(
                height: 72,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavTab(Icons.storefront_outlined, 'Shop', false, () {
                      Navigator.pushReplacementNamed(context, '/menu');
                    }),
                    _buildNavTab(Icons.manage_search, 'Kategori', false, () {
                      Navigator.pushReplacementNamed(context, '/category');
                    }),
                    _buildNavTab(Icons.shopping_cart_outlined, 'Cart', false, () {
                      Navigator.pushReplacementNamed(context, '/cart');
                    }),
                    _buildNavTab(Icons.favorite_border_outlined, 'Favourite', false, () {
                      Navigator.pushReplacementNamed(context, '/favourite');
                    }),
                    _buildNavTab(Icons.person, 'Account', true, () {
                      Navigator.pushReplacementNamed(context, '/account');
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.8,
          color: const Color(0xFF7E4D2B),
        ),
      ),
    );
  }

  Widget _buildEditableContainer({
    required bool isEditing,
    required TextEditingController controller,
    required String displayValue,
    required VoidCallback onEditToggle,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFF3F3F3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: isEditing
                ? TextField(
                    controller: controller,
                    autofocus: true,
                    keyboardType: keyboardType,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF7E4D2B),
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  )
                : Text(
                    displayValue,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onEditToggle,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              child: Text(
                isEditing ? 'Save' : 'Edit',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavTab(IconData icon, String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: active ? const Color(0xFF7E4D2B) : Colors.black45,
            size: 23,
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 9,
              fontWeight: active ? FontWeight.w900 : FontWeight.w700,
              color: active ? const Color(0xFF7E4D2B) : Colors.black45,
            ),
          ),
        ],
      ),
    );
  }
}
