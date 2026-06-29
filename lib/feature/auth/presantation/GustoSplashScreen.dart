import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'food_screen.dart';

class GustoSplashScreen extends StatefulWidget {
  const GustoSplashScreen({super.key});

  @override
  State<GustoSplashScreen> createState() => _GustoSplashScreenState();
}

class _GustoSplashScreenState extends State<GustoSplashScreen> {
  void initState() {
    super.initState();
    // Прячем системные панели для full-screen эффекта (по желанию)
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    // Имитация задержки перед переходом на следующий экран
    Future.delayed(const Duration(seconds: 2), () {
      // Вернем системные бары обратно при уходе со сплеша
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

      // TODO: Твоя логика навигации, например:
       Navigator.of(context).pushReplacement(
         MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
       );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Красивый градиентный фон для Gusto
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF7A1B29), // Насыщенный оранжевый сверху
              Color(0xFFB71C1C), // Золотисто-желтый снизу
            ],
          ),
        ),
        child: const SafeArea(
          child: Stack(
            children: [
              // 1. Центральный блок: Логотип и Название
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _GustoLogoAndName(),
                    SizedBox(height: 12),
                    _GustoTagline(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Компонент логотипа и названия бренда
class _GustoLogoAndName extends StatelessWidget {
  const _GustoLogoAndName();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Временная иконка вместо логотипа (можно заменить на Image.asset)
        Icon(
          Icons.whatshot_rounded,
          size: 60,
          color: Colors.white.withOpacity(0.9),
        ),
        const SizedBox(width: 12),
        // Текстовое название бренда
        Text(
          'Gusto',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}

// Компонент слогана/подписи
class _GustoTagline extends StatelessWidget {
  const _GustoTagline();

  @override
  Widget build(BuildContext context) {
    return Text(
      'ВАШ ВКУСНЫЙ МИР',
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        color: Colors.white.withOpacity(0.8),
        fontWeight: FontWeight.w400,
        letterSpacing: 1.2,
      ),
    );
  }
}




