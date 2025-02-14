import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/book_model.dart';

class BookDetailsInfo extends StatelessWidget {
  final BookModel book;

  BookDetailsInfo({required this.book});

  Widget _buildInfoRow(String iconPath, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(iconPath, height: 20),
              SizedBox(width: 8),
              Text(label, style: TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow("lib/assets/icons/author.svg", "Author", book.author),
          _buildInfoRow("lib/assets/icons/calendar.svg", "Published", "2014"),
          _buildInfoRow("lib/assets/icons/rating.svg", "Rating", "4.7"),
        ],
      ),
    );
  }
}
