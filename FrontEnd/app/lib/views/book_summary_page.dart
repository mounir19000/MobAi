import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app/core/constants/app_theme.dart';
import '../models/book_model.dart';

class BookSummaryPage extends StatefulWidget {
  final BookModel book;

  BookSummaryPage({required this.book});

  @override
  _BookSummaryPageState createState() => _BookSummaryPageState();
}

class _BookSummaryPageState extends State<BookSummaryPage> {
  bool showSummary = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Image Positioned at Bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SvgPicture.asset(
              "lib/assets/images/booksummarybg.svg",
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width, // Ensure full width
            ),
          ),

          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderSection(),
                BookInfo(book: widget.book),
                ActionButtons(
                  showSummary: showSummary,
                  onToggleSummary: () {
                    setState(() {
                      showSummary = !showSummary;
                    });
                  },
                ),
                BookDetails(book: widget.book),
                if (showSummary) BookSummary(),
                SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Header Section with Back Button & Logo
class HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: SvgPicture.asset("lib/assets/icons/back.svg", height: 24),
          ),
          SvgPicture.asset("lib/assets/icons/logo-white.svg", height: 24),
        ],
      ),
    );
  }
}

// Book Title & Image
class BookInfo extends StatelessWidget {
  final BookModel book;

  const BookInfo({required this.book});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 30,),
          Text(
            book.name,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          SizedBox(height: 30),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withOpacity(0.3), // Shadow color with transparency
                  blurRadius: 10, // Soften the shadow
                  spreadRadius: 1, // Spread the shadow
                  offset: Offset(0, 10), // Position of the shadow (X, Y)
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                book.imageurl,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}

// Buttons for Wishlist & Summary Toggle
class ActionButtons extends StatelessWidget {
  final bool showSummary;
  final VoidCallback onToggleSummary;

  const ActionButtons(
      {required this.showSummary, required this.onToggleSummary});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton.icon(
            onPressed: () {},
            icon: SvgPicture.asset("lib/assets/icons/heart-white.svg"),
            label: Text(
              "Add to wishlist",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 20),
          ElevatedButton(
            onPressed: onToggleSummary,
            child: Text(showSummary ? "Hide summary" : "See summary"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.primaryColor,
              side: BorderSide(color: Colors.white),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Book Details Section
class BookDetails extends StatelessWidget {
  final BookModel book;

  const BookDetails({required this.book});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BookDetailRow(
              label: "Author",
              value: book.author,
              iconPath: "lib/assets/icons/author-white.svg"),
          SizedBox(height: 12),
          BookDetailRow(
              label: "Published",
              value: "2014",
              iconPath: "lib/assets/icons/calendar-white.svg"),
          SizedBox(height: 12),
          BookDetailRow(
              label: "Rating",
              value: "4.7",
              iconPath: "lib/assets/icons/rating-white.svg"),
        ],
      ),
    );
  }
}

// Single Book Detail Row
class BookDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final String iconPath;

  const BookDetailRow(
      {required this.label, required this.value, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(iconPath, height: 20),
        SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white70),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

// Book Summary Section
class BookSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        "“Someone Like You” by Roald Dahl is a collection of 18 short stories "
        "that explore themes of suspense, irony, and human nature with dark humor "
        "and unexpected twists. Each story presents an unsettling scenario, often leading "
        "to a shocking or ironic conclusion. 'Lamb to the Slaughter' follows a wife who "
        "kills her husband with a frozen leg of lamb and cleverly disposes of the murder "
        "weapon. 'Man from the South' tells of a chilling bet where a man risks his finger "
        "in a high-stakes gamble. 'Taste' revolves around a seemingly innocent wine-tasting contest "
        "that takes a sinister turn.",
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          height: 1.5,
        ),
      ),
    );
  }
}
