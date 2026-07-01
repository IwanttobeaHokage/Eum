import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class ThemeTags extends StatelessWidget {
  final List<String> themes;
  const ThemeTags({super.key, required this.themes});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('핵심 주제', style: AppTextStyles.titleMedium),
          const SizedBox(height: 4),
          Text('상담 기록에서 자주 등장한 주제예요', style: AppTextStyles.bodyMedium),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: themes.asMap().entries.map((e) {
              final isTop = e.key == 0;
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isTop
                      ? AppColors.primaryLight
                      : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(20),
                  border: isTop
                      ? Border.all(
                          color: AppColors.primary.withOpacity(0.4))
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isTop)
                      const Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Icon(Icons.star_rounded,
                            size: 13, color: AppColors.primary),
                      ),
                    Text(
                      e.value,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: isTop
                            ? AppColors.primaryDark
                            : AppColors.textSecondary,
                        fontWeight:
                            isTop ? FontWeight.w600 : FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
