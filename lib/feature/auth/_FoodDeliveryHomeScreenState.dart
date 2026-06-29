

import 'package:flutter/material.dart';

// Основная палитра приложения для точного попадания в дизайн
class FoodAppColors {
  static const Color burgundy = Color(0xFF7D1926); // Насыщенный бордовый
  static const Color amber = Color(0xFFFFC41D);    // Яркий желтый для фильтра
  static const Color lightCream = Color(0xFFFFF5E6); // Крем-бэкграунд для баннера
  static const Color bgGrey = Color(0xFFF9F9F9);    // Светлый фон экрана
  static const Color textDark = Color(0xFF212121);
  static const Color textGrey = Color(0xFF8D8D8D);
}

class FoodDeliveryHomeScreen extends StatefulWidget {
  const FoodDeliveryHomeScreen({super.key});

  @override
  State<FoodDeliveryHomeScreen> createState() => _FoodDeliveryHomeScreenState();
}

class _FoodDeliveryHomeScreenState extends State<FoodDeliveryHomeScreen> {
  // Состояния для интерактивных элементов
  int _selectedCategoryIndex = 0;
  int _selectedNavIndex = 0;
  String _selectedLocation = "Los Angeles, CA";

  // Данные категорий
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Pizza', 'icon': Icons.local_pizza},
    {'name': 'Burgers', 'icon': Icons.lunch_dining},
    {'name': 'Sushi', 'icon': Icons.set_meal},
    {'name': 'Desserts', 'icon': Icons.cake},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FoodAppColors.bgGrey,
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Бордовая верхняя панель (Шапка + Поиск)
                _buildHeader(),

                const SizedBox(height: 24),

                // 2. Секция Exclusive Deals
                _buildSectionTitle("Exclusive Deals"),
                const SizedBox(height: 12),
                _buildExclusiveDealsBanner(),

                const SizedBox(height: 24),

                // 3. Секция Browse Categories
                _buildSectionTitle("Browse Categories"),
                const SizedBox(height: 16),
                _buildCategoriesList(),

                const SizedBox(height: 24),

                // 4. Секция Popular Restaurants
                _buildSectionTitle("Popular Restaurants"),
                const SizedBox(height: 12),
                _buildPopularRestaurantsList(),

                // Отступ снизу, чтобы контент не перекрывался плавающим Bottom Nav Bar
                const SizedBox(height: 100),
              ],
            ),
          ),

          // 5. Кастомный закругленный Bottom Navigation Bar
          _buildBottomNavigationBar(),
        ],
      ),
    );
  }

  // Виджет верхней бордовой панели
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: FoodAppColors.burgundy,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(40),
        ),
      ),
      padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 32),
      child: Column(
        children: [
          // Профиль, Локация и Уведомления
          Row(
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Deliver to",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    GestureDetector(
                      onTap: () => _showLocationPicker(),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, color: FoodAppColors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            _selectedLocation,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.notifications_none, color: Colors.white),
                  onPressed: () => _showSnackBar("Уведомления открыты"),
                ),
              )
            ],
          ),
          const SizedBox(height: 28),

          // Поле поиска интегрированное с фильтром
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 52,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.horizontal(left: Radius.circular(16)),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: "Search for restaurants, cuisines...",
                      hintStyle: TextStyle(color: FoodAppColors.textGrey, fontSize: 14),
                      prefixIcon: Icon(Icons.search, color: FoodAppColors.textGrey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _showSnackBar("Фильтры поиска нажаты"),
                child: Container(
                  height: 52,
                  width: 55,
                  decoration: const BoxDecoration(
                    color: FoodAppColors.amber,
                    borderRadius: BorderRadius.horizontal(right: Radius.circular(16)),
                  ),
                  child: const Icon(Icons.tune, color: FoodAppColors.burgundy),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // Заголовки секций с интерактивной кнопкой "See All"
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: FoodAppColors.textDark),
          ),
          GestureDetector(
            onTap: () => _showSnackBar('Показать всё для: $title'),
            child: const Text(
              "See All",
              style: TextStyle(color: FoodAppColors.burgundy, fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  // Желтый промо-баннер
  Widget _buildExclusiveDealsBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: FoodAppColors.lightCream,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Get 25% OFF", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: FoodAppColors.textDark)),
                const SizedBox(height: 4),
                const Text("On your first order", style: TextStyle(fontSize: 14, color: FoodAppColors.textGrey)),
                const SizedBox(height: 8),
                const Text("Use code: TASTY25", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: FoodAppColors.burgundy)),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: FoodAppColors.burgundy,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    elevation: 0,
                  ),
                  onPressed: () => _showSnackBar("Применение скидки..."),
                  child: const Text("Order Now", style: TextStyle(fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Image.network(
              'https://cdn-icons-png.flaticon.com/512/3132/3132693.png', // Прозрачный графический плейсхолдер пиццы
              fit: BoxFit.contain,
              errorBuilder: (c, e, s) => const Icon(Icons.local_pizza, size: 80, color: FoodAppColors.amber),
            ),
          )
        ],
      ),
    );
  }

  // Список категорий с изменением состояния по тапу
  Widget _buildCategoriesList() {
    return SizedBox(
      height: 95,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedCategoryIndex == index;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategoryIndex = index;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: isSelected ? FoodAppColors.burgundy : Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Icon(
                      _categories[index]['icon'],
                      color: isSelected ? Colors.white : FoodAppColors.burgundy,
                      size: 26,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _categories[index]['name'],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? FoodAppColors.burgundy : FoodAppColors.textDark,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  // Горизонтальная лента популярных ресторанов
  Widget _buildPopularRestaurantsList() {
    final List<String> restaurantImages = [
      'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=400', // Бургерная
      'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?q=80&w=400', // Паста
    ];

    return SizedBox(
      height: 140,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: restaurantImages.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _showSnackBar("Переход к ресторану #${index + 1}"),
            child: Container(
              width: 200,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: NetworkImage(restaurantImages[index]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Плавающий навигационный бар (Floating Bottom Navigation)
  Widget _buildBottomNavigationBar() {
    final List<IconData> navIcons = [
      Icons.home_filled,
      Icons.search,
      Icons.qr_code_scanner,
      Icons.shopping_cart_outlined,
      Icons.person_outline,
    ];

    return Positioned(
      left: 24,
      right: 24,
      bottom: 24,
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          color: FoodAppColors.burgundy,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: FoodAppColors.burgundy.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(navIcons.length, (index) {
            final isSelected = _selectedNavIndex == index;
            return IconButton(
              icon: Icon(navIcons[index]),
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
              iconSize: isSelected ? 28 : 24,
              onPressed: () {
                setState(() {
                  _selectedNavIndex = index;
                });
                _showSnackBar("Раздел меню: ${navIcons[index].toString()}");
              },
            );
          }),
        ),
      ),
    );
  }

  // Быстрый выбор локации
  void _showLocationPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        final cities = ["Los Angeles, CA", "New York, NY", "Chicago, IL", "San Francisco, CA"];
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Select Delivery Location", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ...cities.map((city) => ListTile(
                title: Text(city),
                leading: const Icon(Icons.map, color: FoodAppColors.burgundy),
                onTap: () {
                  setState(() => _selectedLocation = city);
                  Navigator.pop(context);
                },
              )),
            ],
          ),
        );
      },
    );
  }

  // Универсальный быстрый вывод обратной связи при кликах
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 110, left: 24, right: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}