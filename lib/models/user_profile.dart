class UserProfile {
  final String nickname;
  final String userId;
  final String avatar;
  final String gender;
  final String birthday;
  final String city;
  final String role;
  final String tags;
  final String bio;
  final int likes;
  final int following;
  final String fans;

  const UserProfile({
    required this.nickname,
    required this.userId,
    required this.avatar,
    required this.gender,
    required this.birthday,
    required this.city,
    required this.role,
    required this.tags,
    required this.bio,
    this.likes = 128,
    this.following = 45,
    this.fans = '8.9k',
  });

  List<String> get tagList {
    return tags
        .split(RegExp(r'\s+'))
        .where((e) => e.trim().isNotEmpty)
        .toList();
  }

  UserProfile copyWith({
    String? nickname,
    String? userId,
    String? avatar,
    String? gender,
    String? birthday,
    String? city,
    String? role,
    String? tags,
    String? bio,
    int? likes,
    int? following,
    String? fans,
  }) {
    return UserProfile(
      nickname: nickname ?? this.nickname,
      userId: userId ?? this.userId,
      avatar: avatar ?? this.avatar,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
      city: city ?? this.city,
      role: role ?? this.role,
      tags: tags ?? this.tags,
      bio: bio ?? this.bio,
      likes: likes ?? this.likes,
      following: following ?? this.following,
      fans: fans ?? this.fans,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
      'userId': userId,
      'avatar': avatar,
      'gender': gender,
      'birthday': birthday,
      'city': city,
      'role': role,
      'tags': tags,
      'bio': bio,
      'likes': likes,
      'following': following,
      'fans': fans,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      nickname: json['nickname'] as String,
      userId: json['userId'] as String,
      avatar: json['avatar'] as String,
      gender: json['gender'] as String,
      birthday: json['birthday'] as String,
      city: json['city'] as String,
      role: json['role'] as String,
      tags: json['tags'] as String,
      bio: json['bio'] as String,
      likes: json['likes'] as int? ?? 128,
      following: json['following'] as int? ?? 45,
      fans: json['fans'] as String? ?? '8.9k',
    );
  }

  static const UserProfile defaults = UserProfile(
    nickname: 'Nana_酱',
    userId: '8839201',
    avatar: 'assets/images/avatar_me.jpg',
    gender: '女',
    birthday: '2000-06-12',
    city: '浙江 杭州',
    role: '独立模特',
    tags: '双子座 喜欢胶片',
    bio: '自由模特，擅长日系/情绪/胶片风。不接私房。\n周末有空，欢迎互勉/付费约拍',
  );
}
