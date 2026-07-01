import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../providers/checkin_provider.dart';

class CheckInScreen extends ConsumerWidget {
  const CheckInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(checkInFormProvider);
    final notifier = ref.read(checkInFormProvider.notifier);

    if (form.submitted) {
      return _SubmittedView(onReset: notifier.reset);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_todayLabel(), style: AppTextStyles.bodyMedium),
                    const SizedBox(height: 4),
                    Text('오늘 하루 어떠셨나요?',
                        style: AppTextStyles.displayMedium),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // 기분
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _Section(
                  title: '지금 기분',
                  child: _MoodRow(
                    value: form.moodScore,
                    onChanged: notifier.setMood,
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // 수면
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _Section(
                  title: '수면 시간',
                  child: _SleepSlider(
                    value: form.sleepHours,
                    onChanged: notifier.setSleep,
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // 실천 여부
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _PracticeToggle(
                  value: form.practiceCompleted,
                  onTap: notifier.togglePractice,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // 메모
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _Section(
                  title: '한 줄 메모 (선택)',
                  child: TextField(
                    onChanged: notifier.setNote,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: '오늘 인상 깊었던 순간이나 느낀 점을 적어보세요...',
                    ),
                    style: AppTextStyles.bodyLarge,
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: notifier.submit,
                    child: const Text('체크인 완료'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _todayLabel() {
    final d = DateTime.now();
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    return '${d.month}월 ${d.day}일 (${weekdays[d.weekday - 1]})';
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  const _Section({required this.title, required this.child});

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
          Text(title, style: AppTextStyles.titleMedium),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _MoodRow extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  const _MoodRow({required this.value, required this.onChanged});

  static const _items = [
    ('😔', '매우\n나쁨'),
    ('😞', '나쁨'),
    ('😐', '보통'),
    ('🙂', '좋음'),
    ('😊', '매우\n좋음'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(_items.length, (i) {
        final selected = i + 1 == value;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(i + 1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primaryLight
                    : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
                border: selected
                    ? Border.all(color: AppColors.primary, width: 1.5)
                    : null,
              ),
              child: Column(
                children: [
                  Text(_items[i].$1,
                      style: TextStyle(fontSize: selected ? 26 : 20)),
                  const SizedBox(height: 4),
                  Text(
                    _items[i].$2,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: selected
                          ? AppColors.primaryDark
                          : AppColors.textHint,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _SleepSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  const _SleepSlider({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final hours = value.floor();
    final half = value - hours >= 0.5;
    final label = half ? '$hours.5시간' : '$hours시간';

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                )),
            Text(
              value < 6 ? '수면 부족' : value >= 8 ? '충분한 수면' : '적정 수면',
              style: AppTextStyles.labelSmall.copyWith(
                color: value < 6 ? AppColors.warning : AppColors.accent,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.surfaceVariant,
            thumbColor: AppColors.primary,
            overlayColor: AppColors.primaryLight,
            trackHeight: 4,
          ),
          child: Slider(
            value: value,
            min: 0,
            max: 12,
            divisions: 24,
            onChanged: onChanged,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('0시간', style: AppTextStyles.labelSmall),
            Text('12시간', style: AppTextStyles.labelSmall),
          ],
        ),
      ],
    );
  }
}

class _PracticeToggle extends StatelessWidget {
  final bool value;
  final VoidCallback onTap;
  const _PracticeToggle({required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: value ? AppColors.accentLight : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: value
              ? Border.all(color: AppColors.accent, width: 1.5)
              : null,
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: value ? AppColors.accent : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                value ? Icons.check_circle : Icons.circle_outlined,
                color: value ? Colors.white : AppColors.textHint,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('오늘 셀프케어 실천했나요?',
                      style: AppTextStyles.titleMedium),
                  Text(
                    value ? '완료했어요 👍' : '탭해서 체크하세요',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color:
                          value ? AppColors.accent : AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubmittedView extends StatelessWidget {
  final VoidCallback onReset;
  const _SubmittedView({required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.favorite_outline,
                      color: AppColors.primary, size: 44),
                ),
                const SizedBox(height: 24),
                Text('체크인 완료!', style: AppTextStyles.displayMedium),
                const SizedBox(height: 12),
                Text(
                  '오늘 하루도 수고하셨어요.\n꾸준한 기록이 나를 이해하는 첫걸음이에요.',
                  style: AppTextStyles.bodyLarge
                      .copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                TextButton(
                  onPressed: onReset,
                  child: Text(
                    '다시 입력하기',
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
