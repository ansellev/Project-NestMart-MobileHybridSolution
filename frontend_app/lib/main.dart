import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/account_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/favourites_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/my_details_screen.dart';
import 'screens/delivery_address_screen.dart';
import 'screens/help_support_screen.dart';
import 'screens/category_screen.dart';
import 'screens/search_screen.dart';
import 'screens/store_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/notification_screen.dart';
import 'theme.dart';

void main() {
  runApp(const NestmartApp());
}

class NestmartApp extends StatelessWidget {
  const NestmartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nestmart',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/menu': (context) => const MenuScreen(),
        '/account': (context) => const AccountScreen(),
        '/cart': (context) => const CartScreen(),
        '/product': (context) => const ProductDetailScreen(),
        '/favourite': (context) => const FavouritesScreen(),
        '/orders': (context) => const OrdersScreen(),
        '/my_details': (context) => const MyDetailsScreen(),
        '/delivery_address': (context) => const DeliveryAddressScreen(),
        '/help_support': (context) => const HelpSupportScreen(),
        '/category': (context) => const CategoryScreen(),
        '/search': (context) => const SearchScreen(),
        '/store': (context) => const StoreScreen(),
        '/checkout': (context) => const CheckoutScreen(),
        '/notification': (context) => const NotificationScreen(),
        // Baris '/checkout' yang duplikat sudah dihapus dari sini
      },
    );
  }
}
