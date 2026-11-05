# Frontend

The frontend is the **web UI** in the browser: a small Flask application that renders HTML pages and talks to the backend to load the game state and forward the player's actions.

## Tech stack

| Technology | Purpose |
|---|---|
| Python 3, [Flask](https://flask.palletsprojects.com/), [APIFlask](https://apiflask.com/) | HTTP server and routing |
| [Jinja2](https://jinja.palletsprojects.com/) | HTML templates |
| [Inter](https://fonts.google.com/specimen/Inter) | UI font |
| [Bootstrap Icons](https://icons.getbootstrap.com/) | Icons (CDN) |

## Structure

```text
frontend/
├── app/
│   ├── __init__.py     app factory
│   ├── extensions.py   shared extensions
│   ├── main/
│   │   └── routes.py   URL routes
│   ├── static/         CSS, JavaScript, images
│   └── templates/      Jinja2 templates (see templates/README.md)
├── config.py           title, backend URL, secret key
├── requirements.txt
└── wsgi.py             entry point
```

## Routes

```python
@bp.get("/")          # index.html: start page
@bp.get("/tutorial")  # tutorial.html: the escape room
@bp.get("/healthz")   # {"status": "ok"}: health probe, excluded from sign-in
```

Pages receive `user` (from the `X-MS-CLIENT-PRINCIPAL-NAME` header set by the authentication layer) and `title` (from `config.py`).

## Talking to the backend

The tutorial page contains JavaScript that sends REST requests directly to the backend:

```text
Browser → fetch() → backend API → computes new game state → JSON → browser renders it
```

The backend URL comes from `BACKEND_URL` in `config.py`: `http://localhost:5001` locally, the public host name in Azure. The runtime endpoints let the player stop or delete the active room and start a fresh one while the frontend stays available.

## Design system

`base.html` defines CSS custom properties that apply to every page:

```css
--blue:    #0078D4;   /* primary */
--cyan:    #22D3EE;   /* accent */
--navy:    #0F172A;   /* background */
--surface: #1E293B;   /* cards */
--text:    #F1F5F9;
--muted:   #94A3B8;
```

The palette is inspired by Microsoft Fluent and the Tailwind slate and blue scales.

## Run locally

```bash
cd frontend
pip install -r requirements.txt
python wsgi.py
# http://localhost:5000
```

Locally the frontend listens on port 5000, in the container on port 8000 (`gunicorn -b 0.0.0.0:8000`). The game needs the backend on port 5001; without it the UI loads, but *Start Game* shows an error.
