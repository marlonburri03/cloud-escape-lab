from apiflask import Schema
from apiflask.fields import String
from flask import current_app, g, render_template

from app.main import bp


class HealthOut(Schema):
    status = String()


class IndexOut(Schema):
    user = String()
    title = String()


@bp.get("/healthz")
@bp.output(HealthOut, status_code=200)
def healthz():
    """Health probe target for App Gateway and App Service."""
    return {"status": "ok"}


@bp.get("/")
@bp.doc(summary="Landing page", responses=[200])
def index():
    return render_template(
        "index.html",
        user=g.get("user", "anonymous"),
        title=current_app.config["SITE_TITLE"],
    )


@bp.get("/tutorial")
@bp.doc(
    summary="Tutorial entry stub (Phase 2 will redirect to theme container)",
    responses=[200],
)
def tutorial():
    return render_template(
        "tutorial.html",
        title=current_app.config["SITE_TITLE"],
    )
