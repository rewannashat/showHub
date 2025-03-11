class Movie {
  final String name;
  final String streamType;
  final int streamId;
  final String streamIcon;

  Movie({
    required this.name,
    required this.streamType,
    required this.streamId,
    required this.streamIcon,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      name: json['name'] ?? 'Unknown',
      streamType: json['stream_type'] ?? '',
      streamId: json['stream_id'] ?? 0,
      streamIcon: json['stream_icon'] ?? '',
    );
  }
}
