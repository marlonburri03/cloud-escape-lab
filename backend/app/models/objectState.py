from app.extensions import db


class ObjectState(db.Model):
    __tablename__ = "object_states"
    id = db.Column(db.Integer, primary_key=True)
    visible = db.Column(db.Boolean())
    locked = db.Column(db.Boolean())
    object_name = db.Column(db.String(128))
    state = db.Column(db.String(256))
    room_state_id = db.Column(db.Integer, db.ForeignKey("room_states.id"))
    room_state = db.relationship("RoomState", back_populates="object_states")
    object_id = db.Column(db.Integer)

    def __init__(self, visible, locked, state, object_name):
        self.visible = visible
        self.locked = locked
        self.state = state
        self.object_name = object_name
