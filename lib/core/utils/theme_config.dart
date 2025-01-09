import 'package:flutter/material.dart';

class ThemeConfig {
  // Light Theme
  static const Color customGreen = Color(0xFF11422D);
  static  ThemeData selectedTheme = blueTheme;
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: customGreen,
    indicatorColor: customGreen,
    scaffoldBackgroundColor: Color.fromARGB(255, 213, 220, 216),
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
static const Color CustomMaroon = Color.fromARGB(255, 66, 27, 17);
  static final ThemeData maroonTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: CustomMaroon,
    indicatorColor: CustomMaroon,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      color: CustomMaroon,
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
        borderSide: const BorderSide(color: CustomMaroon),
      ),
      labelStyle: const TextStyle(color: CustomMaroon),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    backgroundColor: CustomMaroon,
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

  // orange theme 
static const Color customBlue = Color.fromARGB(255, 38, 17, 66);
  static final ThemeData blueTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: customBlue,
    indicatorColor: customBlue,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      color: customBlue,
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
        borderSide: const BorderSide(color: customBlue),
      ),
      labelStyle: const TextStyle(color: customBlue),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    backgroundColor: customBlue,
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