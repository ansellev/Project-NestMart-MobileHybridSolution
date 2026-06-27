import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../seller_state.dart';
import 'models.dart';
import 'seller_dashboard_screen.dart';

class SellerRegisterScreen extends StatefulWidget {
  const SellerRegisterScreen({super.key});

  @override
  State<SellerRegisterScreen> createState() => _SellerRegisterScreenState();
}

class _SellerRegisterScreenState extends State<SellerRegisterScreen> {
  static const _primary = Color(0xFF7E4D2B);
  static const _bg = Color(0xFFECEAE6);

  final _nameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _customImgCtrl = TextEditingController();

  String _selectedCategory = 'Fashion & Pakaian';
  String _selectedImage = '';
  bool _showCustomImg = false;

  static const _presetImages = [
    'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=400&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?w=400&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1498837167922-ddd27525d352?w=400&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=400&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1531403009284-440f080d1e12?w=400&auto=format&fit=crop&q=80',
  ];

  static const _categories = [
    'Fashion & Pakaian',
    'Elektronik',
    'Makanan & Minuman',
    'Kecantikan',
    'Olahraga',
    'Hobi & Koleksi',
    'Perabotan',
    'Otomotif',
    'Umum',
  ];

  @override
  void initState() {
    super.initState();
    _selectedImage = _presetImages.first;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    _customImgCtrl.dispose();
    super.dispose();
  }

  // ── Submit ────────────────────────────────────────────────

  void _submit() {
    final name = _nameCtrl.text.trim();
    final address = _addressCtrl.text.trim();

    if (name.isEmpty) {
      _snack('Nama toko tidak boleh kosong');
      return;
    }
    if (address.isEmpty) {
      _snack('Alamat toko tidak boleh kosong');
      return;
    }

    final finalImg =
        _showCustomImg && _customImgCtrl.text.trim().startsWith('http')
            ? _customImgCtrl.text.trim()
            : _selectedImage;

    final s = SellerState();
    s.hasStore = true;
    s.storeName = name;
    s.storeAddress = address;
    s.storeCategory = _selectedCategory;
    s.storeImage = finalImg;
    SellerState.initMockOrders();

    // Daftarkan toko ke list STORES global agar muncul di search bar pembeli
    STORES.removeWhere((s) => s.id == SellerState.sellerStoreId); // hindari duplikat
    STORES.add(StoreItem(
      id: SellerState.sellerStoreId,
      name: name,
      category: _selectedCategory,
      rating: 0.0,
      image: finalImg,
      location: address,
      description: 'Toko UMKM $name di NestMart. Jual berbagai produk $_selectedCategory pilihan.',
      isOpen: true,
      isOfficial: false,
    ));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SellerDashboardScreen()),
    );
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  // ── Build ─────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Foto Profil Toko'),
                    const SizedBox(height: 12),
                    _buildImagePicker(),
                    const SizedBox(height: 24),
                    _label('Nama Toko'),
                    const SizedBox(height: 10),
                    _input(_nameCtrl, 'Contoh: Baju Keren Bandung',
                        Icons.storefront_outlined),
                    const SizedBox(height: 20),
                    _label('Kategori Usaha'),
                    const SizedBox(height: 10),
                    _buildCategoryPicker(),
                    const SizedBox(height: 20),
                    _label('Alamat Toko'),
                    const SizedBox(height: 10),
                    _input(_addressCtrl, 'Contoh: Jl. Braga No. 10, Bandung',
                        Icons.location_on_outlined,
                        maxLines: 3),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        child: Text('Buka Toko Sekarang',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                                color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        'Dengan mendaftar, kamu menyetujui\nKetentuan Penjual NestMart',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                            fontSize: 12, color: Colors.black38, height: 1.6),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        color: _primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 24, 28),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 17),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Daftar Toko Baru',
                  style: GoogleFonts.merriweather(
                      fontWeight: FontWeight.w900,
                      fontSize: 19,
                      color: Colors.white)),
              const SizedBox(height: 2),
              Text('Mulai berjualan di NestMart',
                  style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────

  Widget _label(String text) => Text(text,
      style: GoogleFonts.inter(
          fontWeight: FontWeight.w800, fontSize: 14, color: Colors.black87));

  Widget _input(
    TextEditingController ctrl,
    String hint,
    IconData icon, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(fontSize: 14, color: Colors.black38),
        prefixIcon: maxLines == 1
            ? Icon(icon, color: _primary, size: 20)
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
            horizontal: maxLines > 1 ? 16 : 0, vertical: 16),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _primary, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Preview
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border:
                    Border.all(color: _primary.withOpacity(0.35), width: 2),
                color: const Color(0xFFF6F4F2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: _selectedImage.isNotEmpty
                    ? Image.network(_selectedImage,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                            Icons.store_rounded,
                            color: _primary,
                            size: 32))
                    : const Icon(Icons.store_rounded, color: _primary, size: 32),
              ),
            ),
            const SizedBox(width: 12),
            // Presets scroll
            Expanded(
              child: SizedBox(
                height: 82,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _presetImages.length,
                  itemBuilder: (_, i) {
                    final sel = _selectedImage == _presetImages[i];
                    return GestureDetector(
                      onTap: () => setState(() {
                        _selectedImage = _presetImages[i];
                        _showCustomImg = false;
                      }),
                      child: Container(
                        width: 58,
                        height: 58,
                        margin: const EdgeInsets.only(
                            right: 8, top: 12, bottom: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: sel ? _primary : Colors.transparent,
                            width: 2.5,
                          ),
                          boxShadow: sel
                              ? [
                                  BoxShadow(
                                      color: _primary.withOpacity(0.25),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2))
                                ]
                              : null,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(_presetImages[i],
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.broken_image_rounded)),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Upload toggle
        GestureDetector(
          onTap: () => setState(() => _showCustomImg = !_showCustomImg),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: _primary.withOpacity(0.35)),
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFFFCF6F0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                    _showCustomImg
                        ? Icons.close_rounded
                        : Icons.cloud_upload_outlined,
                    color: _primary,
                    size: 18),
                const SizedBox(width: 8),
                Text(_showCustomImg ? 'Batal' : 'Upload Foto Custom',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: _primary)),
              ],
            ),
          ),
        ),
        if (_showCustomImg) ...[
          const SizedBox(height: 10),
          TextField(
            controller: _customImgCtrl,
            onChanged: (v) {
              if (v.trim().startsWith('http')) {
                setState(() => _selectedImage = v.trim());
              }
            },
            style: GoogleFonts.inter(fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Tempel URL gambar di sini...',
              hintStyle:
                  GoogleFonts.inter(fontSize: 13, color: Colors.black38),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCategoryPicker() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCategory,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: _primary),
          style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87),
          onChanged: (v) => setState(() => _selectedCategory = v!),
          items: _categories
              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
              .toList(),
        ),
      ),
    );
  }
}
