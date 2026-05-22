from apiflask import HTTPTokenAuth
from app.models.roomState import RoomState

token_auth = HTTPTokenAuth()


@token_auth.verify_token
def verify_token(token):
    game_uuid = RoomState.verify_auth_token(token)
    if not game_uuid:
        return False
    return game_uuid
