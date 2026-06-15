from apiflask import Schema
from apiflask.fields import Integer, String, Boolean, Nested

from app.extensions import db
from flask import current_app
from jwt import encode, decode, InvalidTokenError
from datetime import datetime
import logging


class ObjectOut(Schema):
    id = Integer()
    name = String()
    locked = Boolean()
    state = String()
    description = String()
    icon = String()


class RoomStateOut(Schema):
    objects = Nested(ObjectOut(many=True))
    exits_locked = Boolean()
    message = String()
    game_uuid = String()


class PlayerIn(Schema):
    name = String(required=True)
    email = String(required=False, allow_none=True)


class RoomStateIn(Schema):
    player = Nested(PlayerIn)
    game_uuid = String(required=True)


class PingOut(Schema):
    message = String()


class DescriptionOut(Schema):
    description = String()


class ExitsOut(Schema):
    north = String()
    east = String()
    south = String()
    west = String()


class TokenOut(Schema):
    token = String()


class RuntimeOut(Schema):
    game_uuid = String()
    status = String()
    message = String()


class InteractionIn(Schema):
    object_id = Integer(required=False)
    parameter = String(required=False)


class RoomState(db.Model):
    __tablename__ = "room_states"
    id = db.Column(db.Integer, primary_key=True)
    started_on = db.Column(db.DateTime)
    game_uuid = db.Column(db.String(32))
    room_name = db.Column(db.String(128))
    solved = db.Column(db.Boolean)
    exits_locked = db.Column(db.Boolean)
    object_states = db.relationship("ObjectState", back_populates="room_state")
    player_id = db.Column(db.Integer, db.ForeignKey("players.id"))
    player = db.relationship("Player")

    def __init__(self, game_uuid, room_name):
        self.game_uuid = game_uuid
        self.room_name = room_name
        self.started_on = datetime.now()
        self.solved = False
        self.exits_locked = True

    def generate_auth_token(self):
        return encode(
            {"uuid": self.game_uuid},
            current_app.config["SECRET_KEY"],
            algorithm="HS256",
        )

    @staticmethod
    def verify_auth_token(token):
        try:
            data = decode(
                token,
                current_app.config["SECRET_KEY"],
                algorithms=["HS256"],
            )
            return data["uuid"]
        except InvalidTokenError:
            logging.warning("Token was invalid")
            return None
        except Exception:
            logging.warning("Unknown token validation error")
            return None
