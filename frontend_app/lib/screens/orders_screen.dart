import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
// Import OrderDetailsScreen dengan 'show' untuk menghindari konflik import
import 'order_details_screen.dart' show OrderDetailsScreen;

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

List<FlutterOrder> mockOrders = [];

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String? _activeFilter;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    setState(() => _loading = true);
    try {
      final res = await ApiService.instance.getOrders();
      final orders = res is List
          ? res
          : (res is Map && res['data'] is List ? res['data'] as List : []);

      if (orders.isNotEmpty) {
        mockOrders = orders.map((item) {
          final items = item['items'] as List? ?? [];
          final firstProd = items.isNotEmpty ? items.first['product'] : null;
          return FlutterOrder(
            id: item['id'].toString(),
            orderId: 'ORD-#${item['id']}',
            date: item['createdAt'] != null ? item['createdAt'].toString().substring(0, 10) : '2026-06-29',
            status: item['status'] ?? 'DIPROSES',
            productName: firstProd != null ? firstProd['name'] ?? 'Produk NestMart' : 'Pesanan NestMart',
            productPrice: firstProd != null ? 'Rp ${firstProd['price']}' : 'Rp 0',
            productImage: firstProd != null ? firstProd['image'] ?? '' : '',
            quantity: items.isNotEmpty ? items.first['quantity'] ?? 1 : 1,
            shippingAddress: item['shippingAddress'] ?? 'Alamat Pengiriman',
            paymentMethod: item['paymentMethod'] ?? 'Transfer Bank',
            shippingCost: 'Rp 10.000',
            totalPrice: 'Rp ${item['total'] ?? item['totalPrice'] ?? 0}',
          );
        }).toList();
      }
    } catch (e) {
      debugPrint('Error fetching orders: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _toggleFilter(String filter) {
    setState(() {
      _activeFilter = (_activeFilter == filter) ? null : filter;
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
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
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
                        color: Color(0xFF7E4D2B),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/LOGO.png', height: 170),
                      const SizedBox(height: 4),
                      Text(
                        'PESANAN SAYA',
                        style: GoogleFonts.merriweather(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                          color: const Color(0xFF7E4D2B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildTab(
                            'BELUM BAYAR',
                            'Belum Bayar',
                            Icons.hourglass_empty_rounded,
                          ),
                          _buildTab(
                            'DIPROSES',
                            'Diproses',
                            Icons.settings_outlined,
                          ),
                          _buildTab(
                            'DIKIRIM',
                            'Dikirim',
                            Icons.local_shipping_outlined,
                          ),
                          _buildTab(
                            'SELESAI',
                            'Selesai',
                            Icons.check_circle_outline_rounded,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: filteredList.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 12.0,
                              ),
                              physics: const BouncingScrollPhysics(),
                              itemCount: filteredList.length,
                              itemBuilder: (context, index) =>
                                  _buildOrderCard(context, filteredList[index]),
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

  Widget _buildTab(String filterKey, String label, IconData icon) {
    final isActive = _activeFilter == filterKey;
    return GestureDetector(
      onTap: () => _toggleFilter(filterKey),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF7E4D2B).withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 24, color: const Color(0xFF7E4D2B)),
            const SizedBox(height: 6),
            Text(
              label.toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 9,
                fontWeight: FontWeight.w900,
                color: isActive ? const Color(0xFF7E4D2B) : Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 48,
            color: const Color(0xFF7E4D2B).withValues(alpha: 0.35),
          ),
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
          TextButton(
            onPressed: () => setState(() => _activeFilter = null),
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
    );
  }

  Widget _buildOrderCard(BuildContext context, FlutterOrder order) {
    Color badgeColor = (order.status == 'SELESAI')
        ? const Color(0xFF7E4D2B)
        : (order.status == 'DIKIRIM'
              ? const Color(0xFFB07D53)
              : (order.status == 'DIPROSES'
                    ? const Color(0xFF915B35)
                    : const Color(0xFFD97706)));
    String badgeText = (order.status == 'DIPROSES') ? 'DIKEMAS' : order.status;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFD),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Column(
        children: [
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
                    ),
                  ),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
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
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    // Logika untuk menampilkan gambar dari Checkout (Mendukung link/aset lokal)
                    image: order.productImage.startsWith('http')
                        ? NetworkImage(order.productImage) as ImageProvider
                        : AssetImage(order.productImage),
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
                      order.productName, // Nama produk dari checkout
                      style: GoogleFonts.poppins(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      order.productPrice, // Harga produk dari checkout
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
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderDetailsScreen(order: order),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7E4D2B),
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
