import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../providers/report_provider.dart';
import 'widgets/trend_chart.dart';
import 'widgets/theme_tags.dart';

class ReportScreen extends ConsumerWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(reportProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 헤더
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _periodLabel(
                              report.periodStart, report.periodEnd),
                          style: AppTextStyles.bodyMedium,
                        ),
                        const SizedBox(height: 2),
                        Text('나의 리포트', style: AppTextStyles.displayMedium),
                      ],
                    ),
                    _ShareButton(),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // 요약 지표 카드
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _SummaryCards(report: report),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // 추세 차트
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TrendChart(emotionTrend: report.emotionTrend),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // 핵심 주제
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ThemeTags(themes: report.topThemes),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // 체크인 기록 요약
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _CheckInSummary(report: report),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // 상담사 공유 버튼
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                child: _ShareWithTherapistButton(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _periodLabel(DateTime start, DateTime end) {
    return '${start.month}월 ${start.day}일 — ${end.month}월 ${end.day}일';
  }
}

class _SummaryCards extends StatelessWidget {
  final dynamic report;
  const _SummaryCards({required this.report});

  @override
  Widget build(BuildContext context) {
    final avgMood = report.avgMoodScore as double;
    final practiceRate =
        (report.practiceCompletionRate * 100).round();
    final totalCheckIns = (report.checkIns as List).length;

    return Row(
      children: [
        _StatCard(
          label: '평균 기분',
          value: avgMood.toStringAsFixed(1),
          unit: '/ 5',
          icon: Icons.mood,
          color: AppColors.primary,
        ),
        const SizedBox(width: 10),
        _StatCard(
          label: '실천율',
          value: '$practiceRate',
          unit: '%',
          icon: Icons.check_circle_outline,
          color: AppColors.accent,
        ),
        const SizedBox(width: 10),
        _StatCard(
          label: '체크인',
          value: '$totalCheckIns',
          unit: '회',
          icon: Icons.calendar_today_outlined,
          color: AppColors.emotionAnxious,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;
  const _StatCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: AppTextStyles.displayMedium.copyWith(
                    color: color,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(width: 2),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(unit,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: color.withOpacity(0.7),
                      )),
                ),
              ],
            ),
            Text(label, style: AppTextStyles.labelSmall),
          ],
        ),
      ),
    );
  }
}

class _CheckInSummary extends StatelessWidget {
  final dynamic report;
  const _CheckInSummary({required this.report});

  @override
  Widget build(BuildContext context) {
    final checkIns = report.checkIns as List;
    if (checkIns.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('체크인 기록', style: AppTextStyles.titleMedium),
          const SizedBox(height: 14),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: checkIns.map((c) {
              final mood = c.moodScore as int;
              final done = c.practiceCompleted as bool;
              final date = c.date as DateTime;
              return Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _moodColor(mood).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: done
                      ? Border.all(
                          color: AppColors.accent, width: 1.5)
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${date.day}',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: _moodColor(mood),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      _moodEmoji(mood),
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _Legend(
                  color: AppColors.accent, label: '테두리 = 실천 완료'),
              const SizedBox(width: 16),
              _Legend(
                  color: AppColors.primary, label: '색상 = 기분 수준'),
            ],
          ),
        ],
      ),
    );
  }

  Color _moodColor(int mood) {
    switch (mood) {
      case 1:
        return AppColors.emotionAngry;
      case 2:
        return AppColors.emotionSad;
      case 3:
        return AppColors.emotionAnxious;
      case 4:
        return AppColors.emotionCalm;
      default:
        return AppColors.emotionJoy;
    }
  }

  String _moodEmoji(int mood) {
    const emojis = ['😔', '😞', '😐', '🙂', '😊'];
    return emojis[(mood - 1).clamp(0, 4)];
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 10,
            height: 10,
            decoration:
                BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label,
            style: AppTextStyles.labelSmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
      ],
    );
  }
}

class _ShareButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.ios_share, size: 16),
      label: const Text('공유'),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        textStyle: const TextStyle(
          fontFamily: 'NotoSansKR',
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _ShareWithTherapistButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showShareDialog(context),
        icon: const Icon(Icons.send_outlined, size: 18),
        label: const Text('상담사에게 공유하기'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
        ),
      ),
    );
  }

  void _showShareDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: const Text(
          '상담사에게 공유',
          style: TextStyle(
            fontFamily: 'NotoSansKR',
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          '리포트를 상담사에게 전달할까요?\n(실제 전송 기능은 다음 단계에서 구현됩니다)',
          style: TextStyle(fontFamily: 'NotoSansKR'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소',
                style: TextStyle(
                    fontFamily: 'NotoSansKR',
                    color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent),
            child: const Text('확인',
                style: TextStyle(fontFamily: 'NotoSansKR')),
          ),
        ],
      ),
    );
  }
}
