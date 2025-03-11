
class CategoryLive {
  final String categoryId;
  final String categoryName;

  CategoryLive({required this.categoryId, required this.categoryName});

  factory CategoryLive.fromJson(Map<String, dynamic> json) {
    return CategoryLive(
      categoryId: json['category_id'],
      categoryName: json['category_name'],
    );
  }
}

