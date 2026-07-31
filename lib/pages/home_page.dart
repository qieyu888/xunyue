import 'package:flutter/material.dart';

import '../models/feed_post.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scope.dart';
import '../widgets/common_widgets.dart';
import '../widgets/feed_card.dart';
import 'post_detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = AppScope.storeOf(context);
    final feeds = store.visibleHomeFeeds;
    final left = <FeedPost>[];
    final right = <FeedPost>[];
    for (var i = 0; i < feeds.length; i++) {
      if (i.isEven) {
        left.add(feeds[i]);
      } else {
        right.add(feeds[i]);
      }
    }

    return ColoredBox(
      color: AppColors.bg,
      child: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: SectionUnderlineTitle(title: '推荐'),
              ),
            ),
          ),
          Expanded(
            child: feeds.isEmpty
                ? const Center(
                    child: Text(
                      '暂无更多推荐',
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 100),
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              children: left
                                  .map(
                                    (item) => Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 8,
                                        right: 4,
                                      ),
                                      child: FeedCard(
                                        item: item,
                                        onTap: () => _openDetail(context, item),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: right
                                  .map(
                                    (item) => Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 8,
                                        left: 4,
                                      ),
                                      child: FeedCard(
                                        item: item,
                                        onTap: () => _openDetail(context, item),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  void _openDetail(BuildContext context, FeedPost item) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PostDetailPage(item: item)),
    );
  }
}
