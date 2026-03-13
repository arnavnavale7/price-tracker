# Build stage
FROM python:3.11-slim as builder

WORKDIR /app/backend

# Install system dependencies
RUN apt-get update && apt-get install -y \
    chromium-browser \
    chromium-driver \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install Python dependencies
COPY backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Runtime stage
FROM python:3.11-slim

WORKDIR /app/backend

# Install runtime dependencies only
RUN apt-get update && apt-get install -y \
    chromium-browser \
    chromium-driver \
    && rm -rf /var/lib/apt/lists/*

# Copy Python packages from builder
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages

# Copy app code
COPY backend/ .
COPY backend/.env .env

# Expose port
EXPOSE 8000

# Run the app
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
