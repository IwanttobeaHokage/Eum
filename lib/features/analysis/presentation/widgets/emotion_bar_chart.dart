import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class EmotionBarChart extends StatelessWidget {
  final Map<String, double> emotionScores;
  const EmotionBarChart({super.key, required this.emotionScores});

  static const _emotionColors = {
    '불안': AppColors.emotionAnxious,
    '슬픔': AppColors.emotionSad,
    '분노': AppColors.emotionAngry,
    '평온': AppColors.emotionCalm,
    '기쁨': AppColors.emotionJoy,
  };

  @override
  Widget build(BuildContext context) {
    final sorted = emotionScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('감정 분포', style: AppTextStyles.titleMedium),
          const SizedBox(height: 16),
          ...sorted.map((e) => _EmotionRow(
                label: e.key,
                value: e.value,
                color:
                    _emotionColors[e.key] ?? AppColors.primary,
              )),
        ],
      ),
    );
  }
}

class _EmotionRow extends StatelessWidget {
  final String label;
  final double value; // 0.0–1.0
  final Color color;
  const _EmotionRow(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              label,
              style: AppTextStyles.labelLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOut,
                    height: 28,
                    width: constraints.maxWidth * value,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              );
            }),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 34,
            child: Text(
              '${(value * 100).round()}%',
              style: AppTextStyles.labelSmall,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
