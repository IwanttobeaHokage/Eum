from pydantic import BaseModel, Field
from typing import Dict, List


# ── 요청 ─────────────────────────────────────────────────────────────
class AnalyzeRequest(BaseModel):
    text: str = Field(..., min_length=10, description="상담 기록 텍스트")
    mood: int = Field(default=5, ge=1, le=10, description="기분 점수 1-10")
    tags: List[str] = Field(default_factory=list, description="사용자가 선택한 태그")


# ── LLM이 반환해야 하는 내부 구조 (파싱용) ────────────────────────────
class LLMAnalysisResult(BaseModel):
    summary: str
    keywords: List[str]
    themes: List[str]
    emotionScores: Dict[str, float]


# ── Flutter Analysis 모델과 필드명 일치 ───────────────────────────────
class Analysis(BaseModel):
    id: str
    recordId: str
    summary: str
    keywords: List[str]
    themes: List[str]
    emotionScores: Dict[str, float]


# ── Flutter ContentItem과 필드명 일치 + 추천 근거 ─────────────────────
class RecommendedItem(BaseModel):
    id: str
    title: str
    description: str
    type: str                  # "CBT" | "DBT" | "마음챙김"
    steps: List[str]
    durationMinutes: int
    targetThemes: List[str]
    targetEmotions: List[str]
    evidenceNote: str
    reason: str                # 이 항목을 추천한 근거 한 줄


# ── Flutter Recommendation 모델과 필드명 일치 ─────────────────────────
class Recommendation(BaseModel):
    id: str
    analysisId: str
    items: List[RecommendedItem]
    reason: str                # 전체 추천 요약 한 줄


# ── 최종 응답 ─────────────────────────────────────────────────────────
class AnalyzeResponse(BaseModel):
    analysis: Analysis
    recommendation: Recommendation
