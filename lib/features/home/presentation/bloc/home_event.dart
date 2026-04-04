import '../../domain/models/extra_models.dart';

abstract class HomeEvent {}

class LoadHomeDataEvent extends HomeEvent {}

class RefreshOrdersEvent extends HomeEvent {}

class CreateOrderEvent extends HomeEvent {
  CreateOrderEvent({required this.items});

  final List<CreateOrderItemModel> items;
}

class DeleteOrderEvent extends HomeEvent {
  DeleteOrderEvent({required this.orderId});

  final String orderId;
}

class ClearOrderActionMessageEvent extends HomeEvent {}
