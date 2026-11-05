# Tutorial room: game logic

This folder contains the **tutorial escape room**, the room that introduces the game principle.

> **Origin and licence:** the implementation is based on the demo room logic of [`ma-room-template`](https://gitlab.com/solvista/ma-room-template), licensed under **CC BY-SA 4.0**. Story, texts and the integration into the platform were adapted for this project.

## Game principle

The player is locked in a dark office and has to unlock the exit by solving small puzzles. Every object can be examined (`examine`) or used (`interact`). Objects can reveal other objects or change state.

## Objects

Internal names come from the template; display names reflect the adapted story.

| ID | Internal name | Display name | Visible at start | Role |
|---|---|---|---|---|
| 1 | Light Switch | Light Switch | yes | Interact: lights on, desk and exit terminal appear |
| 2 | Wooden Desk | Professor's Desk | no | Examine: the office key appears; key + desk: the journal appears |
| 3 | Column | Exit Terminal | no | Enter the four-digit code: the exit opens |
| 4 | Silver Key | Office Key | no | Used on the desk |
| 5 | Diary | Research Journal | no | Examine: reveals the code |

## Walkthrough (spoiler)

```text
1. INTERACT  Light Switch                        lights on, desk and terminal appear
2. EXAMINE   Professor's Desk                    office key found
3. INTERACT  Professor's Desk + Office Key        research journal appears
4. EXAMINE   Research Journal                    reveals the code
5. INTERACT  Exit Terminal + code                exit opens, room solved
```

## How `routes.py` is organised

1. **Localisation (`TEXT`):** all game texts in English and German; `t(key)` picks the language from the browser's `Accept-Language` header.
2. **Room objects (`room_objects`):** a list of dictionaries with `id`, `name`, localised display names and descriptions, a Bootstrap icon and the initial visibility, lock and state.
3. **API endpoints:** each endpoint verifies the JWT, loads the game, applies the rule for the selected object and commits the new state:

```python
@bp.post("/objects/<int:object_id>/interact")
@bp.auth_required(token_auth)
def interact_with_object(object_id, form_and_files_data):
    game_uuid = token_auth.current_user
    game_room = GameRoom(...)          # load state from the database
    match current_object.name:
        case "Light Switch":
            ...                        # game rule
    db.session.commit()
    return game_room.assemble_json_room_state(message)
```

## Data flow of an interaction

```text
Browser  POST /tutorial-room/objects/1/interact   Authorization: Bearer <jwt>
  → routes.py verifies the JWT and extracts the game UUID
  → GameRoom loads RoomState and ObjectStates from SQLite
  → the rule for "Light Switch" makes the desk and terminal visible
  → commit, then a JSON response with objects, exits_locked and message
  → tutorial.html renders the new object cards
```

## Why `GameRoom` and `GameObject`

`RoomState` and `ObjectState` are plain database rows. `GameRoom` loads them and offers helpers such as `get_object_by_name()`; `GameObject` exposes `visible`, `locked` and `state` and writes changes back to its row. The game rules therefore do not need to know how the database works ([repository pattern](https://martinfowler.com/eaaCatalog/repository.html)).
