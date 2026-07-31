class NeedPost {
  final int id;
  final String author;
  final String avatar;
  final String type;
  final List<String> tags;
  final String content;
  final List<String> images;
  final String time;
  final String? location;
  final String? payMode;

  const NeedPost({
    required this.id,
    required this.author,
    required this.avatar,
    required this.type,
    required this.tags,
    required this.content,
    required this.images,
    this.time = '2小时前活跃',
    this.location,
    this.payMode,
  });

  NeedPost copyWith({
    int? id,
    String? author,
    String? avatar,
    String? type,
    List<String>? tags,
    String? content,
    List<String>? images,
    String? time,
    String? location,
    String? payMode,
  }) {
    return NeedPost(
      id: id ?? this.id,
      author: author ?? this.author,
      avatar: avatar ?? this.avatar,
      type: type ?? this.type,
      tags: tags ?? this.tags,
      content: content ?? this.content,
      images: images ?? this.images,
      time: time ?? this.time,
      location: location ?? this.location,
      payMode: payMode ?? this.payMode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author,
      'avatar': avatar,
      'type': type,
      'tags': tags,
      'content': content,
      'images': images,
      'time': time,
      'location': location,
      'payMode': payMode,
    };
  }

  factory NeedPost.fromJson(Map<String, dynamic> json) {
    return NeedPost(
      id: json['id'] as int,
      author: json['author'] as String,
      avatar: json['avatar'] as String,
      type: json['type'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      content: json['content'] as String,
      images: (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      time: json['time'] as String? ?? '2小时前活跃',
      location: json['location'] as String?,
      payMode: json['payMode'] as String?,
    );
  }
}
