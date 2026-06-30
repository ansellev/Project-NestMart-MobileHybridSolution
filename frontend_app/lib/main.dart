import 'package:flutter/material.dart';

import 'favorites_state.dart';
import 'theme.dart';
import 'user_session.dart';

import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/store_screen.dart';
import 'screens/account_screen.dart';
import 'screens/app_settings_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/category_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/delivery_address_screen.dart';
import 'screens/favourites_screen.dart';
import 'screens/help_support_screen.dart';
import 'screens/my_details_screen.dart';
import 'screens/notification_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/search_screen.dart';
import 'screens/seller_dashboard_screen.dart';
import 'screens/seller_register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await UserSession.instance.autoLogin();
  // await FavoritesState.bootstrap(
  //   includeUserData: UserSession.instance.isLoggedIn,
  // );

  runApp(const NestMartApp());
}

class NestMartApp extends StatelessWidget {
  const NestMartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: UserSession.instance,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'NestMart',
          theme: AppTheme.lightTheme,
          home: UserSession.instance.isLoggedIn
              ? const WelcomeScreen()
              : const LoginScreen(),
          routes: {
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/welcome': (context) => const WelcomeScreen(),
            '/menu': (context) => const MenuScreen(),
            '/store': (context) => const StoreScreen(),
            '/account': (context) => const AccountScreen(),
            '/settings': (context) => const AppSettingsScreen(),
            '/cart': (context) => const CartScreen(),
            '/category': (context) => const CategoryScreen(),
            '/checkout': (context) => const CheckoutScreen(),
            '/delivery_address': (context) => const DeliveryAddressScreen(),
            '/favourite': (context) => const FavouritesScreen(),
            '/help_support': (context) => const HelpSupportScreen(),
            '/my_details': (context) => const MyDetailsScreen(),
            '/notification': (context) => const NotificationScreen(),
            '/orders': (context) => const OrdersScreen(),
            '/product': (context) => const ProductDetailScreen(),
            '/search': (context) => const SearchScreen(),
            '/seller_dashboard': (context) => const SellerDashboardScreen(),
            '/seller_register': (context) => const SellerRegisterScreen(),
          },
        );
      },
    );
  }
}
