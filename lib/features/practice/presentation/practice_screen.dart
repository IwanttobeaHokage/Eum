import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../providers/practice_provider.dart';

class PracticeScreen extends ConsumerWidget {
  final String contentId;
  const PracticeScreen({super.key, required this.contentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(practiceProvider(contentId));
    final notifier = ref.read(practiceProvider(contentId).notifier);

    if (state.completed) {
      return _CompletionScreen(onDone: () => context.go('/home'));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          state.item.typeLabel,
          style: AppTextStyles.titleMedium,
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 진행률
              _ProgressHeader(state: state),
              const SizedBox(height: 24),

              // 제목
              Text(
                state.item.title,
                style: AppTextStyles.displayMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.timer_outlined,
                      size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    '총 ${state.item.durationMinutes}분',
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // 단계 인디케이터
              _StepDots(
                total: state.totalSteps,
                current: state.currentStep,
              ),
              const SizedBox(height: 20),

              // 현재 단계 카드
              Expanded(
                child: _StepCard(
                  stepNumber: state.currentStep + 1,
                  text: state.item.steps[state.currentStep],
                ),
              ),

              const SizedBox(height: 20),

              // 네비게이션 버튼
              _ActionButtons(
                isFirst: state.currentStep == 0,
                isLast: state.isLastStep,
                onPrev: notifier.prev,
                onNext: notifier.next,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  final PracticeState state;
  const _ProgressHeader({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${state.currentStep + 1} / ${state.totalSteps} 단계',
              style: AppTextStyles.labelSmall,
            ),
            Text(
              '${(state.progress * 100).round()}%',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: state.progress,
            backgroundColor: AppColors.surfaceVariant,
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}

class _StepDots extends StatelessWidget {
  final int total;
  final int current;
  const _StepDots({required this.total, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        final done = i < current;
        final active = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.only(right: 6),
          width: active ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: done
                ? AppColors.accent
                : active
                    ? AppColors.primary
                    : AppColors.divider,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

class _StepCard extends StatelessWidget {
  final int stepNumber;
  final String text;
  const _StepCard({required this.stepNumber, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                '$stepNumber',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            text,
            style: AppTextStyles.bodyLarge.copyWith(
              height: 1.8,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  const _ActionButtons({
    required this.isFirst,
    required this.isLast,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!isFirst) ...[
          Expanded(
            flex: 2,
            child: OutlinedButton(
              onPressed: onPrev,
              child: const Text('이전'),
            ),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          flex: 3,
          child: ElevatedButton(
            onPressed: onNext,
            style: isLast
                ? ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                  )
                : null,
            child: Text(isLast ? '완료하기' : '다음 단계'),
          ),
        ),
      ],
    );
  }
}

class _CompletionScreen extends StatelessWidget {
  final VoidCallback onDone;
  const _CompletionScreen({required this.onDone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.accentLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: AppColors.accent,
                  size: 52,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                '잘 하셨어요!',
                style: AppTextStyles.displayLarge,
              ),
              const SizedBox(height: 12),
              Text(
                '오늘 연습을 완료했어요.\n작은 실천이 큰 변화를 만들어요.',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onDone,
                  child: const Text('홈으로 돌아가기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
