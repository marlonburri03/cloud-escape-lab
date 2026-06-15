# Adapted from: ma-room-template/app/rooms/demo_room/routes.py
# Source: https://gitlab.com/solvista/ma-room-template
# License: CC BY-SA 4.0
# Changes in this repository: Contoso/Cloud Escape Lab retheme, room-specific text
# rewrites, tutorial-room naming, and integration into this backend service.

from app.rooms.tutorial import bp
from app.extensions import db
from app.models.gameRoom import GameRoom
from app.models.roomState import RoomStateIn, RoomStateOut, RuntimeOut, TokenOut
from app.models.roomState import PingOut, DescriptionOut, ExitsOut, InteractionIn
from app.auth import token_auth

from flask import g

# -----------------------------
# Localization
# -----------------------------
TEXT = {
    "room.description": {
        "en": (
            "You're trapped in Prof. Dr. Mike Roservice's office at Contoso after his lecture on distributed systems. "
            "The room is cluttered with architecture diagrams and stacks of printed API docs — and completely dark. "
            "The exit door is locked with a digital panel. Find the code before he returns! "
            "A first step: INTERACT with the Light Switch."
        ),
        "de": (
            "Du steckst in Prof. Dr. Mike Roservices Büro an der Contoso fest — nach seiner Vorlesung über verteilte Systeme. "
            "Der Raum ist übersät mit Architekturdiagrammen und Stapeln ausgedruckter API-Dokumentation — und völlig dunkel. "
            "Die Ausgangstür ist mit einem digitalen Panel gesichert. Finde den Code, bevor er zurückkommt! "
            "Ein erster Schritt: INTERAGIERE mit dem Lichtschalter."
        ),
    },
    "room.reset": {
        "en": "The office resets itself — as if a rollback was triggered. Prof. Dr. Mike Roservice is still on his way back. Try again!",
        "de": "Das Büro setzt sich zurück — als wäre ein Rollback ausgelöst worden. Prof. Dr. Mike Roservice ist noch unterwegs. Versuch es nochmal!",
    },
    "runtime.stopped": {
        "en": "Room runtime stopped. Start Game creates a fresh room instance.",
        "de": "Room-Runtime gestoppt. Mit Start Game wird eine neue Room-Instanz erstellt.",
    },
    "runtime.deleted": {
        "en": "Room runtime deleted. Start Game creates a new runtime in the background.",
        "de": "Room-Runtime gelöscht. Mit Start Game wird im Hintergrund eine neue Runtime erstellt.",
    },
    "runtime.not_found": {
        "en": "No active runtime found. You can start a new game now.",
        "de": "Keine aktive Runtime gefunden. Du kannst jetzt ein neues Spiel starten.",
    },
    "examine.desk.key": {
        "en": (
            "You dig through a towering pile of printed API docs and find an office key taped to the underside of the desk. "
            "Typical Roservice — hiding things in layers. "
            "Select the Office Key from the dropdown and INTERACT with the Professor's Desk."
        ),
        "de": (
            "Du durchwühlst einen riesigen Stapel ausgedruckter API-Dokumentation und findest einen Büroschlüssel unter dem Schreibtisch. "
            "Typisch Roservice — alles in Schichten verstecken. "
            "Wähle den Büroschlüssel im Dropdown und INTERAGIERE mit dem Professorenschreibtisch."
        ),
    },
    "examine.diary": {
        "en": (
            "You flip through pages of microservice diagrams and cryptic margin notes. "
            "On the last page, scrawled between two service mesh drawings: "
            "'Emergency exit code (DO NOT SHARE): 1234' — Enter that code into the Exit Terminal."
        ),
        "de": (
            "Du blätterst durch Seiten voller Microservice-Diagramme und kryptischer Randnotizen. "
            "Auf der letzten Seite, zwischen zwei Service-Mesh-Zeichnungen gekritzelt: "
            "'Notfall-Exitcode (NICHT WEITERGEBEN): 1234' — Gib diesen Code ins Ausgangsterminal ein."
        ),
    },
    "examine.default": {
        "en": "You look around carefully, but find nothing new.",
        "de": "Du schaust dich sorgfältig um, findest aber nichts Neues.",
    },
    "interact.light": {
        "en": (
            "Click! The fluorescent lights flicker to life. "
            "You can now see the Professor's Desk buried under paperwork, and an Exit Terminal next to the door. "
            "EXAMINE them to find out more."
        ),
        "de": (
            "Klick! Die Neonlichter flackern an. "
            "Du siehst jetzt den Professorenschreibtisch, begraben unter Papierstapeln, und ein Ausgangsterminal neben der Tür. "
            "UNTERSUCHE sie, um mehr herauszufinden."
        ),
    },
    "interact.desk.key_used": {
        "en": "You unlock the drawer with the office key and find Prof. Roservice's research journal inside — it looks important. EXAMINE the Research Journal.",
        "de": "Du öffnest die Schublade mit dem Büroschlüssel und findest Prof. Roservices Forschungstagebuch — es sieht wichtig aus. UNTERSUCHE das Forschungstagebuch.",
    },
    "interact.desk.wrong": {
        "en": "That doesn't seem to work with the desk. Maybe try a different approach — Prof. Roservice always said: 'wrong interface, wrong result.'",
        "de": "Das scheint nicht mit dem Schreibtisch zu funktionieren. Vielleicht ein anderer Ansatz — Prof. Roservice sagte immer: 'Falsches Interface, falsches Ergebnis.'",
    },
    "interact.desk.hint": {
        "en": "The drawer has a keyhole. Maybe another object could help. Try selecting one from the dropdown.",
        "de": "Die Schublade hat ein Schlüsselloch. Vielleicht hilft ein anderes Objekt. Wähle eines aus dem Dropdown.",
    },
    "interact.column.success": {
        "en": "Access granted! The exit door swings open. You slip out of Prof. Dr. Mike Roservice's office just in time — you can already hear his footsteps in the corridor. Well done!",
        "de": "Zugang gewährt! Die Ausgangstür schwingt auf. Du verlässt Prof. Dr. Mike Roservices Büro gerade noch rechtzeitig — seine Schritte sind schon im Flur zu hören. Gut gemacht!",
    },
    "interact.column.wrong": {
        "en": "Access denied. The terminal blinks red. That's not the right code — check the professor's notes again.",
        "de": "Zugang verweigert. Das Terminal blinkt rot. Das ist nicht der richtige Code — schau nochmal in den Notizen des Professors nach.",
    },
    "interact.column.hint": {
        "en": "The exit terminal has a numeric keypad. Enter the code in the input field below, then click Interact.",
        "de": "Das Ausgangsterminal hat ein Nummernfeld. Gib den Code ins Eingabefeld ein und klicke dann auf Interagieren.",
    },
    "interact.default": {
        "en": "Nothing happened.",
        "de": "Nichts ist passiert.",
    },
    "exits.north": {
        "en": "A door leads to the Contoso main corridor.",
        "de": "Eine Tür führt zum Contoso-Hauptkorridor.",
    },
    "exits.east": {
        "en": "A heavy door with a digital 'EXIT' panel next to it.",
        "de": "Eine schwere Tür mit einem digitalen 'EXIT'-Panel daneben.",
    },
    "exits.south": {
        "en": "A glass door reveals the lecture hall beyond.",
        "de": "Eine Glastür zeigt den Hörsaal dahinter.",
    },
    "exits.west": {
        "en": "A window overlooks the Contoso campus courtyard.",
        "de": "Ein Fenster mit Blick auf den Contoso-Campushof.",
    },
}


def t(key: str, **fmt):
    lang = getattr(g, "lang", "en")
    template = TEXT.get(key, {}).get(lang) or TEXT.get(key, {}).get("en") or key
    return template.format(**fmt) if fmt else template


# -----------------------------
# Room setup
# -----------------------------
room_name = "tutorial-room"

room_objects = [
    {
        "id": 1,
        "name": "Light Switch",
        "display_name_en": "Light Switch",
        "display_name_de": "Lichtschalter",
        "description_en": "A dusty light switch on the wall. Prof. Roservice clearly prefers the dark.",
        "description_de": "Ein staubiger Lichtschalter an der Wand. Prof. Roservice bevorzugt offenbar die Dunkelheit.",
        "icon": "toggle2-off",
        "initial-visibility": True,
        "initial-state": "untouched",
        "initial-locked": False,
    },
    {
        "id": 2,
        "name": "Wooden Desk",
        "display_name_en": "Professor's Desk",
        "display_name_de": "Professorenschreibtisch",
        "description_en": "A desk buried under towering stacks of API documentation and microservice diagrams. One drawer has a keyhole.",
        "description_de": "Ein Schreibtisch, begraben unter riesigen Stapeln API-Dokumentation und Microservice-Diagrammen. Eine Schublade hat ein Schlüsselloch.",
        "icon": "archive-fill",
        "initial-visibility": False,
        "initial-state": "untouched",
        "initial-locked": False,
    },
    {
        "id": 3,
        "name": "Column",
        "display_name_en": "Exit Terminal",
        "display_name_de": "Ausgangsterminal",
        "description_en": "A digital keypad panel mounted next to the exit door. Requires a four-digit code.",
        "description_de": "Ein digitales Nummernfeld neben der Ausgangstür. Erfordert einen vierstelligen Code.",
        "icon": "database-lock",
        "initial-visibility": False,
        "initial-state": "untouched",
        "initial-locked": False,
    },
    {
        "id": 4,
        "name": "Silver Key",
        "display_name_en": "Office Key",
        "display_name_de": "Büroschlüssel",
        "description_en": "A small key taped under the desk beneath a stack of printed API docs. Typical Roservice.",
        "description_de": "Ein kleiner Schlüssel, unter dem Schreibtisch unter einem Stapel ausgedruckter API-Docs befestigt. Typisch Roservice.",
        "icon": "key-fill",
        "initial-visibility": False,
        "initial-state": "untouched",
        "initial-locked": False,
    },
    {
        "id": 5,
        "name": "Diary",
        "display_name_en": "Research Journal",
        "display_name_de": "Forschungstagebuch",
        "description_en": "Prof. Roservice's personal research journal, filled with microservice diagrams and cryptic margin notes.",
        "description_de": "Prof. Roservices persönliches Forschungstagebuch, gefüllt mit Microservice-Diagrammen und kryptischen Randnotizen.",
        "icon": "journal",
        "initial-visibility": False,
        "initial-state": "untouched",
        "initial-locked": False,
    },
]


# -----------------------------
# Standard endpoints
# -----------------------------
@bp.get("/ping")
@bp.output(PingOut, status_code=200)
def get_ping():
    return {"message": "pong"}


@bp.get("/description")
@bp.output(DescriptionOut, status_code=200)
def get_description():
    return {"description": t("room.description")}


@bp.get("/exits")
@bp.output(ExitsOut, status_code=200)
def get_exits():
    return {
        "north": t("exits.north"),
        "east": t("exits.east"),
        "south": t("exits.south"),
        "west": t("exits.west"),
    }


@bp.post("/start")
@bp.input(RoomStateIn, location="json")
@bp.output(TokenOut, status_code=200)
def start_visit(json_data):
    player = json_data.get("player", {})
    game_uuid = json_data.get("game_uuid")

    # Start is idempotent for a given UUID: replace any existing runtime state.
    GameRoom.delete_runtime(game_uuid, room_name)

    room_state = GameRoom.create_initial_state(game_uuid, room_name, player, room_objects)
    token = room_state.generate_auth_token()

    return {"token": token}


@bp.get("/examine")
@bp.auth_required(token_auth)
@bp.output(RoomStateOut, status_code=200)
def examine_room():
    game_uuid = token_auth.current_user
    game_room = GameRoom(game_uuid, room_name, room_objects)
    return game_room.assemble_json_room_state(t("room.description"))


@bp.post("/reset")
@bp.auth_required(token_auth)
@bp.output(RoomStateOut, status_code=200)
def reset_room():
    game_uuid = token_auth.current_user
    game_room = GameRoom(game_uuid, room_name, room_objects)
    game_room.reset_object_states()
    game_room.exits_locked = True
    db.session.commit()
    return game_room.assemble_json_room_state(t("room.reset"))


@bp.post("/runtime/stop")
@bp.auth_required(token_auth)
@bp.output(RuntimeOut, status_code=200)
def stop_runtime():
    game_uuid = token_auth.current_user
    deleted = GameRoom.delete_runtime(game_uuid, room_name)
    return {
        "game_uuid": game_uuid,
        "status": "stopped",
        "message": t("runtime.stopped") if deleted else t("runtime.not_found"),
    }


@bp.delete("/runtime")
@bp.auth_required(token_auth)
@bp.output(RuntimeOut, status_code=200)
def delete_runtime():
    game_uuid = token_auth.current_user
    deleted = GameRoom.delete_runtime(game_uuid, room_name)
    return {
        "game_uuid": game_uuid,
        "status": "deleted",
        "message": t("runtime.deleted") if deleted else t("runtime.not_found"),
    }


# -----------------------------
# Game logic
# -----------------------------
@bp.get("/objects/<int:object_id>/examine")
@bp.auth_required(token_auth)
@bp.output(RoomStateOut, status_code=200)
def examine_object(object_id):
    game_uuid = token_auth.current_user
    game_room = GameRoom(game_uuid, room_name, room_objects)
    current_object = game_room.get_object_by_id(object_id)

    message = t("examine.default")

    match current_object.name:
        case "Wooden Desk":
            if current_object.state == "untouched":
                current_object.state = "examined"
                silver_key = game_room.get_object_by_name("Silver Key")
                silver_key.visible = True
                message = t("examine.desk.key")
        case "Diary":
            message = t("examine.diary")
        case _:
            message = t("examine.default")

    db.session.commit()
    return game_room.assemble_json_room_state(message)


@bp.post("/objects/<int:object_id>/interact")
@bp.auth_required(token_auth)
@bp.input(InteractionIn, location="form_and_files")
@bp.output(RoomStateOut, status_code=200)
def interact_with_object(object_id, form_and_files_data):
    game_uuid = token_auth.current_user
    game_room = GameRoom(game_uuid, room_name, room_objects)
    current_object = game_room.get_object_by_id(object_id)

    message = t("interact.default")

    match current_object.name:
        case "Light Switch":
            game_room.get_object_by_name("Wooden Desk").visible = True
            game_room.get_object_by_name("Column").visible = True
            current_object.visible = False
            message = t("interact.light")

        case "Wooden Desk":
            if form_and_files_data.get("object_id"):
                param_object = game_room.get_object_by_id(form_and_files_data.get("object_id"))
                if param_object.name == "Silver Key":
                    current_object.locked = False
                    diary = game_room.get_object_by_name("Diary")
                    diary.visible = True
                    param_object.visible = False
                    message = t("interact.desk.key_used")
                else:
                    message = t("interact.desk.wrong")
            else:
                message = t("interact.desk.hint")

        case "Column":
            if form_and_files_data.get("parameter"):
                if form_and_files_data.get("parameter") == "1234":
                    game_room.exits_locked = False
                    current_object.state = "unlocked"
                    message = t("interact.column.success")
                else:
                    message = t("interact.column.wrong")
            else:
                message = t("interact.column.hint")

        case _:
            message = t("interact.default")

    db.session.commit()
    return game_room.assemble_json_room_state(message)
