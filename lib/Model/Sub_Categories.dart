class SubCategoriesOfMainCategory {
  bool? error;
  String? message;
  Data? data;

  SubCategoriesOfMainCategory({this.error, this.message, this.data});

  SubCategoriesOfMainCategory.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? categoryBanner;
  List<SubCategories>? subCategories;

  Data({this.categoryBanner, this.subCategories});

  Data.fromJson(Map<String, dynamic> json) {
    categoryBanner = json['category_banner'];
    if (json['sub_categories'] != null) {
      subCategories = <SubCategories>[];
      json['sub_categories'].forEach((v) {
        subCategories!.add(new SubCategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_banner'] = this.categoryBanner;
    if (this.subCategories != null) {
      data['sub_categories'] =
          this.subCategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCategories {
  String? id;
  String? name;
  String? slug;
  String? flag;
  String? image;
  String? url;

  SubCategories(
      {this.id, this.name, this.slug, this.flag, this.image, this.url});

  SubCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    flag = json['flag'];
    image = json['image'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['flag'] = this.flag;
    data['image'] = this.image;
    data['url'] = this.url;
    return data;
  }
}
