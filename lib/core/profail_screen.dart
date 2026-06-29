import 'package:flutter/material.dart';
import 'package:gusto/core/screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text('Профиль', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),

              Row(
                children: [
                  const CircleAvatar(radius: 35, backgroundColor: Color(0xFFEEEEEE), child: Icon(Icons.person, size: 40, color: Colors.grey)),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Row(
                      children: [
                        _authButton('Регистрация', true, () => print("Нажата Регистрация")),
                        const SizedBox(width: 10),
                        // Внутри метода build в ProfileScreen:
                        _authButton('Войти', false, () => showAuthDialog(context)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Divider(),

              // Интерактивное меню
              _menuItem(Icons.list_alt, 'Список заказов', () => print("Переход в заказы")),
              _menuItem(Icons.percent, 'Скидки и бонусы', () => print("Переход в скидки")),
              _menuItem(Icons.location_on_outlined, 'Мои адреса', () => print("Переход в адреса")),
              _menuItem(Icons.credit_card, 'Мои карты', () => print("Переход в карты")),
              _menuItem(Icons.settings_outlined, 'Настройки', () => print("Переход в настройки")),

              const SizedBox(height: 40),
              const Text('Контакты:', style: TextStyle(fontWeight: FontWeight.bold)),
              const Text('0-800-000-000\n0-800-000-000'),
              const SizedBox(height: 10),
              const Text('Адрес: г. Николаев', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  // Кнопка с колбэком onTap
  Widget _authButton(String title, bool isFilled, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isFilled ? const Color(0xFFA5131C) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: isFilled ? null : Border.all(color: const Color(0xFFA5131C)),
          ),
          child: Text(title, style: TextStyle(color: isFilled ? Colors.white : const Color(0xFFA5131C), fontWeight: FontWeight.bold, fontSize: 12)),
        ),
      ),
    );
  }

  // Элемент списка с колбэком onTap
  Widget _menuItem(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey.shade700),
            const SizedBox(width: 16),
            Text(title, style: const TextStyle(fontSize: 16)),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}