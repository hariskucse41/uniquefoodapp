import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/home_models.dart';
import '../../domain/repository/home_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;

  HomeBloc(this.repository) : super(HomeInitial()) {
    on<LoadHomeDataEvent>(_onLoadHomeData);
    on<RefreshOrdersEvent>(_onRefreshOrders);
    on<CreateOrderEvent>(_onCreateOrder);
    on<DeleteOrderEvent>(_onDeleteOrder);
    on<ClearOrderActionMessageEvent>(_onClearOrderActionMessage);
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
        repository.getActiveOrders(),
        repository.getCompletedOrders(),
        repository.getCancelledOrders(),
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
          activeOrders: _asDynamicList(responses[6]),
          completedOrders: _asDynamicList(responses[7]),
          cancelledOrders: _asDynamicList(responses[8]),
          userProfile: _asNullableMap(responses[9]),
        ),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _onRefreshOrders(
    RefreshOrdersEvent event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;
    if (currentState is! HomeLoaded) {
      return;
    }

    try {
      final responses = await Future.wait([
        repository.getActiveOrders(),
        repository.getCompletedOrders(),
        repository.getCancelledOrders(),
      ]);

      emit(
        currentState.copyWith(
          activeOrders: _asDynamicList(responses[0]),
          completedOrders: _asDynamicList(responses[1]),
          cancelledOrders: _asDynamicList(responses[2]),
        ),
      );
    } catch (e) {
      emit(
        currentState.copyWith(
          orderActionMessage: e.toString().replaceFirst('Exception: ', ''),
          isOrderActionError: true,
        ),
      );
    }
  }

  Future<void> _onCreateOrder(
    CreateOrderEvent event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;
    if (currentState is! HomeLoaded) {
      return;
    }

    if (event.items.isEmpty) {
      emit(
        currentState.copyWith(
          orderActionMessage: 'Please add at least one item before checkout.',
          isOrderActionError: true,
        ),
      );
      return;
    }

    emit(
      currentState.copyWith(
        isCreatingOrder: true,
        clearOrderActionMessage: true,
        isOrderActionError: false,
      ),
    );

    try {
      await repository.createOrder(event.items);

      final orderResponses = await Future.wait([
        repository.getActiveOrders(),
        repository.getCompletedOrders(),
        repository.getCancelledOrders(),
      ]);

      emit(
        currentState.copyWith(
          isCreatingOrder: false,
          activeOrders: _asDynamicList(orderResponses[0]),
          completedOrders: _asDynamicList(orderResponses[1]),
          cancelledOrders: _asDynamicList(orderResponses[2]),
          orderActionMessage: 'Order placed successfully.',
          isOrderActionError: false,
        ),
      );
    } catch (e) {
      emit(
        currentState.copyWith(
          isCreatingOrder: false,
          orderActionMessage: e.toString().replaceFirst('Exception: ', ''),
          isOrderActionError: true,
        ),
      );
    }
  }

  Future<void> _onDeleteOrder(
    DeleteOrderEvent event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;
    if (currentState is! HomeLoaded) {
      return;
    }

    if (event.orderId.trim().isEmpty) {
      emit(
        currentState.copyWith(
          orderActionMessage: 'Invalid order id.',
          isOrderActionError: true,
        ),
      );
      return;
    }

    emit(
      currentState.copyWith(
        clearOrderActionMessage: true,
        isOrderActionError: false,
      ),
    );

    try {
      await repository.deleteOrder(event.orderId);

      final orderResponses = await Future.wait([
        repository.getActiveOrders(),
        repository.getCompletedOrders(),
        repository.getCancelledOrders(),
      ]);

      emit(
        currentState.copyWith(
          activeOrders: _asDynamicList(orderResponses[0]),
          completedOrders: _asDynamicList(orderResponses[1]),
          cancelledOrders: _asDynamicList(orderResponses[2]),
          orderActionMessage: 'Order deleted successfully.',
          isOrderActionError: false,
        ),
      );
    } catch (e) {
      emit(
        currentState.copyWith(
          orderActionMessage: e.toString().replaceFirst('Exception: ', ''),
          isOrderActionError: true,
        ),
      );
    }
  }

  void _onClearOrderActionMessage(
    ClearOrderActionMessageEvent event,
    Emitter<HomeState> emit,
  ) {
    final currentState = state;
    if (currentState is! HomeLoaded) {
      return;
    }

    emit(currentState.copyWith(clearOrderActionMessage: true));
  }

  List<dynamic> _asDynamicList(dynamic value) {
    if (value is List<dynamic>) {
      return value;
    }

    if (value is List) {
      return List<dynamic>.from(value);
    }

    return <dynamic>[];
  }

  Map<String, dynamic>? _asNullableMap(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return null;
  }
}
