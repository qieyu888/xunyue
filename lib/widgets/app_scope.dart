import 'package:flutter/material.dart';

import '../data/app_store.dart';

class AppScope extends InheritedWidget {
  const AppScope({
    super.key,
    required this.store,
    required this.refresh,
    required super.child,
  });

  final AppStore store;
  final VoidCallback refresh;

  static AppScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope 未找到，请确认已在根节点包裹');
    return scope!;
  }

  static AppStore storeOf(BuildContext context) => of(context).store;

  @override
  bool updateShouldNotify(AppScope oldWidget) {
    // refresh() 会重建根节点；始终通知依赖方，以便收藏/点赞等即时同步到「我的」等页
    return true;
  }
}
