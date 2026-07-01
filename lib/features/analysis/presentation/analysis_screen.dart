import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../providers/analysis_provider.dart';
import 'widgets/emotion_bar_chart.dart';
import 'widgets/keyword_chips.dart';
import 'widgets/recommendation_card.dart';

class AnalysisScreen extends ConsumerWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysis = ref.watch(analysisProvider);
    final recommendation = ref.watch(recommendationProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('AI 분석 결과'),
        leading: const BackButton(),
      ),
      body: CustomScrollView(
        slivers: [
          // AI 요약 배너
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(16),
                border:
                    Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.auto_awesome,
                      color: AppColors.primary, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      analysis.summary,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.primaryDark,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // 감정 바 차트
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: EmotionBarChart(emotionScores: analysis.emotionScores),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // 키워드 칩
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: KeywordChips(keywords: analysis.keywords),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // 추천 섹션 헤더
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('셀프케어 추천', style: AppTextStyles.titleLarge),
                  const SizedBox(height: 4),
                  Text(
                    recommendation.reason,
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),
          ),

          // 추천 카드 목록
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => Padding(
                padding:
                    EdgeInsets.fromLTRB(20, 0, 20, i < recommendation.items.length - 1 ? 12 : 32),
                child: RecommendationCard(
                  item: recommendation.items[i],
                  index: i,
                ),
              ),
              childCount: recommendation.items.length,
            ),
          ),
        ],
      ),
    );
  }
}
