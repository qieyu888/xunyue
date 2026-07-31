import 'package:flutter/material.dart';

import '../data/app_images.dart';
import '../models/need_post.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scope.dart';
import '../widgets/common_widgets.dart';
import '../widgets/need_card.dart';
import 'need_detail_page.dart';
import 'publish_need_page.dart';

class RecommendPage extends StatelessWidget {
  const RecommendPage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = AppScope.storeOf(context);
    final needs = store.allNeeds;

    return ColoredBox(
      color: AppColors.bg,
      child: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 10),
              child: Row(
                children: [
                  const SizedBox(width: 48),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            AppImages.logo,
                            width: 28,
                            height: 28,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '寻约',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _openPublish(context),
                    icon: const Icon(Icons.add_box_outlined, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: AppTheme.bannerGradient,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '快速发布需求',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFEA580C),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '摄影 / 模特 / 妆造 一键匹配',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xCCFB923C),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GradientButton(
                        label: '发布',
                        onTap: () => _openPublish(context),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ...needs.map(
                  (item) => NeedCard(
                    item: item,
                    onTap: () => _openDetail(context, item),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openPublish(BuildContext context) async {
    final created = await Navigator.of(context).push<NeedPost>(
      MaterialPageRoute(builder: (_) => const PublishNeedPage()),
    );
    if (created != null && context.mounted) {
      final scope = AppScope.of(context);
      await scope.store.addNeed(created);
      scope.refresh();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('需求已发布')),
        );
      }
    }
  }

  void _openDetail(BuildContext context, NeedPost item) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => NeedDetailPage(item: item)),
    );
  }
}
