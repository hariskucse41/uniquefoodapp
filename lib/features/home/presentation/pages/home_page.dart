import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/home_bloc.dart';
import '../bloc/home_state.dart';
import '../widgets/home_content_widgets.dart';
import '../widgets/home_sections.dart';

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
                if (state.heroBanners.isNotEmpty)
                  HeroBannerCard(hero: state.heroBanners.first),
                SizedBox(height: 24.h),

                if (state.categories.isNotEmpty) ...[
                  HomeSection(
                    title: 'Categories',
                    child: CategoriesStrip(categories: state.categories),
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
                    child: PopularDishesStrip(dishes: state.popularDishes),
                  ),
                ],

                if (state.recommendedDishes.isNotEmpty) ...[
                  HomeSection(
                    title: 'Recommended For You',
                    bottomSpacing: 40,
                    child: RecommendedDishesList(
                      items: state.recommendedDishes,
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
