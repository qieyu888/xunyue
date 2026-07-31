import 'package:flutter_test/flutter_test.dart';

import 'package:xunyue/data/app_store.dart';
import 'package:xunyue/data/local_storage.dart';
import 'package:xunyue/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('寻约 App 启动并显示首页推荐', (tester) async {
    SharedPreferences.setMockInitialValues({'xunyue_logged_in': true});
    final storage = LocalStorage();
    await storage.init();
    final store = AppStore(storage);
    await store.load();

    await tester.pumpWidget(XunyueApp(store: store));
    await tester.pump(const Duration(milliseconds: 2300));
    await tester.pumpAndSettle();

    expect(find.text('推荐'), findsOneWidget);
    expect(find.text('首页'), findsOneWidget);
    expect(find.text('寻约'), findsOneWidget);
  });

  test('个人主页互动总数与可展示详情数量一致', () async {
    SharedPreferences.setMockInitialValues({});
    final storage = LocalStorage();
    await storage.init();
    final store = AppStore(storage);
    await store.load();

    store.likedIds.addAll({'feed_1', 'moment_1'});
    store.collectedIds.addAll({'feed_2', 'moment_2'});
    store.followedAuthors.addAll({'林夏', '摄影师老王'});

    expect(store.likedEntries, hasLength(2));
    expect(store.favorites, hasLength(2));
    expect(
      store.likedAndCollectedCount,
      store.likedEntries.length + store.favorites.length,
    );
    expect(store.likedAndCollectedCount, 4);
    expect(store.followedAuthors, hasLength(2));
  });
}
