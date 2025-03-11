class MovieCategory {
  final String categoryId;
  final String categoryName;

  MovieCategory({required this.categoryId, required this.categoryName});

  factory MovieCategory.fromJson(Map<String, dynamic> json) {
    return MovieCategory(
      categoryId: json['category_id'],
      categoryName: json['category_name'],
    );
  }
}
