import 'package:flutter/material.dart';

import '../data/app_store.dart';
import '../widgets/app_scope.dart';
import '../widgets/bottom_nav.dart';
import 'community_page.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'recommend_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;
  AppStore? _store;

  final _pages = const [
    HomePage(),
    RecommendPage(),
    CommunityPage(),
    ProfilePage(),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final store = AppScope.storeOf(context);
    if (!identical(_store, store)) {
      _store?.mainTabIndex.removeListener(_onTabRequested);
      _store = store;
      _index = store.mainTabIndex.value;
      store.mainTabIndex.addListener(_onTabRequested);
    }
  }

  void _onTabRequested() {
    final next = _store?.mainTabIndex.value;
    if (next == null || next == _index || !mounted) return;
    setState(() => _index = next);
  }

  @override
  void dispose() {
    _store?.mainTabIndex.removeListener(_onTabRequested);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: _pages,
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _index,
        onChanged: (i) {
          setState(() => _index = i);
          _store?.selectMainTab(i);
        },
      ),
    );
  }
}
