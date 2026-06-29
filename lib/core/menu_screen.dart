import 'package:flutter/material.dart';

class FoodProduct {
  final String id;
  final String title;
  final String weight;
  final int price;
  final String imageUrl;

  FoodProduct({
    required this.id,
    required this.title,
    required this.weight,
    required this.price,
    required this.imageUrl,
  });
}

class CartItem {
  final FoodProduct product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

// --- ГЛАВНЫЙ ЭКРАН С НАВИГАЦИЕЙ ---

class MainNavigationScreens extends StatefulWidget {
  const MainNavigationScreens({super.key});

  @override
  State<MainNavigationScreens> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreens> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const CartScreen(),
    const Center(child: Text("Избранное")),
    const Center(child: Text("Профиль")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _screens[_currentIndex]),
      // Кастомный плавающий красный BottomNavigationBar

    );
  }

  Widget _navIcon(IconData icon, int index) {
    final isSelected = _currentIndex == index;
    return IconButton(
      icon: Icon(
        icon,
        color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
        size: 28,
      ),
      onPressed: () => setState(() => _currentIndex = index),
    );
  }
}

// ==========================================
// ЭКРАН 1: ГЛАВНАЯ (HOME SCREEN)
// ==========================================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategory = 0;
  final List<String> _categories = ['Усі', 'Бургери', 'Піца', 'Хот дог'];

  final List<FoodProduct> _products = [
    FoodProduct(
      id: '1',
      title: 'Роли "Каліфорнія"',
      weight: '295 г',
      price: 255,
      imageUrl: 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=500',
    ),
    FoodProduct(
      id: '2',
      title: 'Бургер зі свининою',
      weight: '250 г',
      price: 100,
      imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500',
    ),
    FoodProduct(
      id: '3',
      title: 'Сет "Філадельфія"',
      weight: '420 г',
      price: 340,
      imageUrl: 'https://images.unsplash.com/photo-1611143669185-af224c5e3252?w=500',
    ),
    FoodProduct(
      id: '4',
      title: 'Піца "Пепероні"',
      weight: '500 г',
      price: 210,
      imageUrl: 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=500',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        const SizedBox(height: 10),
        // Шапка
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(onPressed: () {
            }, icon: const Icon(Icons.arrow_back_ios, size: 28)),
            const Text(
              'Pasta Palace меню',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic,color: Color(0xFF7A1B29)),
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.restaurant, size: 28,)),
          ],
        ),
        const SizedBox(height: 16),

        // Промо-баннер

        const SizedBox(height: 20),

        // Горизонтальные категории
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final isSelected = _selectedCategory == index;
              return GestureDetector(
                onTap: () => setState(() => _selectedCategory = index),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFA5131C) : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _categories[index],
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),

        const Text('Їжа', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),

        // Сетка товаров
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.72,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: _products.length,
          itemBuilder: (context, index) => ProductCard(product: _products[index]),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

// Виджет карточки товара
class ProductCard extends StatelessWidget {
  final FoodProduct product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.08), spreadRadius: 2, blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.network(product.imageUrl, width: double.infinity, fit: BoxFit.cover),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: const Icon(Icons.favorite_border, color: Colors.white),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(product.weight, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${product.price}₴', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                    const Icon(Icons.shopping_cart_outlined, size: 20, color: Colors.black54),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

// ==========================================
// ЭКРАН 2: КОРЗИНА (CART SCREEN)
// ==========================================

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<CartItem> _cartList = [
    CartItem(
      product: FoodProduct(
        id: '1',
        title: 'Роли "Каліфорнія"',
        weight: '295 г',
        price: 255,
        imageUrl: 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=500',
      ),
      quantity: 1,
    ),
    CartItem(
      product: FoodProduct(
        id: '5',
        title: 'Coca Cola',
        weight: '1 л',
        price: 90,
        imageUrl: 'https://images.unsplash.com/photo-1622483767028-3f66f32aef97?w=500',
      ),
      quantity: 2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return
    SafeArea(child:   Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 10),
          // Шапка корзины
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Корзинка', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.delete_outline, color: Colors.black54)),
            ],
          ),
          const SizedBox(height: 10),

          // Список товаров в корзине
          Expanded(
            child: ListView.separated(
              itemCount: _cartList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                final item = _cartList[index];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(item.product.imageUrl, width: 85, height: 85, fit: BoxFit.cover),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(item.product.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              GestureDetector(
                                onTap: () => setState(() => _cartList.removeAt(index)),
                                child: const Icon(Icons.close, size: 18, color: Colors.grey),
                              )
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(item.product.weight, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                          const SizedBox(height: 4),
                          Text('${item.product.price}₴', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                          const SizedBox(height: 8),
                          // Счетчик +/-
                          Row(
                            children: [
                              _counterBtn('-', () {
                                if (item.quantity > 1) setState(() => item.quantity--);
                              }),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(6)),
                                child: Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              _counterBtn('+', () => setState(() => item.quantity++)),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                );
              },
            ),
          ),

          // Кнопка оформления заказа
          Container(
            width: double.infinity,
            height: 58,
            margin: const EdgeInsets.only(bottom: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA5131C),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: () {},
              child: const Text(
                'Оформити замовлення за 345₴',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    ),
    );

  }

  Widget _counterBtn(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(text, style: const TextStyle(color: Color(0xFFA5131C), fontSize: 20, fontWeight: FontWeight.bold)),
      ),
    );
  }
}