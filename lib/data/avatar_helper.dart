import '../data/app_store.dart';
import '../models/user_profile.dart';

/// 当前用户头像同步：个人信息 / 动态 / 评论等处统一解析
class AvatarHelper {
  static const Set<String> selfAliases = {
    'Nana_酱',
  };

  static bool isCurrentUser(String author, UserProfile profile) {
    if (author.isEmpty) return false;
    if (author == profile.nickname) return true;
    return selfAliases.contains(author);
  }

  static String resolve(AppStore store, String author, String fallback) {
    if (isCurrentUser(author, store.profile)) {
      return store.profile.avatar;
    }
    return fallback;
  }
}
