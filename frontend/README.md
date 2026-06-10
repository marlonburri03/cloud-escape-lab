# Frontend – Cloud Escape Lab

Das Frontend ist die **Weboberfläche**, die der Nutzer im Browser sieht. Es ist eine einfache Python-Webanwendung, die HTML-Seiten ausliefert. Es kommuniziert mit dem Backend, um den Spielstand abzurufen und Aktionen des Spielers weiterzuleiten.

---

## Technologie-Stack

| Technologie | Zweck | Quelle |
|---|---|---|
| **Python 3** | Programmiersprache | [python.org](https://www.python.org/) |
| **Flask** | Web-Framework (HTTP-Server, Routing) | [flask.palletsprojects.com](https://flask.palletsprojects.com/) |
| **APIFlask** | Erweiterung von Flask mit automatischer API-Dokumentation | [apiflask.com](https://apiflask.com/) |
| **Jinja2** | Template-Engine (HTML-Vorlagen mit Variablen) | [jinja.palletsprojects.com](https://jinja.palletsprojects.com/) |
| **Inter (Google Fonts)** | Schriftart im UI | [fonts.google.com/specimen/Inter](https://fonts.google.com/specimen/Inter) |
| **Bootstrap Icons** | Icon-Bibliothek (CDN) | [icons.getbootstrap.com](https://icons.getbootstrap.com/) |

---

## Ordnerstruktur

```
frontend/
├── app/
│   ├── __init__.py          # App-Factory: erstellt die Flask-Anwendung
│   ├── extensions.py        # Gemeinsam genutzte Flask-Erweiterungen
│   ├── main/
│   │   ├── __init__.py      # Blueprint-Definition
│   │   └── routes.py        # URL-Routen: welche URL → welche Seite
│   ├── static/              # Statische Dateien (CSS, JS, Bilder)
│   └── templates/           # HTML-Vorlagen (Jinja2)
│       ├── base.html        # Basis-Layout: Header, Design-System, shared CSS
│       ├── index.html       # Startseite (Welcome-Card)
│       └── tutorial.html    # Tutorial Escape Room (Spieloberfläche)
├── config.py                # Konfiguration (Titel, Backend-URL, Secret Key)
├── requirements.txt         # Python-Abhängigkeiten
└── wsgi.py                  # Einstiegspunkt zum Starten des Servers
```

---

## Wie funktioniert das Routing?

Das Routing wird in `app/main/routes.py` definiert. Jede Funktion ist einer URL zugeordnet:

```python
@bp.get("/")          # → index.html  (Startseite)
@bp.get("/tutorial")  # → tutorial.html (Escape Room)
@bp.get("/healthz")   # → JSON {"status": "ok"} (Gesundheitsprüfung für Azure)
```

Flask übergibt der Seite Variablen wie `user` (aus dem Azure Easy Auth Header) oder `title` (aus `config.py`).

---

## Wie kommuniziert das Frontend mit dem Backend?

Das Tutorial-Room-Template (`tutorial.html`) enthält JavaScript, das beim Spielen direkt **REST-API-Anfragen** an das Backend schickt:

```
Browser → JavaScript fetch() → Backend API (Port 5001)
                                      ↓
                              Spielzustand berechnen
                                      ↓
Browser ← JSON-Antwort ←─────────────┘
```

Die Backend-URL kommt aus der Konfiguration (`config.py` → `BACKEND_URL`).
Das Frontend selbst bleibt jederzeit erreichbar; über die Runtime-Endpunkte (`/tutorial-room/runtime/stop`, `/tutorial-room/runtime`) kann die aktive Room-Instanz im Backend gestoppt oder gelöscht und danach neu gestartet werden.

---

## Design-System (base.html)

Das Design basiert auf **CSS Custom Properties** (Variablen), die einmal in `base.html` definiert sind und in allen Seiten gelten:

```css
--blue:    #0078D4;   /* Microsoft Azure Blau */
--cyan:    #22D3EE;   /* Akzentfarbe / Highlights */
--navy:    #0F172A;   /* Dunkler Hintergrund */
--surface: #1E293B;   /* Kartenoberfläche */
--text:    #F1F5F9;   /* Heller Text */
--muted:   #94A3B8;   /* Gedämpfter Text */
```

**Quellen für das Design:**
- Farbpalette: inspiriert vom [Microsoft Azure Portal](https://portal.azure.com) und dem [Tailwind CSS](https://tailwindcss.com/docs/customizing-colors) Farbsystem (Slate + Blau-Töne)
- Layout-Konzept: [MDN Web Docs – CSS Custom Properties](https://developer.mozilla.org/en-US/docs/Web/CSS/Using_CSS_custom_properties)
- Dark-Mode-Muster: [web.dev – prefers-color-scheme](https://web.dev/prefers-color-scheme/)

---

## Lokal starten

```bash
cd frontend
python wsgi.py
# → http://localhost:5000
```

> Das Frontend benötigt das Backend auf Port 5001 damit das Spiel funktioniert.
> Ohne Backend ist die Oberfläche weiterhin erreichbar, aber "Start Game" und Room-Aktionen zeigen eine Fehlermeldung.
