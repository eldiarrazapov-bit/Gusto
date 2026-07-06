


import 'package:flutter/material.dart';

import '../main.dart';

class MainWrapperr extends StatefulWidget {
  const MainWrapperr({super.key});

  @override
  State<MainWrapperr> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapperr> {
  int _currentIndex = 0; // 0: Menu, 1: Cart, 2: Orders, 3: Profile

  late List<Product> _products;

  @override
  void initState() {
    super.initState();
    // Наш общий стейт товаров для Меню и Корзины
    _products = [
      Product(
        id: '1',
        name: 'Классический...',
        description: 'Говяжья котлета, чеддер...',
        price: 450,
        rating: 4.8,
        imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500',
        quantity: 1,
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
        quantity: 2,
      ),
    ];
  }

  void _updateQuantity(String id, int delta) {
    setState(() {
      final product = _products.firstWhere((p) => p.id == id);
      product.quantity = (product.quantity + delta).clamp(0, 99);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProducts = _products.where((p) => p.quantity > 0).toList();

    // ТЕПЕРЬ ТВОЙ ProfileScreen ПОДКЛЮЧЕН СЮДА (Индекс 3)
    final List<Widget> screens = [
      MenuScreen(products: _products, onQuantityChanged: _updateQuantity),
      CartScreen(cartProducts: cartProducts, onQuantityChanged: _updateQuantity),
      const Center(child: Text('История заказов', style: TextStyle(color: kDarkText, fontSize: 18))),
      const ProfileScreen(), // Твой экран профиля
    ];

    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: screens,
          ),
          // Нижний плавающий бар навигации
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
          _buildNavItem(1, Icons.shopping_bag_outlined, 'Cart'),
          _buildNavItem(2, Icons.qr_code_scanner_sharp, 'Orders'),
          _buildNavItem(3, Icons.person_outline, 'Profile'), // Ведет на ProfileScreen
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index; // Переключает экраны при клике
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
            Icon(icon, color: isSelected ? Colors.white : Colors.grey[600], size: 22),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

// ==========================================
// --- ЭКРАН ТВОЕГО ПРОФИЛЯ (PROFILE) ---
// ==========================================
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text('Профиль', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: kDarkText)),
              const SizedBox(height: 30),

              Row(
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Color(0xFFEEEEEE),
                    child: Icon(Icons.person, size: 40, color: Colors.grey),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Row(
                      children: [
                        _authButton('Регистрация', true, () => print("Нажата Регистрация")),
                        const SizedBox(width: 10),
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
              const Text('Контакты:', style: TextStyle(fontWeight: FontWeight.bold, color: kDarkText)),
              const SizedBox(height: 4),
              const Text('0-800-000-000\n0-800-000-000', style: TextStyle(height: 1.3)),
              const SizedBox(height: 12),
              const Text('Адрес: г. Николаев', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 100), // Отступ, чтобы контент не перекрывался баром навигации
            ],
          ),
        ),
      ),
    );
  }

  // Кнопка авторизации с цветами бренда CRAVE
  Widget _authButton(String title, bool isFilled, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isFilled ? kBrandBrown : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: isFilled ? null : Border.all(color: kBrandBrown),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: isFilled ? Colors.white : kBrandBrown,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _menuItem(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey.shade700),
            const SizedBox(width: 16),
            Text(title, style: const TextStyle(fontSize: 16, color: kDarkText)),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

// Вспомогательный метод для отображения диалога входа
void showAuthDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Авторизация'),
      content: const Text('Окно входа в систему CRAVE'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Закрыть', style: TextStyle(color: kBrandBrown)),
        ),
      ],
    ),
  );
}

// ==========================================
// --- ЭКРАН МЕНЮ (MENU SCREEN) ---
// ==========================================
class MenuScreen extends StatefulWidget {
  final List<Product> products;
  final Function(String, int) onQuantityChanged;

  const MenuScreen({super.key, required this.products, required this.onQuantityChanged});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _selectedCategoryIndex = 1;
  final List<String> _categories = ['Все', 'Бургеры', 'Закуски', 'Напитки'];

  @override
  Widget build(BuildContext context) {
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
          SliverToBoxAdapter(
            child: const Center(
              child: Text('CRAVE', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 1.2, color: kBrandBrown)),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          _buildSearchBar(),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          _buildCategorySelector(),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          _buildGrid(filteredProducts),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
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
        delegate: SliverChildBuilderDelegate(
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

// ==========================================
// --- ЭКРАН КОРЗИНЫ (CART SCREEN) ---
// ==========================================
class CartScreen extends StatelessWidget {
  final List<Product> cartProducts;
  final Function(String, int) onQuantityChanged;

  const CartScreen({super.key, required this.cartProducts, required this.onQuantityChanged});

  @override
  Widget build(BuildContext context) {
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
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cartProducts.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) => _buildCartItem(cartProducts[index]),
                  ),
                  const SizedBox(height: 24),
                  _buildPromoCodeSection(),
                  const SizedBox(height: 24),
                  _buildOrderDetails(totalSum),
                  const SizedBox(height: 24),
                  _buildCheckoutButton(),
                  const SizedBox(height: 90),
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
          //const Icon(Icons.menu, color: kBrandBrown),
          const Text('CRAVE', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: kBrandBrown, letterSpacing: 1.2)),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: kBrandBrown, width: 1.5)),
            //child: const Icon(Icons.person, color: kBrandBrown, size: 16),
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