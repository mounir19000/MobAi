import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app/core/constants/app_theme.dart';
import 'package:app/widgets/add_to_cart_widget.dart';
import '../models/book_model.dart';

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
                TextButton.icon(
                  onPressed: () {},
                  label: Text(
                    "Add to Wishlist",
                    style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600),
                  ),
                  icon: SvgPicture.asset("lib/assets/icons/heart.svg"),
                ),
                SizedBox(height: 10),
                AddToCartWidget(),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => BookSummaryPage(book: book),
                    //   ),
                    // );
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
