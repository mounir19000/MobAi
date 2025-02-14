import 'package:app/core/constants/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/book_model.dart';

class BookDetailsHeader extends StatelessWidget {
  final BookModel book;

  BookDetailsHeader({required this.book});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 80, 30, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: SvgPicture.asset("lib/assets/icons/back.svg", height: 24),
              ),
              SvgPicture.asset("lib/assets/icons/logo-white.svg", height: 24),
            ],
          ),
          SizedBox(height: 30),
          Center(
            child: Column(
              children: [
                Text(
                  book.name,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 30),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(book.imageurl, height: 230, fit: BoxFit.cover),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${book.price} \$",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    TextButton.icon(
                      onPressed: () {},
                      icon: SvgPicture.asset("lib/assets/icons/star.svg", height: 20),
                      label: Text("Rate", style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.w600),),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
