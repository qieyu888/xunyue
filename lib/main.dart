import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'data/app_store.dart';
import 'data/local_storage.dart';
import 'pages/splash_page.dart';
import 'theme/app_theme.dart';
import 'widgets/app_scope.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  final storage = LocalStorage();
  await storage.init();
  final store = AppStore(storage);
  await store.load();

  runApp(XunyueApp(store: store));
}

class XunyueApp extends StatefulWidget {
  const XunyueApp({super.key, required this.store});

  final AppStore store;

  @override
  State<XunyueApp> createState() => _XunyueAppState();
}

class _XunyueAppState extends State<XunyueApp> {
  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '寻约',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      builder: (context, child) {
        return AppScope(
          store: widget.store,
          refresh: _refresh,
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const SplashPage(),
    );
  }
}
