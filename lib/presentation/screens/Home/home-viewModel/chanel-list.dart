class Channel {
  final String name;
  final String imageUrl;
  final String streamId;
  final String category;

  Channel({
    required this.name,
    required this.imageUrl,
    required this.streamId,
    required this.category,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      name: json['name'] ?? "Unknown",
      imageUrl: json['stream_icon'] ?? 'assets/images/placeholder.png',
      streamId: json['stream_id'].toString(),
      category: json['category_name'] ?? "Unknown",
    );
  }
}
