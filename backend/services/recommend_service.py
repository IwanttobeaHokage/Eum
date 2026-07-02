import json
import logging
from pathlib import Path
from ..models.schemas import RecommendedItem

logger = logging.getLogger(__name__)

_content_cache: list[dict] | None = None

DATA_PATH = Path(__file__).parent.parent / "data" / "content.json"

# LLM 실패 또는 score 전부 0일 때 반환할 감정 중립 기본 세트
# 실물 ID 검증 완료: dbt_09(마음챙김 호흡), dbt_02(5-4-3-2-1 그라운딩), dbt_03(감정 라벨링)
SAFE_DEFAULT_IDS = ["dbt_09", "dbt_02", "dbt_03"]

SAFE_DEFAULT_REASON = "지금 바로 해볼 수 있는 기본 연습이에요."


def _load_content() -> list[dict]:
    global _content_cache
    if _content_cache is None:
        with open(DATA_PATH, encoding="utf-8") as f:
            _content_cache = json.load(f)
    return _content_cache


def _to_item(raw: dict, reason: str) -> RecommendedItem:
    return RecommendedItem(
        id=raw["id"],
        title=raw["title"],
        description=raw["description"],
        type=raw["type"],
        steps=raw["steps"],
        durationMinutes=raw["duration"],
        targetThemes=raw["targetThemes"],
        targetEmotions=raw["targetEmotions"],
        evidenceNote=raw.get("evidenceNote", ""),
        reason=reason,
    )


def _score_item(item: dict, themes: list[str], emotions: list[str]) -> int:
    theme_hits = sum(1 for t in item.get("targetThemes", []) if t in themes)
    emotion_hits = sum(1 for e in item.get("targetEmotions", []) if e in emotions)
    return theme_hits * 2 + emotion_hits


def _build_reason(item: dict, themes: list[str], emotions: list[str]) -> str:
    matched_themes = [t for t in item.get("targetThemes", []) if t in themes]
    matched_emotions = [e for e in item.get("targetEmotions", []) if e in emotions]
    parts = []
    if matched_themes:
        parts.append(f"'{', '.join(matched_themes)}' 주제에 효과적")
    if matched_emotions:
        parts.append(f"'{', '.join(matched_emotions)}' 감정 조절에 도움")
    if not parts:
        return "전반적인 심리적 안녕감 향상에 유용한 기법이에요."
    return "이 연습은 " + "이고, ".join(parts) + "이에요."


def safe_defaults() -> list[RecommendedItem]:
    """LLM 실패 또는 매칭 점수 전부 0일 때 반환하는 감정 중립 기본 추천."""
    by_id = {item["id"]: item for item in _load_content()}
    result = []
    for sid in SAFE_DEFAULT_IDS:
        raw = by_id.get(sid)
        if raw:
            result.append(_to_item(raw, SAFE_DEFAULT_REASON))
        else:
            logger.error("SAFE_DEFAULT_IDS에 존재하지 않는 id: %s", sid)
    return result


def recommend(
    themes: list[str],
    emotions: list[str],
    top_n: int = 3,
) -> list[RecommendedItem]:
    all_items = _load_content()

    scored = [(item, _score_item(item, themes, emotions)) for item in all_items]
    scored.sort(key=lambda x: x[1], reverse=True)

    # 최고 점수가 0이면 — 매칭 없음 → 안전 기본 세트 반환
    if scored[0][1] == 0:
        logger.warning("themes/emotions 매칭 점수 전부 0, safe_defaults 반환. themes=%s emotions=%s", themes, emotions)
        return safe_defaults()

    return [
        _to_item(item, _build_reason(item, themes, emotions))
        for item, _ in scored[:top_n]
    ]
