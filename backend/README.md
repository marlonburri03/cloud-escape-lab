# Backend: room API

The backend is a **REST API** that contains the complete game logic of the escape rooms. It stores the game state in a database, validates player actions and always returns the current state of the room. The browser holds no game logic of its own; it only calls this API.

## Tech stack

| Technology | Purpose |
|---|---|
| Python 3 | Language |
| [Flask](https://flask.palletsprojects.com/) / [APIFlask](https://apiflask.com/) | Web framework and REST API with generated OpenAPI documentation |
| [SQLAlchemy](https://docs.sqlalchemy.org/) | ORM: database access through Python objects |
| [SQLite](https://www.sqlite.org/) | Database (local file `app.db`) |
| [PyJWT](https://pyjwt.readthedocs.io/) | Issues and verifies JWTs for game sessions |
| [Flask-CORS](https://flask-cors.readthedocs.io/) | Allows the frontend on another origin to call the API |

## Structure

```text
backend/
├── app/
│   ├── __init__.py        app factory, registers blueprints
│   ├── auth.py            JWT authentication
│   ├── extensions.py      shared SQLAlchemy instance
│   ├── models/            database models and game classes
│   │   ├── gameRoom.py      GameRoom and GameObject: game logic on top of the tables
│   │   ├── objectState.py   state of a single object
│   │   ├── player.py        player (name, e-mail)
│   │   └── roomState.py     state of a game and API schemas
│   └── rooms/
│       └── tutorial/      tutorial escape room (own blueprint)
├── config.py              configuration (database URI, secret key)
├── requirements.txt
└── wsgi.py                entry point, serves on port 5001
```

## API (tutorial room)

All endpoints are prefixed with `/tutorial-room`.

| Method | Path | Auth | Description |
|---|---|---|---|
| `GET` | `/ping` | – | Reachability check |
| `GET` | `/description` | – | Room description |
| `POST` | `/start` | – | Start a game and receive a JWT |
| `POST` | `/runtime/stop` | JWT | Stop the active room runtime |
| `DELETE` | `/runtime` | JWT | Delete the active room runtime |
| `GET` | `/examine` | JWT | Load the current room state |
| `POST` | `/reset` | JWT | Reset the game to its initial state |
| `GET` | `/objects/{id}/examine` | JWT | Examine an object |
| `POST` | `/objects/{id}/interact` | JWT | Interact with an object |

Interactive OpenAPI documentation is available at `http://localhost:5001/docs` while the backend runs. In Azure the API is reachable under `/tutorial-room/*` behind the Application Gateway.

## Sessions

The backend is **stateless**: every request has to prove which game it belongs to, using a JSON Web Token.

```text
1. POST /start            backend creates a game with a UUID and returns a JWT
2. every further request  frontend sends  Authorization: Bearer <token>
3. backend verifies the token, extracts the UUID and loads the game state
4. POST /runtime/stop or DELETE /runtime ends or deletes the runtime
```

JWTs are self-contained (the UUID is inside the token), so no session table lookup is needed. They are signed with `SECRET_KEY` and cannot be forged.

## Data model

```text
players          room_states         object_states
-------          -----------         -------------
id (PK)          id (PK)             id (PK)
name             game_uuid           object_id
email            room_name           visible
                 started_on          locked
                 solved              state
                 exits_locked        object_name
                 player_id (FK)      room_state_id (FK)
```

A player can have several games; a game has one object state per object in the room.

## Run locally

```bash
cd backend
pip install -r requirements.txt
python wsgi.py
# http://localhost:5001  and  http://localhost:5001/docs
```

The SQLite database `app.db` is created on first start. In Azure the same file-based database is used unless `DATABASE_URI` is set.
