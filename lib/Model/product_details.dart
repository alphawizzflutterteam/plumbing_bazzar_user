class ProductDetailModel {
  final bool status;
  final ProductData? data;

  ProductDetailModel({required this.status, this.data});

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailModel(
      status: json['status'],
      data: json['data'] != null ? ProductData.fromJson(json['data']) : null,
    );
  }
}

class ProductData {
  final String id;
  final String name;
  final String description;
  final String image;
  final String price;

  ProductData({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      price: json['price'].toString(),
    );
  }
}
