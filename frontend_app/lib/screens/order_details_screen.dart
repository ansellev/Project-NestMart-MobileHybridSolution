import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'orders_screen.dart'; // Akses model FlutterOrder

class OrderDetailsScreen extends StatelessWidget {
  final FlutterOrder order;

  // Tema Warna Cokelat Nestmart
  static const Color primaryBrown = Color(0xFF7E4D2B);
  static const Color bgLightBrown = Color(0xFFF8F6F4); // Warna background krem

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    String badgeText = order.status;

    // Gradasi warna untuk status pesanan
    if (order.status == 'SELESAI') {
      badgeColor = primaryBrown;
    } else if (order.status == 'DIKIRIM') {
      badgeColor = const Color(0xFFA67C5B);
    } else if (order.status == 'DIPROSES') {
      badgeColor = const Color(0xFFC49A7A);
      badgeText = 'DIKEMAS';
    } else {
      badgeColor = const Color(0xFFD97706); // Oranye tetap untuk peringatan
    }

    return Scaffold(
      backgroundColor: bgLightBrown,
      body: SafeArea(
        child: Column(
          children: [
            // Top Header: Back Arrow & Page Title
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(
                        Icons.chevron_left,
                        size: 32,
                        color: primaryBrown,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'RINCIAN PESANAN',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ID: #${order.orderId}',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status Tracker
                      _buildStatusCard(badgeColor, badgeText, order.status),
                      const SizedBox(height: 28),

                      // Produk Terkait
                      _buildSectionTitle('PRODUK TERKAIT'),
                      const SizedBox(height: 12),
                      _buildProductCard(order),
                      const SizedBox(height: 24),

                      // Alamat Pengiriman
                      _buildSectionTitle('ALAMAT PENGIRIMAN'),
                      const SizedBox(height: 12),
                      _buildAddressCard(order),
                      const SizedBox(height: 24),

                      // Informasi Pembayaran
                      _buildSectionTitle('INFORMASI PEMBAYARAN'),
                      const SizedBox(height: 12),
                      _buildPaymentCard(order),
                      const SizedBox(height: 32),

                      // Tombol Kembali
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: primaryBrown,
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'KEMBALI KE DAFTAR PESANAN',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              color: primaryBrown,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(Color color, String text, String status) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryBrown.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: primaryBrown.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Status Pesanan',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.black45,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  text,
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Timeline Sederhana
          Row(
            children: [
              _buildStep('Bayar', status != 'BELUM BAYAR', 1),
              _buildLine(status != 'BELUM BAYAR'),
              _buildStep('Kemas', status != 'BELUM BAYAR', 2),
              _buildLine(status == 'DIKIRIM' || status == 'SELESAI'),
              _buildStep(
                'Kirim',
                status == 'DIKIRIM' || status == 'SELESAI',
                3,
              ),
              _buildLine(status == 'SELESAI'),
              _buildStep('Selesai', status == 'SELESAI', 4),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep(String label, bool active, int num) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: active ? primaryBrown : Colors.black12,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$num',
              style: TextStyle(
                fontSize: 10,
                color: active ? Colors.white : Colors.black45,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 8,
            fontWeight: FontWeight.w900,
            color: active ? primaryBrown : Colors.black38,
          ),
        ),
      ],
    );
  }

  Widget _buildLine(bool active) => Expanded(
    child: Container(
      height: 2,
      color: active ? primaryBrown : Colors.black12,
      margin: const EdgeInsets.only(bottom: 18),
    ),
  );

  Widget _buildSectionTitle(String title) => Text(
    title,
    style: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w900,
      color: primaryBrown,
      letterSpacing: 1.0,
    ),
  );

  Widget _buildProductCard(FlutterOrder order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: NetworkImage(order.productImage),
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
                  order.productName,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
                Text(
                  order.productPrice,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w900,
                    color: primaryBrown,
                  ),
                ),
                Text(
                  'Kuantitas: ${order.quantity}x',
                  style: GoogleFonts.inter(fontSize: 10, color: Colors.black45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(FlutterOrder order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined, color: primaryBrown),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              order.shippingAddress,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(FlutterOrder order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Column(
        children: [
          _rowBill('Metode', order.paymentMethod),
          const Divider(height: 24),
          _rowBill('Produk', order.productPrice),
          _rowBill('Ongkir', order.shippingCost),
          const Divider(height: 24),
          _rowBill('TOTAL', order.totalPrice, isTotal: true),
        ],
      ),
    );
  }

  Widget _rowBill(String label, String val, {bool isTotal = false}) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: GoogleFonts.inter(fontSize: 10, color: Colors.black45),
      ),
      Text(
        val,
        style: GoogleFonts.inter(
          fontSize: isTotal ? 14 : 11,
          fontWeight: FontWeight.w900,
          color: isTotal ? primaryBrown : Colors.black87,
        ),
      ),
    ],
  );
}
