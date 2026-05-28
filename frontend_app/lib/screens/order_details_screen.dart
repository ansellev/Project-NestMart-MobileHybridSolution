import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'orders_screen.dart'; // import to access FlutterOrder model definition
import '../favorites_state.dart';

class OrderDetailsScreen extends StatelessWidget {
  final FlutterOrder order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    String badgeText = order.status;

    if (order.status == 'SELESAI') {
      badgeColor = const Color(0xFF7E4D2B);
    } else if (order.status == 'DIKIRIM') {
      badgeColor = const Color(0xFFB07D53);
    } else if (order.status == 'DIPROSES') {
      badgeColor = const Color(0xFF915B35);
      badgeText = 'DIKEMAS';
    } else {
      badgeColor = const Color(0xFFD97706);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      body: SafeArea(
        child: Column(
          children: [
            // Top Header: Back Arrow & Page Title & Subtitle ID
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.chevron_left, size: 32, color: Color(0xFF7E4D2B)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'RINCIAN PESANAN',
                        style: GoogleFonts.merriweather(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'ID: #${order.orderId}',
                        style: GoogleFonts.inter(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w900,
                          color: Colors.black45,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // White rounded details panel
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
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      // 1. Status Progress Tracker Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7E4D2B).withOpacity(0.03),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFF7E4D2B).withOpacity(0.1)),
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
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black45,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: badgeColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    badgeText,
                                    style: GoogleFonts.inter(
                                      fontSize: 8.5,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            
                            // Horizontal timeline steps matching React
                            Row(
                              children: [
                                _buildTimelineStep('Belum Bayar', true, 1),
                                _buildTimelineLine(order.status != 'BELUM BAYAR'),
                                _buildTimelineStep('Dikemas', order.status != 'BELUM BAYAR', 2),
                                _buildTimelineLine(order.status == 'DIKIRIM' || order.status == 'SELESAI'),
                                _buildTimelineStep('Dikirim', order.status == 'DIKIRIM' || order.status == 'SELESAI', 3),
                                _buildTimelineLine(order.status == 'SELESAI'),
                                _buildTimelineStep('Selesai', order.status == 'SELESAI', 4),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 2. Produk Terkait
                      Text(
                        'PRODUK TERKAIT',
                        style: GoogleFonts.poppins(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 8),

                      GestureDetector(
                        onTap: () {
                          // Mencari data produk yang sesuai berdasarkan nama produk di rincian pesanan
                          final product = FavoritesState.getProductByOrderName(order.productName);
                          // Navigasi ke halaman detail produk dengan menyertakan argumen yang diperlukan
                          Navigator.pushNamed(
                            context,
                            '/product',
                            arguments: {
                              'id': product.id,
                              'name': product.name,
                              'price': product.price,
                              'rating': FavoritesState.getProductAverageRating(product.id).toString(),
                              'image': product.image,
                              'description': product.description,
                              'canReview': order.status == 'SELESAI',
                            },
                          );
                        },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDFDFD),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFFF3F4F6)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                border: Border.all(color: const Color(0xFFF3F4F6)),
                                borderRadius: BorderRadius.circular(16),
                                image: DecorationImage(
                                  image: NetworkImage(order.productImage),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    order.productName,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    order.productPrice,
                                    style: GoogleFonts.inter(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w900,
                                      color: const Color(0xFF7E4D2B),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Kuantitas: ${order.quantity}x',
                                    style: GoogleFonts.inter(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (order.status == 'SELESAI') ...[
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 38,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              final product = FavoritesState.getProductByOrderName(order.productName);
                              Navigator.pushNamed(
                                context,
                                '/product',
                                arguments: {
                                  'id': product.id,
                                  'name': product.name,
                                  'price': product.price,
                                  'rating': FavoritesState.getProductAverageRating(product.id).toString(),
                                  'image': product.image,
                                  'description': product.description,
                                  'canReview': true,
                                },
                              );
                            },
                            icon: const Icon(Icons.rate_review_rounded, size: 16, color: Colors.white),
                            label: Text(
                              'BERI ULASAN SEKARANG',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF7E4D2B),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),

                      // 3. Alamat Pengiriman
                      Text(
                        'ALAMAT PENGIRIMAN',
                        style: GoogleFonts.poppins(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDFDFD),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFFF3F4F6)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.location_on_outlined, size: 22, color: Color(0xFF7E4D2B)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ALAMAT',
                                    style: GoogleFonts.inter(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black38,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    order.shippingAddress,
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black87,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 4. Informasi Pembayaran
                      Text(
                        'INFORMASI PEMBAYARAN',
                        style: GoogleFonts.poppins(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDFDFD),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFFF3F4F6)),
                        ),
                        child: Column(
                          children: [
                            _buildBillRow('Metode Pembayaran', order.paymentMethod, isHighlight: false),
                            const SizedBox(height: 12),
                            const Divider(color: Color(0xFFF3F4F6), height: 1),
                            const SizedBox(height: 12),
                            _buildBillRow('Harga Produk', order.productPrice, isHighlight: false),
                            const SizedBox(height: 8),
                            _buildBillRow('Biaya Pengiriman', order.shippingCost, isHighlight: false),
                            const SizedBox(height: 12),
                            const Divider(color: Color(0xFFF3F4F6), height: 1),
                            const SizedBox(height: 12),
                            _buildBillRow('Total Pembayaran', order.totalPrice, isHighlight: true),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Kembali ke Daftar Pesanan button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF7E4D2B), width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'KEMBALI KE DAFTAR PESANAN',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF7E4D2B),
                              letterSpacing: 1.0,
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

  Widget _buildTimelineStep(String label, bool active, int stepNumber) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: active ? const Color(0xFF7E4D2B) : const Color(0xFFE5E7EB),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$stepNumber',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: active ? Colors.white : Colors.black45,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 8,
                fontWeight: FontWeight.w900,
                color: active ? const Color(0xFF7E4D2B) : Colors.black38,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineLine(bool active) {
    return Container(
      width: 20,
      height: 2,
      margin: const EdgeInsets.only(bottom: 12),
      color: active ? const Color(0xFF7E4D2B) : const Color(0xFFE5E7EB),
    );
  }

  Widget _buildBillRow(String label, String value, {required bool isHighlight}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.inter(
            fontSize: 9.5,
            fontWeight: FontWeight.w900,
            color: isHighlight ? Colors.black : Colors.black45,
            letterSpacing: 0.2,
          ),
        ),
        Text(
          value.toUpperCase(),
          style: GoogleFonts.inter(
            fontSize: isHighlight ? 12.5 : 10.5,
            fontWeight: FontWeight.w900,
            color: isHighlight ? const Color(0xFF7E4D2B) : Colors.black87,
          ),
        ),
      ],
    );
  }
}
