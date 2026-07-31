import 'package:flutter/material.dart';

import '../models/moment_post.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scope.dart';
import '../widgets/common_widgets.dart';
import '../widgets/moment_card.dart';
import 'moment_detail_page.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final moments = AppScope.storeOf(context).visibleMoments;

    return ColoredBox(
      color: AppColors.bg,
      child: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: SectionUnderlineTitle(title: '动态'),
              ),
            ),
          ),
          Expanded(
            child: moments.isEmpty
                ? const Center(
                    child: Text(
                      '暂无更多动态',
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.only(bottom: 100),
                    itemCount: moments.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1, color: AppColors.border),
                    itemBuilder: (context, index) {
                      final item = moments[index];
                      return MomentCard(
                        item: item,
                        onTap: () => _openDetail(context, item),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _openDetail(BuildContext context, MomentPost item) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => MomentDetailPage(item: item)),
    );
  }
}
