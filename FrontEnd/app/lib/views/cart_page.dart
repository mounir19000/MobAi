import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app/core/constants/app_theme.dart';

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
                      : CartItemList(cartItems: cartItems, onRemove: removeItem),
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: cartItems.isEmpty ? null : emptyCart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                                color: AppTheme.primaryColor, width: 2),
                          ),
                        ),
                        child: const Text(
                          'Empty Cart',
                          style: TextStyle(color: AppTheme.primaryColor),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: cartItems.isEmpty ? null : () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        child: const Text(
                          'Purchase Items',
                          style: TextStyle(color: Colors.white),
                        ),
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

  const CartItemList({super.key, required this.cartItems, required this.onRemove});

  @override
  _CartItemListState createState() => _CartItemListState();
}

class _CartItemListState extends State<CartItemList> {
  late List<int> quantities;

  @override
  void initState() {
    super.initState();
    quantities = List.filled(widget.cartItems.length, 1);
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
    return Expanded(  // Wrap ListView in Expanded to prevent infinite height issue
      child: ListView.builder(
        itemCount: widget.cartItems.length,
        itemBuilder: (context, index) {
          final item = widget.cartItems[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 70,
                  height: 120,  // Set a fixed height to prevent layout errors
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: const DecorationImage(
                      image: AssetImage('lib/assets/images/book-cover.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  width: 140,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        spreadRadius: 2,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'],
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                      Text(item['author']),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () => decrementQuantity(index),
                            icon: Icon(Icons.remove, color: AppTheme.primaryColor),
                          ),
                          Text(
                            "${quantities[index]}",
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                const SizedBox(width: 15),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppTheme.primaryColor,
                          width: 2,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: FittedBox(
                        child: Text(
                          '${item['price'] * quantities[index]}\$',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                            fontSize: 16, // Adjusted font size
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 30,
                      child: TextButton(
                        onPressed: () => widget.onRemove(index),
                        style: TextButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
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
          );
        },
      ),
    );
  }
}
