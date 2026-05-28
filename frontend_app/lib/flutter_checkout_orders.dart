import 'package:flutter/material.dart';
import 'dart:math';

// ==========================================
// 1. DATA MODELS & TYPES
// ==========================================

class Product {
  final String id;
  final String name;
  final double price;
  final String category;
  final String description;
  final String image;
  final String storeId;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.description,
    required this.image,
    required this.storeId,
  });
}

class CartItem {
  final String id;
  final String name;
  final double price;
  final String image;
  int quantity;
  final String description;
  final String category;
  final String storeName;
  final double rating;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.quantity,
    this.description = 'Kopi cold brew premium dengan aroma buah manis berkelas, mengekstrak rasa coklat murni yang memikat indera perasa Anda.',
    this.category = 'Makanan & Minuman',
    this.storeName = 'NestMart Official Store',
    this.rating = 4.8,
  });
}

enum OrderStatus { BELUM_BAYAR, DIPROSES, DIKIRIM, SELESAI }

class OrderModel {
  final String id;
  final String orderId;
  final String date;
  OrderStatus status;
  final String productName;
  final String productPrice;
  final String productImage;
  final int quantity;
  final String shippingAddress;
  final String paymentMethod;
  final String shippingCost;
  final String totalPrice;

  OrderModel({
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

class Address {
  final String id;
  final String name;
  final String fullAddress;

  Address({
    required this.id,
    required this.name,
    required this.fullAddress,
  });
}

// Shipping method option model
class ShippingOption {
  final String id;
  final String name;
  final String eta;
  final double price;

  ShippingOption({
    required this.id,
    required this.name,
    required this.eta,
    required this.price,
  });
}

// Payment option model
class PaymentOption {
  final String id;
  final String name;
  final String icon;
  final String description;

  PaymentOption({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
  });
}


// ==========================================
// 2. STATE PROVIDER (SIMPLE DART STATE)
// ==========================================

class AppStateProvider extends ChangeNotifier {
  // Address States
  List<Address> addresses = [
    Address(
      id: '1',
      name: 'HOME ADDRESS',
      fullAddress: 'Jl. Diponegoro No 51, Kecamatan Menteng, Jakarta Pusat, DKI Jakarta 15082',
    ),
    Address(
      id: '2',
      name: 'OFFICE ADDRESS',
      fullAddress: 'Jl. Kebayoran No 41, Kecamatan Kebayoran Baru, Jakarta Selatan, DKI Jakarta 15023',
    ),
  ];
  String selectedAddressId = '1';

  // Cart list
  List<CartItem> cart = [
    CartItem(
      id: 'c1',
      name: 'NESPRESSO COLD BREW',
      price: 23.16,
      image: 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=400',
      quantity: 1,
    ),
  ];

  // Completed Orders
  List<OrderModel> orders = [
    OrderModel(
      id: 'o1',
      orderId: '1247850912',
      date: '12 MEI 2026',
      status: OrderStatus.SELESAI,
      productName: 'LUXURY BAG',
      productPrice: '\$23.16',
      productImage: 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=400',
      quantity: 1,
      shippingAddress: 'JL. KEMANG RAYA NO. 12, JAKARTA SELATAN, DKI JAKARTA 12730',
      paymentMethod: 'M-BANKING (BCA)',
      shippingCost: '\$2.00',
      totalPrice: '\$25.16',
    ),
  ];

  Address get selectedAddress {
    return addresses.firstWhere(
      (a) => a.id == selectedAddressId,
      orElse: () => addresses.first,
    );
  }

  void addOrder(OrderModel order) {
    orders.insert(0, order);
    notifyListeners();
  }

  void clearCart() {
    cart.clear();
    notifyListeners();
  }
}


// ==========================================
// 3. FLUTTER CHECKOUT SCREEN DESIGN
// ==========================================

class FlutterCheckoutPage extends StatefulWidget {
  final AppStateProvider state;
  final Function() onNavigateToOrders;

  const FlutterCheckoutPage({
    Key? key,
    required this.state,
    required this.onNavigateToOrders,
  }) : super(key: key);

  @override
  _FlutterCheckoutPageState createState() => _FlutterCheckoutPageState();
}

class _FlutterCheckoutPageState extends State<FlutterCheckoutPage> {
  final Color primaryColor = const Color(0xFF7E4D2B);
  final Color canvasColor = const Color(0xFFECEAE6);

  final List<ShippingOption> _shipOptions = [
    ShippingOption(id: 'ship1', name: 'J&T Regular', eta: '2-3 Hari', price: 2.0),
    ShippingOption(id: 'ship2', name: 'JNE YES (Yakin Esok Sampai)', eta: '1 Hari', price: 5.0),
    ShippingOption(id: 'ship3', name: 'SiCepat Gokil (Cargo)', eta: '4-6 Hari', price: 1.0),
  ];

  final List<PaymentOption> _payOptions = [
    PaymentOption(id: 'pay1', name: 'M-Banking (BCA)', icon: '🏦', description: 'Transfer Bank Mandiri/BCA/BRI'),
    PaymentOption(id: 'pay2', name: 'E-Wallet (GoPay)', icon: '📱', description: 'Instant pay dengan GoPay / OVO'),
    PaymentOption(id: 'pay3', name: 'Cod (Bayar di Tempat)', icon: '💵', description: 'Bayar tunai kurir saat sampai'),
  ];

  String _selectedShipId = 'ship1';
  String _selectedPayId = 'pay1';
  bool _isProcessing = false;

  void _showProductDetailsBottomSheet(BuildContext context, CartItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          padding: const EdgeInsets.only(top: 16, left: 24, right: 24, bottom: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Center drag handle accent line
              Center(
                child: Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Product Header details Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      item.image,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item.category.toUpperCase(),
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              '${item.rating}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              
              // Seller Store Card Info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '🏪',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                item.storeName,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.verified,
                                color: Colors.blue,
                                size: 14,
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Official Partner Store • Jaminan 100% Original',
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // Description Header
              const Text(
                'DESKRIPSI PRODUK',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 8),
              
              // Description Paragraph body text
              Text(
                item.description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              
              // Summary Price Label & Dismiss Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Harga Satuan',
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '\$${item.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'TUTUP',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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
    // Math computations
    double subtotal = widget.state.cart.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
    ShippingOption selectedShip = _shipOptions.firstWhere((s) => s.id == _selectedShipId);
    PaymentOption selectedPay = _payOptions.firstWhere((p) => p.id == _selectedPayId);
    double serviceFee = 1.0;
    double total = subtotal + selectedShip.price + serviceFee;

    return Scaffold(
      backgroundColor: canvasColor,
      body: Stack(
        children: [
          Column(
            children: [
              // Custom Rounded Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 50, bottom: 24, left: 16, right: 16),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'KONFIRMASI PESANAN',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // Spacer to balance back button
                  ],
                ),
              ),

              // Scrollable Body Content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // 1. Delivery Address Card
                    _buildSectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.location_on, color: primaryColor, size: 18),
                                  const SizedBox(width: 6),
                                  const Text(
                                    'ALAMAT PENGIRIMAN',
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.extrabold, color: Colors.grey),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Navigate to delivery address modifier
                                },
                                child: Text(
                                  'Ubah Alamat',
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: primaryColor),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.state.selectedAddress.name,
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.state.selectedAddress.fullAddress,
                                  style: TextStyle(fontSize: 11, color: Colors.grey.shade700, height: 1.4),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 2. Shopping Catalogue Card
                    _buildSectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'KATALOG BELANJA (${widget.state.cart.length} Item)',
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.extrabold, color: Colors.grey),
                          ),
                          const SizedBox(height: 12),
                          ...widget.state.cart.map((item) => GestureDetector(
                            onTap: () => _showProductDetailsBottomSheet(context, item),
                            behavior: HitTestBehavior.opaque,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      item.image,
                                      width: 48,
                                      height: 48,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          style: const TextStyle(
                                            fontSize: 12, 
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.underline,
                                            decorationColor: Colors.black26,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${item.quantity} x \$${item.price.toStringAsFixed(2)}',
                                          style: const TextStyle(fontSize: 10, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryColor),
                                  )
                                ],
                              ),
                            ),
                          )).toList(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 3. Shipping Method Picker Card
                    _buildSectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.local_shipping, color: primaryColor, size: 18),
                              const SizedBox(width: 6),
                              const Text(
                                'METODE PENGIRIMAN',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.extrabold, color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ..._shipOptions.map((ship) {
                            bool isSelected = _selectedShipId == ship.id;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedShipId = ship.id),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isSelected ? primaryColor.withOpacity(0.04) : Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected ? primaryColor : Colors.grey.shade200,
                                    width: 1.2,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        _buildRadioCircle(isSelected),
                                        const SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              ship.name,
                                              style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              'Estimasi: ${ship.eta}',
                                              style: const TextStyle(fontSize: 9, color: Colors.grey),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Text(
                                      '\$${ship.price.toStringAsFixed(2)}',
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryColor),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 4. Payment Method Card
                    _buildSectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.payment, color: primaryColor, size: 18),
                              const SizedBox(width: 6),
                              const Text(
                                'PILIHAN PEMBAYARAN',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.extrabold, color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ..._payOptions.map((pay) {
                            bool isSelected = _selectedPayId == pay.id;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedPayId = pay.id),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isSelected ? primaryColor.withOpacity(0.04) : Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected ? primaryColor : Colors.grey.shade200,
                                    width: 1.2,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    _buildRadioCircle(isSelected),
                                    const SizedBox(width: 12),
                                    Text(pay.icon, style: const TextStyle(fontSize: 18)),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            pay.name,
                                            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            pay.description,
                                            style: const TextStyle(fontSize: 9, color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 5. Receipt Calculation Card
                    _buildSectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'RINCIAN PEMBAYARAN',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.extrabold, color: Colors.grey),
                          ),
                          const SizedBox(height: 12),
                          _buildReceiptRow('Subtotal Produk', subtotal),
                          _buildReceiptRow('Biaya Pengiriman (${selectedShip.name})', selectedShip.price),
                          _buildReceiptRow('Biaya Jasa Layanan Aplikasi', serviceFee),
                          const Divider(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Belanja', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              Text(
                                '\$${total.toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.black, color: primaryColor),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 12), // Safe padding at list-end
                  ],
                ),
              ),
            ],
          ),

          // Async Payment Loading Processing state
          if (_isProcessing)
            Container(
              color: Colors.black.withOpacity(0.6),
              alignment: Alignment.center,
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                elevation: 12,
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(primaryColor)),
                      const SizedBox(height: 20),
                      const Text(
                        'Memproses Pembayaran',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Mengamankan transaksi Anda...',
                        style: TextStyle(color: Colors.grey, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
            )
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(horizontal: 20, vertical: 16, bottom: 24),
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
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Total Pembayaran', style: TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.black, color: primaryColor),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                onPressed: _triggerPayment,
                child: const Text(
                  'BAYAR SEKARANG',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.black, color: Colors.white, letterSpacing: 0.5),
                ),
              ),
            )
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
          color: isSelected ? primaryColor : Colors.grey.shade400,
          width: 2,
        ),
      ),
      alignment: Alignment.center,
      child: isSelected
          ? Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
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
          Text(title, style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
          Text('\$${val.toStringAsFixed(2)}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _triggerPayment() {
    if (widget.state.cart.isEmpty) return;

    setState(() => _isProcessing = true);

    // Simulate standard transaction clearing latency
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isProcessing = false);

      // UBAHAN BARU: Menggabungkan dua angka acak 5-digit agar menghasilkan 10-digit tanpa melampaui batas 2^32 dari nextInt() di Dart
      final part1 = 10000 + Random().nextInt(90000);
      final part2 = 10000 + Random().nextInt(90000);
      final orderId = '$part1$part2';

      double subTotal = widget.state.cart.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
      ShippingOption ship = _shipOptions.firstWhere((s) => s.id == _selectedShipId);
      PaymentOption pay = _payOptions.firstWhere((p) => p.id == _selectedPayId);
      double total = subTotal + ship.price + 1.0;

      // UBAHAN BARU: Loop over each cart item and create separate orders so they all update in the "Diproses" page
      OrderModel? firstOrder;
      for (int i = 0; i < widget.state.cart.length; i++) {
        final item = widget.state.cart[i];
        OrderModel newOrder = OrderModel(
          id: 'ord_${DateTime.now().millisecondsSinceEpoch}_$i',
          orderId: orderId,
          date: DateTime.now().toLocal().toString().split(' ')[0].toUpperCase(),
          status: OrderStatus.DIPROSES, // Automatically set status direct to Diproses
          productName: item.name,
          productPrice: '\$${item.price.toStringAsFixed(2)}',
          productImage: item.image,
          quantity: item.quantity,
          shippingAddress: widget.state.selectedAddress.fullAddress,
          paymentMethod: pay.name,
          shippingCost: '\$${ship.price.toStringAsFixed(2)}',
          totalPrice: '\$${total.toStringAsFixed(2)}',
        );

        if (firstOrder == null) {
          firstOrder = newOrder;
        }
        widget.state.addOrder(newOrder);
      }

      widget.state.clearCart();

      // Show Awesome Success Modal pop-up using first order details (total is shared)
      if (firstOrder != null) {
        _showSuccessDialog(firstOrder);
      }
    });
  }

  void _showSuccessDialog(OrderModel order) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              const Icon(Icons.check_circle, color: Colors.green, size: 64),
              const SizedBox(height: 16),
              const Text(
                'Pembayaran Berhasil!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                'Pesanan Anda dikonfirmasi & langsung masuk status "Diproses".',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 11, height: 1.4),
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
                        const Text('ORDER ID', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                        Text('#${order.orderId}', style: const TextStyle(fontSize: 10, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('TOTAL BAYAR', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        Text(order.totalPrice, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryColor)),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx); // close dialog
                    widget.onNavigateToOrders(); // go straight to Orders tab
                  },
                  child: const Text('PANTAU PESANAN SAYA', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
