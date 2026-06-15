<<<<<<< HEAD
# Production image for the Escape Room Platform Backend API.
=======
# Production image for the Escape Room Platform Backend.
>>>>>>> 35b35a3 (S3M-25: format files)

FROM python:3.13-slim-trixie

WORKDIR /app

# Install dependencies
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5001

# Copy source
COPY . .

# WSGI entrypoint (wsgi.py exposes `app = create_app()`)
CMD ["gunicorn", "--preload", "-w", "2", "-b", "0.0.0.0:5001", "wsgi:app"]
