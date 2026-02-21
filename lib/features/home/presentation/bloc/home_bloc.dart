import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/home_models.dart';
import '../../domain/repository/home_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;

  HomeBloc(this.repository) : super(HomeInitial()) {
    on<LoadHomeDataEvent>(_onLoadHomeData);
  }

  Future<void> _onLoadHomeData(
    LoadHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      final responses = await Future.wait([
        repository.getHeroBanners(),
        repository.getCategories(),
        repository.getSpecialOffers(),
        repository.getPopularDishes(),
        repository.getRecommendedDishes(),
        repository.getProducts(),
        repository.getOrders('Preparing'),
        repository.getOrders('Delivered'),
        repository.getUserProfile(),
      ]);

      emit(
        HomeLoaded(
          heroBanners: responses[0] as List<PromotionModel>,
          categories: responses[1] as List<CategoryModel>,
          specialOffers: responses[2] as List<PromotionModel>,
          popularDishes: responses[3] as List<ProductModel>,
          recommendedDishes: responses[4] as List<ProductModel>,
          products: responses[5] as List<ProductModel>,
          activeOrders: responses[6] as List<dynamic>,
          completedOrders: responses[7] as List<dynamic>,
          userProfile: responses[8] as Map<String, dynamic>?,
        ),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
