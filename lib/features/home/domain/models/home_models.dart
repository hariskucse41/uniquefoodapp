class PromotionModel {
  final int id;
  final String title;
  final String subtitle;
  final String? actionText;
  final String? backgroundColor;
  final String? imageUrl;
  final double? price;
  final String? currency;
  final String? color;

  PromotionModel({
    required this.id,
    required this.title,
    required this.subtitle,
    this.actionText,
    this.backgroundColor,
    this.imageUrl,
    this.price,
    this.currency,
    this.color,
  });

  factory PromotionModel.fromJson(Map<String, dynamic> json) {
    return PromotionModel(
      id: json['id'],
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      actionText: json['actionText'],
      backgroundColor: json['backgroundColor'],
      imageUrl: json['imageUrl'],
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      currency: json['currency'],
      color: json['color'],
    );
  }
}

class CategoryModel {
  final int id;
  final String name;
  final String iconName;
  final String color;

  CategoryModel({
    required this.id,
    required this.name,
    required this.iconName,
    required this.color,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'] ?? '',
      iconName: json['iconName'] ?? '',
      color: json['color'] ?? '',
    );
  }
}

class ProductModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final double rating;
  final String? prepTime;
  final String? imageUrl;
  final int categoryId;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    this.prepTime,
    this.imageUrl,
    required this.categoryId,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] != null ? (json['price'] as num).toDouble() : 0.0,
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : 0.0,
      prepTime: json['prepTime'],
      imageUrl: json['imageUrl'],
      categoryId: json['categoryId'] ?? 0,
    );
  }
}
