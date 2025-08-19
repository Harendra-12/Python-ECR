# Use official Python base imagee
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Create a simple Python app directly inside the image
RUN echo 'print("Hello from test container!")' > app.py

# Expose port (optional for testing)
EXPOSE 5000

# Run the test app
CMD ["python", "app.py"]
