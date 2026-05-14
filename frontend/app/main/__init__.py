"""Main blueprint of the Escape Room Frontend."""

from apiflask import APIBlueprint

bp = APIBlueprint("main", __name__)

from app.main import routes  # noqa: E402,F401
