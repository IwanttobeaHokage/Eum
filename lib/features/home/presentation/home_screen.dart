import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../providers/home_provider.dart';
import 'widgets/dday_card.dart';
import 'widgets/emotion_mini_chart.dart';
import 'widgets/quick_action_row.dart';
import 'widgets/today_care_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final todayCheckIn = ref.watch(todayCheckInProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '안녕하세요, ${user.name.substring(1)}님',
                          style: AppTextStyles.bodyMedium,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '오늘도 잘 지내고 있나요?',
                          style: AppTextStyles.titleLarge,
                        ),
                      ],
                    ),
                    _CheckInBadge(isDone: todayCheckIn != null),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // D-Day 카드
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: DDayCard(),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // 빠른 액션
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: QuickActionRow(),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // 오늘의 셀프케어
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TodayCareCard(),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // 감정 흐름 미니 차트
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: EmotionMiniChart(),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}

class _CheckInBadge extends StatelessWidget {
  final bool isDone;
  const _CheckInBadge({required this.isDone});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDone ? AppColors.accentLight : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isDone ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 14,
            color: isDone ? AppColors.accent : AppColors.textHint,
          ),
          const SizedBox(width: 4),
          Text(
            isDone ? '체크인 완료' : '체크인 전',
            style: AppTextStyles.labelSmall.copyWith(
              color: isDone ? AppColors.accent : AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }
}
