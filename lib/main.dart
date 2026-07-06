import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gusto/core/menu_screen.dart';
import 'package:gusto/core/profail_screen.dart';
import 'package:gusto/feature/auth/presantation/GustoSplashScreen.dart';
import 'package:gusto/feature/auth/presantation/food_screen.dart' hide DetailScreen;
import 'package:gusto/feature/auth/screen.dart';
import 'package:gusto/feature/screenone.dart';
import 'package:gusto/feature/screentwo.dart' hide MainWrappers;

import 'feature/screens.dart';



void main() => runApp(
  DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => MyApp(), // Wrap your app
  ),
);
const Color kBrandBrown = Color(0xFF8B3A0E);
const Color kActiveOrange = Color(0xFFFF6600);
const Color kBgColor = Color(0xFFF7F7F7);
const Color kGreyBg = Color(0xFFEAEAEA);
const Color kDarkText = Color(0xFF1E1E1E);

// --- МОДЕЛЬ ДАННЫХ ТОВАРА ---
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double rating;
  final String imageUrl;
  int quantity;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.imageUrl,
    this.quantity = 0,
  });
}
// const Color kBrandBrown = Color(0xFF8B3A0E);   // Фирменный коричневый
// const Color kActiveOrange = Color(0xFFFF6600); // Активный оранжевый для выделения
// const Color kBgColor = Color(0xFFF7F7F7);      // Светлый фон экранов
// const Color kGreyBg = Color(0xFFEAEAEA);       // Серый цвет для подложек/поиска
// const Color kDarkText = Color(0xFF1E1E1E);     // Темный текст
//
// // --- МОДЕЛЬ ДАННЫХ ТОВАРА ---
// class Product {
//   final String id;
//   final String name;
//   final String description;
//   final double price;
//   final double rating;
//   final String imageUrl;
//   int quantity;
//
//   Product({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.price,
//     required this.rating,
//     required this.imageUrl,
//     this.quantity = 0,
//   });
// }


// --- ОСНОВНАЯ ТЕМА И ЦВЕТА ---
class AppColors {
  static const Color primaryRed = Color(0xFF7A1B29);
  static const Color background = Color(0xFFFBFBFB);
  static const Color textDark = Color(0xFF333333);
  static const Color textLight = Color(0xFF999999);
  static const Color accentYellow = Color(0xFFFFC107);

  static Color? primary;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const MainWrappers()
    );
  }
}