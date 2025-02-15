import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app/core/constants/app_theme.dart';
import 'package:app/widgets/add_to_cart_widget.dart';
import 'package:provider/provider.dart';
import '../models/book_model.dart';
import '../state/user_provider.dart';

class BookDetailsActions extends StatelessWidget {
  final BookModel book;

  BookDetailsActions({required this.book});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          SizedBox(
            width: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Consumer<UserProvider>(
                  builder: (context, userProvider, child) {
                    bool isFavorite = userProvider.user!.wishlist.contains(book.bookId);
                    return TextButton.icon(
                      onPressed: () {
                        isFavorite? userProvider.removeFromWishlist(book.bookId):
                          userProvider.addToWishlist(book.bookId);
                      },
                      label: Text(
                        isFavorite ? "Remove from Wishlist" : "Add to Wishlist",
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: AppTheme.primaryColor,
                      ),
                    );
                  },
                ),
                SizedBox(height: 10),
                AddToCartWidget(),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to book summary
                  },
                  icon: SvgPicture.asset("lib/assets/icons/summary.svg",
                      height: 20),
                  label: Text("See Summary"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppTheme.primaryColor,
                    side: BorderSide(color: AppTheme.primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
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
