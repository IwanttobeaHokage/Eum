import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/models/content_item.dart';

class RecommendationCard extends StatelessWidget {
  final ContentItem item;
  final int index;
  const RecommendationCard({super.key, required this.item, required this.index});

  static const _typeColors = {
    ContentType.cbt: AppColors.primary,
    ContentType.dbt: AppColors.accent,
    ContentType.mindfulness: AppColors.emotionCalm,
  };

  static const _typeIcons = {
    ContentType.cbt: Icons.psychology_outlined,
    ContentType.dbt: Icons.waves_outlined,
    ContentType.mindfulness: Icons.spa_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final color = _typeColors[item.type] ?? AppColors.primary;
    final icon = _typeIcons[item.type] ?? Icons.star_outline;

    return GestureDetector(
      onTap: () => context.push('/practice/${item.id}'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: index == 0
              ? Border.all(color: AppColors.primary.withOpacity(0.4), width: 1.5)
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          item.typeLabel,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${item.durationMinutes}분',
                        style: AppTextStyles.labelSmall,
                      ),
                      if (index == 0) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '추천',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.warningDark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.title,
                    style: AppTextStyles.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    style: AppTextStyles.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                size: 14, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}
