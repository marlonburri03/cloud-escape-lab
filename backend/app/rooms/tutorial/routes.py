from app.rooms.tutorial import bp
from app.extensions import db
from app.models.gameRoom import GameRoom
from app.models.roomState import RoomStateIn, RoomStateOut, TokenOut, RoomState
from app.models.roomState import PingOut, DescriptionOut, ExitsOut, InteractionIn
from app.auth import token_auth

from flask import g

# -----------------------------
# Localization
# -----------------------------
TEXT = {
    "room.description": {
        "en": (
            "Welcome to the Cloud Escape Lab tutorial! This is a cosy old office. "
            "It's pretty dark in here. "
            "A first step could be to bring some light into the scene — "
            "INTERACT with the Light Switch."
        ),
        "de": (
            "Willkommen im Cloud Escape Lab Tutorial! Dies ist ein gemütliches altes Büro. "
            "Es ist ziemlich dunkel hier. "
            "Ein erster Schritt wäre, etwas Licht ins Dunkel zu bringen — "
            "INTERAGIERE mit dem Lichtschalter."
        ),
    },
    "room.reset": {
        "en": "The room shifts, and everything returns to its original state. The challenge begins anew.",
        "de": "Der Raum verändert sich und alles kehrt in seinen Ursprungszustand zurück. Die Herausforderung beginnt von Neuem.",
    },
    "examine.desk.key": {
        "en": (
            "You search below the desk and find a silver key attached with duct tape. "
            "Maybe you can USE this key with the desk? "
            "Select the Silver Key from the dropdown and INTERACT with the Wooden Desk."
        ),
        "de": (
            "Du suchst unter dem Schreibtisch und findest einen Silberschlüssel mit Klebeband befestigt. "
            "Vielleicht kannst du diesen Schlüssel mit dem Schreibtisch verwenden? "
            "Wähle den Silberschlüssel im Dropdown und INTERAGIERE mit dem Holzschreibtisch."
        ),
    },
    "examine.diary": {
        "en": (
            "The diary falls open on a bookmarked page. A note reads: "
            "'Today's exit code is 1234.' — Enter that code into the Stone Column."
        ),
        "de": (
            "Das Tagebuch schlägt sich auf einer markierten Seite auf. Eine Notiz steht dort: "
            "'Der heutige Ausgangscode ist 1234.' — Gib diesen Code in die Steinsäule ein."
        ),
    },
    "examine.default": {
        "en": "You look around carefully, but find nothing new.",
        "de": "Du schaust dich sorgfältig um, findest aber nichts Neues.",
    },
    "interact.light": {
        "en": (
            "Click! The lights flicker on. You can now see a Wooden Desk and a Stone Column. "
            "EXAMINE them to find out more."
        ),
        "de": (
            "Klick! Das Licht geht an. Du siehst jetzt einen Holzschreibtisch und eine Steinsäule. "
            "UNTERSUCHE sie, um mehr herauszufinden."
        ),
    },
    "interact.desk.key_used": {
        "en": "You use the silver key to unlock the desk drawer and find an old diary inside. EXAMINE the diary.",
        "de": "Du öffnest die Schublade mit dem Silberschlüssel und findest ein altes Tagebuch. UNTERSUCHE das Tagebuch.",
    },
    "interact.desk.wrong": {
        "en": "That doesn't seem to work with the desk.",
        "de": "Das scheint nicht mit dem Schreibtisch zu funktionieren.",
    },
    "interact.desk.hint": {
        "en": "Maybe you need to use another object together with the desk. Try selecting an object from the dropdown.",
        "de": "Vielleicht musst du ein anderes Objekt zusammen mit dem Schreibtisch verwenden. Wähle ein Objekt aus dem Dropdown.",
    },
    "interact.column.success": {
        "en": "Congratulations! You solved the tutorial room! The exit door springs open. Well done!",
        "de": "Herzlichen Glückwunsch! Du hast den Tutorial-Raum gelöst! Die Ausgangstür springt auf. Gut gemacht!",
    },
    "interact.column.wrong": {
        "en": "You punch in the numbers, but nothing happens. That must be the wrong code.",
        "de": "Du gibst die Zahlen ein, aber nichts passiert. Das muss der falsche Code sein.",
    },
    "interact.column.hint": {
        "en": "The column has a combination lock. Enter a code in the input field below, then click Interact.",
        "de": "Die Säule hat ein Kombinationsschloss. Gib einen Code ins Eingabefeld ein und klicke dann auf Interagieren.",
    },
    "interact.default": {
        "en": "Nothing happened.",
        "de": "Nichts ist passiert.",
    },
    "exits.north": {
        "en": "A bright door leads outside into the sunshine.",
        "de": "Eine helle Tür führt nach draußen in den Sonnenschein.",
    },
    "exits.east": {
        "en": "A heavy door with a 'Exit' sign above it.",
        "de": "Eine schwere Tür mit einem 'Ausgang'-Schild darüber.",
    },
    "exits.south": {
        "en": "A glass door reveals the corridor beyond.",
        "de": "Eine Glastür zeigt den Korridor dahinter.",
    },
    "exits.west": {
        "en": "A small window lets in a sliver of light.",
        "de": "Ein kleines Fenster lässt einen Lichtstreifen herein.",
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
        "description_en": "A dusty light switch on the wall.",
        "description_de": "Ein staubiger Lichtschalter an der Wand.",
        "icon": "toggle2-off",
        "initial-visibility": True,
        "initial-state": "untouched",
        "initial-locked": False,
    },
    {
        "id": 2,
        "name": "Wooden Desk",
        "display_name_en": "Wooden Desk",
        "display_name_de": "Holzschreibtisch",
        "description_en": "An old wooden desk. One drawer has a keyhole.",
        "description_de": "Ein alter Holzschreibtisch. Eine Schublade hat ein Schlüsselloch.",
        "icon": "archive-fill",
        "initial-visibility": False,
        "initial-state": "untouched",
        "initial-locked": False,
    },
    {
        "id": 3,
        "name": "Column",
        "display_name_en": "Stone Column",
        "display_name_de": "Steinsäule",
        "description_en": "A stone column with a four-digit combination lock.",
        "description_de": "Eine Steinsäule mit einem vierstelligen Kombinationsschloss.",
        "icon": "database-lock",
        "initial-visibility": False,
        "initial-state": "untouched",
        "initial-locked": False,
    },
    {
        "id": 4,
        "name": "Silver Key",
        "display_name_en": "Silver Key",
        "display_name_de": "Silberschlüssel",
        "description_en": "A worn silver key. Rests of duct tape still cling to it.",
        "description_de": "Ein abgenutzter Silberschlüssel. Klebereste haften noch daran.",
        "icon": "key-fill",
        "initial-visibility": False,
        "initial-state": "untouched",
        "initial-locked": False,
    },
    {
        "id": 5,
        "name": "Diary",
        "display_name_en": "Diary",
        "display_name_de": "Tagebuch",
        "description_en": "An old diary with a bookmark. What secrets does it hold?",
        "description_de": "Ein altes Tagebuch mit einem Lesezeichen. Welche Geheimnisse verbirgt es?",
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

    room_state = GameRoom.create_initial_state(game_uuid, room_name, player, room_objects)
    token = room_state.generate_auth_token()
    db.session.add(room_state)
    db.session.commit()

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
