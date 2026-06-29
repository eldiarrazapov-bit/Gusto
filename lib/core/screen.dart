


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showAuthDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Bite.', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              // Поле Имя
              const Align(alignment: Alignment.centerLeft, child: Text("Введите ваше имя")),
              const SizedBox(height: 8),
              TextField(decoration: InputDecoration(filled: true, fillColor: Colors.grey.shade100, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none), hintText: "Имя")),
              const SizedBox(height: 16),

              // Поле Телефон
              const Align(alignment: Alignment.centerLeft, child: Text("Номер телефона")),
              const SizedBox(height: 8),
              TextField(decoration: InputDecoration(filled: true, fillColor: Colors.grey.shade100, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none), hintText: "+380")),
              const SizedBox(height: 24),

              // Кнопка
              // Кнопка регистрации внутри showDialog
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA5131C),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  onPressed: () {
                    // 1. Здесь можно добавить логику проверки данных (валидацию)

                    // 2. Эта команда закрывает диалог и возвращает тебя на экран профиля
                    Navigator.pop(context);

                    // 3. Можно добавить уведомление, что регистрация прошла успешно
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Вы успешно зарегистрировались!")),
                    );
                  },
                  child: const Text("Зарегистрироваться", style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 16),
              const Text("Или"),
              const SizedBox(height: 16),

              // Соцсети
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _socialButton(Icons.g_mobiledata, Colors.red), // Можно заменить на Image.asset
                  const SizedBox(width: 20),
                  _socialButton(Icons.facebook, Colors.blue),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}

// Виджет для иконок соцсетей
Widget _socialButton(IconData icon, Color color) {
  return Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade300)),
    child: Icon(icon, color: color, size: 30),
  );
}