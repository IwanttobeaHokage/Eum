import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../providers/record_provider.dart';

class RecordScreen extends ConsumerWidget {
  const RecordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(recordFormProvider);
    final notifier = ref.read(recordFormProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('상담 기록'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: form.isValid
                ? () {
                    notifier.submit();
                    context.go('/analysis');
                  }
                : null,
            child: Text(
              'AI 분석',
              style: AppTextStyles.titleMedium.copyWith(
                color: form.isValid
                    ? AppColors.primary
                    : AppColors.textHint,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 날짜 표시
            Text(
              _formatDate(DateTime.now()),
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 16),

            // 기분 선택
            _SectionTitle('지금 기분은 어떤가요?'),
            const SizedBox(height: 12),
            _MoodSelector(
              value: form.moodScore,
              onChanged: notifier.setMood,
            ),
            const SizedBox(height: 24),

            // 상담 내용 입력
            _SectionTitle('오늘 상담에서 어떤 이야기를 했나요?'),
            const SizedBox(height: 4),
            Text(
              '10자 이상 적으면 AI 분석이 시작됩니다.',
              style: AppTextStyles.labelSmall,
            ),
            const SizedBox(height: 10),
            TextField(
              maxLines: 8,
              onChanged: notifier.setContent,
              decoration: const InputDecoration(
                hintText: '오늘 상담에서 나눈 이야기, 느낀 점, 떠오르는 생각을 자유롭게 적어보세요...',
              ),
              style: AppTextStyles.bodyLarge,
            ),
            const SizedBox(height: 24),

            // 태그
            _SectionTitle('관련 주제를 선택해보세요 (선택)'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: availableTags.map((tag) {
                final selected = form.selectedTags.contains(tag);
                return FilterChip(
                  label: Text(tag),
                  selected: selected,
                  onSelected: (_) => notifier.toggleTag(tag),
                  selectedColor: AppColors.primaryLight,
                  backgroundColor: AppColors.surfaceVariant,
                  checkmarkColor: AppColors.primaryDark,
                  labelStyle: AppTextStyles.labelLarge.copyWith(
                    color: selected
                        ? AppColors.primaryDark
                        : AppColors.textSecondary,
                  ),
                  side: BorderSide(
                    color: selected
                        ? AppColors.primary
                        : Colors.transparent,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 40),

            // 하단 CTA
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: form.isValid
                    ? () {
                        notifier.submit();
                        context.go('/analysis');
                      }
                    : null,
                icon: const Icon(Icons.auto_awesome, size: 18),
                label: const Text('AI 분석 시작하기'),
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor: AppColors.surfaceVariant,
                  disabledForegroundColor: AppColors.textHint,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    return '${d.year}년 ${d.month}월 ${d.day}일 (${weekdays[d.weekday - 1]})';
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.titleMedium);
  }
}

class _MoodSelector extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  const _MoodSelector({required this.value, required this.onChanged});

  static const _emojis = ['😔', '😞', '😐', '🙂', '😊'];
  static const _labels = ['많이 힘들어요', '조금 힘들어요', '그저 그래요', '괜찮아요', '좋아요'];

  @override
  Widget build(BuildContext context) {
    // value 1–5 → index 0–4
    final idx = (value - 1).clamp(0, 4);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (i) {
              final selected = i == idx;
              return GestureDetector(
                onTap: () => onChanged(i + 1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.primaryLight
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _emojis[i],
                    style: TextStyle(fontSize: selected ? 32 : 24),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Text(_labels[idx], style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}
