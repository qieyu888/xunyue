import 'package:flutter/foundation.dart';

import 'app_images.dart';
import '../models/comment_item.dart';
import '../models/feed_post.dart';
import '../models/moment_post.dart';
import '../models/need_post.dart';
import '../models/user_profile.dart';
import 'local_storage.dart';
import 'mock_data.dart';

/// 收藏条目：统一卡片展示，并保留来源以便正确跳转详情。
class FavoriteEntry {
  const FavoriteEntry({
    required this.collectKey,
    required this.post,
    this.moment,
  });

  final String collectKey;
  final FeedPost post;
  final MomentPost? moment;

  bool get isMoment => moment != null;
}

/// 点赞内容条目：把作品和动态统一为可展示、可跳转的卡片。
class LikedEntry {
  const LikedEntry({required this.likeKey, required this.post, this.moment});

  final String likeKey;
  final FeedPost post;
  final MomentPost? moment;

  bool get isMoment => moment != null;
}

/// 本地数据仓库。页面变更后自行 setState 刷新。
class AppStore {
  AppStore(this._storage);

  final LocalStorage _storage;

  UserProfile profile = UserProfile.defaults;
  final List<NeedPost> publishedNeeds = [];
  final Set<String> likedIds = {};
  final Set<String> collectedIds = {};
  final Set<String> followedAuthors = {};
  final Set<String> blockedAuthors = {};
  final Set<String> hiddenFeedIds = {};
  final Set<String> hiddenMomentIds = {};
  final Set<String> hiddenNeedIds = {};
  final Map<String, List<CommentItem>> userComments = {};
  final Set<String> likedCommentKeys = {};
  bool isLoggedIn = false;

  /// 主壳底部 Tab：0 首页 / 1 寻约 / 2 动态 / 3 我的
  final ValueNotifier<int> mainTabIndex = ValueNotifier(0);

  Future<void> load() async {
    profile = await _storage.loadProfile();
    publishedNeeds
      ..clear()
      ..addAll(_storage.loadPublishedNeeds());
    likedIds
      ..clear()
      ..addAll(_storage.loadLikedIds());
    collectedIds
      ..clear()
      ..addAll(_storage.loadCollectedIds());
    followedAuthors
      ..clear()
      ..addAll(_storage.loadFollowedAuthors());
    blockedAuthors
      ..clear()
      ..addAll(_storage.loadBlockedAuthors());
    hiddenFeedIds
      ..clear()
      ..addAll(_storage.loadHiddenFeedIds());
    hiddenMomentIds
      ..clear()
      ..addAll(_storage.loadHiddenMomentIds());
    hiddenNeedIds
      ..clear()
      ..addAll(_storage.loadHiddenNeedIds());
    userComments
      ..clear()
      ..addAll(_storage.loadComments());
    likedCommentKeys
      ..clear()
      ..addAll(_storage.loadLikedCommentKeys());
    isLoggedIn = _storage.loadLoggedIn();
  }

  /// 首页可见推荐流（过滤拉黑用户与屏蔽内容）
  List<FeedPost> get visibleHomeFeeds {
    return MockData.homeFeeds.where((post) {
      if (blockedAuthors.contains(post.author)) return false;
      if (hiddenFeedIds.contains(post.id.toString())) return false;
      return true;
    }).toList();
  }

  /// 动态页可见内容（过滤拉黑用户与屏蔽动态）
  List<MomentPost> get visibleMoments {
    return MockData.moments.where((moment) {
      if (blockedAuthors.contains(moment.author)) return false;
      if (hiddenMomentIds.contains(moment.id.toString())) return false;
      return true;
    }).toList();
  }

  /// 「我的」作品（过滤已删除）
  List<FeedPost> get visibleProfileWorks {
    return MockData.profileWorks.where((post) {
      return !hiddenFeedIds.contains(post.id.toString());
    }).toList();
  }

  /// 他人主页作品（首页流 + 个人作品里该作者的内容）
  List<FeedPost> worksForAuthor(String author) {
    final fromHome = MockData.homeFeeds.where((post) {
      if (post.author != author) return false;
      if (hiddenFeedIds.contains(post.id.toString())) return false;
      return true;
    });
    final fromProfile = MockData.profileWorks.where((post) {
      if (post.author != author) return false;
      if (hiddenFeedIds.contains(post.id.toString())) return false;
      return true;
    });
    return [...fromHome, ...fromProfile];
  }

  /// 他人主页动态
  List<MomentPost> momentsForAuthor(String author) {
    return MockData.moments.where((moment) {
      if (moment.author != author) return false;
      if (hiddenMomentIds.contains(moment.id.toString())) return false;
      return true;
    }).toList();
  }

  /// 他人主页需求
  List<NeedPost> needsForAuthor(String author) {
    return allNeeds.where((need) => need.author == author).toList();
  }

  List<NeedPost> get allNeeds {
    return [...publishedNeeds, ...MockData.recommendNeeds].where((need) {
      if (blockedAuthors.contains(need.author)) return false;
      if (hiddenNeedIds.contains(need.id.toString())) return false;
      return true;
    }).toList();
  }

  /// 根据已收藏 ID 解析「我的收藏」列表（新收藏在前）。
  List<FavoriteEntry> get favorites {
    final feedById = <int, FeedPost>{
      for (final p in MockData.homeFeeds) p.id: p,
      for (final p in MockData.profileWorks) p.id: p,
    };
    final momentById = <int, MomentPost>{
      for (final m in MockData.moments) m.id: m,
    };

    final result = <FavoriteEntry>[];
    for (final key in collectedIds.toList().reversed) {
      if (key.startsWith('feed_')) {
        final id = int.tryParse(key.substring(5));
        final post = id == null ? null : feedById[id];
        if (post != null) {
          result.add(FavoriteEntry(collectKey: key, post: post));
        }
      } else if (key.startsWith('moment_')) {
        final id = int.tryParse(key.substring(7));
        final moment = id == null ? null : momentById[id];
        if (moment != null) {
          result.add(
            FavoriteEntry(
              collectKey: key,
              moment: moment,
              post: FeedPost(
                id: moment.id,
                type: moment.category,
                title: moment.title.isNotEmpty ? moment.title : moment.content,
                author: moment.author,
                avatar: moment.avatar,
                image: moment.images.isNotEmpty
                    ? moment.images.first
                    : AppImages.feeds[0],
                likes: moment.likes,
                description: moment.content,
              ),
            ),
          );
        }
      }
    }
    return result;
  }

  /// 根据已点赞 ID 解析点赞列表（新点赞在前）。
  List<LikedEntry> get likedEntries {
    final feedById = <int, FeedPost>{
      for (final p in MockData.homeFeeds) p.id: p,
      for (final p in MockData.profileWorks) p.id: p,
    };
    final momentById = <int, MomentPost>{
      for (final m in MockData.moments) m.id: m,
    };

    final result = <LikedEntry>[];
    for (final key in likedIds.toList().reversed) {
      if (key.startsWith('feed_')) {
        final id = int.tryParse(key.substring(5));
        final post = id == null ? null : feedById[id];
        if (post != null) {
          result.add(LikedEntry(likeKey: key, post: post));
        }
      } else if (key.startsWith('moment_')) {
        final id = int.tryParse(key.substring(7));
        final moment = id == null ? null : momentById[id];
        if (moment != null) {
          result.add(
            LikedEntry(
              likeKey: key,
              moment: moment,
              post: FeedPost(
                id: moment.id,
                type: moment.category,
                title: moment.title.isNotEmpty ? moment.title : moment.content,
                author: moment.author,
                avatar: moment.avatar,
                image: moment.images.isNotEmpty
                    ? moment.images.first
                    : AppImages.feeds[0],
                likes: moment.likes,
                description: moment.content,
              ),
            ),
          );
        }
      }
    }
    return result;
  }

  /// 个人主页“获赞与收藏”的真实本机互动总数。
  int get likedAndCollectedCount => likedEntries.length + favorites.length;

  bool isLiked(String key) => likedIds.contains(key);

  bool isCollected(String key) => collectedIds.contains(key);

  bool isFollowed(String author) => followedAuthors.contains(author);

  String commentLikeKey(String threadKey, int commentId) =>
      '$threadKey:$commentId';

  bool isCommentLiked(String threadKey, int commentId) {
    return likedCommentKeys.contains(commentLikeKey(threadKey, commentId));
  }

  /// 某内容下的评论：用户新发在前，其后为默认评论；点赞数含本地点赞。
  /// 默认评论条数与列表展示的评论数一致（1–5），且各帖评论内容互不雷同。
  List<CommentItem> commentsFor(String threadKey) {
    final extras = userComments[threadKey] ?? const <CommentItem>[];
    final seedCount = seededCommentCount(threadKey);
    final seeded = MockData.seededCommentsFor(threadKey, seedCount).map((c) {
      final liked = isCommentLiked(threadKey, c.id);
      return liked ? c.copyWith(likes: c.likes + 1) : c;
    });
    final userMapped = extras.map((c) {
      final liked = isCommentLiked(threadKey, c.id);
      return liked ? c.copyWith(likes: c.likes + 1) : c;
    });
    return [...userMapped, ...seeded];
  }

  /// 各内容默认评论条数（不含用户新发），与卡片上的评论数字对齐。
  int seededCommentCount(String threadKey) {
    if (threadKey.startsWith('moment_')) {
      final id = int.tryParse(threadKey.substring('moment_'.length));
      if (id != null) {
        for (final moment in MockData.moments) {
          if (moment.id == id) {
            return moment.comments.clamp(1, 5);
          }
        }
      }
    } else if (threadKey.startsWith('feed_')) {
      final id = int.tryParse(threadKey.substring('feed_'.length));
      if (id != null) {
        return 1 + ((id - 1) % 5);
      }
    } else if (threadKey.startsWith('need_')) {
      final id = int.tryParse(threadKey.substring('need_'.length));
      if (id != null) {
        return 1 + ((id - 1) % 5);
      }
    }
    return 3;
  }

  Future<CommentItem> addComment(
    String threadKey,
    String content, {
    String? replyTo,
  }) async {
    final text = content.trim();
    if (text.isEmpty) {
      throw ArgumentError('评论内容不能为空');
    }
    final comment = CommentItem(
      id: DateTime.now().millisecondsSinceEpoch,
      author: profile.nickname,
      avatar: profile.avatar,
      content: text,
      time: '刚刚',
      likes: 0,
      replyTo: replyTo,
    );
    final list = List<CommentItem>.from(userComments[threadKey] ?? const []);
    list.insert(0, comment);
    userComments[threadKey] = list;
    await _storage.saveComments(userComments);
    return comment;
  }

  Future<void> deleteComment(String threadKey, int commentId) async {
    final list = userComments[threadKey];
    if (list == null) return;
    list.removeWhere((c) => c.id == commentId);
    if (list.isEmpty) {
      userComments.remove(threadKey);
    }
    likedCommentKeys.remove(commentLikeKey(threadKey, commentId));
    await _storage.saveComments(userComments);
    await _storage.saveLikedCommentKeys(likedCommentKeys);
  }

  Future<void> toggleCommentLike(String threadKey, int commentId) async {
    final key = commentLikeKey(threadKey, commentId);
    if (likedCommentKeys.contains(key)) {
      likedCommentKeys.remove(key);
    } else {
      likedCommentKeys.add(key);
    }
    await _storage.saveLikedCommentKeys(likedCommentKeys);
  }

  Future<void> toggleLike(String key) async {
    if (likedIds.contains(key)) {
      likedIds.remove(key);
    } else {
      likedIds.add(key);
    }
    await _storage.saveLikedIds(likedIds);
  }

  Future<void> toggleCollect(String key) async {
    if (collectedIds.contains(key)) {
      collectedIds.remove(key);
    } else {
      collectedIds.add(key);
    }
    await _storage.saveCollectedIds(collectedIds);
  }

  Future<void> toggleFollow(String author) async {
    if (followedAuthors.contains(author)) {
      followedAuthors.remove(author);
    } else {
      followedAuthors.add(author);
    }
    await _storage.saveFollowedAuthors(followedAuthors);
  }

  /// 拉黑用户：首页不再展示其内容，并取消关注
  Future<void> blockAuthor(String author) async {
    blockedAuthors.add(author);
    followedAuthors.remove(author);
    await _storage.saveBlockedAuthors(blockedAuthors);
    await _storage.saveFollowedAuthors(followedAuthors);
  }

  /// 不感兴趣 / 举报后屏蔽单条首页动态
  Future<void> hideFeed(int feedId) async {
    hiddenFeedIds.add(feedId.toString());
    await _storage.saveHiddenFeedIds(hiddenFeedIds);
  }

  /// 不感兴趣 / 举报后屏蔽单条社区动态
  Future<void> hideMoment(int momentId) async {
    hiddenMomentIds.add(momentId.toString());
    await _storage.saveHiddenMomentIds(hiddenMomentIds);
  }

  /// 不感兴趣 / 举报后屏蔽单条约拍需求
  Future<void> hideNeed(int needId) async {
    hiddenNeedIds.add(needId.toString());
    await _storage.saveHiddenNeedIds(hiddenNeedIds);
  }

  void selectMainTab(int index) {
    mainTabIndex.value = index;
  }

  Future<void> saveProfile(UserProfile next) async {
    profile = next;
    await _storage.saveProfile(next);
  }

  Future<void> addNeed(NeedPost need) async {
    publishedNeeds.insert(0, need);
    await _storage.savePublishedNeeds(publishedNeeds);
  }

  /// 删除自己发布的需求
  Future<void> deleteNeed(int needId) async {
    publishedNeeds.removeWhere((n) => n.id == needId);
    hiddenNeedIds.add(needId.toString());
    await _storage.savePublishedNeeds(publishedNeeds);
    await _storage.saveHiddenNeedIds(hiddenNeedIds);
  }

  Future<void> clearInteractions() async {
    likedIds.clear();
    collectedIds.clear();
    followedAuthors.clear();
    blockedAuthors.clear();
    hiddenFeedIds.clear();
    hiddenMomentIds.clear();
    hiddenNeedIds.clear();
    userComments.clear();
    likedCommentKeys.clear();
    await _storage.clearInteractions();
  }

  /// 退出账号：清除互动状态，保留本机资料展示
  Future<void> logout() async {
    await clearInteractions();
    isLoggedIn = false;
    await _storage.saveLoggedIn(false);
  }

  Future<void> login() async {
    isLoggedIn = true;
    await _storage.saveLoggedIn(true);
  }

  /// 注销账号：清空本机全部用户数据并恢复默认资料
  Future<void> deleteAccount() async {
    likedIds.clear();
    collectedIds.clear();
    followedAuthors.clear();
    blockedAuthors.clear();
    hiddenFeedIds.clear();
    hiddenMomentIds.clear();
    hiddenNeedIds.clear();
    userComments.clear();
    likedCommentKeys.clear();
    publishedNeeds.clear();
    profile = UserProfile.defaults;
    isLoggedIn = false;
    await _storage.clearAll();
  }
}
