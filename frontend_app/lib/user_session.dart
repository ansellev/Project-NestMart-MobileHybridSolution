import 'package:flutter/foundation.dart';

import 'favorites_state.dart';
import 'models/user_model.dart';
import 'services/api_service.dart';

class FlutterAddress {
  FlutterAddress({
    required this.id,
    required this.name,
    required this.fullAddress,
  });

  final String id;
  String name;
  String fullAddress;
}

class UserSession extends ChangeNotifier {
  static final UserSession instance = UserSession._();

  UserSession._();

  UserModel? _user;
  bool _loggedIn = false;
  bool _loading = false;
  String _selectedAddressId = "1";

  final List<FlutterAddress> _addresses = [
    FlutterAddress(
      id: "1",
      name: "HOME ADDRESS",
      fullAddress: "Jl. NestMart No. 1, Jakarta",
    ),
  ];

  UserModel? get user => _user;

  bool get isLoggedIn => _loggedIn;

  bool get isLoading => _loading;

  String get name => _user?.name ?? "Pengguna NestMart";
  set name(String value) {}

  String get email => _user?.email ?? "user@nestmart.com";
  set email(String value) {}

  String get photoUrl => "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150";
  set photoUrl(String value) {}

  String get password => "••••••••";
  set password(String value) {}

  List<FlutterAddress> get addresses => _addresses;
  String get selectedAddressId => _selectedAddressId;
  set selectedAddressId(String value) {
    _selectedAddressId = value;
    notifyListeners();
  }

  Future<bool> autoLogin() async {
    _loading = true;
    notifyListeners();

    try {
      final token = await ApiService.instance.getToken();

      if (token == null || token.isEmpty) {
        _loggedIn = false;
        _user = null;
        return false;
      }

      final response =
          await ApiService.instance.getProfile();

      if (response["success"] == true) {
        _user = UserModel.fromJson(
          response["user"],
        );

         _loggedIn = true;
        // await FavoritesState.bootstrap(includeUserData: true);

        return true;
      }

      await logout();

      return false;
    } catch (_) {
      await logout();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> login({
  required String email,
  required String password,
}) async {
  _loading = true;
  notifyListeners();

  try {
    final response = await ApiService.instance.login(
      email: email,
      password: password,
    );

    if (response["success"] == true) {
      _user = UserModel.fromJson(response["user"]);
      _loggedIn = true;
    }

    return Map<String, dynamic>.from(response);
  } catch (e) {
    return {
      "success": false,
      "message": "Invalid email or password",
    };
  } finally {
    _loading = false;
    notifyListeners();
  }
}

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final res = await ApiService.instance.register(
      name: name,
      email: email,
      password: password,
    );
    return Map<String, dynamic>.from(res);
  }

  Future<void> logout() async {
    await ApiService.instance.logout();

    _user = null;
    _loggedIn = false;
    FavoritesState.favoriteIds.value = {};

    notifyListeners();
  }
}
