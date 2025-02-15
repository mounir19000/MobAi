import 'package:app/core/constants/top_curve.dart';
import 'package:flutter/material.dart';

import '../core/constants/app_theme.dart';
import '../state/user_provider.dart';
import '../widgets/books.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = UserProvider();
  
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Stack(
            children: [
              ClipPath(
                clipper: InversedOnboardingClipper(),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.12,
                  width: double.infinity,
                  color: AppTheme.primaryColor,
                ),
              ),
              Center(
                child: Image.asset(
                  "lib/assets/images/Logo.png",
                  height: 50,
                  width: 50,
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
        ),
        body: Column(
  children: [
    Expanded(
      child: BookGridOfWishlist(wishlist: userProvider.user!.wishlist,), 
    ),
  ],
),
      ),
    );
  }
}
