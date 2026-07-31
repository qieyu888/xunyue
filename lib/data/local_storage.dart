import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/comment_item.dart';
import '../models/need_post.dart';
import '../models/user_profile.dart';

class LocalStorage {
  static const String _keyProfile = 'xunyue_profile';
  static const String _keyLiked = 'xunyue_liked_ids';
  static const String _keyCollected = 'xunyue_collected_ids';
  static const String _keyFollowed = 'xunyue_followed_authors';
  static const String _keyBlocked = 'xunyue_blocked_authors';
  static const String _keyHiddenFeeds = 'xunyue_hidden_feed_ids';
  static const String _keyHiddenMoments = 'xunyue_hidden_moment_ids';
  static const String _keyHiddenNeeds = 'xunyue_hidden_need_ids';
  static const String _keyComments = 'xunyue_comments';
  static const String _keyLikedComments = 'xunyue_liked_comments';
  static const String _keyNeeds = 'xunyue_published_needs';
  static const String _keyLoggedIn = 'xunyue_logged_in';

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get prefs {
    final p = _prefs;
    if (p == null) {
      throw StateError('LocalStorage 尚未初始化，请先调用 init()');
    }
    return p;
  }

  Future<UserProfile> loadProfile() async {
    final raw = prefs.getString(_keyProfile);
    if (raw == null || raw.isEmpty) {
      return UserProfile.defaults;
    }
    try {
      return UserProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return UserProfile.defaults;
    }
  }

  Future<void> saveProfile(UserProfile profile) async {
    await prefs.setString(_keyProfile, jsonEncode(profile.toJson()));
  }

  Set<String> loadLikedIds() {
    return prefs.getStringList(_keyLiked)?.toSet() ?? <String>{};
  }

  Future<void> saveLikedIds(Set<String> ids) async {
    await prefs.setStringList(_keyLiked, ids.toList());
  }

  Set<String> loadCollectedIds() {
    return prefs.getStringList(_keyCollected)?.toSet() ?? <String>{};
  }

  Future<void> saveCollectedIds(Set<String> ids) async {
    await prefs.setStringList(_keyCollected, ids.toList());
  }

  Set<String> loadFollowedAuthors() {
    return prefs.getStringList(_keyFollowed)?.toSet() ?? <String>{};
  }

  Future<void> saveFollowedAuthors(Set<String> authors) async {
    await prefs.setStringList(_keyFollowed, authors.toList());
  }

  Set<String> loadBlockedAuthors() {
    return prefs.getStringList(_keyBlocked)?.toSet() ?? <String>{};
  }

  Future<void> saveBlockedAuthors(Set<String> authors) async {
    await prefs.setStringList(_keyBlocked, authors.toList());
  }

  Set<String> loadHiddenFeedIds() {
    return prefs.getStringList(_keyHiddenFeeds)?.toSet() ?? <String>{};
  }

  Future<void> saveHiddenFeedIds(Set<String> ids) async {
    await prefs.setStringList(_keyHiddenFeeds, ids.toList());
  }

  Set<String> loadHiddenMomentIds() {
    return prefs.getStringList(_keyHiddenMoments)?.toSet() ?? <String>{};
  }

  Future<void> saveHiddenMomentIds(Set<String> ids) async {
    await prefs.setStringList(_keyHiddenMoments, ids.toList());
  }

  Set<String> loadHiddenNeedIds() {
    return prefs.getStringList(_keyHiddenNeeds)?.toSet() ?? <String>{};
  }

  Future<void> saveHiddenNeedIds(Set<String> ids) async {
    await prefs.setStringList(_keyHiddenNeeds, ids.toList());
  }

  Map<String, List<CommentItem>> loadComments() {
    final raw = prefs.getString(_keyComments);
    if (raw == null || raw.isEmpty) return {};
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return map.map((key, value) {
        final list = (value as List<dynamic>)
            .map((e) => CommentItem.fromJson(e as Map<String, dynamic>))
            .toList();
        return MapEntry(key, list);
      });
    } catch (_) {
      return {};
    }
  }

  Future<void> saveComments(Map<String, List<CommentItem>> comments) async {
    final encoded = jsonEncode(
      comments.map(
        (key, value) => MapEntry(key, value.map((e) => e.toJson()).toList()),
      ),
    );
    await prefs.setString(_keyComments, encoded);
  }

  Set<String> loadLikedCommentKeys() {
    return prefs.getStringList(_keyLikedComments)?.toSet() ?? <String>{};
  }

  Future<void> saveLikedCommentKeys(Set<String> keys) async {
    await prefs.setStringList(_keyLikedComments, keys.toList());
  }

  List<NeedPost> loadPublishedNeeds() {
    final raw = prefs.getString(_keyNeeds);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => NeedPost.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> savePublishedNeeds(List<NeedPost> needs) async {
    final encoded = jsonEncode(needs.map((e) => e.toJson()).toList());
    await prefs.setString(_keyNeeds, encoded);
  }

  Future<void> clearInteractions() async {
    await prefs.remove(_keyLiked);
    await prefs.remove(_keyCollected);
    await prefs.remove(_keyFollowed);
    await prefs.remove(_keyBlocked);
    await prefs.remove(_keyHiddenFeeds);
    await prefs.remove(_keyHiddenMoments);
    await prefs.remove(_keyHiddenNeeds);
    await prefs.remove(_keyComments);
    await prefs.remove(_keyLikedComments);
  }

  Future<void> clearAll() async {
    await prefs.remove(_keyProfile);
    await prefs.remove(_keyLiked);
    await prefs.remove(_keyCollected);
    await prefs.remove(_keyFollowed);
    await prefs.remove(_keyBlocked);
    await prefs.remove(_keyHiddenFeeds);
    await prefs.remove(_keyHiddenMoments);
    await prefs.remove(_keyHiddenNeeds);
    await prefs.remove(_keyComments);
    await prefs.remove(_keyLikedComments);
    await prefs.remove(_keyNeeds);
    await prefs.remove(_keyLoggedIn);
  }

  bool loadLoggedIn() => prefs.getBool(_keyLoggedIn) ?? false;

  Future<void> saveLoggedIn(bool value) async {
    await prefs.setBool(_keyLoggedIn, value);
  }
}
