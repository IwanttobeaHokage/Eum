import json
import logging
import os
import re
import httpx
from ..models.schemas import LLMAnalysisResult

logger = logging.getLogger(__name__)

AVAILABLE_THEMES = [
    "대인관계", "자기비판", "자기비난", "스트레스", "수면", "불안",
    "우울", "분노", "반추", "직장", "가족", "고립", "무기력",
    "완벽주의", "경계설정", "충동", "회피", "수치심", "감정조절",
]
AVAILABLE_THEMES_SET = set(AVAILABLE_THEMES)

SYSTEM_PROMPT = f"""당신은 심리상담 기록을 분석하는 AI입니다.
사용자의 상담 기록을 분석하고 반드시 아래 JSON 형식만 출력하세요.
마크다운, 설명, 코드블록 없이 JSON 오브젝트 하나만 출력하세요.

{{"summary":"2-3문장 한국어 요약","keywords":["키1","키2","키3","키4"],"themes":["테마1","테마2"],"emotionScores":{{"불안":0.7,"슬픔":0.5,"분노":0.3,"평온":0.2,"기쁨":0.1}}}}

규칙:
- summary: 2-3문장, 한국어, 공감적 어조
- keywords: 4-6개 한국어 단어
- themes: 2-4개, 반드시 아래 목록의 값을 그대로 사용. 영어 번역·신조어·변형 절대 금지.
  허용 목록: {', '.join(AVAILABLE_THEMES)}
- emotionScores: 불안/슬픔/분노/평온/기쁨 다섯 키 모두 포함, 값 0.0~1.0
- 유효한 JSON만 출력. 다른 텍스트 절대 금지."""


def _get_config() -> tuple[str, str, str]:
    base_url = os.getenv("MLAPI_BASE_URL", "").rstrip("/")
    token = os.getenv("MLAPI_TOKEN", "")
    model = os.getenv("MLAPI_MODEL", "openai/gpt-5-nano")
    if not base_url or not token:
        raise ValueError("MLAPI_BASE_URL 또는 MLAPI_TOKEN 환경변수가 설정되지 않았습니다.")
    return base_url, token, model


def _extract_json(raw: str) -> str:
    raw = re.sub(r"```(?:json)?", "", raw).strip()
    start = raw.find("{")
    end = raw.rfind("}") + 1
    if start == -1 or end == 0:
        raise ValueError(f"응답에서 JSON을 찾을 수 없습니다: {raw[:200]}")
    return raw[start:end]


async def analyze_with_llm(
    text: str,
    mood: int,
    tags: list[str],
) -> LLMAnalysisResult:
    base_url, token, model = _get_config()

    user_message = f"""상담 기록:
{text}

기분 점수: {mood}/10
선택한 태그: {', '.join(tags) if tags else '없음'}"""

    payload = {
        "model": model,
        "max_completion_tokens": 8192,
        "messages": [
            {"role": "system", "content": SYSTEM_PROMPT},
            {"role": "user", "content": user_message},
        ],
    }
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json",
    }

    async with httpx.AsyncClient(timeout=60.0) as client:
        resp = await client.post(
            f"{base_url}/v1/chat/completions",
            json=payload,
            headers=headers,
        )
        resp.raise_for_status()

    data = resp.json()
    raw = data["choices"][0]["message"]["content"]
    json_str = _extract_json(raw)

    try:
        parsed = json.loads(json_str)
    except json.JSONDecodeError as e:
        raise ValueError(f"LLM 응답 JSON 파싱 실패: {e}\n원문: {json_str[:300]}")

    # 테마 검증 — 허용 목록 외 값 제거 + 경고 로그
    raw_themes = parsed.get("themes", [])
    valid_themes = [t for t in raw_themes if t in AVAILABLE_THEMES_SET]
    dropped = [t for t in raw_themes if t not in AVAILABLE_THEMES_SET]
    if dropped:
        logger.warning("테마 필터링됨 (허용 목록 외): %s", dropped)
    parsed["themes"] = valid_themes

    # 필수 감정 키 보정
    emotion_keys = {"불안", "슬픔", "분노", "평온", "기쁨"}
    scores = parsed.get("emotionScores", {})
    for k in emotion_keys:
        scores.setdefault(k, 0.0)
    parsed["emotionScores"] = {
        k: float(max(0.0, min(1.0, v))) for k, v in scores.items()
    }

    return LLMAnalysisResult(**parsed)
