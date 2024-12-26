import 'package:flutter/material.dart';

class ThemeConfig {
  // Light Theme
  static const Color customGreen = Color(0xFF11422D);
  static  ThemeData selectedTheme = orangeTheme;
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: customGreen,
    indicatorColor: customGreen,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      color: customGreen,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.black, fontSize: 14,),
      bodySmall: TextStyle(color: Colors.white, fontSize: 12),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: customGreen),
      ),
      labelStyle: const TextStyle(color: customGreen),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    backgroundColor: customGreen,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    textStyle: const TextStyle(
      fontSize: 16, 
      fontWeight: FontWeight.bold, 
      color: Colors.white, // Text color
    ),
    iconColor: Colors.white, // Icon color
  ),
),  
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.black,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      color: Color(0xFF1F1F1F),
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.white, fontSize: 14),
      bodySmall: TextStyle(color: Colors.black, fontSize: 12),

    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.white),
      ),
      labelStyle: const TextStyle(color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        iconColor: Colors.black,
      ),
    ),
  );
  
// orange theme 
static const Color customOrange = Color.fromARGB(255, 66, 47, 17);
  static final ThemeData orangeTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: customOrange,
    indicatorColor: customOrange,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      color: customOrange,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.black, fontSize: 14,),
      bodySmall: TextStyle(color: Colors.white, fontSize: 12),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: customOrange),
      ),
      labelStyle: const TextStyle(color: customOrange),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    backgroundColor: customOrange,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    textStyle: const TextStyle(
      fontSize: 16, 
      fontWeight: FontWeight.bold, 
      color: Colors.white, // Text color
    ),
    iconColor: Colors.white, // Icon color
  ),
),  
  );
}