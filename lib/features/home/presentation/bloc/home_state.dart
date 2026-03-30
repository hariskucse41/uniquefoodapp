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
  final bool isCreatingOrder;
  final String? orderActionMessage;
  final bool isOrderActionError;

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
    this.isCreatingOrder = false,
    this.orderActionMessage,
    this.isOrderActionError = false,
  });

  HomeLoaded copyWith({
    List<PromotionModel>? heroBanners,
    List<CategoryModel>? categories,
    List<PromotionModel>? specialOffers,
    List<ProductModel>? popularDishes,
    List<ProductModel>? recommendedDishes,
    List<ProductModel>? products,
    List<dynamic>? activeOrders,
    List<dynamic>? completedOrders,
    Map<String, dynamic>? userProfile,
    bool? isCreatingOrder,
    String? orderActionMessage,
    bool clearOrderActionMessage = false,
    bool? isOrderActionError,
  }) {
    return HomeLoaded(
      heroBanners: heroBanners ?? this.heroBanners,
      categories: categories ?? this.categories,
      specialOffers: specialOffers ?? this.specialOffers,
      popularDishes: popularDishes ?? this.popularDishes,
      recommendedDishes: recommendedDishes ?? this.recommendedDishes,
      products: products ?? this.products,
      activeOrders: activeOrders ?? this.activeOrders,
      completedOrders: completedOrders ?? this.completedOrders,
      userProfile: userProfile ?? this.userProfile,
      isCreatingOrder: isCreatingOrder ?? this.isCreatingOrder,
      orderActionMessage: clearOrderActionMessage
          ? null
          : (orderActionMessage ?? this.orderActionMessage),
      isOrderActionError: isOrderActionError ?? this.isOrderActionError,
    );
  }
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
