// class CategoryResponse {
//   bool error;
//   String message;
//   CategoryData? data;
//
//   CategoryResponse({
//     required this.error,
//     required this.message,
//      this.data,
//   });
//
//   factory CategoryResponse.fromJson(Map<String, dynamic> json) {
//     return CategoryResponse(
//       error: json['error'],
//       message: json['message'],
//       data: CategoryData.fromJson(json['data']),
//     );
//   }
// }
//
// class CategoryData {
//   String categoryName;
//   List<SubCategory1> subCategories1;
//   List<CategoryProduct> products;
//
//   CategoryData({
//     required this.categoryName,
//     required this.subCategories1,
//     required this.products,
//   });
//
//   factory CategoryData.fromJson(Map<String, dynamic> json) {
//     return CategoryData(
//       categoryName: json['category_name'],
//       subCategories1: (json['sub_categories'] as List).map((e) => SubCategory1.fromJson(e)).toList(),
//       products: (json['products'] as List).map((e) => CategoryProduct.fromJson(e)).toList(),
//     );
//   }
// }
//
// class SubCategory1 {
//   String id;
//   String name;
//   String slug;
//   String flag;
//   String image;
//   String percentage;
//   String url;
//
//   SubCategory1({
//     required this.id,
//     required this.name,
//     required this.slug,
//     required this.flag,
//     required this.image,
//     required this.percentage,
//     required this.url,
//   });
//
//   factory SubCategory1.fromJson(Map<String, dynamic> json) {
//     return SubCategory1(
//       id: json['id'],
//       name: json['name'],
//       slug: json['slug'],
//       flag: json['flag'],
//       image: json['image'],
//       percentage: json['percentage'],
//       url: json['url'],
//     );
//   }
// }
//
// class CategoryProduct {
//   String id;
//   String name;
//   String image;
//   String url;
//
//   CategoryProduct({
//     required this.id,
//     required this.name,
//     required this.image,
//     required this.url,
//   });
//
//   factory CategoryProduct.fromJson(Map<String, dynamic> json) {
//     return CategoryProduct(
//       id: json['id'],
//       name: json['name'],
//       image: json['image'],
//       url: json['url'],
//     );
//   }
// }
class CategoryResponse {
  bool error;
  String message;
  CategoryData? data;

  CategoryResponse({
    required this.error,
    required this.message,
    this.data,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
      error: json['error'],
      message: json['message'],
      data: json['data'] != null ? CategoryData.fromJson(json['data']) : null,
    );
  }
}

class CategoryData {
  String categoryName;
  List<SubCategory1> subCategories1;
  List<CategoryProduct> products;
  List<MostLikedProduct> mostLikedProducts;

  CategoryData({
    required this.categoryName,
    required this.subCategories1,
    required this.products,
    required this.mostLikedProducts,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      categoryName: json['category_name'],
      subCategories1: (json['sub_categories'] as List)
          .map((e) => SubCategory1.fromJson(e))
          .toList(),
      products: (json['products'] as List)
          .map((e) => CategoryProduct.fromJson(e))
          .toList(),
      mostLikedProducts: (json['most_liked_products'] as List)
          .map((e) => MostLikedProduct.fromJson(e))
          .toList(),
    );
  }
}

class SubCategory1 {
  String id;
  String name;
  String slug;
  String flag;
  String image;
  String percentage;
  String url;

  SubCategory1({
    required this.id,
    required this.name,
    required this.slug,
    required this.flag,
    required this.image,
    required this.percentage,
    required this.url,
  });

  factory SubCategory1.fromJson(Map<String, dynamic> json) {
    return SubCategory1(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      flag: json['flag'],
      image: json['image'],
      percentage: json['percentage'],
      url: json['url'],
    );
  }
}

class CategoryProduct {
  String id;
  String name;
  String image;
  String url;
  dynamic slug;

  CategoryProduct({
    required this.id,
    required this.name,
    required this.image,
    required this.url,required this.slug
  });

  factory CategoryProduct.fromJson(Map<String, dynamic> json) {
    return CategoryProduct(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      url: json['url'],
      slug: json['slug'],
    );
  }
}

class MostLikedProduct {
  String id;
  String name;
  String slug;
  String image;
  String price;
  dynamic? specialPrice;
  int discountPercentage;
  int averageRating;
  String url;

  MostLikedProduct({
    required this.id,
    required this.name,
    required this.slug,
    required this.image,
    required this.price,
    this.specialPrice,
    required this.discountPercentage,
    required this.averageRating,
    required this.url,
  });

  factory MostLikedProduct.fromJson(Map<String, dynamic> json) {
    return MostLikedProduct(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      image: json['image'],
      price: json['price'],
      specialPrice: json['special_price'],
      discountPercentage: json['discount_percentage'],
      averageRating: json['average_rating'],
      url: json['url'],
    );
  }
}
