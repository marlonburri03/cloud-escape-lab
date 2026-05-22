from apiflask import APIFlask
from flask import request, g
from flask_cors import CORS

from config import Config
from app.extensions import db


def create_app(config_class: type = Config) -> APIFlask:
    app = APIFlask(__name__, title="Cloud Escape Lab – Room API", version="0.1.0")
    app.config.from_object(config_class)

    # Allow the frontend (different port in dev) to call the room API
    CORS(app)

    db.init_app(app)

    from app.rooms.tutorial import bp as tutorial_bp
    app.register_blueprint(tutorial_bp, url_prefix="/tutorial-room")

    with app.app_context():
        db.create_all()

    @app.before_request
    def detect_language():
        lang = request.headers.get("Accept-Language", "en")
        g.lang = lang.split(",")[0].split("-")[0]

    @app.get("/")
    def index():
        return {"message": "Cloud Escape Lab – Room API running"}

    return app
