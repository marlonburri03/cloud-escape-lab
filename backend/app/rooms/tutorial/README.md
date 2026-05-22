# Tutorial Room – Spiellogik

Dieser Ordner enthält den **Tutorial Escape Room**: die einzige fertiggestellte Rauminstanz der Plattform. Er dient als Einführung in das Spielprinzip.

---

## Spielprinzip

Der Spieler befindet sich in einem dunklen Büro und muss durch das Lösen kleiner Rätsel den Ausgang freischalten. Jedes **Objekt** im Raum kann untersucht (`examine`) oder benutzt (`interact`) werden. Objekte können weitere Objekte sichtbar machen oder Zustände verändern.

---

## Raum-Objekte

| ID | Name | Anfangs sichtbar | Rätsel |
|---|---|---|---|
| 1 | Light Switch | ✅ Ja | Interagieren → Licht an, Desk + Column werden sichtbar |
| 2 | Wooden Desk | ❌ Nein | Untersuchen → Silver Key erscheint; Key + Desk → Diary erscheint |
| 3 | Column (Stone Column) | ❌ Nein | Code "1234" eingeben → Ausgang öffnet sich |
| 4 | Silver Key | ❌ Nein | Wird mit Wooden Desk kombiniert |
| 5 | Diary | ❌ Nein | Untersuchen → zeigt den Code "1234" |

---

## Lösungsweg (Spoiler)

```
1. INTERACT  Light Switch   → Licht geht an, Desk + Column erscheinen
2. EXAMINE   Wooden Desk    → Silver Key wird entdeckt
3. INTERACT  Wooden Desk    + Silver Key (Dropdown) → Diary erscheint
4. EXAMINE   Diary          → Code "1234" wird verraten
5. INTERACT  Column         + Code "1234" (Eingabefeld) → Ausgang offen → Gewonnen!
```

---

## Aufbau von `routes.py`

Die Datei ist in drei Bereiche unterteilt:

### 1. Lokalisierung (`TEXT`-Dictionary)

Alle Spieltexte sind auf **Englisch und Deutsch** hinterlegt:

```python
TEXT = {
    "interact.light": {
        "en": "Click! The lights flicker on ...",
        "de": "Klick! Das Licht geht an ...",
    },
    ...
}
```

Die Funktion `t(key)` sucht automatisch die richtige Sprache basierend auf dem `Accept-Language`-HTTP-Header des Browsers.

### 2. Raum-Objekte (`room_objects`)

Eine Python-Liste mit allen Objekten. Jedes Objekt ist ein Dictionary mit:
- `id`, `name` – Eindeutige Kennung
- `display_name_en` / `display_name_de` – Angezeigter Name (mehrsprachig)
- `description_en` / `description_de` – Beschreibungstext
- `icon` – Bootstrap Icon Name (wird im Frontend angezeigt)
- `initial-visibility` – Sichtbar beim Start?
- `initial-locked` – Gesperrt beim Start?
- `initial-state` – Anfangszustand (z. B. `"untouched"`)

### 3. API-Endpunkte

Jeder Endpunkt folgt dem gleichen Muster:

```python
@bp.post("/objects/<int:object_id>/interact")
@bp.auth_required(token_auth)   # ← JWT prüfen
def interact_with_object(object_id, form_and_files_data):
    game_uuid = token_auth.current_user   # UUID aus Token
    game_room = GameRoom(...)             # Spielzustand aus DB laden
    
    match current_object.name:           # Python match/case = switch
        case "Light Switch":
            # Spiellogik hier ...
    
    db.session.commit()                  # Zustand in DB speichern
    return game_room.assemble_json_room_state(message)  # JSON zurückgeben
```

---

## Datenfluss bei einer Interaktion

```
Browser
  │  POST /tutorial-room/objects/1/interact
  │  Authorization: Bearer <jwt>
  │  Body: { object_id: 4 }
  ▼
routes.py → interact_with_object(object_id=1)
  │  token_auth prüft JWT → extrahiert game_uuid
  │  GameRoom lädt RoomState + ObjectStates aus SQLite
  │  match "Light Switch": setzt Desk.visible=True, Column.visible=True
  │  db.session.commit() → speichert in app.db
  │  assemble_json_room_state() → baut JSON-Antwort
  ▼
JSON-Antwort:
{
  "objects": [
    {"id": 2, "name": "Wooden Desk", "icon": "archive-fill", ...},
    {"id": 3, "name": "Stone Column", "icon": "database-lock", ...}
  ],
  "exits_locked": true,
  "message": "Click! The lights flicker on ..."
}
  │
  ▼
Frontend (tutorial.html JavaScript)
  refreshState(data) → renderObjects() → zeigt neue Karten im Browser
```

---

## Wieso `GameRoom` und `GameObject`? (models/gameRoom.py)

Diese Klassen trennen die **Datenbanklogik** von der **Spiellogik**:

- `RoomState` / `ObjectState` → reine Datenbankzeilen (SQLAlchemy-Modelle)
- `GameRoom` → lädt die DB-Zeilen und bietet einfache Methoden wie `get_object_by_name()`
- `GameObject` → ein einzelnes Objekt mit Properties (`visible`, `locked`, `state`), die beim Setzen automatisch die DB-Zeile aktualisieren

Das Muster heisst **Repository Pattern** – die Spiellogik muss nicht wissen wie die Datenbank funktioniert.  
→ Quelle: [martinfowler.com – Repository](https://martinfowler.com/eaaCatalog/repository.html)

---

## Quellen

| Thema | Quelle |
|---|---|
| APIFlask Blueprints | [apiflask.com/docs/blueprint](https://apiflask.com/docs/blueprint/) |
| Python `match/case` (Structural Pattern Matching) | [PEP 634](https://peps.python.org/pep-0634/) |
| Flask-SQLAlchemy Relationships | [flask-sqlalchemy.palletsprojects.com](https://flask-sqlalchemy.palletsprojects.com/en/3.x/models/) |
| JWT in Python | [pyjwt.readthedocs.io](https://pyjwt.readthedocs.io/en/stable/) |
| REST API Design | [restfulapi.net](https://restfulapi.net/) |
| Repository Pattern | [martinfowler.com](https://martinfowler.com/eaaCatalog/repository.html) |
