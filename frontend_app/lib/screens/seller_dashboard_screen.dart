import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../seller_state.dart';
import 'models.dart';

class SellerDashboardScreen extends StatefulWidget {
  const SellerDashboardScreen({super.key});

  @override
  State<SellerDashboardScreen> createState() => _SellerDashboardScreenState();
}

class _SellerDashboardScreenState extends State<SellerDashboardScreen> {
  static const _primary = Color(0xFF7E4D2B);
  static const _dark = Color(0xFF4A2C18);
  static const _bg = Color(0xFFECEAE6);

  int _tab = 0;
  String? _orderFilter; // null = Semua

  // ──────────────────────────────────────────────────────────
  // BUILD & NAV
  // ──────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: _tab,
          children: [
            _berandaTab(),
            _produkTab(),
            _pesananTab(),
            _tokoTab(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 76,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 16,
              offset: const Offset(0, -4)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navItem(Icons.dashboard_outlined, Icons.dashboard_rounded,
              'Beranda', 0),
          _navItem(Icons.inventory_2_outlined, Icons.inventory_2_rounded,
              'Produk', 1),
          _navItem(Icons.receipt_long_outlined, Icons.receipt_long_rounded,
              'Pesanan', 2),
          _navItem(Icons.storefront_outlined, Icons.storefront_rounded,
              'Toko', 3),
        ],
      ),
    );
  }

  Widget _navItem(
      IconData off, IconData on, String label, int idx) {
    final active = _tab == idx;
    return GestureDetector(
      onTap: () => setState(() => _tab = idx),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(active ? on : off,
                color: active ? _primary : Colors.black38, size: 24),
            const SizedBox(height: 4),
            Text(label,
                style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight:
                        active ? FontWeight.w800 : FontWeight.w600,
                    color: active ? _primary : Colors.black38)),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // TAB 0 — BERANDA
  // ──────────────────────────────────────────────────────────

  Widget _berandaTab() {
    final seller = SellerState();
    return ValueListenableBuilder<List<SellerProduct>>(
      valueListenable: SellerState.products,
      builder: (_, products, __) =>
          ValueListenableBuilder<List<SellerOrder>>(
        valueListenable: SellerState.orders,
        builder: (_, orders, __) {
          final newCount =
              orders.where((o) => o.status == 'BARU').length;
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _berandaHeader(seller),

                // Stat cards — float over header via Transform
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Transform.translate(
                    offset: const Offset(0, -22),
                    child: Row(children: [
                      Expanded(
                          child: _statCard(
                              'Produk',
                              products.length.toString(),
                              Icons.inventory_2_outlined)),
                      const SizedBox(width: 10),
                      Expanded(
                          child: _statCard(
                              'Pesanan',
                              orders.length.toString(),
                              Icons.receipt_long_outlined)),
                      const SizedBox(width: 10),
                      Expanded(
                          child: _statCard(
                              'Baru',
                              newCount.toString(),
                              Icons.fiber_new_rounded,
                              highlight: newCount > 0)),
                    ]),
                  ),
                ),

                // Body content
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Revenue card
                      _revenueCard(SellerState.totalRevenue),
                      const SizedBox(height: 24),

                      // Quick actions
                      _sectionTitle('Aksi Cepat'),
                      const SizedBox(height: 12),
                      Row(children: [
                        Expanded(
                            child: _quickAction(
                                Icons.add_box_outlined,
                                'Tambah Produk',
                                () => _showProductForm(null))),
                        const SizedBox(width: 12),
                        Expanded(
                            child: _quickAction(
                                Icons.receipt_long_outlined,
                                'Lihat Pesanan',
                                () => setState(() => _tab = 2))),
                      ]),
                      const SizedBox(height: 24),

                      // Recent orders
                      _sectionTitle('Pesanan Terbaru'),
                      const SizedBox(height: 12),
                      if (orders.isEmpty)
                        _emptyHint('Belum ada pesanan masuk',
                            Icons.receipt_long_outlined)
                      else
                        ...orders
                            .take(3)
                            .map((o) => _orderCard(o)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _berandaHeader(SellerState seller) {
    return Container(
      decoration: const BoxDecoration(
        color: _primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 52),
      child: Row(
        children: [
          // Store avatar
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: Colors.white.withOpacity(0.4), width: 2),
              color: Colors.white.withOpacity(0.1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: seller.storeImage.isNotEmpty
                  ? Image.network(seller.storeImage,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                          Icons.storefront_rounded,
                          color: Colors.white,
                          size: 24))
                  : const Icon(Icons.storefront_rounded,
                      color: Colors.white, size: 24),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(seller.storeName,
                    style: GoogleFonts.merriweather(
                        fontWeight: FontWeight.w900,
                        fontSize: 17,
                        color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(seller.storeCategory,
                    style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon,
      {bool highlight = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: highlight ? _primary : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Icon(icon,
              color: highlight ? Colors.white70 : _primary, size: 20),
          const SizedBox(height: 5),
          Text(value,
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  color: highlight ? Colors.white : Colors.black87)),
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: highlight ? Colors.white70 : Colors.black45)),
        ],
      ),
    );
  }

  Widget _revenueCard(double revenue) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _dark,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: _dark.withOpacity(0.35),
              blurRadius: 14,
              offset: const Offset(0, 6)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Pendapatan',
                    style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.white60,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                Text(SellerState.formatRupiah(revenue),
                    style: GoogleFonts.merriweather(
                        fontWeight: FontWeight.w900,
                        fontSize: 22,
                        color: Colors.white)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.account_balance_wallet_outlined,
                color: Colors.white, size: 28),
          ),
        ],
      ),
    );
  }

  Widget _quickAction(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 3)),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF3EBE6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: _primary, size: 22),
            ),
            const SizedBox(height: 8),
            Text(label,
                style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87)),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // TAB 1 — PRODUK
  // ──────────────────────────────────────────────────────────

  Widget _produkTab() {
    return ValueListenableBuilder<List<SellerProduct>>(
      valueListenable: SellerState.products,
      builder: (_, products, __) {
        return Column(
          children: [
            // Header row
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Produk Saya',
                          style: GoogleFonts.merriweather(
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                              color: Colors.black87)),
                      Text('${products.length} produk',
                          style: GoogleFonts.inter(
                              fontSize: 13,
                              color: Colors.black45,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => _showProductForm(null),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: _primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.add_rounded,
                              color: Colors.white, size: 18),
                          const SizedBox(width: 5),
                          Text('Tambah',
                              style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // List or empty state
            Expanded(
              child: products.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inventory_2_outlined,
                              size: 80, color: Colors.grey.shade300),
                          const SizedBox(height: 18),
                          Text('Belum ada produk',
                              style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black54)),
                          const SizedBox(height: 8),
                          Text('Mulai tambahkan produkmu',
                              style: GoogleFonts.inter(
                                  fontSize: 13, color: Colors.black38)),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () => _showProductForm(null),
                            icon: const Icon(Icons.add_rounded),
                            label: const Text('Tambah Produk Pertama'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                              elevation: 0,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                      physics: const BouncingScrollPhysics(),
                      itemCount: products.length,
                      itemBuilder: (_, i) =>
                          _productManageCard(products[i]),
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _productManageCard(SellerProduct p) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          // Product image
          Container(
            width: 74,
            height: 74,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: const Color(0xFFF6F4F2)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(p.image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(
                      Icons.image_outlined,
                      color: Colors.black26,
                      size: 30)),
            ),
          ),
          const SizedBox(width: 14),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.name,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: Colors.black87),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 3),
                Text(p.description,
                    style: GoogleFonts.inter(
                        fontSize: 12, color: Colors.black38),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Text(p.price,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        color: _primary)),
              ],
            ),
          ),
          // Action buttons
          Column(
            children: [
              _iconBtn(Icons.edit_outlined, const Color(0xFFF3EBE6),
                  _primary, () => _showProductForm(p)),
              const SizedBox(height: 8),
              _iconBtn(Icons.delete_outline_rounded,
                  const Color(0xFFFFF2F2), Colors.redAccent,
                  () => _confirmDelete(p)),
            ],
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // TAB 2 — PESANAN
  // ──────────────────────────────────────────────────────────

  Widget _pesananTab() {
    return ValueListenableBuilder<List<SellerOrder>>(
      valueListenable: SellerState.orders,
      builder: (_, orders, __) {
        final filtered = _orderFilter == null
            ? orders
            : orders.where((o) => o.status == _orderFilter).toList();

        return Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pesanan Masuk',
                      style: GoogleFonts.merriweather(
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                          color: Colors.black87)),
                  Text('${orders.length} total pesanan',
                      style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.black45,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),

            // Status filter chips
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                physics: const BouncingScrollPhysics(),
                children: [
                  _filterChip('Semua', null),
                  _filterChip('BARU', 'BARU'),
                  _filterChip('DIPROSES', 'DIPROSES'),
                  _filterChip('DIKIRIM', 'DIKIRIM'),
                  _filterChip('SELESAI', 'SELESAI'),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Order list or empty
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.receipt_long_outlined,
                              size: 80, color: Colors.grey.shade300),
                          const SizedBox(height: 16),
                          Text('Tidak ada pesanan',
                              style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black45)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                      physics: const BouncingScrollPhysics(),
                      itemCount: filtered.length,
                      itemBuilder: (_, i) =>
                          _orderCard(filtered[i], showActions: true),
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _filterChip(String label, String? filter) {
    final active = _orderFilter == filter;
    return GestureDetector(
      onTap: () => setState(() => _orderFilter = filter),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? _primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 5,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Text(label,
            style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: active ? Colors.white : Colors.black54)),
      ),
    );
  }

  Widget _orderCard(SellerOrder o, {bool showActions = false}) {
    final Color statusColor;
    final Color statusBg;
    switch (o.status) {
      case 'BARU':
        statusColor = const Color(0xFF0C447C);
        statusBg = const Color(0xFFE6F1FB);
        break;
      case 'DIPROSES':
        statusColor = const Color(0xFF633806);
        statusBg = const Color(0xFFFAEEDA);
        break;
      case 'DIKIRIM':
        statusColor = const Color(0xFF27500A);
        statusBg = const Color(0xFFEAF3DE);
        break;
      default: // SELESAI
        statusColor = const Color(0xFF444441);
        statusBg = const Color(0xFFF1EFE8);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xFFF6F4F2)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(o.productImage,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                          Icons.image_outlined,
                          color: Colors.black26)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(o.productName,
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                            color: Colors.black87),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Text('${o.buyerName}  ·  ${o.quantity}x',
                        style: GoogleFonts.inter(
                            fontSize: 12, color: Colors.black45)),
                  ],
                ),
              ),
              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(8)),
                child: Text(o.status,
                    style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: statusColor)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                const Icon(Icons.calendar_today_outlined,
                    size: 12, color: Colors.black38),
                const SizedBox(width: 4),
                Text(o.date,
                    style: GoogleFonts.inter(
                        fontSize: 11, color: Colors.black38)),
              ]),
              Text(o.totalPrice,
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      color: _primary)),
            ],
          ),
          // Action button (advance order status)
          if (showActions && o.status != 'SELESAI') ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 38,
              child: ElevatedButton(
                onPressed: () => _advanceStatus(o),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                child: Text(_nextLabel(o.status),
                    style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _nextLabel(String s) {
    switch (s) {
      case 'BARU':
        return 'Proses Pesanan';
      case 'DIPROSES':
        return 'Kirim Pesanan';
      default:
        return 'Tandai Selesai';
    }
  }

  void _advanceStatus(SellerOrder o) {
    const seq = ['BARU', 'DIPROSES', 'DIKIRIM', 'SELESAI'];
    final i = seq.indexOf(o.status);
    if (i < seq.length - 1) {
      o.status = seq[i + 1];
      // Reassign to trigger ValueNotifier listeners
      SellerState.orders.value = List.from(SellerState.orders.value);
    }
  }

  // ──────────────────────────────────────────────────────────
  // TAB 3 — TOKO
  // ──────────────────────────────────────────────────────────

  Widget _tokoTab() {
    final s = SellerState();
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Profil Toko',
              style: GoogleFonts.merriweather(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  color: Colors.black87)),
          const SizedBox(height: 20),

          // Store card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _dark,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                    color: _dark.withOpacity(0.4),
                    blurRadius: 14,
                    offset: const Offset(0, 6)),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.35), width: 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: s.storeImage.isNotEmpty
                        ? Image.network(s.storeImage,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                                Icons.storefront_rounded,
                                color: Colors.white,
                                size: 26))
                        : const Icon(Icons.storefront_rounded,
                            color: Colors.white, size: 26),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.storeName,
                          style: GoogleFonts.merriweather(
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                              color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(s.storeCategory,
                            style: GoogleFonts.inter(
                                fontSize: 11,
                                color: Colors.white70,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Info cards
          _infoCard(Icons.location_on_outlined, 'Alamat Toko',
              s.storeAddress),
          const SizedBox(height: 10),
          _infoCard(Icons.category_outlined, 'Kategori Usaha',
              s.storeCategory),
          const SizedBox(height: 24),

          // Mini stats
          ValueListenableBuilder<List<SellerProduct>>(
            valueListenable: SellerState.products,
            builder: (_, products, __) =>
                ValueListenableBuilder<List<SellerOrder>>(
              valueListenable: SellerState.orders,
              builder: (_, orders, __) {
                final rev = SellerState.totalRevenue;
                final revLabel = rev >= 1000000
                    ? '${(rev / 1000000).toStringAsFixed(1)}jt'
                    : SellerState.formatRupiah(rev);
                return Row(children: [
                  Expanded(
                      child: _miniStat('Produk',
                          products.length.toString(),
                          Icons.inventory_2_outlined)),
                  const SizedBox(width: 10),
                  Expanded(
                      child: _miniStat('Pesanan',
                          orders.length.toString(),
                          Icons.receipt_long_outlined)),
                  const SizedBox(width: 10),
                  Expanded(
                      child: _miniStat(
                          'Pendapatan', revLabel, Icons.wallet_outlined)),
                ]);
              },
            ),
          ),
          const SizedBox(height: 28),

          // Close store
          GestureDetector(
            onTap: () => _confirmClose(),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF2F2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: Colors.redAccent.withOpacity(0.4)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.store_mall_directory_outlined,
                      color: Colors.redAccent, size: 20),
                  const SizedBox(width: 8),
                  Text('Tutup Toko',
                      style: GoogleFonts.inter(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w700,
                          fontSize: 14)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: const Color(0xFFF3EBE6),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: _primary, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.black38)),
                const SizedBox(height: 2),
                Text(value,
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniStat(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: _primary, size: 18),
          const SizedBox(height: 5),
          Text(value,
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: Colors.black87)),
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.black38)),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // PRODUCT FORM — Modal Bottom Sheet (Add / Edit)
  // ──────────────────────────────────────────────────────────

  void _showProductForm(SellerProduct? existing) {
    final nameCtrl =
        TextEditingController(text: existing?.name ?? '');
    final descCtrl =
        TextEditingController(text: existing?.description ?? '');
    final priceCtrl =
        TextEditingController(text: existing?.price ?? '');
    final customImgCtrl = TextEditingController();

    String selectedCat = existing?.category ?? 'Fashion & Pakaian';
    String selectedImg =
        (existing?.image.isNotEmpty == true)
            ? existing!.image
            : 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=400&auto=format&fit=crop';
    bool showCustomImg = false;

    const presets = [
      'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=400&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1491553895911-0055eca6402d?w=400&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1585386959984-a4155224a1ad?w=400&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1556228453-efd6c1ff04f6?w=400&auto=format&fit=crop',
    ];

    const cats = [
      'Fashion & Pakaian', 'Elektronik', 'Makanan & Minuman',
      'Kecantikan', 'Olahraga', 'Hobi & Koleksi',
      'Perabotan', 'Otomotif',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheet) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: const BoxDecoration(
              color: Color(0xFFF8F5F2),
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(2)),
                ),
                // Title row
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 14, 22, 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          existing == null
                              ? 'Tambah Produk'
                              : 'Edit Produk',
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w900, fontSize: 18)),
                      GestureDetector(
                        onTap: () => Navigator.pop(ctx),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              color: const Color(0xFFF0F0F0),
                              borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Icons.close,
                              size: 18, color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFEAEAEA)),

                // Scrollable form
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      22, 18, 22,
                      MediaQuery.of(context).viewInsets.bottom + 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Foto Produk ──────────────────────
                        _formLabel('Foto Produk'),
                        const SizedBox(height: 12),
                        _formImagePicker(
                          presets: presets,
                          selectedImg: selectedImg,
                          showCustom: showCustomImg,
                          customCtrl: customImgCtrl,
                          onSelect: (img) => setSheet(() {
                            selectedImg = img;
                            showCustomImg = false;
                          }),
                          onToggle: () => setSheet(
                              () => showCustomImg = !showCustomImg),
                          onUrlChange: (v) {
                            if (v.trim().startsWith('http')) {
                              setSheet(() => selectedImg = v.trim());
                            }
                          },
                        ),
                        const SizedBox(height: 20),

                        // ── Nama Produk ──────────────────────
                        _formLabel('Nama Produk'),
                        const SizedBox(height: 10),
                        _formInput(nameCtrl,
                            'Contoh: Kaos Polos Premium',
                            Icons.label_outlined),
                        const SizedBox(height: 18),

                        // ── Deskripsi ────────────────────────
                        _formLabel('Deskripsi Produk'),
                        const SizedBox(height: 10),
                        _formInput(descCtrl,
                            'Jelaskan produkmu secara singkat...',
                            Icons.description_outlined,
                            maxLines: 4),
                        const SizedBox(height: 18),

                        // ── Harga ────────────────────────────
                        _formLabel('Harga'),
                        const SizedBox(height: 10),
                        _formInput(priceCtrl, 'Contoh: Rp150.000',
                            Icons.sell_outlined),
                        const SizedBox(height: 18),

                        // ── Kategori ─────────────────────────
                        _formLabel('Kategori'),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedCat,
                              isExpanded: true,
                              icon: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: _primary),
                              style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87),
                              onChanged: (v) =>
                                  setSheet(() => selectedCat = v!),
                              items: cats
                                  .map((c) => DropdownMenuItem(
                                      value: c, child: Text(c)))
                                  .toList(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // ── Save ─────────────────────────────
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: () => _saveProduct(
                              ctx: ctx,
                              existing: existing,
                              name: nameCtrl.text.trim(),
                              desc: descCtrl.text.trim(),
                              price: priceCtrl.text.trim(),
                              category: selectedCat,
                              img: showCustomImg &&
                                      customImgCtrl.text
                                          .trim()
                                          .startsWith('http')
                                  ? customImgCtrl.text.trim()
                                  : selectedImg,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                              elevation: 0,
                            ),
                            child: Text(
                                existing == null
                                    ? 'Tambah Produk'
                                    : 'Simpan Perubahan',
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                    color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _saveProduct({
    required BuildContext ctx,
    required SellerProduct? existing,
    required String name,
    required String desc,
    required String price,
    required String category,
    required String img,
  }) {
    if (name.isEmpty || desc.isEmpty || price.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Nama, deskripsi, dan harga harus diisi'),
      ));
      return;
    }

    if (existing == null) {
      SellerState.addProduct(SellerProduct(
        id: 'sp_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        description: desc,
        price: price,
        category: category,
        image: img,
      ));
    } else {
      existing.name = name;
      existing.description = desc;
      existing.price = price;
      existing.category = category;
      existing.image = img;
      SellerState.updateProduct(existing);
    }

    Navigator.pop(ctx);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(existing == null
          ? 'Produk berhasil ditambahkan!'
          : 'Produk berhasil diperbarui!'),
      backgroundColor: _primary,
    ));
  }

  Widget _formLabel(String text) => Text(text,
      style: GoogleFonts.inter(
          fontWeight: FontWeight.w800,
          fontSize: 14,
          color: Colors.black87));

  Widget _formInput(
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
        hintStyle:
            GoogleFonts.inter(fontSize: 14, color: Colors.black38),
        prefixIcon: maxLines == 1
            ? Icon(icon, color: _primary, size: 20)
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
            horizontal: maxLines > 1 ? 16 : 0, vertical: 15),
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

  Widget _formImagePicker({
    required List<String> presets,
    required String selectedImg,
    required bool showCustom,
    required TextEditingController customCtrl,
    required void Function(String) onSelect,
    required VoidCallback onToggle,
    required void Function(String) onUrlChange,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: _primary.withOpacity(0.35), width: 2),
                color: const Color(0xFFF6F4F2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(selectedImg,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                        Icons.image_outlined,
                        color: Colors.black26,
                        size: 28)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: presets.length,
                  itemBuilder: (_, i) {
                    final sel = selectedImg == presets[i];
                    return GestureDetector(
                      onTap: () => onSelect(presets[i]),
                      child: Container(
                        width: 58,
                        height: 58,
                        margin: const EdgeInsets.only(
                            right: 8, top: 11, bottom: 11),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: sel ? _primary : Colors.transparent,
                            width: 2.5,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(presets[i],
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
        GestureDetector(
          onTap: onToggle,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 11),
            decoration: BoxDecoration(
              border: Border.all(color: _primary.withOpacity(0.35)),
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFFFCF6F0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                    showCustom
                        ? Icons.close_rounded
                        : Icons.cloud_upload_outlined,
                    color: _primary,
                    size: 17),
                const SizedBox(width: 7),
                Text(showCustom ? 'Batal' : 'Upload Foto Custom',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: _primary)),
              ],
            ),
          ),
        ),
        if (showCustom) ...[
          const SizedBox(height: 8),
          TextField(
            controller: customCtrl,
            onChanged: onUrlChange,
            style: GoogleFonts.inter(fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Tempel URL gambar...',
              hintStyle:
                  GoogleFonts.inter(fontSize: 13, color: Colors.black38),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
            ),
          ),
        ],
      ],
    );
  }

  // ──────────────────────────────────────────────────────────
  // DIALOGS
  // ──────────────────────────────────────────────────────────

  void _confirmDelete(SellerProduct p) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: Text('Hapus Produk?',
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w900, fontSize: 17)),
        content: Text('"${p.name}" akan dihapus secara permanen.',
            style: GoogleFonts.inter(
                fontSize: 14, color: Colors.black54)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Batal',
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      color: Colors.black45))),
          TextButton(
              onPressed: () {
                SellerState.deleteProduct(p.id);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Produk berhasil dihapus'),
                  backgroundColor: Colors.redAccent,
                ));
              },
              child: Text('Hapus',
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      color: Colors.redAccent))),
        ],
      ),
    );
  }

  void _confirmClose() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: Text('Tutup Toko?',
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w900, fontSize: 17)),
        content: Text(
            'Semua data toko dan produk akan dihapus permanen.',
            style: GoogleFonts.inter(
                fontSize: 14, color: Colors.black54)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Batal',
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      color: Colors.black45))),
          TextButton(
              onPressed: () {
                // Hapus toko dari list pencarian global sebelum reset state
                STORES.removeWhere((s) => s.id == SellerState.sellerStoreId);
                SellerState.reset();
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
              child: Text('Tutup Toko',
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      color: Colors.redAccent))),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // SHARED HELPERS
  // ──────────────────────────────────────────────────────────

  Widget _iconBtn(
      IconData icon, Color bg, Color fg, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: bg, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: fg, size: 18),
      ),
    );
  }

  Widget _sectionTitle(String t) => Text(t,
      style: GoogleFonts.inter(
          fontWeight: FontWeight.w900,
          fontSize: 16,
          color: Colors.black87));

  Widget _emptyHint(String msg, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(16)),
      child: Column(children: [
        Icon(icon, size: 40, color: Colors.grey.shade300),
        const SizedBox(height: 8),
        Text(msg,
            style: GoogleFonts.inter(
                fontSize: 13, color: Colors.black38)),
      ]),
    );
  }
}
