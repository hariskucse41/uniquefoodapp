import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Banner
          _buildHeroBanner(context),
          const SizedBox(height: 24),

          // Food Categories
          _buildSectionTitle('Categories'),
          const SizedBox(height: 12),
          _buildCategories(),
          const SizedBox(height: 28),

          // Special Offers
          _buildSectionTitle('Special Offers'),
          const SizedBox(height: 12),
          _buildSpecialOffers(),
          const SizedBox(height: 28),

          // Popular Dishes
          _buildSectionTitle('Popular Dishes'),
          const SizedBox(height: 12),
          _buildPopularDishes(),
          const SizedBox(height: 28),

          // Recommended
          _buildSectionTitle('Recommended For You'),
          const SizedBox(height: 12),
          _buildRecommended(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeroBanner(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 180,
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryStart.withValues(alpha: .3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: .1),
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: .08),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '🔥 Today\'s Special',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Get 30% Off',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                const Text(
                  'On your first order!',
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Text(
                    'Order Now',
                    style: TextStyle(
                      color: Color(0xff667eea),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const Text(
            'See All',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryStart,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    final categories = [
      _CategoryItem(Icons.local_pizza, 'Pizza', const Color(0xFFFF6B35)),
      _CategoryItem(Icons.ramen_dining, 'Asian', const Color(0xFF667EEA)),
      _CategoryItem(Icons.bakery_dining, 'Bakery', const Color(0xFFE94560)),
      _CategoryItem(Icons.local_cafe, 'Drinks', const Color(0xFF00C853)),
      _CategoryItem(Icons.icecream, 'Desserts', const Color(0xFFFFB347)),
      _CategoryItem(Icons.lunch_dining, 'Burgers', const Color(0xFF764BA2)),
    ];

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return Container(
            width: 80,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: cat.color.withValues(alpha: .15),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: cat.color.withValues(alpha: .3),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(cat.icon, color: cat.color, size: 28),
                ),
                const SizedBox(height: 8),
                Text(
                  cat.label,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSpecialOffers() {
    final offers = [
      _OfferItem(
        'Family Combo',
        'Up to 4 people',
        '\$29.99',
        const Color(0xFFE94560),
        Icons.family_restroom,
      ),
      _OfferItem(
        'Weekend Brunch',
        'Sat & Sun only',
        '\$15.99',
        const Color(0xFF667EEA),
        Icons.brunch_dining,
      ),
      _OfferItem(
        'Happy Hour',
        '5PM - 7PM Daily',
        '\$8.99',
        const Color(0xFFFF6B35),
        Icons.local_bar,
      ),
    ];

    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: offers.length,
        itemBuilder: (context, index) {
          final offer = offers[index];
          return Container(
            width: 240,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  offer.color.withValues(alpha: .2),
                  offer.color.withValues(alpha: .05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: offer.color.withValues(alpha: .2)),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: offer.color.withValues(alpha: .2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(offer.icon, color: offer.color, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        offer.title,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        offer.subtitle,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        offer.price,
                        style: TextStyle(
                          color: offer.color,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPopularDishes() {
    final dishes = [
      _DishItem(
        'Margherita Pizza',
        'Classic Italian',
        '\$12.99',
        '⭐ 4.8',
        Icons.local_pizza,
        const Color(0xFFFF6B35),
      ),
      _DishItem(
        'Pad Thai',
        'Spicy Noodles',
        '\$10.49',
        '⭐ 4.7',
        Icons.ramen_dining,
        const Color(0xFF667EEA),
      ),
      _DishItem(
        'Tiramisu',
        'Italian Dessert',
        '\$8.99',
        '⭐ 4.9',
        Icons.cake,
        const Color(0xFFE94560),
      ),
      _DishItem(
        'Caesar Salad',
        'Fresh & Healthy',
        '\$9.49',
        '⭐ 4.6',
        Icons.eco,
        const Color(0xFF00C853),
      ),
    ];

    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: dishes.length,
        itemBuilder: (context, index) {
          final dish = dishes[index];
          return Container(
            width: 170,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceOverlay,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: .05)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Food image placeholder with icon
                Container(
                  height: 110,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        dish.color.withValues(alpha: .3),
                        dish.color.withValues(alpha: .1),
                      ],
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(18),
                    ),
                  ),
                  child: Center(
                    child: Icon(dish.icon, size: 50, color: dish.color),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dish.name,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        dish.description,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            dish.price,
                            style: TextStyle(
                              color: dish.color,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            dish.rating,
                            style: const TextStyle(
                              color: AppColors.accentGold,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecommended() {
    final items = [
      _DishItem(
        'Beef Burger',
        'Juicy & Tender',
        '\$11.49',
        '⭐ 4.7',
        Icons.lunch_dining,
        const Color(0xFF764BA2),
      ),
      _DishItem(
        'Matcha Latte',
        'Creamy Green Tea',
        '\$5.99',
        '⭐ 4.5',
        Icons.local_cafe,
        const Color(0xFF00C853),
      ),
      _DishItem(
        'Sushi Platter',
        '12 Pieces',
        '\$18.99',
        '⭐ 4.9',
        Icons.set_meal,
        const Color(0xFFE94560),
      ),
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surfaceOverlay,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: .05)),
          ),
          child: Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      item.color.withValues(alpha: .3),
                      item.color.withValues(alpha: .1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(item.icon, size: 34, color: item.color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          item.price,
                          style: TextStyle(
                            color: item.color,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          item.rating,
                          style: const TextStyle(
                            color: AppColors.accentGold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 20),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CategoryItem {
  final IconData icon;
  final String label;
  final Color color;

  _CategoryItem(this.icon, this.label, this.color);
}

class _OfferItem {
  final String title;
  final String subtitle;
  final String price;
  final Color color;
  final IconData icon;

  _OfferItem(this.title, this.subtitle, this.price, this.color, this.icon);
}

class _DishItem {
  final String name;
  final String description;
  final String price;
  final String rating;
  final IconData icon;
  final Color color;

  _DishItem(
    this.name,
    this.description,
    this.price,
    this.rating,
    this.icon,
    this.color,
  );
}
