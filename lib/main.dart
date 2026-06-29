import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gusto/core/menu_screen.dart';
import 'package:gusto/feature/auth/presantation/GustoSplashScreen.dart';
import 'package:gusto/feature/auth/presantation/food_screen.dart' hide DetailScreen;



void main() => runApp(
  DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => MyApp(), // Wrap your app
  ),
);


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
      home: const GustoSplashScreen()
    );
  }
}