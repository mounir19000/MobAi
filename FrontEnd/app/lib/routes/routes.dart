// routes.dart

import 'package:app/views/home_page.dart';
import 'package:flutter/material.dart';

import '../views/forget_pass_page';
import '../views/login_page.dart';
import '../views/register_page.dart';



class AppRoutes {
  static const String homepage = '/homepage';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgetpass= '/forgetpass';
  // static const String forgetPass = '/forgetpass';
  // static const String select_user_role = '/select_user_role';
  // static const String map = '/map';
  // static const String storeDetail = '/storeDetail';
  // static const String cart = '/cart';
  // static const String favorites = '/favorites';
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

      case AppRoutes.homepage:
        return MaterialPageRoute(builder: (_) => HomePage());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case AppRoutes.forgetpass:
        return MaterialPageRoute(builder: (_) => ForgetPassPage());
      // case AppRoutes.storeDetail:
      //   final storeId = settings.arguments as String;
      //   return MaterialPageRoute(
      //       builder: (_) => StoreDetailScreen(storeId: storeId));
      // case AppRoutes.cart:
      //   return MaterialPageRoute(builder: (_) => CartScreen());
      // case AppRoutes.favorites:
      //   return MaterialPageRoute(builder: (_) => FavoritesScreen());
      default:
        return MaterialPageRoute(builder: (_) => const HomePage());
    }
  }
}
