import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = [
    'All',
    'Pizza',
    'Burgers',
    'Asian',
    'Desserts',
    'Drinks',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.surfaceOverlay,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withValues(alpha: .05)),
            ),
            child: Row(
              children: [
                const SizedBox(width: 14),
                Icon(Icons.search, color: AppColors.textMuted, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Search dishes...',
                      hintStyle: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(6),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.tune, color: Colors.white, size: 18),
                ),
              ],
            ),
          ),
        ),

        // Category tabs
        Container(
          height: 42,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: Colors.white,
            unselectedLabelColor: AppColors.textMuted,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            indicator: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(25),
            ),
            tabAlignment: TabAlignment.start,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            labelPadding: const EdgeInsets.symmetric(horizontal: 4),
            tabs: _tabs.map((tab) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                alignment: Alignment.center,
                child: Text(tab),
              );
            }).toList(),
          ),
        ),

        // Menu items grid
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: _tabs.map((_) => _buildMenuGrid()).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuGrid() {
    final items = [
      _MenuItem(
        'Margherita Pizza',
        '\$12.99',
        '⭐ 4.8',
        Icons.local_pizza,
        const Color(0xFFFF6B35),
        '25 min',
      ),
      _MenuItem(
        'Chicken Burger',
        '\$10.99',
        '⭐ 4.6',
        Icons.lunch_dining,
        const Color(0xFF764BA2),
        '15 min',
      ),
      _MenuItem(
        'Pad Thai',
        '\$10.49',
        '⭐ 4.7',
        Icons.ramen_dining,
        const Color(0xFF667EEA),
        '20 min',
      ),
      _MenuItem(
        'Tiramisu',
        '\$8.99',
        '⭐ 4.9',
        Icons.cake,
        const Color(0xFFE94560),
        '10 min',
      ),
      _MenuItem(
        'Matcha Latte',
        '\$5.99',
        '⭐ 4.5',
        Icons.local_cafe,
        const Color(0xFF00C853),
        '5 min',
      ),
      _MenuItem(
        'Sushi Platter',
        '\$18.99',
        '⭐ 4.9',
        Icons.set_meal,
        const Color(0xFFFFB347),
        '30 min',
      ),
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceOverlay,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withValues(alpha: .05)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon image area
              Expanded(
                flex: 5,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        item.color.withValues(alpha: .25),
                        item.color.withValues(alpha: .08),
                      ],
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(18),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Icon(item.icon, size: 48, color: item.color),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: .5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.timer,
                                color: Colors.white70,
                                size: 12,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                item.time,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Details
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.rating,
                        style: const TextStyle(
                          color: AppColors.accentGold,
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.price,
                            style: TextStyle(
                              color: item.color,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MenuItem {
  final String name;
  final String price;
  final String rating;
  final IconData icon;
  final Color color;
  final String time;

  _MenuItem(
    this.name,
    this.price,
    this.rating,
    this.icon,
    this.color,
    this.time,
  );
}
