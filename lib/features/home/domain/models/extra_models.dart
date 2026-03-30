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
    final product = json['product'] as Map<String, dynamic>?;

    return OrderItemModel(
      quantity: json['quantity'] ?? 1,
      price: json['price'] != null ? (json['price'] as num).toDouble() : 0.0,
      productName: (json['productName'] ?? product?['name'] ?? 'Unknown item')
          .toString(),
    );
  }
}

class CreateOrderItemModel {
  final int productId;
  final int quantity;

  const CreateOrderItemModel({required this.productId, required this.quantity});

  Map<String, dynamic> toJson() {
    return {'productId': productId, 'quantity': quantity};
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
    final rawItems =
        (json['orderItems'] as List<dynamic>?) ??
        (json['items'] as List<dynamic>?);

    final orderDateRaw = json['orderDate']?.toString();

    return OrderModel(
      id: json['id']?.toString() ?? '',
      status: _normalizeStatus(json['status']),
      totalAmount: json['totalAmount'] != null
          ? (json['totalAmount'] as num).toDouble()
          : 0.0,
      orderDate: orderDateRaw == null
          ? ''
          : DateTime.tryParse(orderDateRaw)?.toLocal().toString() ??
                orderDateRaw,
      items:
          rawItems
              ?.map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  static String _normalizeStatus(dynamic rawStatus) {
    if (rawStatus == null) {
      return 'Pending';
    }

    if (rawStatus is int) {
      switch (rawStatus) {
        case 0:
          return 'Pending';
        case 1:
          return 'Completed';
        case 2:
          return 'Cancelled';
        default:
          return rawStatus.toString();
      }
    }

    final str = rawStatus.toString();
    if (str == '0') return 'Pending';
    if (str == '1') return 'Completed';
    if (str == '2') return 'Cancelled';
    return str;
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
