
import 'package:app/core/constants/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroPage extends StatelessWidget {
  final String imagurl;
  final String title;
  final String description;

  const IntroPage({super.key, required this.imagurl, required this.title, required this.description});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        SizedBox(height: 30),
        Text(
          title,
          textAlign: TextAlign.center,
          style:TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
        ),
        SizedBox(height: 120),
        Image.asset(
          imagurl,
          height: 200,
          width: 300,
          fit: BoxFit.contain,
        ),
        SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sit aenean ullamcorper id platea enim id.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     _buildPaginationDot(AppTheme.primaryColor),
        //     SizedBox(width: 8),
        //     _buildPaginationDot(Colors.grey[300] ?? Colors.grey),
        //     SizedBox(width: 8),
        //     _buildPaginationDot(Colors.grey[300] ?? Colors.grey),
        //   ],
        // ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Container(
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     border: Border(
              //       top: BorderSide(color: AppTheme.primaryColor, width: 2),
              //       right: BorderSide(color: AppTheme.primaryColor, width: 2),
              //       // You can set other sides to transparent or any other color as needed
              //       bottom: BorderSide.none,
              //       left: BorderSide.none,
              //     ),
              //     shape: BoxShape.circle,
              //   ),
              //   child: IconButton(
              //     icon: Icon(
              //         size: 40,
              //         Icons.arrow_forward,
              //         color: AppTheme.primaryColor),
              //     onPressed: () {},
              //   ),
              // ),
            ],
          ),
        ),
        //SizedBox(height: 20),
      ],
    );
  }

  
}
