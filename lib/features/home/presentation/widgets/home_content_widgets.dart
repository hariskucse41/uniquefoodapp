import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/models/home_models.dart';
import '../utils/home_ui_mapper.dart';

class HeroBannerCard extends StatelessWidget {
  const HeroBannerCard({super.key, required this.hero});

  final PromotionModel hero;

  @override
  Widget build(BuildContext context) {
    final bannerColor = HomeUiMapper.parseColor(
      hero.backgroundColor,
      const Color(0xff667eea),
    );

    return Container(
      margin: EdgeInsets.all(16.w),
      height: 220.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: bannerColor,
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
                      const SizedBox.shrink(),
                ),
              ),
            ),
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
                      color: bannerColor,
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
}

class CategoriesStrip extends StatelessWidget {
  const CategoriesStrip({super.key, required this.categories});

  final List<CategoryModel> categories;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final categoryColor = HomeUiMapper.parseColor(
            category.color,
            AppColors.primaryStart,
          );

          return Container(
            width: 80.w,
            margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
            child: Column(
              children: [
                Container(
                  width: 60.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    color: categoryColor.withValues(alpha: .15),
                    borderRadius: BorderRadius.circular(18.r),
                    border: Border.all(
                      color: categoryColor.withValues(alpha: .3),
                      width: 1.5.w,
                    ),
                  ),
                  child: Icon(
                    HomeUiMapper.iconFromName(category.iconName),
                    color: categoryColor,
                    size: 28.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Expanded(
                  child: Text(
                    category.name,
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
}

class SpecialOffersStrip extends StatelessWidget {
  const SpecialOffersStrip({super.key, required this.offers});

  final List<PromotionModel> offers;

  @override
  Widget build(BuildContext context) {
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
          final offerColor = HomeUiMapper.parseColor(
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
                  offerColor.withValues(alpha: .2),
                  offerColor.withValues(alpha: .05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: offerColor.withValues(alpha: .2)),
            ),
            child: Row(
              children: [
                Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: offerColor.withValues(alpha: .2),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(Icons.star, color: offerColor, size: 26.sp),
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
                            color: offerColor,
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
}

class PopularDishesStrip extends StatelessWidget {
  const PopularDishesStrip({super.key, required this.dishes});

  final List<ProductModel> dishes;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 290.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        itemCount: dishes.length,
        itemBuilder: (context, index) {
          final dish = dishes[index];
          const dishColor = AppColors.primaryStart;

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
                Container(
                  height: 110.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        dishColor.withValues(alpha: .3),
                        dishColor.withValues(alpha: .1),
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
                                    color: dishColor,
                                  ),
                                ),
                          ),
                        )
                      : Center(
                          child: Icon(
                            Icons.fastfood,
                            size: 50.sp,
                            color: dishColor,
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
                                color: dishColor,
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
}

class RecommendedDishesList extends StatelessWidget {
  const RecommendedDishesList({super.key, required this.items});

  final List<ProductModel> items;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        const itemColor = AppColors.primaryEnd;

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
                      itemColor.withValues(alpha: .3),
                      itemColor.withValues(alpha: .1),
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
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.fastfood,
                            size: 34.sp,
                            color: itemColor,
                          ),
                        ),
                      )
                    : Icon(Icons.fastfood, size: 34.sp, color: itemColor),
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
                            color: itemColor,
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
