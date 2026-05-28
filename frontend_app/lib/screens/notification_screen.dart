import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'orders_screen.dart'; // To access FlutterOrder and mockOrders
import 'order_details_screen.dart'; // To access OrderDetailsScreen

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Filter orders that are in the successful payment 'DIPROSES' stage
    final processedOrders = mockOrders.where((order) => order.status == 'DIPROSES').toList();

    return Scaffold(
      backgroundColor: const Color(0xFFECEAE6), // Matching beige cream background
      body: SafeArea(
        child: Column(
          children: [
            // Custom Custom Header/App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Navigator.canPop(context)
                        ? IconButton(
                            icon: const Icon(Icons.chevron_left, size: 32, color: Color(0xFF7E4D2B)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        : null,
                  ),
                  Text(
                    'NOTIFIKASI',
                    style: GoogleFonts.merriweather(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Notification Screen Body
            Expanded(
              child: processedOrders.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.notifications_none_rounded,
                              size: 64,
                              color: Color(0xFF7E4D2B),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Belum Ada Notifikasi',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Transaksi pembayaran dan status pesanan baru\nakan muncul di sini.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: Colors.black54,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                      itemCount: processedOrders.length,
                      itemBuilder: (context, index) {
                        final order = processedOrders[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                            border: Border.all(
                              color: const Color(0xFF7E4D2B).withOpacity(0.05),
                            ),
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Success Badge Row
                              Row(
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFE8F5E9),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check_circle_rounded,
                                      color: Color(0xFF2E7D32),
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'PEMBAYARAN BERHASIL!',
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w900,
                                            color: const Color(0xFF2E7D32),
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Status: Diproses',
                                          style: GoogleFonts.inter(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black45,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    order.date,
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black45,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Text Message
                              RichText(
                                text: TextSpan(
                                  style: GoogleFonts.inter(
                                    fontSize: 12.5,
                                    color: Colors.black,
                                    height: 1.5,
                                  ),
                                  children: [
                                    const TextSpan(text: 'Pembayaran untuk produk '),
                                    TextSpan(
                                      text: order.productName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const TextSpan(text: ' sebesar '),
                                    TextSpan(
                                      text: order.productPrice,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF7E4D2B),
                                      ),
                                    ),
                                    const TextSpan(text: ' telah kami terima dan pesanan Anda kini masuk ke tahap '),
                                    const TextSpan(
                                      text: '"Diproses"',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF2E7D32),
                                      ),
                                    ),
                                    const TextSpan(text: '.'),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Mini Product Preview & Action Item
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF9F9F9),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.black.withOpacity(0.02),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        image: DecorationImage(
                                          image: NetworkImage(order.productImage),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Order ID',
                                            style: GoogleFonts.inter(
                                              fontSize: 9.5,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black38,
                                            ),
                                          ),
                                          Text(
                                            '#${order.orderId}',
                                            style: GoogleFonts.inter(
                                              fontSize: 11.5,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => OrderDetailsScreen(order: order),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF7E4D2B),
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                      ),
                                      child: Text(
                                        'PANTAU',
                                        style: GoogleFonts.inter(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
