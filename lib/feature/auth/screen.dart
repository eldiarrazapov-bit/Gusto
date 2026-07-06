import 'package:flutter/material.dart';
class PlaceholderMenuScreen extends StatelessWidget {
  const PlaceholderMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Экран Меню (Из предыдущего промпта)',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}

class Burger {
  final String id;
  final String name;
  final String description;
  final double price;
  final double rating;
  final String imageUrl;
  int quantity;

  Burger({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.imageUrl,
    this.quantity = 0,
  });
}

class CraveHomeScreen extends StatefulWidget {
  const CraveHomeScreen({super.key});

  @override
  State<CraveHomeScreen> createState() => _CraveHomeScreenState();
}

class _CraveHomeScreenState extends State<CraveHomeScreen> {
  // Цветовая палитра из макета
  static const Color kBrandBrown = Color(0xFF9E4216);
  static const Color kActiveOrange = Color(0xFFFF6600);
  static const Color kGreyBg = Color(0xFFEAEAEA);
  static const Color kDarkText = Color(0xFF1E1E1E);

  int _selectedCategoryIndex = 1; // "Бургеры" выбраны по умолчанию
  int _selectedNavIndex = 0;

  final List<String> _categories = [
    'Все',
    'Бургеры',
    'Закуски',
    'Напитки',
    'Десерты',
  ];

  // Мок-данные в точности по макету
  final List<Burger> _burgers = [
    Burger(
      id: '1',
      name: 'Классический...',
      description: 'Говяжья котлета, чеддер...',
      price: 450,
      rating: 4.8,
      imageUrl:
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500',
    ),
    Burger(
      id: '2',
      name: 'BBQ Бекон...',
      description: 'Двойная котлета, хрустящий бекон...',
      price: 520,
      rating: 4.9,
      quantity: 1,
      // Имитируем уже добавленный товар
      imageUrl:
          'https://images.unsplash.com/photo-1586190848861-99aa4a171e90?w=500',
    ),
    Burger(
      id: '3',
      name: 'Чикен Бургер',
      description: 'Хрустящее куриное филе, салат айсберг...',
      price: 390,
      rating: 4.6,
      imageUrl:
          'https://images.unsplash.com/photo-1610440042657-612cbb401524?w=500',
    ),
    Burger(
      id: '4',
      name: 'Грибной Свис...',
      description: 'Говяжья котлета, обжаренные грибы...',
      price: 580,
      rating: 4.7,
      imageUrl:
          'https://images.unsplash.com/photo-1553979459-d2229ba7433b?w=500',
    ),
  ];

  ScrollController? get scrollController => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
                _buildHeader(),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                _buildSearchBar(),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                _buildCategorySelector(),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                _buildGrid(),
                // Отступ снизу, чтобы контент не перекрывался плавающим BottomBar
                const SliverToBoxAdapter(child: SizedBox(height: 110)),
              ],
            ),

            // Плавающий Bottom Navigation Bar
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: _buildFloatingBottomBar(),
            ),
          ],
        ),
      ),
    );
  }

  // --- ШАПКА ---
  Widget _buildHeader() {
    return const SliverToBoxAdapter(
      child: Center(
        child: Text(
          'CRAVE',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            color: kBrandBrown,
          ),
        ),
      ),
    );
  }

  // --- ПОИСК ---
  Widget _buildSearchBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: kGreyBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              hintText: 'Поиск блюд...',
              hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
              prefixIcon: Icon(Icons.search, color: Colors.grey[600], size: 22),
              border: InputBorder.none,
              isCollapsed: true,
            ),
          ),
        ),
      ),
    );
  }

  // --- ГОРИЗОНТАЛЬНЫЕ КАТЕГОРИИ ---
  Widget _buildCategorySelector() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 38,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          itemCount: _categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final isSelected = _selectedCategoryIndex == index;
            return GestureDetector(
              onTap: () => setState(() => _selectedCategoryIndex = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? kDarkText : kGreyBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _categories[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : kDarkText,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // --- СЕТКА ТОВАРОВ ---
  Widget _buildGrid() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.62, // Пропорция карточки из макета
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => _buildBurgerCard(_burgers[index]),
          childCount: _burgers.length,
        ),
      ),
    );
  }

  // --- КАРТОЧКА БУРГЕРА ---
  Widget _buildBurgerCard(Burger burger) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Блок с картинкой и рейтингом
          Expanded(
            flex: 12,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                  child: Container(
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: Image.network(
                      burger.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.fastfood, color: Colors.grey),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 13),
                        const SizedBox(width: 3),
                        Text(
                          burger.rating.toString(),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Блок с текстом и ценой
          Expanded(
            flex: 11,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        burger.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        burger.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${burger.price.toInt()} ₽',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: kBrandBrown,
                        ),
                      ),
                      _buildActionBtn(burger),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- КНОПКА ТОВАРА (2 состояния) ---
  Widget _buildActionBtn(Burger burger) {
    if (burger.quantity == 0) {
      return InkWell(
        onTap: () => setState(() => burger.quantity = 1),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: kBrandBrown,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 20),
        ),
      );
    }

    return Container(
      height: 34,
      decoration: BoxDecoration(
        color: kActiveOrange,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => setState(() => burger.quantity--),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Icon(Icons.remove, color: Colors.white, size: 16),
            ),
          ),
          Text(
            '${burger.quantity}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          InkWell(
            onTap: () => setState(() => burger.quantity++),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Icon(Icons.add, color: Colors.white, size: 16),
            ),
          ),
        ],
      ),
    );
  }

  // --- ПЛАВАЮЩАЯ НАВИГАЦИЯ ---
  Widget _buildFloatingBottomBar() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFEFEF),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavItem(0, Icons.restaurant_menu, 'Menu'),
          _buildNavItem(2, Icons.qr_code_scanner_sharp, 'Orders'),
          _buildNavItem(1, Icons.shopping_bag_outlined, 'Cart'),
          _buildNavItem(3, Icons.person_outline, 'Profile'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedNavIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedNavIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: isSelected
            ? const EdgeInsets.symmetric(horizontal: 14, vertical: 8)
            : const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? kActiveOrange : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[700],
              size: 20,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
