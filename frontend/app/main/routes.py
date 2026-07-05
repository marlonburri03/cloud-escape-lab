from apiflask import Schema
from apiflask.fields import String
from flask import current_app, g, render_template

from app.main import bp


class HealthOut(Schema):
    status = String()


class IndexOut(Schema):
    user = String()
    title = String()


def _player_identity(raw_user: str) -> tuple[str, str | None]:
    if not raw_user or raw_user == "anonymous":
        return "Local Player", None

    if "@" not in raw_user:
        return raw_user, None

    local_part = raw_user.split("@", 1)[0]
    display_name = (
        local_part.replace(".", " ").replace("_", " ").replace("-", " ").strip()
    )
    return (display_name.title() if display_name else raw_user, raw_user)


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
@bp.doc(summary="Tutorial escape room", responses=[200])
def tutorial():
    player_name, player_email = _player_identity(g.get("user", "anonymous"))
    return render_template(
        "tutorial.html",
        title=current_app.config["SITE_TITLE"],
        backend_url=current_app.config["BACKEND_URL"],
        player_name=player_name,
        player_email=player_email,
    )
