from app.models.roomState import RoomState
from app.models.objectState import ObjectState
from app.models.player import Player
from app.extensions import db
from flask import jsonify, g


def _lang():
    raw = getattr(g, "lang", "en") or "en"
    return raw.split(",")[0].split("-")[0].lower()


def _loc(obj: dict, base: str) -> str:
    lang = _lang()
    return (
        obj.get(f"{base}_{lang}")
        or obj.get(f"{base}_en")
        or obj.get(base)
        or ""
    )


class GameObject:
    def __init__(self, object_dict, object_state):
        self.object_dict = object_dict
        self.object_state = object_state
        self.id = object_dict["id"]
        self.name = object_dict["name"]
        self.icon = object_dict["icon"]
        self.display_name = object_state.object_name
        self.visible = object_state.visible
        self.locked = object_state.locked
        self.state = object_state.state

    @property
    def display_name(self):
        try:
            override = self._display_name
        except AttributeError:
            override = None
        return override or _loc(self.object_dict, "display_name") or self.name

    @display_name.setter
    def display_name(self, value):
        self._display_name = value
        self.object_state.object_name = value

    @property
    def visible(self):
        return self._visible

    @visible.setter
    def visible(self, value):
        self._visible = value
        self.object_state.visible = value

    @property
    def locked(self):
        return self._locked

    @locked.setter
    def locked(self, value):
        self._locked = value
        self.object_state.locked = value

    @property
    def state(self):
        return self._state

    @state.setter
    def state(self, value):
        self._state = value
        self.object_state.state = value


class GameRoom:
    def __init__(self, game_uuid, room_name, room_objects):
        self.game_uuid = game_uuid
        self.room_name = room_name
        self.room_objects = room_objects

        self.room_state = RoomState.query.filter_by(
            game_uuid=game_uuid, room_name=room_name
        ).first()
        if not self.room_state:
            raise ValueError(
                f"RoomState with UUID '{game_uuid}' and room '{room_name}' not found."
            )
        self.exits_locked = self.room_state.exits_locked

    @property
    def exits_locked(self):
        return self._exits_locked

    @exits_locked.setter
    def exits_locked(self, value):
        self._exits_locked = value
        self.room_state.exits_locked = value

    def get_object_by_id(self, object_id):
        obj_dict = next((o for o in self.room_objects if o["id"] == object_id), None)
        obj_state = next(
            (s for s in self.room_state.object_states if s.object_id == object_id), None
        )
        return GameObject(obj_dict, obj_state)

    def get_object_by_name(self, object_name):
        obj_dict = next((o for o in self.room_objects if o["name"] == object_name), None)
        obj_state = next(
            (s for s in self.room_state.object_states if s.object_id == obj_dict["id"]),
            None,
        )
        return GameObject(obj_dict, obj_state)

    def assemble_json_room_state(self, message):
        objects = []
        for obj_state in self.room_state.object_states:
            room_object = next(
                (o for o in self.room_objects if o["id"] == obj_state.object_id), None
            )
            if not room_object or not obj_state.visible:
                continue
            display_name = (
                obj_state.object_name
                or _loc(room_object, "display_name")
                or room_object.get("name")
            )
            objects.append(
                {
                    "id": obj_state.object_id,
                    "name": display_name or "Unknown",
                    "locked": obj_state.locked,
                    "state": str(obj_state.state),
                    "description": _loc(room_object, "description") or "",
                    "icon": room_object.get("icon", "dash"),
                }
            )
        return jsonify(
            {
                "objects": objects,
                "exits_locked": self.room_state.exits_locked,
                "game_uuid": self.room_state.game_uuid,
                "message": message,
            }
        )

    def reset_object_states(self):
        for obj_state in self.room_state.object_states:
            initial_data = next(
                (o for o in self.room_objects if o["id"] == obj_state.object_id), None
            )
            if initial_data:
                obj_state.visible = initial_data["initial-visibility"]
                obj_state.locked = initial_data["initial-locked"]
                obj_state.state = initial_data["initial-state"]
                obj_state.object_name = None
        db.session.commit()

    @staticmethod
    def create_initial_state(game_uuid, room_name, player_in, room_objects):
        player_email = player_in.get("email")
        player_name = player_in.get("name")

        if not player_email:
            player = Player.query.filter_by(name=player_name).first()
        else:
            player = Player.query.filter_by(email=player_email).first()

        if not player:
            player = Player(**player_in)
            db.session.add(player)

        room_state = RoomState(game_uuid, room_name)
        room_state.player = player
        db.session.add(room_state)
        db.session.commit()

        for obj_data in room_objects:
            object_state = ObjectState(
                obj_data["initial-visibility"],
                obj_data["initial-locked"],
                obj_data["initial-state"],
                None,
            )
            object_state.object_id = obj_data["id"]
            db.session.add(object_state)
            room_state.object_states.append(object_state)
            db.session.commit()

        return room_state
