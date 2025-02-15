import 'dart:math';

import 'package:app/core/constants/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> cartItems = [
    {'title': 'Someone Like You', 'author': 'Roald Dahl', 'price': 35},
    {'title': 'The Alchemist', 'author': 'Paulo Coelho', 'price': 40},
    {'title': '1984', 'author': 'George Orwell', 'price': 30},
    {'title': 'To Kill a Mockingbird', 'author': 'Harper Lee', 'price': 45},
  ];

  void removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  void emptyCart() {
    setState(() {
      cartItems.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.offWhite,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 170,
              child: SvgPicture.asset(
                'lib/assets/images/cartbg.svg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 120),
            child: Column(
              children: [
                Expanded(
                  child: cartItems.isEmpty
                      ? const Center(child: Text('Your cart is empty'))
                      : CartItemList(
                          cartItems: cartItems, onRemove: removeItem),
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: cartItems.isEmpty ? null : emptyCart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent, // No background
                          shadowColor: Colors.transparent, // Removes shadow
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                                color: AppTheme.primaryColor,
                                width: 2), // Border color
                          ),
                        ),
                        child: const Text(
                          'Empty Cart',
                          style: TextStyle(
                              color: AppTheme.primaryColor), // Text color to match the border
                        ),
                      ),
                      ElevatedButton(
                        onPressed: cartItems.isEmpty ? null : () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        child: const Text('Purchase Items', style: TextStyle(color: Colors.white),),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CartItemList extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final Function(int) onRemove;

  const CartItemList(
      {super.key, required this.cartItems, required this.onRemove});

  @override
  _CartItemListState createState() => _CartItemListState();
}

class _CartItemListState extends State<CartItemList> {
  List<int> quantities = [];

  @override
  void initState() {
    super.initState();
    quantities = List.filled(
        widget.cartItems.length, 1); // Initialize with 1 for each item
  }

  void incrementQuantity(int index) {
    setState(() {
      quantities[index]++;
    });
  }

  void decrementQuantity(int index) {
    if (quantities[index] > 1) {
      setState(() {
        quantities[index]--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.cartItems.length,
      itemBuilder: (context, index) {
        final item = widget.cartItems[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SizedBox(
            // height: 130,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 100,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: AssetImage('lib/assets/images/book-cover.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                  width: 180,
                  decoration: BoxDecoration(
                    color: Colors.white, // Move color inside BoxDecoration
                    borderRadius: BorderRadius.circular(
                        30), // Adjust the radius as needed
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        spreadRadius: 2,
                        offset: Offset(0, 3), // Adds a slight shadow effect
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'],
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                      Text(item['author']),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () => decrementQuantity(index),
                            icon: Icon(Icons.remove,
                                color: AppTheme.primaryColor),
                          ),
                          Text(
                            "${quantities[index]}",
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            onPressed: () => incrementQuantity(index),
                            icon: Icon(Icons.add, color: AppTheme.primaryColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      alignment: Alignment
                          .center, // Centers the child inside the container
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppTheme.primaryColor,
                          width: 2, // Border with primary color
                        ),
                        shape:
                            BoxShape.circle, // Ensures perfect circular shape
                      ),
                      child: Text(
                        '${item['price'] * quantities[index]}\$',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                          fontSize: 18,
                        ),
                        textAlign:
                            TextAlign.center, // Ensures text stays centered
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      height: 30, // Set desired height
                      child: TextButton(
                        onPressed: () => widget.onRemove(index),
                        style: TextButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          padding: EdgeInsets.symmetric(
                              vertical: 4, horizontal: 12), // Adjust padding
                        ),
                        child: const Text(
                          'Remove',
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
