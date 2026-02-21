import '../../domain/models/home_models.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<PromotionModel> heroBanners;
  final List<CategoryModel> categories;
  final List<PromotionModel> specialOffers;
  final List<ProductModel> popularDishes;
  final List<ProductModel> recommendedDishes;
  final List<ProductModel> products;
  final List<dynamic> activeOrders;
  final List<dynamic> completedOrders;
  final Map<String, dynamic>? userProfile;

  HomeLoaded({
    required this.heroBanners,
    required this.categories,
    required this.specialOffers,
    required this.popularDishes,
    required this.recommendedDishes,
    required this.products,
    required this.activeOrders,
    required this.completedOrders,
    this.userProfile,
  });
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
