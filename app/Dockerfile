# Use a slim Python image as base
FROM python:3.9-slim

# Set workdir
WORKDIR /app

# Install system dependencies (optional, for Redis or Tornado dependencies)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
 && rm -rf /var/lib/apt/lists/*

# Copy dependencies file and install
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire app code
COPY . .

# Will be overridden at runtime
ENV ENVIRONMENT=DEV
ENV HOST=0.0.0.0
ENV PORT=8000
ENV REDIS_HOST=redis
ENV REDIS_PORT=6379
ENV REDIS_DB=0

# Expose the port
EXPOSE 8000

# Run the app
CMD ["python", "app.py"]
