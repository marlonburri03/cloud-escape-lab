# Production image for the Escape Room Platform Frontend.

FROM python:3.13-slim-trixie

WORKDIR /app

# Install dependencies
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8000

# Copy source
COPY . .

# WSGI entrypoint (wsgi.py exposes `app = create_app()`)
CMD ["gunicorn", "--preload", "-w", "2", "-b", "0.0.0.0:8000", "wsgi:app"]
