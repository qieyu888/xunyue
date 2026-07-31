class MomentPost {
  final int id;
  final String author;
  final String avatar;
  final String time;
  final String category;
  final String title;
  final String content;
  final List<String> images;
  final int likes;
  final int comments;

  const MomentPost({
    required this.id,
    required this.author,
    required this.avatar,
    required this.time,
    required this.category,
    required this.title,
    required this.content,
    required this.images,
    required this.likes,
    required this.comments,
  });

  MomentPost copyWith({
    int? id,
    String? author,
    String? avatar,
    String? time,
    String? category,
    String? title,
    String? content,
    List<String>? images,
    int? likes,
    int? comments,
  }) {
    return MomentPost(
      id: id ?? this.id,
      author: author ?? this.author,
      avatar: avatar ?? this.avatar,
      time: time ?? this.time,
      category: category ?? this.category,
      title: title ?? this.title,
      content: content ?? this.content,
      images: images ?? this.images,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author,
      'avatar': avatar,
      'time': time,
      'category': category,
      'title': title,
      'content': content,
      'images': images,
      'likes': likes,
      'comments': comments,
    };
  }

  factory MomentPost.fromJson(Map<String, dynamic> json) {
    return MomentPost(
      id: json['id'] as int,
      author: json['author'] as String,
      avatar: json['avatar'] as String,
      time: json['time'] as String,
      category: json['category'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      images: (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      likes: json['likes'] as int,
      comments: json['comments'] as int,
    );
  }
}
