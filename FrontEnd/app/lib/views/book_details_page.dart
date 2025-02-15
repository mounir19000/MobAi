import 'package:app/widgets/book_details_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app/core/constants/app_theme.dart';
import 'package:app/widgets/book_details_header.dart';
import 'package:app/widgets/book_details_info.dart';
import '../models/book_model.dart';

class BookDetailsPage extends StatelessWidget {
  final BookModel book;

  BookDetailsPage({required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SvgPicture.asset(
                "lib/assets/images/bookdetailsbg.svg",
                height: 400,
                fit: BoxFit.cover,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BookDetailsHeader(book: book),
                BookDetailsActions(book: book),
                BookDetailsInfo(book: book),
                SizedBox(height: 40),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
