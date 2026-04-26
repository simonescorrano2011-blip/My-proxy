FROM python:3.11-bookworm

WORKDIR /app

COPY requirements.txt .

ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright
ENV PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=0
ENV PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y \
    ffmpeg \
    xvfb \
    libnss3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libasound2 \
    libpango-1.0-0 \
    libcairo2 \
    libatspi2.0-0 \
    libxshmfence1 \
    libglu1-mesa \
    ca-certificates \
    fonts-liberation \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir -r requirements.txt

RUN python -m playwright install chromium

COPY . .

EXPOSE 7860

# ✅ FIX PORTA + stabilità Railway
CMD ["sh", "-c", "WORKERS_COUNT=${WORKERS:-2}; xvfb-run -a --server-args='-screen 0 1366x768x24' gunicorn --bind 0.0.0.0:$PORT --workers $WORKERS_COUNT --worker-class aiohttp.worker.GunicornWebWorker --timeout 120 --graceful-timeout 120 app:app"]
