class FeedPost {
  final int id;
  final String type;
  final String title;
  final String author;
  final String avatar;
  final String image;
  final int likes;
  final double imageHeight;
  final String? description;

  const FeedPost({
    required this.id,
    required this.type,
    required this.title,
    required this.author,
    required this.avatar,
    required this.image,
    required this.likes,
    this.imageHeight = 220,
    this.description,
  });

  FeedPost copyWith({
    int? id,
    String? type,
    String? title,
    String? author,
    String? avatar,
    String? image,
    int? likes,
    double? imageHeight,
    String? description,
  }) {
    return FeedPost(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      author: author ?? this.author,
      avatar: avatar ?? this.avatar,
      image: image ?? this.image,
      likes: likes ?? this.likes,
      imageHeight: imageHeight ?? this.imageHeight,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'author': author,
      'avatar': avatar,
      'image': image,
      'likes': likes,
      'imageHeight': imageHeight,
      'description': description,
    };
  }

  factory FeedPost.fromJson(Map<String, dynamic> json) {
    return FeedPost(
      id: json['id'] as int,
      type: json['type'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      avatar: json['avatar'] as String,
      image: json['image'] as String,
      likes: json['likes'] as int,
      imageHeight: (json['imageHeight'] as num?)?.toDouble() ?? 220,
      description: json['description'] as String?,
    );
  }
}
