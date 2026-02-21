import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/models/home_models.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_state.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<CategoryModel> _categories = [];
  bool _initialized = false;

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void _initTabs(List<CategoryModel> categories) {
    if (_initialized) return;
    _categories = [
      CategoryModel(id: 0, name: 'All', iconName: '', color: ''),
      ...categories,
    ];
    _tabController = TabController(length: _categories.length, vsync: this);
    _initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading || state is HomeInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is HomeError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        if (state is HomeLoaded) {
          _initTabs(state.categories);

          return Column(
            children: [
              // Search bar
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                child: Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceOverlay,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: .05),
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 14.w),
                      Icon(
                        Icons.search,
                        color: AppColors.textMuted,
                        size: 22.sp,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: TextField(
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14.sp,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search dishes...',
                            hintStyle: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 14.sp,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(6.w),
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          Icons.tune,
                          color: Colors.white,
                          size: 18.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Category tabs
              if (_tabController != null)
                Container(
                  height: 50.h,
                  margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    labelColor: Colors.white,
                    unselectedLabelColor: AppColors.textMuted,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13.sp,
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    tabAlignment: TabAlignment.start,
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 12.h,
                    ),
                    labelPadding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 4.h,
                    ),
                    tabs: _categories.map((cat) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 18.w,
                          vertical: 8.h,
                        ),
                        alignment: Alignment.center,
                        child: Text(cat.name),
                      );
                    }).toList(),
                  ),
                ),

              // Menu items grid
              if (_tabController != null)
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: _categories.map((cat) {
                      final filteredProducts = cat.id == 0
                          ? state.products
                          : state.products
                                .where((p) => p.categoryId == cat.id)
                                .toList();
                      return _buildMenuGrid(filteredProducts);
                    }).toList(),
                  ),
                ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Color _parseColor(String colorStr, Color defaultColor) {
    if (colorStr.isEmpty) return defaultColor;
    try {
      String hex = colorStr.replaceAll('#', '');
      if (hex.length == 6) {
        hex = 'FF$hex';
      }
      return Color(int.parse(hex, radix: 16));
    } catch (_) {
      return defaultColor;
    }
  }

  IconData _getIconFromCategory(
    int categoryId,
    List<CategoryModel> allCategories,
  ) {
    final cat = allCategories.firstWhere(
      (c) => c.id == categoryId,
      orElse: () => CategoryModel(id: 0, name: '', iconName: '', color: ''),
    );

    switch (cat.iconName) {
      case 'local_pizza':
        return Icons.local_pizza;
      case 'ramen_dining':
        return Icons.ramen_dining;
      case 'bakery_dining':
        return Icons.bakery_dining;
      case 'local_cafe':
        return Icons.local_cafe;
      case 'icecream':
        return Icons.icecream;
      case 'lunch_dining':
        return Icons.lunch_dining;
      default:
        return Icons.fastfood;
    }
  }

  Color _getColorFromCategory(
    int categoryId,
    List<CategoryModel> allCategories,
  ) {
    final cat = allCategories.firstWhere(
      (c) => c.id == categoryId,
      orElse: () => CategoryModel(id: 0, name: '', iconName: '', color: ''),
    );
    return _parseColor(cat.color, AppColors.primaryStart);
  }

  Widget _buildMenuGrid(List<ProductModel> products) {
    if (products.isEmpty) {
      return const Center(
        child: Text(
          'No products available.',
          style: TextStyle(color: AppColors.textMuted),
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 260.h,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final item = products[index];
        final iColor = _getColorFromCategory(item.categoryId, _categories);

        return Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceOverlay,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: Colors.white.withValues(alpha: .05)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon/Image area
              Expanded(
                flex: 5,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        iColor.withValues(alpha: .25),
                        iColor.withValues(alpha: .08),
                      ],
                    ),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(18.r),
                    ),
                  ),
                  child: Stack(
                    children: [
                      if (item.imageUrl != null && item.imageUrl!.isNotEmpty)
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(18.r),
                            ),
                            child: Image.network(
                              item.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Center(
                                    child: Icon(
                                      _getIconFromCategory(
                                        item.categoryId,
                                        _categories,
                                      ),
                                      size: 48.sp,
                                      color: iColor,
                                    ),
                                  ),
                            ),
                          ),
                        )
                      else
                        Center(
                          child: Icon(
                            _getIconFromCategory(item.categoryId, _categories),
                            size: 48.sp,
                            color: iColor,
                          ),
                        ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: .5),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.timer,
                                color: Colors.white70,
                                size: 12.sp,
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                item.prepTime ?? '20 min',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10.sp,
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
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '⭐ ${item.rating}',
                        style: TextStyle(
                          color: AppColors.accentGold,
                          fontSize: 12.sp,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${item.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: iColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            width: 30.w,
                            height: 30.h,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 18.sp,
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
