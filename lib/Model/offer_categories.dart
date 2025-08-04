class OfferCategories {
  bool? error;
  String? message;
  PT? data;

  OfferCategories({this.error, this.message, this.data});

  OfferCategories.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    data = json['data'] != null ? new PT.fromJson(json['data']) : null;
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

class PT {
  ParentCategory? parentCategory;
  List<offerCategories>? categories;

  PT({this.parentCategory, this.categories});

  PT.fromJson(Map<String, dynamic> json) {
    parentCategory = json['parent_category'] != null
        ? new ParentCategory.fromJson(json['parent_category'])
        : null;
    if (json['categories'] != null) {
      categories = <offerCategories>[];
      json['categories'].forEach((v) {
        categories!.add(new offerCategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.parentCategory != null) {
      data['parent_category'] = this.parentCategory!.toJson();
    }
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ParentCategory {
  String? id;
  String? name;
  String? slug;

  ParentCategory({this.id, this.name, this.slug});

  ParentCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    return data;
  }
}

class offerCategories {
  String? id;
  String? name;
  String? slug;
  String? image;
  String? url;

  offerCategories({this.id, this.name, this.slug, this.image, this.url});

  offerCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    image = json['image'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['image'] = this.image;
    data['url'] = this.url;
    return data;
  }
}
