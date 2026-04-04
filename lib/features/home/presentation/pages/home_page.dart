import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/home_models.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_state.dart';
import '../widgets/home_content_widgets.dart';
import '../widgets/home_sections.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    this.onHeroActionTap,
    this.onCategoryTap,
    this.onPopularAddTap,
    this.onRecommendedAddTap,
    this.onPopularSeeAllTap,
    this.onRecommendedSeeAllTap,
  });

  final VoidCallback? onHeroActionTap;
  final ValueChanged<int>? onCategoryTap;
  final ValueChanged<ProductModel>? onPopularAddTap;
  final ValueChanged<ProductModel>? onRecommendedAddTap;
  final VoidCallback? onPopularSeeAllTap;
  final VoidCallback? onRecommendedSeeAllTap;

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
                if (state.heroBanners.isNotEmpty)
                  HeroBannerCard(
                    hero: state.heroBanners.first,
                    onActionTap: onHeroActionTap,
                  ),
                SizedBox(height: 10.h),

                if (state.categories.isNotEmpty) ...[
                  HomeSection(
                    title: 'Categories',
                    child: CategoriesStrip(
                      categories: state.categories,
                      onCategoryTap: (category) =>
                          onCategoryTap?.call(category.id),
                    ),
                  ),
                ],

                if (state.specialOffers.isNotEmpty) ...[
                  HomeSection(
                    title: 'Special Offers',
                    child: SpecialOffersStrip(offers: state.specialOffers),
                  ),
                ],

                if (state.popularDishes.isNotEmpty) ...[
                  HomeSection(
                    title: 'Popular Dishes',
                    onSeeAllTap: onPopularSeeAllTap,
                    child: PopularDishesStrip(
                      dishes: state.popularDishes,
                      onAddTap: onPopularAddTap,
                    ),
                  ),
                ],

                if (state.recommendedDishes.isNotEmpty) ...[
                  HomeSection(
                    title: 'Recommended For You',
                    onSeeAllTap: onRecommendedSeeAllTap,
                    bottomSpacing: 24,
                    child: RecommendedDishesList(
                      items: state.recommendedDishes,
                      onAddTap: onRecommendedAddTap,
                    ),
                  ),
                ],
              ],
            ),
          );
        }

        return SizedBox.shrink();
      },
    );
  }
}
