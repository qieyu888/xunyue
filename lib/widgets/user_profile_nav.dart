import 'package:flutter/material.dart';

import '../data/avatar_helper.dart';
import '../pages/user_profile_page.dart';
import 'app_scope.dart';

/// 打开个人主页：本人回到「我的」Tab，他人进入 [UserProfilePage]。
void openUserProfile(
  BuildContext context, {
  required String author,
  String? avatar,
}) {
  if (author.trim().isEmpty) return;

  final scope = AppScope.of(context);
  final store = scope.store;

  if (AvatarHelper.isCurrentUser(author, store.profile)) {
    store.selectMainTab(3);
    scope.refresh();
    Navigator.of(context).popUntil((route) => route.isFirst);
    return;
  }

  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => UserProfilePage(
        author: author,
        avatar: avatar,
      ),
    ),
  );
}
