import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/models/home_models.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Banner
                if (state.heroBanners.isNotEmpty)
                  _buildHeroBanner(context, state.heroBanners.first),
                SizedBox(height: 24.h),

                // Food Categories
                if (state.categories.isNotEmpty) ...[
                  _buildSectionTitle('Categories'),
                  SizedBox(height: 12.h),
                  _buildCategories(state.categories),
                  SizedBox(height: 28.h),
                ],

                // Special Offers
                if (state.specialOffers.isNotEmpty) ...[
                  _buildSectionTitle('Special Offers'),
                  SizedBox(height: 12.h),
                  _buildSpecialOffers(state.specialOffers),
                  SizedBox(height: 28.h),
                ],

                // Popular Dishes
                if (state.popularDishes.isNotEmpty) ...[
                  _buildSectionTitle('Popular Dishes'),
                  SizedBox(height: 12.h),
                  _buildPopularDishes(state.popularDishes),
                  SizedBox(height: 28.h),
                ],

                // Recommended
                if (state.recommendedDishes.isNotEmpty) ...[
                  _buildSectionTitle('Recommended For You'),
                  SizedBox(height: 12.h),
                  _buildRecommended(state.recommendedDishes),
                  SizedBox(height: 40.h),
                ],
              ],
            ),
          );
        }

        return SizedBox.shrink();
      },
    );
  }

  Color _parseColor(String? colorStr, Color defaultColor) {
    if (colorStr == null || colorStr.isEmpty) return defaultColor;
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

  IconData _getIcon(String? iconName) {
    switch (iconName) {
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
      case 'family_restroom':
        return Icons.family_restroom;
      case 'brunch_dining':
        return Icons.brunch_dining;
      case 'local_bar':
        return Icons.local_bar;
      case 'cake':
        return Icons.cake;
      case 'eco':
        return Icons.eco;
      case 'set_meal':
        return Icons.set_meal;
      default:
        return Icons.fastfood;
    }
  }

  Widget _buildHeroBanner(BuildContext context, PromotionModel hero) {
    return Container(
      margin: EdgeInsets.all(16.w),
      height: 220.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: _parseColor(hero.backgroundColor, const Color(0xff667eea)),
        gradient: hero.backgroundColor == null ? AppColors.heroGradient : null,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryStart.withValues(alpha: .3),
            blurRadius: 20.r,
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
              width: 120.w,
              height: 120.h,
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
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: .08),
              ),
            ),
          ),
          // Background Image (if any)
          if (hero.imageUrl != null && hero.imageUrl!.isNotEmpty)
            Positioned(
              right: 16,
              bottom: 16,
              top: 16,
              width: 140.w,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Image.network(
                  hero.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      SizedBox.shrink(),
                ),
              ),
            ),
          // Content
          Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  hero.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  hero.subtitle,
                  style: TextStyle(color: Colors.white70, fontSize: 15.sp),
                ),
                SizedBox(height: 14.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  child: Text(
                    hero.actionText ?? 'Order Now',
                    style: TextStyle(
                      color: _parseColor(
                        hero.backgroundColor,
                        const Color(0xff667eea),
                      ),
                      fontWeight: FontWeight.bold,
                      fontSize: 13.sp,
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
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            'See All',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryStart,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories(List<CategoryModel> categories) {
    return SizedBox(
      height: 140.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final catColor = _parseColor(cat.color, AppColors.primaryStart);
          return Container(
            width: 80.w,
            margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
            child: Column(
              children: [
                Container(
                  width: 60.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    color: catColor.withValues(alpha: .15),
                    borderRadius: BorderRadius.circular(18.r),
                    border: Border.all(
                      color: catColor.withValues(alpha: .3),
                      width: 1.5.w,
                    ),
                  ),
                  child: Icon(
                    _getIcon(cat.iconName),
                    color: catColor,
                    size: 28.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Expanded(
                  child: Text(
                    cat.name,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSpecialOffers(List<PromotionModel> offers) {
    return SizedBox(
      height: 180.h,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        itemCount: offers.length,
        itemBuilder: (context, index) {
          final offer = offers[index];
          final oColor = _parseColor(
            offer.color ?? offer.backgroundColor,
            AppColors.primaryStart,
          );
          return Container(
            width: 240.w,
            margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  oColor.withValues(alpha: .2),
                  oColor.withValues(alpha: .05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: oColor.withValues(alpha: .2)),
            ),
            child: Row(
              children: [
                Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: oColor.withValues(alpha: .2),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(Icons.star, color: oColor, size: 26.sp),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        offer.title,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        offer.subtitle,
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6.h),
                      if (offer.price != null)
                        Text(
                          '${offer.currency ?? '\$'}${offer.price}',
                          style: TextStyle(
                            color: oColor,
                            fontSize: 18.sp,
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

  Widget _buildPopularDishes(List<ProductModel> dishes) {
    return SizedBox(
      height: 290.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        itemCount: dishes.length,
        itemBuilder: (context, index) {
          final dish = dishes[index];
          // Use AppColors.primaryStart as default dish color since color is not in ProductModel
          final dColor = AppColors.primaryStart;
          return Container(
            width: 170.w,
            margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.surfaceOverlay,
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(color: Colors.white.withValues(alpha: .05)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Food image
                Container(
                  height: 110.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        dColor.withValues(alpha: .3),
                        dColor.withValues(alpha: .1),
                      ],
                    ),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(18.r),
                    ),
                  ),
                  child: dish.imageUrl != null && dish.imageUrl!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(18.r),
                          ),
                          child: Image.network(
                            dish.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Center(
                                  child: Icon(
                                    Icons.fastfood,
                                    size: 50.sp,
                                    color: dColor,
                                  ),
                                ),
                          ),
                        )
                      : Center(
                          child: Icon(
                            Icons.fastfood,
                            size: 50.sp,
                            color: dColor,
                          ),
                        ),
                ),
                Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dish.name,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        dish.description,
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              '\$${dish.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: dColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '⭐ ${dish.rating}',
                            style: TextStyle(
                              color: AppColors.accentGold,
                              fontSize: 12.sp,
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

  Widget _buildRecommended(List<ProductModel> items) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final iColor = AppColors.primaryEnd;
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: AppColors.surfaceOverlay,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.white.withValues(alpha: .05)),
          ),
          child: Row(
            children: [
              Container(
                width: 70.w,
                height: 70.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      iColor.withValues(alpha: .3),
                      iColor.withValues(alpha: .1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(14.r),
                        child: Image.network(
                          item.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.fastfood, size: 34.sp, color: iColor),
                        ),
                      )
                    : Icon(Icons.fastfood, size: 34.sp, color: iColor),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      item.description,
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        Text(
                          '\$${item.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: iColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '⭐ ${item.rating}',
                          style: TextStyle(
                            color: AppColors.accentGold,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                width: 36.w,
                height: 36.h,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(Icons.add, color: Colors.white, size: 20.sp),
              ),
            ],
          ),
        );
      },
    );
  }
}
