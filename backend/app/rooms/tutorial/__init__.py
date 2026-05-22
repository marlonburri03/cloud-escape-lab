from apiflask import APIBlueprint

bp = APIBlueprint("tutorial", __name__, static_folder="static")

from app.rooms.tutorial import routes  # noqa: E402,F401
