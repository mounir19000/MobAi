// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFFF07168);

  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        textStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
      ),
      labelStyle: TextStyle(color: primaryColor),
    ),
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: primaryColor,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        textStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
      ),
      labelStyle: TextStyle(color: primaryColor),
    ),
  );
}

class Inputdeco {
  static getDeco(String labelText, String hintText,String? ErrorName) {
    return InputDecoration(
      errorText: ErrorName,
      labelText: labelText,
      hintText: hintText,
      labelStyle: TextStyle(
        color: Colors.grey, // Label color when not selected
      ),
      floatingLabelStyle: TextStyle(
        color: AppTheme.primaryColor, // Label color when focused
      ),
      enabledBorder: OutlineInputBorder(
          // Border when not selected
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Color(0xffE9EBED), 
            width: 1)),
      focusedBorder: OutlineInputBorder(
          // Border when focused
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            width: 2,
            color: AppTheme.primaryColor,
          )),
    );
  }
}
