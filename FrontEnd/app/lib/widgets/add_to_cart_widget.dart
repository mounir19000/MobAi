import 'package:app/core/constants/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddToCartWidget extends StatefulWidget {
  @override
  _AddToCartWidgetState createState() => _AddToCartWidgetState();
}

class _AddToCartWidgetState extends State<AddToCartWidget> {
  bool isAddingToCart = false;
  int quantity = 1;

  void toggleCart() {
    setState(() {
      isAddingToCart = !isAddingToCart;
    });
  }

  void incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 200,
          child: ElevatedButton.icon(
            onPressed: toggleCart,
            icon: SvgPicture.asset("lib/assets/icons/cart.svg", height: 20),
            label: Text("Add to cart"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),
        ),
        SizedBox(height: 12),
        if (isAddingToCart)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: decrementQuantity,
                icon: Icon(Icons.remove, color: AppTheme.primaryColor),
                style: IconButton.styleFrom(
                  side: BorderSide(color: AppTheme.primaryColor),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(width: 5),
              Text(
                "$quantity",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 10),
              IconButton(
                onPressed: incrementQuantity,
                icon: Icon(Icons.add, color: AppTheme.primaryColor),
                style: IconButton.styleFrom(
                  side: BorderSide(color: AppTheme.primaryColor),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  // Handle adding to cart logic
                },
                child: Text("Add"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(16),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
