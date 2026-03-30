import '../../domain/models/extra_models.dart';

abstract class HomeEvent {}

class LoadHomeDataEvent extends HomeEvent {}

class RefreshOrdersEvent extends HomeEvent {}

class CreateOrderEvent extends HomeEvent {
  CreateOrderEvent({required this.items});

  final List<CreateOrderItemModel> items;
}

class ClearOrderActionMessageEvent extends HomeEvent {}
