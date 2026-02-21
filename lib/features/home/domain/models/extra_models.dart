class OrderItemModel {
  final int quantity;
  final double price;
  final String productName;

  OrderItemModel({
    required this.quantity,
    required this.price,
    required this.productName,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      quantity: json['quantity'] ?? 1,
      price: json['price'] != null ? (json['price'] as num).toDouble() : 0.0,
      productName: json['productName'] ?? '',
    );
  }
}

class OrderModel {
  final String id;
  final String status;
  final double totalAmount;
  final String orderDate;
  final List<OrderItemModel> items;

  OrderModel({
    required this.id,
    required this.status,
    required this.totalAmount,
    required this.orderDate,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id']?.toString() ?? '',
      status: json['status'] ?? '',
      totalAmount: json['totalAmount'] != null
          ? (json['totalAmount'] as num).toDouble()
          : 0.0,
      orderDate: json['orderDate'] ?? '',
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class UserProfileModel {
  final String id;
  final String fullName;
  final String email;
  final String? avatarUrl;
  final Map<String, dynamic>? stats;

  UserProfileModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.avatarUrl,
    this.stats,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatarUrl'],
      stats: json['stats'] as Map<String, dynamic>?,
    );
  }
}
