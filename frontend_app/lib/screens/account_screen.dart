import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../user_session.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final List<String> _presetAvatars = [
    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=150&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&auto=format&fit=crop&q=80'
  ];

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
          padding: EdgeInsets.fromLTRB(24, 20, 24, MediaQuery.of(context).viewInsets.bottom + 40),
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
                      color: Colors.black,
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
              Text(
                'Pilih dan upload foto dari galeri/perangkat Anda:',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54),
              ),
              const SizedBox(height: 12),
              
              // Mock Gallery Button Action Match React File Selector
              GestureDetector(
                onTap: () {
                  setState(() {
                    // Set to another random high quality beautiful unsplash portrait to simulate upload
                    UserSession().photoUrl = 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400&auto=format&fit=crop&q=80';
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Foto profil berhasil diupload secara real-time!'),
                      backgroundColor: Color(0xFF7E4D2B),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCF6F0),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF7E4D2B).withOpacity(0.3), style: BorderStyle.solid),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.cloud_upload_outlined, size: 36, color: Color(0xFF7E4D2B)),
                      const SizedBox(height: 8),
                      Text(
                        'PILIH FOTO DARI PERANGKAT',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                          color: const Color(0xFF7E4D2B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Mendukung JPEG, PNG, WEBP',
                        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black38),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(child: Container(height: 1, color: Colors.black12)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'ATAU',
                      style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black38),
                    ),
                  ),
                  Expanded(child: Container(height: 1, color: Colors.black12)),
                ],
              ),
              
              const SizedBox(height: 14),
              Text(
                'Gunakan URL gambar kustom:',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: TextField(
                        controller: urlController,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
                        decoration: const InputDecoration(
                          hintText: 'https://example.com/photo.jpg',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      final text = urlController.text.trim();
                      if (text.startsWith('http')) {
                        setState(() {
                          UserSession().photoUrl = text;
                        });
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7E4D2B),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                    child: Text(
                      'Gunakan',
                      style: GoogleFonts.inter(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = UserSession();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top dark brown segment (header) with bottom-rounded corners stretching full width
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF7E4D2B), // Rich chocolate brown
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(28.0, 32.0, 28.0, 28.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 1. Circle Avatar (Custom change trigger)
                  GestureDetector(
                    onTap: _showAvatarPicker,
                    child: Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        color: const Color(0xFFAB7A4E),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24, width: 3.0),
                        image: DecorationImage(
                          image: NetworkImage(session.photoUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  // 2. Profile Details
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          session.name,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          session.email,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 12.5,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // List of options (Middle Part)
            Expanded(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 12.0),
                child: ListView(
                  physics: const ClampingScrollPhysics(),
                  children: [
                    _buildAccountItem(
                      context,
                      Icons.inventory_2_outlined,
                      'MY ORDERS',
                      () {
                        Navigator.pushNamed(context, '/orders');
                      },
                    ),
                    _buildAccountItem(
                      context,
                      Icons.badge_outlined,
                      'MY DETAILS',
                      () {
                        Navigator.pushNamed(context, '/my_details');
                      },
                    ),
                    _buildAccountItem(
                      context,
                      Icons.location_on_outlined,
                      'DELIVERY ADDRESS',
                      () {
                        Navigator.pushNamed(context, '/delivery_address');
                      },
                    ),
                    _buildAccountItem(
                      context,
                      Icons.contact_support_outlined,
                      'HELP AND SUPPORT',
                      () {
                        Navigator.pushNamed(context, '/help_support');
                      },
                    ),
                    _buildAccountItem(
                      context,
                      Icons.exit_to_app_rounded,
                      'LOGOUT',
                      () {
                        Navigator.pushReplacementNamed(context, '/'); // Reset to login/welcome
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            // Custom bottom navigation bar mimicking screenshot inside page
            Container(
              height: 72,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Colors.black12,
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavTab(context, Icons.storefront_outlined, 'Shop', false, () {
                    Navigator.pushReplacementNamed(context, '/menu');
                  }),
                  _buildNavTab(context, Icons.manage_search, 'Kategori', false, () {
                    Navigator.pushReplacementNamed(context, '/category');
                  }),
                  _buildNavTab(context, Icons.shopping_cart_outlined, 'Cart', false, () {
                    Navigator.pushReplacementNamed(context, '/cart');
                  }),
                  _buildNavTab(context, Icons.favorite_border_outlined, 'Favourite', false, () {
                    Navigator.pushReplacementNamed(context, '/favourite');
                  }),
                  _buildNavTab(context, Icons.person, 'Account', true, () {}), // Active brown tab with filled layout
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountItem(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 11.5),
            child: Row(
              children: [
                // Custom black outline style icon
                Icon(
                  icon,
                  color: Colors.black,
                  size: 26,
                ),
                const SizedBox(width: 22),
                // Bold label text matching mockup exactly
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                // Custom solid black arrowhead pointer matching mockup
                const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.black,
                  size: 19,
                ),
              ],
            ),
          ),
          // Custom thin divider line matching screenshot
          Container(
            height: 1,
            width: double.infinity,
            color: const Color(0xFFC0A692).withOpacity(0.5), // Semi-transparent warm brown divider
          ),
        ],
      ),
    );
  }

  Widget _buildNavTab(BuildContext context, IconData icon, String label, bool active, VoidCallback onTap) {
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
