import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'order_details_screen.dart';

class FlutterOrder {
  final String id;
  final String orderId;
  final String date;
  final String status; // 'BELUM BAYAR', 'DIPROSES', 'DIKIRIM', 'SELESAI'
  final String productName;
  final String productPrice;
  final String productImage;
  final int quantity;
  final String shippingAddress;
  final String paymentMethod;
  final String shippingCost;
  final String totalPrice;

  const FlutterOrder({
    required this.id,
    required this.orderId,
    required this.date,
    required this.status,
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.quantity,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.shippingCost,
    required this.totalPrice,
  });
}

// Global mock list identical to React implementation
final List<FlutterOrder> mockOrders = [
  const FlutterOrder(
    id: 'o1',
    orderId: '1247850912',
    date: '12 MEI 2026',
    status: 'SELESAI',
    productName: 'LUXURY BAG',
    productPrice: '\$23.16',
    productImage: 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=400',
    quantity: 1,
    shippingAddress: 'JL. KEMANG RAYA NO. 12, JAKARTA SELATAN, DKI JAKARTA 12730',
    paymentMethod: 'M-BANKING (BCA)',
    shippingCost: '\$2.00',
    totalPrice: '\$25.16',
  ),
  const FlutterOrder(
    id: 'o2',
    orderId: '1247851045',
    date: '12 MEI 2026',
    status: 'DIPROSES',
    productName: 'IPHONE 17 PRO MAX',
    productPrice: '\$1.199',
    productImage: 'https://images.unsplash.com/photo-1616348436168-de43ad0db179?w=400',
    quantity: 1,
    shippingAddress: 'JL. KEMANG RAYA NO. 12, JAKARTA SELATAN, DKI JAKARTA 12730',
    paymentMethod: 'COD (BAYAR DI TEMPAT)',
    shippingCost: '\$10.00',
    totalPrice: '\$1.209',
  ),
  const FlutterOrder(
    id: 'o3',
    orderId: '1247851199',
    date: '12 MEI 2026',
    status: 'DIKIRIM',
    productName: 'YAMATO',
    productPrice: '\$23.16',
    productImage: 'https://images.unsplash.com/photo-1615110141027-c17983c9902f?w=400',
    quantity: 1,
    shippingAddress: 'JL. KEMANG RAYA NO. 12, JAKARTA SELATAN, DKI JAKARTA 12730',
    paymentMethod: 'E-WALLET (GOPAY)',
    shippingCost: '\$3.00',
    totalPrice: '\$26.16',
  ),
  const FlutterOrder(
    id: 'o4',
    orderId: '1247851321',
    date: '12 MEI 2026',
    status: 'BELUM BAYAR',
    productName: 'RETRO HELMET',
    productPrice: '\$40.00',
    productImage: 'https://images.unsplash.com/photo-1558981806-ec527fa84c39?w=400',
    quantity: 1,
    shippingAddress: 'JL. KEMANG RAYA NO. 12, JAKARTA SELATAN, DKI JAKARTA 12730',
    paymentMethod: 'M-BANKING (MANDIRI)',
    shippingCost: '\$4.00',
    totalPrice: '\$44.00',
  )
];

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String? _activeFilter; // 'BELUM BAYAR', 'DIPROSES', 'DIKIRIM', 'SELESAI' or null for 'ALL'

  void _toggleFilter(String filter) {
    setState(() {
      if (_activeFilter == filter) {
        _activeFilter = null; // Clear filter to show all
      } else {
        _activeFilter = filter;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _activeFilter == null
        ? mockOrders
        : mockOrders.where((order) => order.status == _activeFilter).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      body: SafeArea(
        child: Column(
          children: [
            // Top Header: Back Arrow, Brand Logo & Page Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                      // Mini representation of central brand logo
                      Image.asset('assets/LOGO.png'),
                      const SizedBox(height: 4),
                      Text(
                        'MY ORDERS',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // White rounded panel containing tabs and orders list
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
                child: Column(
                  children: [
                    // Tabs
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 12.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Color(0xFFF3F4F6), width: 1.0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildTab('BELUM BAYAR', 'Belum Bayar', Icons.hourglass_empty_rounded),
                            _buildTab('DIPROSES', 'Diproses', Icons.settings_outlined),
                            _buildTab('DIKIRIM', 'Dikirim', Icons.local_shipping_outlined),
                            _buildTab('SELESAI', 'Selesai', Icons.check_circle_outline_rounded),
                          ],
                        ),
                      ),
                    ),

                    // Lists of orders
                    Expanded(
                      child: filteredList.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                              physics: const BouncingScrollPhysics(),
                              itemCount: filteredList.length,
                              itemBuilder: (context, index) {
                                return _buildOrderCard(context, filteredList[index]);
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 48,
      height: 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Arch outline
          Positioned(
            bottom: 2,
            child: Container(
              width: 38,
              height: 32,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF7E4D2B), width: 2),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
              ),
            ),
          ),
          // Base shelf line
          Positioned(
            bottom: 1,
            child: Container(
              width: 44,
              height: 2,
              color: const Color(0xFF7E4D2B),
            ),
          ),
          // Flame on top
          Positioned(
            top: 2,
            child: Icon(Icons.local_fire_department, size: 14, color: const Color(0xFF7E4D2B).withOpacity(0.9)),
          ),
          // Bread in basket
          Positioned(
            bottom: 4,
            child: Icon(Icons.shopping_basket_outlined, size: 18, color: const Color(0xFF7E4D2B)),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String filterKey, String label, IconData icon) {
    final isActive = _activeFilter == filterKey;
    return GestureDetector(
      onTap: () => _toggleFilter(filterKey),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF7E4D2B).withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: const Color(0xFF7E4D2B),
            ),
            const SizedBox(height: 6),
            Text(
              label.toUpperCase(),
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 9,
                fontWeight: FontWeight.w900,
                color: isActive ? const Color(0xFF7E4D2B) : Colors.black45,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 48, color: const Color(0xFF7E4D2B).withOpacity(0.35)),
            const SizedBox(height: 12),
            Text(
              'TIDAK ADA PESANAN',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: Colors.black45,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                setState(() {
                  _activeFilter = null;
                });
              },
              child: Text(
                'TAMPILKAN SEMUA',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF7E4D2B),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, FlutterOrder order) {
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

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFD),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF3F4F6), width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header: Order ID & Status Tab badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ORDER ID : ${order.orderId}',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    order.date,
                    style: GoogleFonts.inter(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w900,
                      color: Colors.black45,
                    ),
                  ),
                ],
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
          const SizedBox(height: 12),
          const Divider(color: Color(0xFFF3F4F6), height: 1),
          const SizedBox(height: 12),

          // Product thumbnail + item Name & price row
          Row(
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
                        fontSize: 12.5,
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
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Lihat rincian button
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
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
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'LIHAT RINCIAN',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
