import 'package:flutter/material.dart';

import '../main.dart';

class MainWrappers extends StatefulWidget {
  const MainWrappers({super.key});

  @override
  State<MainWrappers> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrappers> {
  int _currentIndex = 0;
  late List<Product> _products;

  @override
  void initState() {
    super.initState();
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
        name: 'BBQ Бекон',
        description: 'Сочный бургер с говяжьей котлетой, хрустящим беконом, сыром чеддер, красным луком и фирменным соусом BBQ на карамелизированной булочке бриошь.',
        price: 489,
        rating: 4.8,
        imageUrl: 'https://images.unsplash.com/photo-1586190848861-99aa4a171e90?w=500',
      ),
      Product(
        id: '3',
        name: 'Чикен Бургер',
        description: 'Хрустящее куриное филе, салат айсберг...',
        price: 390,
        rating: 4.6,
        imageUrl: 'https://images.unsplash.com/photo-1586190848861-99aa4a171e90?w=500',
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

    final List<Widget> screens = [
      MenuScreen(products: _products, onQuantityChanged: _updateQuantity),
      CartScreen(cartProducts: cartProducts, onQuantityChanged: _updateQuantity),
      const Center(child: Text('История заказов', style: TextStyle(color: kDarkText, fontSize: 18))),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(index: _currentIndex, children: screens),
          Positioned(left: 16, right: 16, bottom: 16, child: _buildFloatingBottomBar()),
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
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 4))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavItem(0, Icons.restaurant_menu, 'Menu'),
          _buildNavItem(1, Icons.shopping_bag_outlined, 'Cart'),
          _buildNavItem(2, Icons.qr_code_scanner_sharp, 'Orders'),
          _buildNavItem(3, Icons.person_outline, 'Profile'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: isSelected ? const EdgeInsets.symmetric(horizontal: 16, vertical: 10) : const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: isSelected ? kActiveOrange : Colors.transparent, borderRadius: BorderRadius.circular(24)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.grey[600], size: 22),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
            ]
          ],
        ),
      ),
    );
  }
}

// ==========================================
// --- ЭКРАН МЕНЮ ---
// ==========================================
class MenuScreen extends StatefulWidget {
  final List<Product> products;
  final Function(String, int) onQuantityChanged;

  const MenuScreen({super.key, required this.products, required this.onQuantityChanged});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _selectedCategoryIndex = 0; // Начни с 0 (Все)
  final ScrollController _scrollController = ScrollController(); // ДОБАВЬ ЭТОТ КОНТРОЛЛЕР

  // ... остальной код
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
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          const SliverToBoxAdapter(child: Center(child: Text('CRAVE', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 1.2, color: kBrandBrown)))),
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
            decoration: InputDecoration(
              hintText: 'Поиск блюд...',
              hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
              prefixIcon: Icon(Icons.search, color: Colors.grey[600], size: 22),
              border: InputBorder.none,
              isCollapsed: true,
            ),
            textAlignVertical: TextAlignVertical.center,
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
              onTap: () {
                setState(() {
                  _selectedCategoryIndex = index;
                  _scrollController.jumpTo(0); // СБРОС СКРОЛЛА ВВЕРХ
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                decoration: BoxDecoration(color: isSelected ? kDarkText : kGreyBg, borderRadius: BorderRadius.circular(20)),
                child: Text(_categories[index], style: TextStyle(color: isSelected ? Colors.white : kDarkText, fontWeight: FontWeight.w600, fontSize: 13)),
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
        key: ValueKey(_selectedCategoryIndex), // ЭТО ЗАСТАВИТ СЕТКУ ПЕРЕРИСОВАТЬСЯ
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.60,
        ),
        delegate: SliverChildBuilderDelegate(
              (context, index) => _buildProductCard(items[index], context),
          childCount: items.length,
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product, BuildContext context) {
    // ДОБАВЛЕН GestureDetector ДЛЯ ПЕРЕХОДА НА ЭКРАН ДЕТАЛЕЙ
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              product: product,
              onAddToCart: widget.onQuantityChanged,
            ),
          ),
        );
      },
      child: Container(
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
                    top: 8, right: 8,
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
      ),
    );
  }

  Widget _buildAddOrInlineQtyButton(Product product) {
    if (product.quantity == 0) {
      return InkWell(
        onTap: () => widget.onQuantityChanged(product.id, 1),
        child: Container(
          width: 32, height: 32,
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
          InkWell(onTap: () => widget.onQuantityChanged(product.id, -1), child: const Padding(padding: EdgeInsets.symmetric(horizontal: 6), child: Icon(Icons.remove, color: Colors.white, size: 26))),
          Text('${product.quantity}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          InkWell(onTap: () => widget.onQuantityChanged(product.id, 1), child: const Padding(padding: EdgeInsets.symmetric(horizontal: 6), child: Icon(Icons.add, color: Colors.white, size: 26))),
        ],
      ),
    );
  }
}

// ==========================================
// --- НОВЫЙ ЭКРАН: ДЕТАЛИ ТОВАРА ---
// ==========================================
class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final Function(String, int) onAddToCart;

  const ProductDetailScreen({super.key, required this.product, required this.onAddToCart});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _localQuantity = 1;
  int _selectedSizeIndex = 1; // 0: Маленькая, 1: Средняя, 2: Большая

  // Список добавок из макета
  final List<Map<String, dynamic>> _addons = [
    {'name': 'Халапеньо', 'price': 59, 'checked': false, 'image': 'https://images.unsplash.com/photo-1604543501062-8cb187513df5?w=100'},
    {'name': 'Двойной сыр', 'price': 89, 'checked': false, 'image': 'https://images.unsplash.com/photo-1618164426543-7f28bc991a0c?w=100'},
    {'name': 'Свежий базилик', 'price': 39, 'checked': false, 'image': 'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=100'},
  ];

  // Подсчет итоговой цены (База + добавки) * количество
  double get _totalPrice {
    double addonsTotal = _addons.where((a) => a['checked'] == true).fold(0, (sum, a) => sum + (a['price'] as int));
    return (widget.product.price + addonsTotal) * _localQuantity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Светлый фон как на макете
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Название и Цена
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(widget.product.name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: kDarkText)),
                      ),
                      Text('₽${widget.product.price.toInt()}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: kBrandBrown)),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Рейтинг и Время
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text('${widget.product.rating} (120+ отзывов)', style: TextStyle(color: Colors.grey[700], fontSize: 13, fontWeight: FontWeight.w500)),
                      const SizedBox(width: 16),
                      Icon(Icons.access_time_outlined, color: Colors.grey[600], size: 16),
                      const SizedBox(width: 4),
                      Text('25-35 мин', style: TextStyle(color: Colors.grey[700], fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Описание
                  Text(widget.product.description, style: TextStyle(color: Colors.grey[700], height: 1.5, fontSize: 14)),
                  const SizedBox(height: 24),

                  // Выбор размера
                  const Text('Размер', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kDarkText)),
                  const SizedBox(height: 12),
                  _buildSizeSelector(),
                  const SizedBox(height: 24),

                  // Добавки
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Добавки', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kDarkText)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
                        child: Text('Опционально', style: TextStyle(fontSize: 10, color: Colors.grey[600], fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildAddonsList(),
                  const SizedBox(height: 100), // Отступ под нижнюю панель
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _buildBottomBar(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 320,
      backgroundColor: Colors.white,
      pinned: true,
      elevation: 0,
      leading: IconButton(
        icon: CircleAvatar(backgroundColor: Colors.white.withOpacity(0.9), child: const Icon(Icons.arrow_back, color: kDarkText)),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: CircleAvatar(backgroundColor: Colors.white.withOpacity(0.9), child: const Icon(Icons.favorite_border, color: Colors.grey)),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: ClipRRect(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
          child: Image.network(widget.product.imageUrl, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildSizeSelector() {
    final sizes = ['Маленькая', 'Средняя', 'Большая'];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: List.generate(sizes.length, (index) {
          final isSelected = _selectedSizeIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedSizeIndex = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF1E1E1E) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  sizes[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[700],
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildAddonsList() {
    return Column(
      children: _addons.map((addon) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Row(
            children: [
              // Обернули в ClipRRect и добавили обработку ошибок загрузки
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  addon['image'],
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  // ТАК МЫ ИСПРАВЛЯЕМ OVERFLOW И 404:
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 40,
                      height: 40,
                      color: Colors.orange.withOpacity(0.1),
                      child: const Icon(
                        Icons.fastfood_outlined,
                        size: 20,
                        color: kBrandBrown,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  addon['name'],
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ),
              Text('+₽${addon['price']}', style: TextStyle(color: Colors.grey[700], fontSize: 13)),
              const SizedBox(width: 8),
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: addon['checked'],
                  activeColor: kBrandBrown,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  onChanged: (val) => setState(() => addon['checked'] = val),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30, top: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: Row(
        children: [
          // Контроллер количества
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            decoration: BoxDecoration(color: const Color(0xFFEEEEEE), borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                InkWell(onTap: () => setState(() => _localQuantity = (_localQuantity > 1 ? _localQuantity - 1 : 1)), child: const Icon(Icons.remove, size: 20)),
                const SizedBox(width: 16),
                Text('$_localQuantity', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(width: 16),
                InkWell(onTap: () => setState(() => _localQuantity++), child: const Icon(Icons.add, size: 20)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Кнопка добавления
          Expanded(
            child: SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  // Передаем количество в главную модель
                  widget.onAddToCart(widget.product.id, _localQuantity);
                  Navigator.pop(context); // Возвращаемся в меню
                },
                style: ElevatedButton.styleFrom(backgroundColor: kBrandBrown, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0),
                child: Text('Добавить за ₽${_totalPrice.toInt()}', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// --- ЭКРАН КОРЗИНЫ ---
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
                    shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
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
          //Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: kBrandBrown, width: 1.5)), )
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
          ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(product.imageUrl, width: 70, height: 70, fit: BoxFit.cover)),
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
                InkWell(onTap: () => onQuantityChanged(product.id, 1), child: const Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6), child: Icon(Icons.add, size: 16, color: kDarkText))),
                Text('${product.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                InkWell(onTap: () => onQuantityChanged(product.id, -1), child: const Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6), child: Icon(Icons.remove, size: 16, color: kDarkText))),
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
          const Expanded(child: TextField(decoration: InputDecoration(hintText: 'Введите промокод', border: InputBorder.none, isDense: true, hintStyle: TextStyle(fontSize: 14)))),
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
            children: [const Text('Итого', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), Text('${totalSum.toInt()} ₽', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: kBrandBrown))],
          )
        ],
      ),
    );
  }

  Widget _buildCheckoutButton() {
    return SizedBox(
      width: double.infinity, height: 56,
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

// ==========================================
// --- ЭКРАН ПРОФИЛЯ ---
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
                  const CircleAvatar(radius: 35, backgroundColor: Color(0xFFEEEEEE), child: Icon(Icons.person, size: 40, color: Colors.grey)),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Row(
                      children: [
                        _authButton('Регистрация', true, () => print("Регистрация")),
                        const SizedBox(width: 10),
                        _authButton('Войти', false, () => showAuthDialog(context)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Divider(),
              _menuItem(Icons.list_alt, 'Список заказов', () {}),
              _menuItem(Icons.percent, 'Скидки и бонусы', () {}),
              _menuItem(Icons.location_on_outlined, 'Мои адреса', () {}),
              _menuItem(Icons.credit_card, 'Мои карты', () {}),
              _menuItem(Icons.settings_outlined, 'Настройки', () {}),
              const SizedBox(height: 40),
              const Text('Контакты:', style: TextStyle(fontWeight: FontWeight.bold, color: kDarkText)),
              const SizedBox(height: 4),
              const Text('0-800-000-000\n0-800-000-000', style: TextStyle(height: 1.3)),
              const SizedBox(height: 12),
              const Text('Адрес: г. Николаев', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _authButton(String title, bool isFilled, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: isFilled ? kBrandBrown : Colors.transparent, borderRadius: BorderRadius.circular(20), border: isFilled ? null : Border.all(color: kBrandBrown)),
          child: Text(title, style: TextStyle(color: isFilled ? Colors.white : kBrandBrown, fontWeight: FontWeight.bold, fontSize: 12)),
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

void showAuthDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Авторизация'),
      content: const Text('Окно входа в систему CRAVE'),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Закрыть', style: TextStyle(color: kBrandBrown)))],
    ),
  );
}