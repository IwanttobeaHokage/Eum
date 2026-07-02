import logging
import uuid
from fastapi import APIRouter
from ..models.schemas import AnalyzeRequest, AnalyzeResponse, Analysis, Recommendation
from ..services.llm_service import analyze_with_llm
from ..services.recommend_service import recommend, safe_defaults

logger = logging.getLogger(__name__)
router = APIRouter()


@router.post(
    "/analyze",
    response_model=AnalyzeResponse,
    summary="상담 기록 AI 분석 + 규칙 기반 셀프케어 추천",
    description="""
**처리 흐름:**
1. LLM → summary / keywords / themes / emotionScores 추출
2. 규칙 기반 매처 → content.json의 targetThemes/targetEmotions와 매칭, 상위 3개 추천

**LLM은 분석만, 추천은 라이브러리에서만 선택합니다.**
LLM 실패 또는 매칭 없을 때는 감정 중립 기본 추천 3개를 반환합니다.
""",
)
async def analyze(request: AnalyzeRequest) -> AnalyzeResponse:
    analysis_id = f"a_{uuid.uuid4().hex[:8]}"
    record_id = f"r_{uuid.uuid4().hex[:8]}"

    # 1. LLM 분석 — 실패해도 500을 내지 않고 fallback으로 진행
    llm_ok = True
    try:
        llm_result = await analyze_with_llm(
            text=request.text,
            mood=request.mood,
            tags=request.tags,
        )
    except Exception as e:
        llm_ok = False
        logger.warning("LLM 분석 실패, fallback 사용: %s", e)

    if not llm_ok:
        analysis = Analysis(
            id=analysis_id,
            recordId=record_id,
            summary="분석이 일시적으로 어려워요. 지금 바로 해볼 수 있는 연습을 먼저 추천드려요.",
            keywords=[],
            themes=[],
            emotionScores={"불안": 0.0, "슬픔": 0.0, "분노": 0.0, "평온": 0.0, "기쁨": 0.0},
        )
        recommendation = Recommendation(
            id=f"rec_{uuid.uuid4().hex[:8]}",
            analysisId=analysis_id,
            items=safe_defaults(),
            reason="분석 없이 바로 시작할 수 있는 기본 연습이에요.",
        )
        return AnalyzeResponse(analysis=analysis, recommendation=recommendation)

    # 2. 정상 경로 — 규칙 기반 추천
    analysis = Analysis(
        id=analysis_id,
        recordId=record_id,
        summary=llm_result.summary,
        keywords=llm_result.keywords,
        themes=llm_result.themes,
        emotionScores=llm_result.emotionScores,
    )

    top_emotions = sorted(llm_result.emotionScores.items(), key=lambda x: x[1], reverse=True)
    high_emotions = [k for k, v in top_emotions if v >= 0.3]

    items = recommend(themes=llm_result.themes, emotions=high_emotions)

    if llm_result.themes and high_emotions:
        overall_reason = (
            f"{', '.join(llm_result.themes[:2])} 주제와 "
            f"{', '.join(high_emotions[:2])} 감정에 맞는 연습을 선택했어요."
        )
    else:
        overall_reason = "현재 상태에 도움이 될 연습을 선택했어요."

    recommendation = Recommendation(
        id=f"rec_{uuid.uuid4().hex[:8]}",
        analysisId=analysis_id,
        items=items,
        reason=overall_reason,
    )

    return AnalyzeResponse(analysis=analysis, recommendation=recommendation)
