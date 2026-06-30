import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import '../user_session.dart';
import 'orders_screen.dart';
// IMPORT INI PENTING: Menghubungkan halaman ini ke data Keranjang
import '../widgets/cart_state.dart';

class ShippingOption {
  final String id;
  final String name;
  final String eta;
  final double price;

  const ShippingOption({
    required this.id,
    required this.name,
    required this.eta,
    required this.price,
  });
}

class PaymentOption {
  final String id;
  final String name;
  final String icon;
  final String description;

  const PaymentOption({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
  });
}

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _session = UserSession.instance;

  final List<ShippingOption> _shipOptions = const [
    ShippingOption(
      id: 'ship1',
      name: 'J&T Regular',
      eta: '2-3 Hari',
      price: 15000, // Disesuaikan menjadi Rupiah
    ),
    ShippingOption(
      id: 'ship2',
      name: 'JNE YES (Yakin Esok Sampai)',
      eta: '1 Hari',
      price: 25000, // Disesuaikan menjadi Rupiah
    ),
    ShippingOption(
      id: 'ship3',
      name: 'SiCepat Gokil (Cargo)',
      eta: '4-6 Hari',
      price: 35000, // Disesuaikan menjadi Rupiah
    ),
  ];

  final List<PaymentOption> _payOptions = const [
    PaymentOption(
      id: 'pay1',
      name: 'M-Banking (BCA)',
      icon: '🏦',
      description: 'Transfer Bank Mandiri/BCA/BRI',
    ),
    PaymentOption(
      id: 'pay2',
      name: 'E-Wallet (GoPay)',
      icon: '📱',
      description: 'Instant pay dengan GoPay / OVO',
    ),
    PaymentOption(
      id: 'pay3',
      name: 'COD (Bayar di Tempat)',
      icon: '💵',
      description: 'Bayar tunai kurir saat sampai',
    ),
  ];

  String _selectedShipId = 'ship1';
  String _selectedPayId = 'pay1';
  bool _isProcessing = false;

  // HAPUS: List statis _cartItems sudah dihapus karena kita mengambil dari CartState

  String _getFormattedDate() {
    final months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MEI',
      'JUN',
      'JUL',
      'AGU',
      'SEP',
      'OKT',
      'NOV',
      'DES',
    ];
    final now = DateTime.now();
    return '${now.day} ${months[now.month - 1]} ${now.year}';
  }

  void _triggerPayment(double total) {
    // Ambil data keranjang saat ini
    final currentCartItems = CartState.cartItems.value;

    // Jika keranjang kosong, cegah proses pembayaran
    if (currentCartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Keranjang Anda kosong!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isProcessing = true);

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _isProcessing = false);

      final part1 = 10000 + Random().nextInt(90000);
      final part2 = 10000 + Random().nextInt(90000);
      final orderId = '$part1$part2';

      final dateString = _getFormattedDate();
      final selectedShip = _shipOptions.firstWhere(
        (s) => s.id == _selectedShipId,
      );
      final selectedPay = _payOptions.firstWhere((p) => p.id == _selectedPayId);
      final activeAddress = _session.addresses.firstWhere(
        (a) => a.id == _session.selectedAddressId,
        orElse: () => _session.addresses[0],
      );

      // --- MEMASUKKAN BARANG DINAMIS KE DAFTAR PESANAN (ORDERS) ---
      for (int i = 0; i < currentCartItems.length; i++) {
        final item = currentCartItems[i];
        final newOrder = FlutterOrder(
          id: 'ord_${DateTime.now().millisecondsSinceEpoch}_$i',
          orderId: orderId,
          date: dateString,
          status: 'DIPROSES',
          productName: item.name,
          productPrice: CartState.formatRupiah(item.price),
          productImage: item.image,
          quantity: item.quantity,
          shippingAddress: activeAddress.fullAddress,
          paymentMethod: selectedPay.name.toUpperCase(),
          shippingCost: CartState.formatRupiah(selectedShip.price),
          totalPrice: CartState.formatRupiah(total),
        );
        mockOrders.insert(0, newOrder);
      }

      _showSuccessDialog(orderId, total);
    });
  }

  void _showSuccessDialog(String orderId, double total) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              const Icon(
                Icons.check_circle_rounded,
                color: Colors.green,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                'Pembayaran Berhasil!',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Pesanan Anda dikonfirmasi & langsung masuk status "Diproses".',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: Colors.grey.shade600,
                  fontSize: 11,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ORDER ID',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '#$orderId',
                          style: const TextStyle(
                            fontSize: 10,
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'TOTAL BAYAR',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          CartState.formatRupiah(total),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF7E4D2B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7E4D2B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    // MENGOSONGKAN KERANJANG SETELAH PEMBAYARAN BERHASIL
                    CartState.cartItems.value = [];

                    Navigator.pop(ctx);
                    Navigator.pushReplacementNamed(context, '/orders');
                  },
                  child: Text(
                    'PANTAU PESANAN SAYA',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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
    // 1. Mengambil data keranjang secara langsung dari state global (CartState)
    final currentCartItems = CartState.cartItems.value;

    // 2. Menghitung Subtotal Harga Produk
    final double subtotal = CartState.getTotalPrice();

    final selectedShip = _shipOptions.firstWhere(
      (s) => s.id == _selectedShipId,
    );

    // 3. Biaya layanan aplikasi dinamis
    final double serviceFee = 2500; // Rp2.500

    // 4. Total Bayar Keseluruhan
    final double total = subtotal + selectedShip.price + serviceFee;

    final activeAddress = _session.addresses.firstWhere(
      (a) => a.id == _session.selectedAddressId,
      orElse: () => _session.addresses[0],
    );

    return Scaffold(
      backgroundColor: const Color(0xFFECEAE6),
      body: Stack(
        children: [
          Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 50,
                  bottom: 24,
                  left: 16,
                  right: 16,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF7E4D2B),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        'KONFIRMASI PESANAN',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.merriweather(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // Balancing back button
                  ],
                ),
              ),

              // Scrollable screen checkout items
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Section 1: Alamat Pengiriman
                    _buildSectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: Color(0xFF7E4D2B),
                                    size: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'ALAMAT PENGIRIMAN',
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/delivery_address',
                                  ).then((_) {
                                    // Rebuild agar alamat yang baru dipilih langsung tampil
                                    if (mounted) setState(() {});
                                  });
                                },
                                child: Text(
                                  'Kelola Alamat',
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF7E4D2B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.shade100),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  activeAddress.name,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF7E4D2B),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  activeAddress.fullAddress,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: Colors.grey.shade700,
                                    height: 1.4,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Section 2: Katalog Belanja (DINAMIS)
                    _buildSectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'KATALOG BELANJA (${currentCartItems.length} ITEM)',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Looping untuk menampilkan setiap barang dari CartState
                          if (currentCartItems.isEmpty)
                            Text(
                              "Tidak ada barang di keranjang",
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),

                          ...currentCartItems
                              .map(
                                (item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        // Logika untuk membaca gambar lokal maupun internet
                                        child: item.image.startsWith('http')
                                            ? Image.network(
                                                item.image,
                                                width: 48,
                                                height: 48,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.asset(
                                                item.image,
                                                width: 48,
                                                height: 48,
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.name,
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${item.quantity} x ${CartState.formatRupiah(item.price)}',
                                              style: GoogleFonts.inter(
                                                fontSize: 10,
                                                color: Colors.grey.shade500,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        CartState.formatRupiah(
                                          item.price * item.quantity,
                                        ),
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          color: const Color(0xFF7E4D2B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Section 3: Metode Pengiriman
                    _buildSectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.local_shipping,
                                color: Color(0xFF7E4D2B),
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'METODE PENGIRIMAN',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ..._shipOptions.map((ship) {
                            final bool isSelected = _selectedShipId == ship.id;
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedShipId = ship.id),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(
                                          0xFF7E4D2B,
                                        ).withOpacity(0.04)
                                      : Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFF7E4D2B)
                                        : Colors.grey.shade200,
                                    width: 1.2,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        _buildRadioCircle(isSelected),
                                        const SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              ship.name,
                                              style: GoogleFonts.inter(
                                                fontSize: 11.5,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              'Estimasi: ${ship.eta}',
                                              style: GoogleFonts.inter(
                                                fontSize: 9,
                                                color: Colors.grey.shade500,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Text(
                                      CartState.formatRupiah(ship.price),
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF7E4D2B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Section 4: Pilihan Pembayaran
                    _buildSectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.payment,
                                color: Color(0xFF7E4D2B),
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'PILIHAN PEMBAYARAN',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ..._payOptions.map((pay) {
                            final bool isSelected = _selectedPayId == pay.id;
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedPayId = pay.id),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(
                                          0xFF7E4D2B,
                                        ).withOpacity(0.04)
                                      : Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFF7E4D2B)
                                        : Colors.grey.shade200,
                                    width: 1.2,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    _buildRadioCircle(isSelected),
                                    const SizedBox(width: 12),
                                    Text(
                                      pay.icon,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            pay.name,
                                            style: GoogleFonts.inter(
                                              fontSize: 11.5,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            pay.description,
                                            style: GoogleFonts.inter(
                                              fontSize: 9,
                                              color: Colors.grey.shade500,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Section 5: Rincian Pembayaran
                    _buildSectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'RINCIAN PEMBAYARAN',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildReceiptRow('Subtotal Produk', subtotal),
                          _buildReceiptRow(
                            'Biaya Pengiriman (${selectedShip.name})',
                            selectedShip.price,
                          ),
                          _buildReceiptRow(
                            'Biaya Jasa Layanan Aplikasi',
                            serviceFee,
                          ),
                          const Divider(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Belanja',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                CartState.formatRupiah(total),
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: const Color(0xFF7E4D2B),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),

          // Loader overlay while processing payment transaction
          if (_isProcessing)
            Container(
              color: Colors.black.withOpacity(0.6),
              alignment: Alignment.center,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 12,
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF7E4D2B),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Memproses Pembayaran',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Mengamankan transaksi Anda...',
                        style: GoogleFonts.inter(
                          color: Colors.grey.shade600,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Total Pembayaran',
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  CartState.formatRupiah(total),
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF7E4D2B),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7E4D2B),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                onPressed: () => _triggerPayment(total),
                child: Text(
                  'BAYAR SEKARANG',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black.withOpacity(0.04)),
      ),
      child: child,
    );
  }

  Widget _buildRadioCircle(bool isSelected) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? const Color(0xFF7E4D2B) : Colors.grey.shade400,
          width: 2,
        ),
      ),
      alignment: Alignment.center,
      child: isSelected
          ? Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Color(0xFF7E4D2B),
                shape: BoxShape.circle,
              ),
            )
          : null,
    );
  }

  Widget _buildReceiptRow(String title, double val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            CartState.formatRupiah(val),
            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
