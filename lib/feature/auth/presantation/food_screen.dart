// --- ЭКРАН С НИЖНЕЙ ПАНЕЛЬЮ НАВИГАЦИИ ---
import 'package:flutter/material.dart';

import '../../../core/menu_screen.dart';
import '../../../core/profail_screen.dart';
import '../../../main.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  // Список экранов для переключения
  final List<Widget> _screens = [
    const HomeScreen(),
    const Center(child: Text("Экран поиска", style: TextStyle(fontSize: 20))),
    const QrScanScreen(), // <-- НАШ НОВЫЙ ЭКРАН (Индекс 2)
    CartScreen(key: UniqueKey()),
    const ProfileScreen(),
    const Center(
      child: Text("Экран избранного", style: TextStyle(fontSize: 20)),
    ),
    const Center(child: Text("Экран профиля", style: TextStyle(fontSize: 20))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // Магия переключения экранов
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primaryRed,
          borderRadius: BorderRadius.circular(30),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(0.4),
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner, size: 28),
              label: '',
            ),
            // Иконка QR
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}

// --- ГЛАВНЫЙ ЭКРАН (HOME SCREEN) ---
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Красная шапка с закруглением
          Container(
            padding: const EdgeInsets.only(
              top: 60,
              left: 20,
              right: 20,
              bottom: 30,
            ),
            decoration: const BoxDecoration(
              color: AppColors.primaryRed,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundImage: NetworkImage(
                            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=150',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Deliver to',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            Row(
                              children: const [
                                Icon(
                                  Icons.location_on,
                                  color: AppColors.accentYellow,
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Los Angeles, CA',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Строка поиска
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(25),
                          ),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.search, color: AppColors.textLight),
                            SizedBox(width: 10),
                            Text(
                              'Search for restaurants, cuisines...',
                              style: TextStyle(color: AppColors.textLight),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      decoration: const BoxDecoration(
                        color: AppColors.accentYellow,
                        borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(25),
                        ),
                      ),
                      child: const Icon(
                        Icons.tune,
                        color: AppColors.primaryRed,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Эксклюзивные предложения
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Exclusive Deals',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'See All',
                  style: TextStyle(
                    color: AppColors.primaryRed,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF5E1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Get 25% OFF',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text('On your first order'),
                        const SizedBox(height: 8),
                        const Text(
                          'Use code: TASTY25',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryRed,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryRed,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'Order Now',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Image.network(
                    'https://cdn-icons-png.flaticon.com/512/3132/3132693.png',
                    width: 100,
                    height: 100,
                  ), // Placeholder пиццы
                ],
              ),
            ),
          ),

          const SizedBox(height: 25),

          // Категории
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Browse Categories',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'See All',
                  style: TextStyle(
                    color: AppColors.primaryRed,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _buildCategoryItem(Icons.local_pizza, 'Pizza', true),
                _buildCategoryItem(Icons.lunch_dining, 'Burgers', false),
                _buildCategoryItem(Icons.set_meal, 'Sushi', false),
                _buildCategoryItem(Icons.cake, 'Desserts', false),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // Популярные рестораны
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Popular Restaurants',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'See All',
                  style: TextStyle(
                    color: AppColors.primaryRed,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _buildRestaurantCard(
                  context,
                  'Burger House',
                  'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=300',
                  '4.6',
                  '30-40 min',
                ),
                const SizedBox(width: 15),
                // ПЕРЕХОД НА ЭКРАН ДЕТАЛЕЙ ПРИ НАЖАТИИ
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DetailScreen(),
                      ),
                    );
                  },
                  child: _buildRestaurantCard(
                    context,
                    'Pasta Palace',
                    'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?auto=format&fit=crop&w=300',
                    '4.8',
                    '25-35 min',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 80), // Отступ для нижней панели
        ],
      ),
    );
  }

  // Модульный виджет для категории
  Widget _buildCategoryItem(IconData icon, String title, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryRed : Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : AppColors.primaryRed,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  // Модульный виджет для карточки ресторана
  Widget _buildRestaurantCard(
    BuildContext context,
    String title,
    String imageUrl,
    String rating,
    String time,
  ) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(
              imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: AppColors.accentYellow,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          rating,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Text(
                      time,
                      style: const TextStyle(color: AppColors.textLight),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- ЭКРАН ДЕТАЛЕЙ (DETAIL SCREEN) ---
class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int quantity = 1;
  String selectedPortion = 'Regular';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: AppColors.primaryRed),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Главное изображение еды
            Center(
              child: ClipOval(
                child: Image.network(
                  'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?auto=format&fit=crop&w=400',
                  height: 250,
                  width: 250,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Миниатюры
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildThumbnail(
                  'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?auto=format&fit=crop&w=100',
                  true,
                ),
                const SizedBox(width: 10),
                _buildThumbnail(
                  'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?auto=format&fit=crop&w=100',
                  false,
                ),
                const SizedBox(width: 10),
                _buildThumbnail(
                  'https://images.unsplash.com/photo-1595295333158-4742f28fbd85?auto=format&fit=crop&w=100',
                  false,
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Название и рейтинг
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Italian',
                        style: TextStyle(color: AppColors.textLight),
                      ),
                      Row(
                        children: const [
                          Icon(
                            Icons.star,
                            color: AppColors.accentYellow,
                            size: 20,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '4.8',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            ' (2.3K)',
                            style: TextStyle(color: AppColors.textLight),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Creamy Alfredo Pasta',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Fettuccine pasta with grilled chicken in a rich alfredo sauce.',
                    style: TextStyle(color: AppColors.textLight, height: 1.5),
                  ),

                  const SizedBox(height: 20),

                  // Инфо о ресторане
                  // Инфо о ресторане
                  const Text(
                    'Restaurant',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
// Оборачиваем Row в InkWell, чтобы вся область стала кликабельной
                  InkWell(
                    onTap:  () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const MainNavigationScreens()),
                            (route) => false, // Удаляет все экраны из истории
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0), // Добавим немного отступов для удобства нажатия
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 25,
                            backgroundColor: AppColors.primaryRed,
                            child: Icon(Icons.restaurant, color: Colors.white),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Pasta Palace',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Italian Cuisine • \$\$\$',
                                  style: TextStyle(
                                    color: AppColors.textLight,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Кнопки остаются отдельными, они не будут перекрыты InkWell
                          IconButton(
                            icon: const Icon(Icons.menu_book),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.phone_outlined),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Выбор порции (Интерактивный)
                  const Text(
                    'Select Portion',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildPortionOption('Regular', '\$10.99'),
                      _buildPortionOption('Large', '\$14.99'),
                      _buildPortionOption('Family', '\$18.99'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Нижняя панель (Добавить в корзину)
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Кнопки количества
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        if (quantity > 1) setState(() => quantity--);
                      },
                    ),
                    Text(
                      '$quantity',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: AppColors.primaryRed),
                      onPressed: () => setState(() => quantity++),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              // Кнопка корзины
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Added $quantity $selectedPortion portion(s) to cart!',
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Add to Cart  \$10.99',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Виджет для миниатюр еды
  Widget _buildThumbnail(String imageUrl, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? AppColors.primaryRed : Colors.transparent,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          imageUrl,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // Виджет для выбора порции с обновлением стейта
  Widget _buildPortionOption(String title, String price) {
    bool isSelected = selectedPortion == title;
    return GestureDetector(
      onTap: () => setState(() => selectedPortion = title),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryRed.withOpacity(0.1)
              : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppColors.primaryRed : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? AppColors.primaryRed : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              price,
              style: TextStyle(color: AppColors.textLight, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  bool _isFlashOn = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // 1. Шапка профиля (такая же, как на главной)
          Container(
            padding: const EdgeInsets.only(
              top: 60,
              left: 20,
              right: 20,
              bottom: 30,
            ),
            decoration: const BoxDecoration(
              color: AppColors.primaryRed,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundImage: NetworkImage(
                            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=150',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Deliver to',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            Row(
                              children: const [
                                Icon(
                                  Icons.location_on,
                                  color: AppColors.accentYellow,
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Los Angeles, CA',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(25),
                          ),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.search, color: AppColors.textLight),
                            SizedBox(width: 10),
                            Text(
                              'Search for restaurants...',
                              style: TextStyle(color: AppColors.textLight),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      decoration: const BoxDecoration(
                        color: AppColors.accentYellow,
                        borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(25),
                        ),
                      ),
                      child: const Icon(
                        Icons.tune,
                        color: AppColors.primaryRed,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // 2. Зона видоискателя сканера
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F4),
                borderRadius: BorderRadius.circular(35),
              ),
              child: Column(
                children: [
                  // Кнопки фонарика и галереи
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          _isFlashOn ? Icons.flash_on : Icons.flash_off,
                          color: _isFlashOn
                              ? AppColors.accentYellow
                              : AppColors.textDark,
                          size: 28,
                        ),
                        onPressed: () {
                          setState(() => _isFlashOn = !_isFlashOn);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                _isFlashOn
                                    ? 'Фонарик включен 🔦'
                                    : 'Фонарик выключен',
                              ),
                              duration: const Duration(milliseconds: 500),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.image_outlined,
                          color: AppColors.textDark,
                          size: 28,
                        ),
                        onPressed: () =>
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Открытие галереи... 🖼️'),
                              ),
                            ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Рамка сканера с QR кодом внутри
                  SizedBox(
                    width: 220,
                    height: 220,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Сам QR-код (Генерируется через интернет)
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Image.network(
                            'https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=TastyAppMenu2026',
                          ),
                        ),
                        // // 4 прицельных уголка
                        // Positioned(
                        //   top: 0,
                        //   left: 0,
                        //   child: buildCorner(isTop: true, isLeft: true),
                        // ),
                        // Positioned(
                        //   top: 0,
                        //   right: 0,
                        //   child: buildCorner(isTop: true, isLeft: false),
                        // ),
                        // Positioned(
                        //   bottom: 0,
                        //   left: 0,
                        //   child: buildCorner(
                        //     isTop:
                        //         'Normally I can help with things like this, but I don t seem to have access to that content.You can try again or ask me for something else.',
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
