# Stage 1: Build Environment
FROM python:3.11-slim AS builder

# Set the working directory
WORKDIR /app

# Copy and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# Stage 2: Final Image
FROM python:3.11-slim

# Set the working directory
WORKDIR /app

# Copy only the necessary files from builder stage
COPY --from=builder /install /usr/local

# Copy the application code
COPY . .

# Expose the application port
EXPOSE 5001

# Set environment variables for AWS Secret Key
ENV AWS_SECRET_KEY=your_secret_key_here

# Run the Python application
CMD ["python", "app.py"]
