import 'package:app/views/home_page.dart';
import 'package:app/views/profile_page.dart';
import 'package:app/views/cart_page.dart';
import 'package:app/views/wishlist_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    WishlistPage(),
    CartPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Switches between pages
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(0.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 15),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Color(0xFF0B5268),
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.black,
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              tabs: [
                GButton(
                  icon: CupertinoIcons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: CupertinoIcons.heart,
                  text: 'Wishlist',
                ),
                GButton(
                  icon: CupertinoIcons.cart,
                  text: 'Cart',
                ),
                GButton(
                  icon: CupertinoIcons.profile_circled,
                  text: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
