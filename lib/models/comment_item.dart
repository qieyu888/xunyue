class CommentItem {
  final int id;
  final String author;
  final String avatar;
  final String content;
  final String time;
  final int likes;
  final String? replyTo;

  const CommentItem({
    required this.id,
    required this.author,
    required this.avatar,
    required this.content,
    required this.time,
    required this.likes,
    this.replyTo,
  });

  CommentItem copyWith({
    int? id,
    String? author,
    String? avatar,
    String? content,
    String? time,
    int? likes,
    String? replyTo,
  }) {
    return CommentItem(
      id: id ?? this.id,
      author: author ?? this.author,
      avatar: avatar ?? this.avatar,
      content: content ?? this.content,
      time: time ?? this.time,
      likes: likes ?? this.likes,
      replyTo: replyTo ?? this.replyTo,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author,
      'avatar': avatar,
      'content': content,
      'time': time,
      'likes': likes,
      'replyTo': replyTo,
    };
  }

  factory CommentItem.fromJson(Map<String, dynamic> json) {
    return CommentItem(
      id: json['id'] as int,
      author: json['author'] as String,
      avatar: json['avatar'] as String,
      content: json['content'] as String,
      time: json['time'] as String,
      likes: json['likes'] as int,
      replyTo: json['replyTo'] as String?,
    );
  }
}
