import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../user_session.dart';

class DeliveryAddressScreen extends StatefulWidget {
  const DeliveryAddressScreen({super.key});

  @override
  State<DeliveryAddressScreen> createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends State<DeliveryAddressScreen> {
  final _session = UserSession();

  // Inputs for adding a new address
  final TextEditingController _newNameController = TextEditingController();
  final TextEditingController _newAddressController = TextEditingController();

  // Inline editing state
  String? _editingAddressId;
  final TextEditingController _editNameController = TextEditingController();
  final TextEditingController _editAddressController = TextEditingController();

  @override
  void dispose() {
    _newNameController.dispose();
    _newAddressController.dispose();
    _editNameController.dispose();
    _editAddressController.dispose();
    super.dispose();
  }

  void _addNewAddress() {
    final name = _newNameController.text.trim();
    final address = _newAddressController.text.trim();
    if (name.isEmpty || address.isEmpty) return;

    final newId = DateTime.now().millisecondsSinceEpoch.toString();
    setState(() {
      _session.addresses.add(
        FlutterAddress(
          id: newId,
          name: name.toUpperCase(),
          fullAddress: address,
        ),
      );
      _session.selectedAddressId = newId;
      _newNameController.clear();
      _newAddressController.clear();
    });
  }

  void _startEditing(FlutterAddress addr) {
    setState(() {
      _editingAddressId = addr.id;
      _editNameController.text = addr.name;
      _editAddressController.text = addr.fullAddress;
    });
  }

  void _saveEditing(String id) {
    final name = _editNameController.text.trim();
    final address = _editAddressController.text.trim();
    if (name.isEmpty || address.isEmpty) return;

    setState(() {
      for (var addr in _session.addresses) {
        if (addr.id == id) {
          addr.name = name.toUpperCase();
          addr.fullAddress = address;
          break;
        }
      }
      _editingAddressId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4CEB4), // Peach background
      body: SafeArea(
        bottom: false,
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFEFEFEF),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.0),
              topRight: Radius.circular(40.0),
            ),
          ),
          child: Column(
            children: [
              // Top Header with back arrow and Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/account');
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.black,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'DAFTAR ALAMAT',
                      style: GoogleFonts.merriweather(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        color: const Color(0xFF7E4D2B),
                      ),
                    ),
                  ],
                ),
              ),

              // Scrollable content area
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // List of Addresses
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _session.addresses.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 24),
                          itemBuilder: (context, index) {
                            final addr = _session.addresses[index];
                            final isSelected = _session.selectedAddressId == addr.id;
                            final isEditing = _editingAddressId == addr.id;

                            return GestureDetector(
                              onTap: () {
                                if (!isEditing) {
                                  setState(() {
                                    _session.selectedAddressId = addr.id;
                                  });
                                }
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(28),
                                  border: Border.all(
                                    color: isSelected ? const Color(0xFF7E4D2B).withOpacity(0.3) : const Color(0xFFF3F3F3),
                                    width: isSelected ? 2.0 : 1.0,
                                  ),
                                  boxShadow: [
                                    if (isSelected)
                                      BoxShadow(
                                        color: const Color(0xFF7E4D2B).withOpacity(0.22),
                                        blurRadius: 35,
                                        offset: const Offset(0, 15),
                                      )
                                    else
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.04),
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                      ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Row with Address Name/Type on left, Edit link on right
                                    Row(
                                      children: [
                                        Expanded(
                                          child: isEditing
                                              ? TextField(
                                                  controller: _editNameController,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w900,
                                                    color: const Color(0xFF7E4D2B),
                                                    letterSpacing: 0.8,
                                                  ),
                                                  decoration: const InputDecoration(
                                                    border: UnderlineInputBorder(),
                                                    isDense: true,
                                                    contentPadding: EdgeInsets.symmetric(vertical: 4),
                                                  ),
                                                )
                                              : Text(
                                                  addr.name,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w900,
                                                    color: const Color(0xFF7E4D2B),
                                                    letterSpacing: 0.8,
                                                  ),
                                                ),
                                        ),
                                        const SizedBox(width: 12),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (!isEditing) ...[
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _session.addresses.removeWhere((element) => element.id == addr.id);
                                                    if (_session.selectedAddressId == addr.id) {
                                                      _session.selectedAddressId = _session.addresses.isNotEmpty 
                                                          ? _session.addresses.first.id 
                                                          : '';
                                                    }
                                                  });
                                                },
                                                behavior: HitTestBehavior.opaque,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(4.0),
                                                  child: Text(
                                                    'Delete',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w900,
                                                      color: const Color(0xFFFF4D4D),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '|',
                                                style: GoogleFonts.inter(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.grey.shade300,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                            ],
                                            GestureDetector(
                                              onTap: () {
                                                if (isEditing) {
                                                  _saveEditing(addr.id);
                                                } else {
                                                  _startEditing(addr);
                                                }
                                              },
                                              behavior: HitTestBehavior.opaque,
                                              child: Padding(
                                                padding: const EdgeInsets.all(4.0),
                                                child: Text(
                                                  isEditing ? 'Save' : 'Edit',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w900,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),

                                    // Full Address
                                    isEditing
                                        ? TextField(
                                            controller: _editAddressController,
                                            maxLines: 2,
                                            style: GoogleFonts.inter(
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.black,
                                              height: 1.4,
                                            ),
                                            decoration: const InputDecoration(
                                              border: UnderlineInputBorder(),
                                              isDense: true,
                                              contentPadding: EdgeInsets.symmetric(vertical: 4),
                                            ),
                                          )
                                        : Text(
                                            addr.fullAddress,
                                            style: GoogleFonts.inter(
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.black,
                                              height: 1.4,
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 36),

                        // Form Section corresponding to bottom box on mockup
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(color: const Color(0xFFF3F3F3)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title row: ADDRESS NAME label left, Add New Address text link right
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'ADDRESS NAME',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900,
                                      color: const Color(0xFF7E4D2B),
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: _addNewAddress,
                                    behavior: HitTestBehavior.opaque,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                      child: Text(
                                        'Add New Address',
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900,
                                          color: const Color(0xFF7E4D2B),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Key Input field
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEFEFEF).withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(color: const Color(0xFFECECEC)),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
                                child: TextField(
                                  controller: _newNameController,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF7E4D2B),
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'e.g. WORK ADDRESS',
                                    hintStyle: GoogleFonts.inter(
                                      color: Colors.black26,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Address label
                              Text(
                                'ADDRESS',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  color: const Color(0xFF7E4D2B),
                                  letterSpacing: 0.8,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Address input field
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEFEFEF).withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: const Color(0xFFECECEC)),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                                child: TextField(
                                  controller: _newAddressController,
                                  maxLines: 2,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Enter full address details...',
                                    hintStyle: GoogleFonts.inter(
                                      color: Colors.black26,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Persistent Bottom navigation bar matching screenshots
              Container(
                height: 72,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavTab(Icons.storefront_outlined, 'Shop', false, () {
                      Navigator.pushReplacementNamed(context, '/menu');
                    }),
                    _buildNavTab(Icons.manage_search, 'Kategori', false, () {
                      Navigator.pushReplacementNamed(context, '/category');
                    }),
                    _buildNavTab(Icons.shopping_cart_outlined, 'Cart', false, () {
                      Navigator.pushReplacementNamed(context, '/cart');
                    }),
                    _buildNavTab(Icons.favorite_border_outlined, 'Favourite', false, () {
                      Navigator.pushReplacementNamed(context, '/favourite');
                    }),
                    _buildNavTab(Icons.person, 'Account', true, () {
                      Navigator.pushReplacementNamed(context, '/account');
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavTab(IconData icon, String label, bool active, VoidCallback onTap) {
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
