# Backend – Cloud Escape Lab Room API

## Was macht das Backend?

Das Backend ist eine **REST-API**, die die gesamte Spiellogik der Escape Rooms enthält. Es speichert den Spielzustand in einer Datenbank, prüft Aktionen des Spielers und gibt immer den aktuellen Zustand des Raums zurück. Der Browser (Frontend) stellt keine Spiellogik selbst auf – er ruft nur das Backend auf.

---

## Technologie-Stack

| Technologie | Zweck | Quelle |
|---|---|---|
| **Python 3** | Programmiersprache | [python.org](https://www.python.org/) |
| **Flask / APIFlask** | Web-Framework, REST-API mit automatischer OpenAPI-Dokumentation | [apiflask.com](https://apiflask.com/) |
| **SQLAlchemy** | ORM – Datenbankzugriff über Python-Objekte statt SQL | [docs.sqlalchemy.org](https://docs.sqlalchemy.org/) |
| **SQLite** | Datenbank (lokale Datei `app.db`) | [sqlite.org](https://www.sqlite.org/) |
| **PyJWT** | Generierung und Prüfung von JWT-Tokens zur Session-Verwaltung | [pyjwt.readthedocs.io](https://pyjwt.readthedocs.io/) |
| **Flask-CORS** | Erlaubt dem Frontend (anderer Port) API-Anfragen zu stellen | [flask-cors.readthedocs.io](https://flask-cors.readthedocs.io/) |

---

## Ordnerstruktur

```
backend/
├── app/
│   ├── __init__.py          # App-Factory: erstellt Flask-App, registriert Blueprints
│   ├── auth.py              # JWT-Token-Authentifizierung
│   ├── extensions.py        # SQLAlchemy db-Objekt (gemeinsam genutzt)
│   ├── models/              # Datenbank-Modelle (Tabellen)
│   │   ├── gameRoom.py      # GameRoom + GameObject: Spiellogik-Klassen
│   │   ├── objectState.py   # DB-Tabelle: Zustand eines einzelnen Objekts
│   │   ├── player.py        # DB-Tabelle: Spieler (Name, E-Mail)
│   │   └── roomState.py     # DB-Tabelle: Zustand eines Spiels + API-Schemas
│   └── rooms/
│       └── tutorial/        # Tutorial Escape Room (eigener Blueprint)
│           ├── __init__.py
│           ├── routes.py    # API-Endpunkte + Spiellogik + Raum-Objekte
│           └── static/      # (zukünftige statische Dateien des Raums)
├── config.py                # Konfiguration (DB-URI, Secret Key)
├── requirements.txt         # Python-Abhängigkeiten
└── wsgi.py                  # Einstiegspunkt: startet den Server auf Port 5001
```

---

## API-Endpunkte (Tutorial Room)

Alle Endpunkte sind unter dem Prefix `/tutorial-room` erreichbar.

| Methode | Pfad | Auth | Beschreibung |
|---|---|---|---|
| `GET` | `/tutorial-room/ping` | Nein | Erreichbarkeitstest |
| `GET` | `/tutorial-room/description` | Nein | Raumbeschreibung (Text) |
| `POST` | `/tutorial-room/start` | Nein | Spiel starten, JWT-Token erhalten |
| `POST` | `/tutorial-room/runtime/stop` | JWT | Aktive Room-Runtime stoppen |
| `DELETE` | `/tutorial-room/runtime` | JWT | Aktive Room-Runtime löschen |
| `GET` | `/tutorial-room/examine` | JWT | Aktuellen Raumzustand laden |
| `POST` | `/tutorial-room/reset` | JWT | Spiel auf Anfangszustand zurücksetzen |
| `GET` | `/tutorial-room/objects/{id}/examine` | JWT | Objekt untersuchen |
| `POST` | `/tutorial-room/objects/{id}/interact` | JWT | Mit Objekt interagieren |

> Die vollständige interaktive API-Dokumentation (OpenAPI/Swagger) ist unter
> `http://localhost:5001/docs` verfügbar wenn das Backend läuft.

---

## Wie funktioniert die Session-Verwaltung?

Das Backend ist **zustandslos** (stateless) – jede HTTP-Anfrage muss beweisen, welches Spiel gemeint ist. Das geschieht über einen **JWT-Token** (JSON Web Token):

```
1. POST /start  → Backend erstellt Spiel mit UUID, gibt JWT-Token zurück
2. Alle weiteren Anfragen → Frontend schickt: Authorization: Bearer <token>
3. Backend prüft Token → extrahiert UUID → lädt Spielzustand aus DB
4. POST /runtime/stop oder DELETE /runtime → beendet/löscht die aktive Runtime
```

**Warum JWT?**
JWT-Tokens sind selbstenthaltend (der UUID steckt direkt im Token) und müssen nicht in einer Session-Tabelle nachgeschlagen werden. Sie werden mit dem `SECRET_KEY` signiert, damit sie nicht gefälscht werden können.
→ Quelle: [jwt.io – Introduction to JSON Web Tokens](https://jwt.io/introduction)

---

## Datenbankmodell

```
players                room_states              object_states
────────────           ──────────────────       ──────────────────
id (PK)                id (PK)                  id (PK)
name                   game_uuid                object_id
email                  room_name                visible
                       started_on               locked
                       solved                   state
                       exits_locked             object_name
                       player_id (FK)           room_state_id (FK)
```

**Beziehungen:**
- Ein `Player` kann mehrere `RoomState`-Einträge haben (mehrere Spiele)
- Ein `RoomState` hat mehrere `ObjectState`-Einträge (ein Eintrag pro Objekt im Raum)

→ Quelle: [Flask-SQLAlchemy – Quickstart](https://flask-sqlalchemy.palletsprojects.com/en/3.x/quickstart/)

---

## Lokal starten

```bash
cd backend
python wsgi.py
# → http://localhost:5001
# → http://localhost:5001/docs  (Swagger UI)
```

Die SQLite-Datenbank (`app.db`) wird beim ersten Start automatisch erstellt.
