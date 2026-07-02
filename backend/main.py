import os
from pathlib import Path
from dotenv import load_dotenv
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

load_dotenv(Path(__file__).parent / ".env")

from .routers.analyze import router as analyze_router

app = FastAPI(
    title="이음(Eum) API",
    description="정신건강 셀프케어 앱 이음의 AI 분석 백엔드",
    version="1.0.0",
)

# CORS — Flutter 웹 + 개발 서버 허용
origins = os.getenv("ALLOWED_ORIGINS", "http://localhost:3000,http://localhost:4200").split(",")
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(analyze_router, prefix="", tags=["분석·추천"])


@app.get("/health", tags=["시스템"])
async def health():
    return {"status": "ok", "service": "eum-backend"}
