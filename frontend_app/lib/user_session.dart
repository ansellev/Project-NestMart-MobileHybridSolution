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
}
