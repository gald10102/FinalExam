# Stage 1: Builder
FROM python:3.11-slim AS builder

WORKDIR /app

# Copy the requirements file
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2: Final Image
FROM python:3.11-slim

WORKDIR /app

# Copy installed dependencies from the builder stage
COPY --from=builder /usr/local /usr/local

# Copy application files
COPY . .

# Expose port 5001 for the Flask app
EXPOSE 5001

# Command to run the app (Flask)
CMD ["python", "app.py"]
