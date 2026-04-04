import '../models/home_models.dart';
import '../models/extra_models.dart';
import '../../data/http/home_http.dart';

abstract class HomeRepository {
  Future<List<PromotionModel>> getHeroBanners();
  Future<List<CategoryModel>> getCategories();
  Future<List<PromotionModel>> getSpecialOffers();
  Future<List<ProductModel>> getPopularDishes();
  Future<List<ProductModel>> getRecommendedDishes();
  Future<List<ProductModel>> getProducts({int? categoryId});
  Future<List<dynamic>> getActiveOrders();
  Future<List<dynamic>> getCompletedOrders();
  Future<List<dynamic>> getCancelledOrders();
  Future<void> createOrder(List<CreateOrderItemModel> items);
  Future<void> deleteOrder(String orderId);
  Future<Map<String, dynamic>?> getUserProfile();
}

class HomeRepositoryImpl implements HomeRepository {
  final HomeApiClient _apiClient;

  HomeRepositoryImpl(this._apiClient);

  @override
  Future<List<PromotionModel>> getHeroBanners() {
    return _apiClient.getHeroBanners();
  }

  @override
  Future<List<CategoryModel>> getCategories() {
    return _apiClient.getCategories();
  }

  @override
  Future<List<PromotionModel>> getSpecialOffers() {
    return _apiClient.getSpecialOffers();
  }

  @override
  Future<List<ProductModel>> getPopularDishes() {
    return _apiClient.getPopularDishes();
  }

  @override
  Future<List<ProductModel>> getRecommendedDishes() {
    return _apiClient.getRecommendedDishes();
  }

  @override
  Future<List<ProductModel>> getProducts({int? categoryId}) {
    return _apiClient.getProducts(categoryId: categoryId);
  }

  @override
  Future<List<dynamic>> getActiveOrders() {
    return _apiClient.getActiveOrders();
  }

  @override
  Future<List<dynamic>> getCompletedOrders() {
    return _apiClient.getCompletedOrders();
  }

  @override
  Future<List<dynamic>> getCancelledOrders() {
    return _apiClient.getCancelledOrders();
  }

  @override
  Future<void> createOrder(List<CreateOrderItemModel> items) {
    return _apiClient.createOrder(items);
  }

  @override
  Future<void> deleteOrder(String orderId) {
    return _apiClient.deleteOrder(orderId);
  }

  @override
  Future<Map<String, dynamic>?> getUserProfile() {
    return _apiClient.getUserProfile();
  }
}
