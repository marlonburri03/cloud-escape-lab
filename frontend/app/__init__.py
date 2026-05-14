"""Frontend application factory (APIFlask-based, teacher-style)."""

from apiflask import APIFlask
from flask import g, request

from config import Config


def create_app(config_class: type = Config) -> APIFlask:
    app = APIFlask(__name__, title="Escape Room Platform Frontend", version="0.1.0")
    app.config.from_object(config_class)

    # Register blueprints
    from app.main import bp as main_bp
    app.register_blueprint(main_bp)

    @app.before_request
    def detect_language() -> None:
        lang = request.headers.get("Accept-Language", "en")
        g.lang = lang.split(",")[0].split("-")[0]

    @app.before_request
    def detect_user() -> None:
        # Easy Auth puts the authenticated principal in this header (Phase 1b+).
        g.user = request.headers.get("X-MS-CLIENT-PRINCIPAL-NAME") or "anonymous"

    return app
