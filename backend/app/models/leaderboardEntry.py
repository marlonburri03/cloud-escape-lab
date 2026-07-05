from datetime import datetime

from app.extensions import db


class LeaderboardEntry(db.Model):
    __tablename__ = "leaderboard_entries"

    id = db.Column(db.Integer, primary_key=True)
    room_name = db.Column(db.String(128), nullable=False, index=True)
    game_uuid = db.Column(db.String(32), nullable=False, index=True)
    player_name = db.Column(db.String(128), nullable=False)
    player_email = db.Column(db.String(128))
    completion_seconds = db.Column(db.Integer, nullable=False)
    completed_on = db.Column(db.DateTime, nullable=False, default=datetime.now)

    def __init__(
        self,
        room_name: str,
        game_uuid: str,
        player_name: str,
        player_email: str | None,
        completion_seconds: int,
    ):
        self.room_name = room_name
        self.game_uuid = game_uuid
        self.player_name = player_name
        self.player_email = player_email
        self.completion_seconds = completion_seconds
