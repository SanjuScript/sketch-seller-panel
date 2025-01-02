import 'package:drawer_panel/ANIMATIONS/fade_transition.dart';
import 'package:drawer_panel/EXTENSIONS/color_ext.dart';
import 'package:drawer_panel/HELPERS/font_helper.dart';
import 'package:flutter/material.dart';

class ArtTheme {
  static final lightTheme = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        surfaceTintColor: Colors.transparent,
        elevation: 5,
        shadowColor: Colors.black12,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.teal),
      ),
      textTheme: TextTheme(
        displayLarge:
            PerfectTypogaphy.bold.copyWith(fontSize: 32, color: Colors.black87),
        displayMedium:
            PerfectTypogaphy.bold.copyWith(fontSize: 28, color: Colors.black87),
        bodyLarge: PerfectTypogaphy.regular
            .copyWith(fontSize: 16, color: Colors.black87),
        bodyMedium: PerfectTypogaphy.regular
            .copyWith(fontSize: 14, color: Colors.black87),
        bodySmall:
            PerfectTypogaphy.regular.copyWith(fontSize: 12, color: Colors.grey),
        labelLarge:
            PerfectTypogaphy.bold.copyWith(fontSize: 16, color: Colors.white),
        titleLarge:
            PerfectTypogaphy.bold.copyWith(fontSize: 24, color: Colors.black87),
        titleMedium:
            PerfectTypogaphy.bold.copyWith(fontSize: 20, color: Colors.black87),
        titleSmall:
            PerfectTypogaphy.bold.copyWith(fontSize: 18, color: Colors.black87),
        headlineLarge: PerfectTypogaphy.regular
            .copyWith(fontSize: 22, color: Colors.black87),
        headlineMedium: PerfectTypogaphy.regular
            .copyWith(fontSize: 20, color: Colors.black87),
        headlineSmall: PerfectTypogaphy.regular
            .copyWith(fontSize: 18, color: Colors.black87),
        labelMedium:
            PerfectTypogaphy.bold.copyWith(fontSize: 16, color: Colors.black87),
        labelSmall:
            PerfectTypogaphy.bold.copyWith(fontSize: 14, color: Colors.black87),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal, // Button background color
          foregroundColor: Colors.white, // Text color
          textStyle: PerfectTypogaphy.bold.copyWith(fontSize: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
         
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          backgroundColor: Colors.teal.shade50,
          foregroundColor: Colors.teal, 
          textStyle: PerfectTypogaphy.bold.copyWith(fontSize: 14),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.teal, 
          side: const BorderSide(color: Colors.teal),
          textStyle: PerfectTypogaphy.bold.copyWith(fontSize: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      buttonTheme: ButtonThemeData(
        
        buttonColor: Colors.teal,
        textTheme: ButtonTextTheme.primary, 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: "#eff3fc".toColor(),
          selectedItemColor: Colors.black87,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: false,
          showSelectedLabels: true,
          selectedLabelStyle: PerfectTypogaphy.regular.copyWith(
            letterSpacing: 0.5,
            color: Colors.black87,
          )),
      pageTransitionsTheme: PageTransitionsTheme(builders: {
        TargetPlatform.android: CustomPageTransition(),
        TargetPlatform.iOS: CustomPageTransition(),
      }));
}
