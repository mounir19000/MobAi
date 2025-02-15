// routes.dart

import 'package:app/views/book_details_page.dart';
import 'package:app/views/home_page.dart';
import 'package:app/views/main_screen.dart';
import 'package:app/views/my_pagview.dart';
import 'package:app/views/profile_page.dart';
import 'package:app/views/cart_page.dart';
import 'package:app/views/wishlist_page.dart';
import 'package:flutter/material.dart';

import '../models/book_model.dart';
import '../views/forget_pass_page.dart';
import '../views/login_page.dart';
import '../views/register_page.dart';



class AppRoutes {
  static const String homepage = '/homepage';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgetpass= '/forgetpass';
  static const String pageview = '/pageview';
  static const String mainscreen = '/mainscreen';
  static const String profilepage = '/profilepage';
  static const String cartpage = '/cartpage';
  static const String wishlistpage = '/wishlistpage';
  static const String book_details_page = '/book_details_page';

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
      case AppRoutes.pageview:
        return MaterialPageRoute(builder: (_) => MyPageView());
      case AppRoutes.mainscreen:
        return MaterialPageRoute(builder: (_) => MainScreen());
      case AppRoutes.cartpage:
        return MaterialPageRoute(builder: (_) => CartPage());
      case AppRoutes.profilepage:
        return MaterialPageRoute(builder: (_) => ProfilePage());
      case AppRoutes.wishlistpage:
        return MaterialPageRoute(builder: (_) => WishlistPage());
      case AppRoutes.book_details_page:
        final args = settings.arguments as BookModel; // Expecting a book
        return MaterialPageRoute(builder: (_) => BookDetailsPage(book: args));

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
