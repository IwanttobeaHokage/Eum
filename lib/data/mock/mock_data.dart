import '../models/user.dart';
import '../models/record.dart';
import '../models/analysis.dart';
import '../models/content_item.dart';
import '../models/recommendation.dart';
import '../models/check_in.dart';
import '../models/report.dart';

final mockUser = User(
  id: 'u1',
  name: '김이음',
  nextSessionDate: DateTime.now().add(const Duration(days: 7)),
  therapistName: '박지현 상담사',
);

final mockRecord = Record(
  id: 'r1',
  date: DateTime.now().subtract(const Duration(days: 1)),
  content:
      '오늘 상담에서 직장 내 관계 문제를 많이 이야기했어요. 팀장과의 갈등이 계속 머릿속에 맴돌고, '
      '퇴근 후에도 마음이 편하지 않아요. 내가 뭘 잘못하고 있는 건지 자꾸 되새기게 됩니다.',
  moodScore: 4,
  tags: ['직장스트레스', '대인관계', '반추'],
);

final mockAnalysis = Analysis(
  id: 'a1',
  recordId: 'r1',
  summary:
      '직장 내 갈등 상황에서 자기비난적 사고 패턴이 반복되고 있어요. '
      '업무 후에도 사건을 계속 되새기는 반추 경향이 정서적 소진으로 이어지고 있습니다.',
  keywords: ['직장 갈등', '자기비난', '반추', '정서 소진', '경계 설정'],
  themes: ['대인관계', '자기비난', '스트레스'],
  emotionScores: {
    '불안': 0.75,
    '슬픔': 0.50,
    '분노': 0.40,
    '평온': 0.20,
    '기쁨': 0.10,
  },
);

final mockContentItems = <ContentItem>[
  ContentItem(
    id: 'c1',
    title: '생각 멈추기 & 재구성',
    description: '자동적으로 떠오르는 부정적 생각을 포착하고 균형 잡힌 시각으로 바꾸는 CBT 기법입니다.',
    type: ContentType.cbt,
    durationMinutes: 10,
    targetThemes: ['자기비난', '반추'],
    targetEmotions: ['불안', '슬픔'],
    steps: [
      '눈을 감고 지금 가장 신경 쓰이는 생각 하나를 떠올려보세요.',
      '"이 생각이 100% 사실일까?" 스스로에게 물어보세요.',
      '반대 증거를 2가지 이상 찾아보세요.',
      '더 균형 잡힌 생각으로 바꿔 써보세요.',
      '새로운 생각을 소리 내어 읽어보세요.',
    ],
  ),
  ContentItem(
    id: 'c2',
    title: 'STOP 기술 (마음챙김)',
    description: '강한 감정이 올라올 때 잠깐 멈추고 현재로 돌아오는 DBT 핵심 기술입니다.',
    type: ContentType.dbt,
    durationMinutes: 5,
    targetThemes: ['스트레스', '대인관계'],
    targetEmotions: ['불안', '분노'],
    steps: [
      'S — Stop: 하던 것을 멈추세요.',
      'T — Take a breath: 천천히 숨을 들이쉬고 내쉬세요 (4-4-4).',
      'O — Observe: 지금 내 몸, 감정, 생각을 관찰하세요. 판단하지 마세요.',
      'P — Proceed: 상황에 맞는 현명한 행동을 선택하세요.',
    ],
  ),
  ContentItem(
    id: 'c3',
    title: '바디 스캔 이완',
    description: '몸의 긴장을 부위별로 확인하고 풀어주는 마음챙김 이완 기법입니다.',
    type: ContentType.mindfulness,
    durationMinutes: 15,
    targetThemes: ['스트레스'],
    targetEmotions: ['불안', '분노'],
    steps: [
      '편안한 자세로 눕거나 앉으세요.',
      '발끝부터 시작해 천천히 각 신체 부위에 주의를 기울이세요.',
      '긴장된 곳이 느껴지면 숨을 내쉬면서 그 부위를 이완시켜보세요.',
      '머리까지 올라오면 전신을 한 번 느껴보세요.',
      '천천히 눈을 뜨고 현재로 돌아오세요.',
    ],
  ),
];

final mockRecommendation = Recommendation(
  id: 'rec1',
  analysisId: 'a1',
  items: mockContentItems,
  reason: '반복되는 자기비난 패턴과 직장 스트레스에 맞춰 인지 재구성과 즉각적인 감정 조절 기술을 선택했어요.',
);

List<CheckIn> get mockCheckIns => List.generate(14, (i) {
      final date = DateTime.now().subtract(Duration(days: 13 - i));
      return CheckIn(
        id: 'ci$i',
        date: date,
        moodScore: 2 + (i % 3) + (i > 7 ? 1 : 0),
        sleepHours: 5.5 + (i % 3) * 0.5,
        practiceCompleted: i % 3 != 0,
      );
    }).where((c) => c.moodScore <= 5).toList();

Report get mockReport {
  final checkIns = mockCheckIns;
  return Report(
    id: 'rep1',
    periodStart: DateTime.now().subtract(const Duration(days: 13)),
    periodEnd: DateTime.now(),
    checkIns: checkIns,
    topThemes: ['대인관계', '자기비난', '스트레스', '수면', '직장'],
    emotionTrend: List.generate(14, (i) {
      final base = 3.0 + (i > 7 ? 0.5 : 0);
      final fluctuation = (i % 3 == 0 ? -0.5 : (i % 3 == 1 ? 0.3 : 0));
      return {
        'date': DateTime.now().subtract(Duration(days: 13 - i)),
        'score': (base + fluctuation).clamp(1.0, 5.0),
      };
    }),
  );
}
