import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/models/extra_models.dart';
import '../../domain/models/home_models.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../utils/home_ui_mapper.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({
    super.key,
    this.selectedCategoryId,
    this.selectionVersion = 0,
  });

  final int? selectedCategoryId;
  final int selectionVersion;

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<CategoryModel> _categories = [];
  bool _initialized = false;
  int? _pendingCategoryId;
  final Map<int, int> _cartQuantities = {};

  @override
  void initState() {
    super.initState();
    _pendingCategoryId = widget.selectedCategoryId;
  }

  @override
  void didUpdateWidget(covariant MenuPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selectionVersion != widget.selectionVersion) {
      _pendingCategoryId = widget.selectedCategoryId;
      _jumpToPendingCategory();
    }
  }

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
    _jumpToPendingCategory();
  }

  void _jumpToPendingCategory() {
    if (_tabController == null || _pendingCategoryId == null) {
      return;
    }

    final selectedIndex = _categories.indexWhere(
      (category) => category.id == _pendingCategoryId,
    );

    _pendingCategoryId = null;

    if (selectedIndex < 0) {
      return;
    }

    _tabController!.animateTo(selectedIndex);
  }

  int _totalCartItems() {
    return _cartQuantities.values.fold(0, (sum, qty) => sum + qty);
  }

  double _totalCartPrice(List<ProductModel> products) {
    final byId = {for (final product in products) product.id: product};
    double total = 0;
    _cartQuantities.forEach((productId, quantity) {
      final product = byId[productId];
      if (product != null) {
        total += product.price * quantity;
      }
    });
    return total;
  }

  void _addToCart(ProductModel product) {
    setState(() {
      final currentQty = _cartQuantities[product.id] ?? 0;
      _cartQuantities[product.id] = currentQty + 1;
    });
  }

  List<CreateOrderItemModel> _buildOrderItems() {
    return _cartQuantities.entries
        .where((entry) => entry.value > 0)
        .map(
          (entry) =>
              CreateOrderItemModel(productId: entry.key, quantity: entry.value),
        )
        .toList();
  }

  void _placeOrder() {
    final orderItems = _buildOrderItems();
    context.read<HomeBloc>().add(CreateOrderEvent(items: orderItems));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is! HomeLoaded || state.orderActionMessage == null) {
          return;
        }

        if (!state.isOrderActionError) {
          setState(() {
            _cartQuantities.clear();
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.orderActionMessage!),
            backgroundColor: state.isOrderActionError
                ? const Color(0xFFE94560)
                : const Color(0xFF00C853),
          ),
        );

        context.read<HomeBloc>().add(ClearOrderActionMessageEvent());
      },
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
                  height: 48.h,
                  margin: EdgeInsets.symmetric(vertical: 8.h),
                  width: double.infinity,
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    labelColor: Colors.white,
                    unselectedLabelColor: AppColors.textSecondary,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                    unselectedLabelStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorPadding: EdgeInsets.symmetric(horizontal: 4.w),
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    tabAlignment: TabAlignment.start,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    labelPadding: EdgeInsets.zero,
                    tabs: _categories.map((cat) {
                      return Tab(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          alignment: Alignment.center,
                          child: Text(cat.name.isNotEmpty ? cat.name : 'All'),
                        ),
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

              if (_cartQuantities.isNotEmpty)
                Container(
                  margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceOverlay,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: .08),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_totalCartItems()} item(s) in cart',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12.sp,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              '\$${_totalCartPrice(state.products).toStringAsFixed(2)}',
                              style: TextStyle(
                                color: AppColors.primaryStart,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: state.isCreatingOrder ? null : _placeOrder,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryStart,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 18.w,
                            vertical: 12.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: state.isCreatingOrder
                            ? SizedBox(
                                width: 18.w,
                                height: 18.h,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Place Order'),
                      ),
                    ],
                  ),
                ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
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
        final iColor = HomeUiMapper.colorFromCategoryId(
          item.categoryId,
          _categories,
          AppColors.primaryStart,
        );

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
                                      HomeUiMapper.iconFromCategoryId(
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
                            HomeUiMapper.iconFromCategoryId(
                              item.categoryId,
                              _categories,
                            ),
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
                          InkWell(
                            onTap: () => _addToCart(item),
                            borderRadius: BorderRadius.circular(8.r),
                            child: Container(
                              width: 30.w,
                              height: 30.h,
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Center(
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 18.sp,
                                    ),
                                  ),
                                  if ((_cartQuantities[item.id] ?? 0) > 0)
                                    Positioned(
                                      right: -6,
                                      top: -6,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 4.w,
                                          vertical: 1.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.accent,
                                          borderRadius: BorderRadius.circular(
                                            10.r,
                                          ),
                                        ),
                                        child: Text(
                                          '${_cartQuantities[item.id]}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 9.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
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
