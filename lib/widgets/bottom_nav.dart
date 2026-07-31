import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onChanged,
  });

  final int currentIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final items = <_NavSpec>[
      const _NavSpec(Icons.home_rounded, '首页'),
      const _NavSpec(Icons.explore_outlined, '寻约'),
      const _NavSpec(Icons.chat_bubble_outline_rounded, '动态'),
      const _NavSpec(Icons.person_outline_rounded, '我的'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        border: const Border(top: BorderSide(color: AppColors.border)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 10,
        bottom: MediaQuery.paddingOf(context).bottom + 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final active = index == currentIndex;
          return Expanded(
            child: InkWell(
              onTap: () => onChanged(index),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedScale(
                      scale: active ? 1.1 : 1,
                      duration: const Duration(milliseconds: 180),
                      child: Icon(
                        item.icon,
                        size: 24,
                        color: active ? AppColors.rose : AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: active ? FontWeight.bold : FontWeight.w500,
                        color: active ? AppColors.rose : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NavSpec {
  const _NavSpec(this.icon, this.label);

  final IconData icon;
  final String label;
}
