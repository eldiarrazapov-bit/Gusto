

import 'package:flutter/material.dart';

import '../main.dart';

class MainWrappers extends StatefulWidget {
  const MainWrappers({super.key});

  @override
  State<MainWrappers> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrappers> {
  int _currentIndex = 0; // По умолчанию открываем первый экран (Menu)

  // Общий список товаров (State) для обоих экранов
  late List<Product> _products;

  @override
  void initState() {
    super.initState();
    // Инициализируем мок-данные из обоих макетов
    _products = [
      Product(
        id: '1',
        name: 'Классический...',
        description: 'Говяжья котлета, чеддер...',
        price: 450,
        rating: 4.8,
        imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500',
        quantity: 1, // Имитируем, что уже в корзине (как на 2-м макете)
      ),
      Product(
        id: '2',
        name: 'BBQ Бекон...',
        description: 'Двойная котлета, хрустящий бекон...',
        price: 520,
        rating: 4.9,
        imageUrl: 'https://images.unsplash.com/photo-1586190848861-99aa4a171e90?w=500',
      ),
      Product(
        id: '3',
        name: 'Чикен Бургер',
        description: 'Хрустящее куриное филе, салат айсберг...',
        price: 390,
        rating: 4.6,
        imageUrl: 'https://images.unsplash.com/photo-1610440042657-612cbb401524?w=500',
      ),
      Product(
        id: '4',
        name: 'Картошка фри',
        description: 'Стандартная порция',
        price: 150,
        rating: 4.7,
        imageUrl: 'https://images.unsplash.com/photo-1576107232684-1279f390859f?w=500',
        quantity: 2, // Имитируем, что две порции в корзине (как на 2-м макете)
      ),
    ];
  }

  // Колбэк для изменения количества товара из любого дочернего экрана
  void _updateQuantity(String id, int delta) {
    setState(() {
      final product = _products.firstWhere((p) => p.id == id);
      product.quantity = (product.quantity + delta).clamp(0, 99);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Динамически получаем только те товары, которые добавлены в корзину (quantity > 0)
    final cartProducts = _products.where((p) => p.quantity > 0).toList();

    // Список экранов, в которые прокидываем стейт и функции изменения
    final List<Widget> screens = [
      MenuScreen(products: _products, onQuantityChanged: _updateQuantity),
      CartScreen(cartProducts: cartProducts, onQuantityChanged: _updateQuantity),
      const Center(child: Text('История заказов', style: TextStyle(color: kDarkText))),
      const Center(child: Text('Профиль', style: TextStyle(color: kDarkText))),
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Отображаем текущий экран на основе индекса
          IndexedStack(
            index: _currentIndex,
            children: screens,
          ),

          // Плавающий Bottom Navigation Bar из макета
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: _buildFloatingBottomBar(),
          ),
        ],
      ),
    );
  }

  // Навигационная панель
  Widget _buildFloatingBottomBar() {
    return Container(
      height: 66,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFEFEF),
        borderRadius: BorderRadius.circular(33),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavItem(0, Icons.restaurant_menu, 'Menu'),
          _buildNavItem(2, Icons.qr_code_scanner_sharp, 'qr'),
          _buildNavItem(1, Icons.shopping_bag_outlined, 'Cart'),
          _buildNavItem(3, Icons.person_outline, 'Profile'),
        ],
      ),
    );
  }

  // ТОТ САМЫЙ МЕТОД, КОТОРЫЙ ТЕПЕРЬ СОЕДИНЯЕТ ЭКРАНЫ
  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index; // Переключаем индекс экрана при тапе
        });
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: isSelected
            ? const EdgeInsets.symmetric(horizontal: 16, vertical: 10)
            : const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? kActiveOrange : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[600],
              size: 22,
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

// ==========================================
// --- ЭКРАН 1: МЕНЮ (ИЗ ПЕРВОГО МАКЕТА) ---
// ==========================================
class MenuScreen extends StatefulWidget {
  final List<Product> products;
  final Function(String, int) onQuantityChanged;

  const MenuScreen({
    super.key,
    required this.products,
    required this.onQuantityChanged,
  });

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _selectedCategoryIndex = 1; // "Бургеры" по умолчанию
  final List<String> _categories = ['Все', 'Бургеры', 'Закуски', 'Напитки'];

  @override
  Widget build(BuildContext context) {
    // Фильтруем (для примера картошка фри будет в "Закусках", бургеры в "Бургерах")
    List<Product> filteredProducts = widget.products;
    if (_selectedCategoryIndex == 1) {
      filteredProducts = widget.products.where((p) => p.name.contains('Бургер') || p.name.contains('Классический') || p.name.contains('BBQ')).toList();
    } else if (_selectedCategoryIndex == 2) {
      filteredProducts = widget.products.where((p) => p.name.contains('Картошка')).toList();
    }

    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          _buildHeader(),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          _buildSearchBar(),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          _buildCategorySelector(),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          _buildGrid(filteredProducts),
          const SliverToBoxAdapter(child: SizedBox(height: 100)), // Отступ под бар
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const SliverToBoxAdapter(
      child: Center(
        child: Text(
          'CRAVE',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 1.2, color: kBrandBrown),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          height: 48,
          decoration: BoxDecoration(color: kGreyBg, borderRadius: BorderRadius.circular(12)),
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
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? kDarkText : kGreyBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _categories[index],
                  style: TextStyle(color: isSelected ? Colors.white : kDarkText, fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGrid(List<Product> items) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.60,
        ),
        delegate: SliverChildBuilderDelegate( // <-- Заменил dynamicDelegate на delegate
              (context, index) => _buildProductCard(items[index]),
          childCount: items.length,
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                  child: Image.network(product.imageUrl, width: double.infinity, height: double.infinity, fit: BoxFit.cover),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 12),
                        const SizedBox(width: 2),
                        Text(product.rating.toString(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1),
                const SizedBox(height: 2),
                Text(product.description, style: TextStyle(fontSize: 11, color: Colors.grey[600]), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${product.price.toInt()} ₽', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: kBrandBrown)),
                    _buildAddOrInlineQtyButton(product),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAddOrInlineQtyButton(Product product) {
    if (product.quantity == 0) {
      return InkWell(
        onTap: () => widget.onQuantityChanged(product.id, 1),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(color: kBrandBrown, borderRadius: BorderRadius.circular(10)),
          child: const Icon(Icons.add, color: Colors.white, size: 18),
        ),
      );
    }
    return Container(
      height: 32,
      decoration: BoxDecoration(color: kActiveOrange, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          InkWell(
            onTap: () => widget.onQuantityChanged(product.id, -1),
            child: const Padding(padding: EdgeInsets.symmetric(horizontal: 6), child: Icon(Icons.remove, color: Colors.white, size: 14)),
          ),
          Text('${product.quantity}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
          InkWell(
            onTap: () => widget.onQuantityChanged(product.id, 1),
            child: const Padding(padding: EdgeInsets.symmetric(horizontal: 6), child: Icon(Icons.add, color: Colors.white, size: 14)),
          ),
        ],
      ),
    );
  }
}

// ===============================================
// --- ЭКРАН 2: КОРЗИНА (ИЗ ВТОРОГО МАКЕТА) ---
// ===============================================
class CartScreen extends StatelessWidget {
  final List<Product> cartProducts;
  final Function(String, int) onQuantityChanged;

  const CartScreen({
    super.key,
    required this.cartProducts,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Вычисляем сумму динамически на основе переданного стейта
    double totalSum = cartProducts.fold(0, (sum, item) => sum + (item.price * item.quantity));

    return SafeArea(
      child: Column(
        children: [
          _buildCustomAppBar(),
          Expanded(
            child: cartProducts.isEmpty
                ? const Center(child: Text('Ваша корзина пуста', style: TextStyle(color: Colors.grey, fontSize: 16)))
                : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Ваша Корзина', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: kDarkText)),
                  const SizedBox(height: 16),

                  // Рендерим список товаров в корзине
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cartProducts.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final product = cartProducts[index];
                      return _buildCartItem(product);
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildPromoCodeSection(),
                  const SizedBox(height: 24),
                  _buildOrderDetails(totalSum),
                  const SizedBox(height: 24),
                  _buildCheckoutButton(),
                  const SizedBox(height: 90), // Чтобы нижний плавающий бар не перекрывал кнопку оформления
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.menu, color: kBrandBrown),
          const Text('CRAVE', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: kBrandBrown, letterSpacing: 1.2)),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: kBrandBrown, width: 1.5)),
            child: const Icon(Icons.person, color: kBrandBrown, size: 16),
          )
        ],
      ),
    );
  }

  Widget _buildCartItem(Product product) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(product.imageUrl, width: 70, height: 70, fit: BoxFit.cover),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(product.description, style: TextStyle(color: Colors.grey[600], fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                Text('${product.price.toInt()} ₽', style: const TextStyle(fontWeight: FontWeight.w800, color: kBrandBrown, fontSize: 14)),
              ],
            ),
          ),
          // Вертикальный контроллер изменения счетчика из Корзины
          Container(
            decoration: BoxDecoration(color: kBgColor, borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                InkWell(
                  onTap: () => onQuantityChanged(product.id, 1),
                  child: const Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6), child: Icon(Icons.add, size: 16, color: kDarkText)),
                ),
                Text('${product.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                InkWell(
                  onTap: () => onQuantityChanged(product.id, -1),
                  child: const Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6), child: Icon(Icons.remove, size: 16, color: kDarkText)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPromoCodeSection() {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 6, top: 6, bottom: 6),
      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          const Icon(Icons.local_offer_outlined, color: Colors.grey, size: 20),
          const SizedBox(width: 8),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(hintText: 'Введите промокод', border: InputBorder.none, isDense: true, hintStyle: TextStyle(fontSize: 14)),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2C2C2C), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 0),
            child: const Text('Применить', style: TextStyle(color: Colors.white, fontSize: 13)),
          )
        ],
      ),
    );
  }

  Widget _buildOrderDetails(double totalSum) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Детали заказа', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Сумма заказа', style: TextStyle(color: Colors.grey[700], fontSize: 14)), Text('${totalSum.toInt()} ₽', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14))]),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Доставка', style: TextStyle(color: Colors.grey[700], fontSize: 14)), const Text('0 ₽', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14))]),
          const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(color: Color(0xFFEEEEEE), thickness: 1)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Итого', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text('${totalSum.toInt()} ₽', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: kBrandBrown)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCheckoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(backgroundColor: kBrandBrown, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Оформить заказ', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }
}