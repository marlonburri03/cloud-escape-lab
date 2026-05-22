"""Configuration for the Escape Room Frontend"""

import os

basedir = os.path.abspath(os.path.dirname(__file__))


class Config:
    SECRET_KEY = os.environ.get("SECRET_KEY") or "dev_secret_key_change_me"

    # Public display name shown on the landing page.
    SITE_TITLE = os.environ.get("SITE_TITLE", "Contoso Escape Room Platform")

    # URL of the backend room API (override in production via env var).
    BACKEND_URL = os.environ.get("BACKEND_URL", "http://localhost:5001")
