class FlutterAddress {
  String id;
  String name;
  String fullAddress;

  FlutterAddress({required this.id, required this.name, required this.fullAddress});
}

class UserSession {
  static final UserSession _instance = UserSession._internal();
  factory UserSession() => _instance;
  UserSession._internal();

  String name = 'ANDI';
  String email = 'ANDI@GMAIL.COM';
  String password = 'password123';
  String photoUrl = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&auto=format&fit=crop&q=80';

  List<FlutterAddress> addresses = [
    FlutterAddress(
      id: '1',
      name: 'HOME ADDRESS',
      fullAddress: 'Jl. Diponegoro No 51, Kecamatan Menteng, Jakarta Pusat, DKI Jakarta 15082',
    ),
    FlutterAddress(
      id: '2',
      name: 'OFFICE ADDRESS',
      fullAddress: 'Jl. Kebayoran No 41, Kecamatan Kebayoran Baru, Jakarta Selatan, DKI Jakarta 15023',
    ),
  ];
  String selectedAddressId = '1';

  // Dynamic cart items shared session state
  List<Map<String, dynamic>> cartItems = [
    {
      'name': 'LUXURY BAG',
      'price': 23.16,
      'qty': 1,
      'img': 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=400',
    },
    {
      'name': 'URBAN BAG',
      'price': 20.16,
      'qty': 1,
      'img': 'https://images.unsplash.com/photo-1547949003-9792a18a2601?w=400',
    },
    {
      'name': 'YAMATO',
      'price': 66.16,
      'qty': 1,
      'img': 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=400',
    },
  ];

  void addToCart(String name, double price, int qty, String img) {
    final existingIndex = cartItems.indexWhere(
      (item) => (item['name'] as String).toLowerCase() == name.toLowerCase()
    );
    if (existingIndex != -1) {
      cartItems[existingIndex]['qty'] = (cartItems[existingIndex]['qty'] as int) + qty;
    } else {
      cartItems.add({
        'name': name,
        'price': price,
        'qty': qty,
        'img': img,
      });
    }
  }
}


