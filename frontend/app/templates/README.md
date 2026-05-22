# Templates – Jinja2 HTML-Vorlagen

Dieser Ordner enthält alle **HTML-Seiten** der Anwendung. Sie verwenden **Jinja2**, die Template-Engine von Flask.

---

## Was ist Jinja2?

Jinja2 erlaubt es, **HTML mit Python-Variablen und Logik** zu kombinieren. Zum Beispiel:

```html
<h1>Hallo, {{ user }}</h1>
```

Flask übergibt `user` aus der Route, Jinja2 setzt ihn in das HTML ein.  
→ Quelle: [jinja.palletsprojects.com/en/3.x/templates](https://jinja.palletsprojects.com/en/3.x/templates/)

---

## Template-Vererbung (das Wichtigste)

Alle Seiten **erben** von `base.html`. Das vermeidet Code-Wiederholung.

```
base.html          ← Basisgerüst: <html>, <head>, CSS, Header
  ├── index.html   ← {% extends "base.html" %} + {% block content %}
  └── tutorial.html
```

**Wie es funktioniert:**

`base.html` definiert einen Platzhalter:
```html
{% block content %}{% endblock %}
```

Jede Kindseite füllt diesen Platzhalter aus:
```html
{% extends "base.html" %}
{% block content %}
  <!-- Seiteninhalt hier -->
{% endblock %}
```

→ Quelle: [flask.palletsprojects.com – Templates](https://flask.palletsprojects.com/en/3.x/templating/)

---

## Dateien im Überblick

### `base.html` – Das Fundament

**Was es enthält:**
- `<meta viewport>` → Damit die Seite auf Mobilgeräten korrekt dargestellt wird
- **Google Fonts (Inter)** → Moderne, professionelle Schriftart
- **Bootstrap Icons (CDN)** → Icon-Bibliothek (`<i class="bi bi-cloud-fill">`)
- **CSS Design-System** → Alle Farben, Abstände, Schriften als CSS-Variablen
- **App-Shell-Layout** → Der gemeinsame Header mit Logo und Contoso-Bezeichnung

**Warum ein Design-System?**  
Durch CSS Custom Properties (`--blue`, `--navy` etc.) muss eine Farbe nur einmal geändert werden und gilt überall. Das ist ein Best Practice aus der modernen Web-Entwicklung.

---

### `index.html` – Startseite

**Inhalt:**
- Begrüssungskarte mit dem Nutzernamen (`{{ user }}` aus Azure Easy Auth)
- Drei Feature-Chips (Azure Labs, DevOps, Security)
- Button zum Tutorial Room

**Variablen von Flask:**
| Variable | Herkunft | Inhalt |
|---|---|---|
| `{{ user }}` | `g.user` in `routes.py` | Eingeloggter Nutzername (oder "anonymous") |
| `{{ title }}` | `config.py` → `SITE_TITLE` | "Contoso Escape Room Platform" |

---

### `tutorial.html` – Der Escape Room

**Was es enthält:**
- **CSS** (oben im Block): Styling der Spieloberfläche (Panels, Karten, Buttons, Nachrichten)
- **HTML** (Mitte): Startbildschirm, Win-Banner, Spielbereich mit zwei Panels
- **JavaScript** (unten): Gesamte Spiellogik – kommuniziert mit dem Backend

**Aufbau des JavaScripts:**

```
startGame()       → POST /tutorial-room/start  → erhält JWT-Token
examineRoom()     → GET  /tutorial-room/examine
examineSelected() → GET  /tutorial-room/objects/{id}/examine
interactSelected()→ POST /tutorial-room/objects/{id}/interact
resetGame()       → POST /tutorial-room/reset
```

**Wichtig:** Das JavaScript sendet bei jeder Anfrage einen **JWT-Token** im Header:
```
Authorization: Bearer <token>
```
Das Backend prüft diesen Token und weiss so, welches Spiel gemeint ist.

**Woher der Token kommt:**  
Beim `startGame()` wird ein UUID generiert (`crypto.randomUUID()`), ans Backend gesendet, und das Backend gibt einen JWT-Token zurück. Dieser Token wird im Browser gespeichert (`gameToken`).

---

## Was wurde vom Lehrer übernommen? Was habe ich geändert?

| Datei | Ursprung (Lehrer) | Meine Änderungen |
|---|---|---|
| `base.html` | Minimal: 15 Zeilen, weisser Hintergrund, `system-ui`-Font | Komplett neu: Dark Theme, Inter-Font, CSS-Variablen, Logo-Header |
| `index.html` | `<h1>Hello, {{ user }}</h1>` + grüner Button | Welcome-Card mit Feature-Chips, gleiche Variablen und Route |
| `tutorial.html` | Placeholder: "not deployed yet (Phase 2)" → dann vollständige Spiellogik vom Lehrer bereitgestellt | Komplettes CSS-Redesign (Dark Theme), JS **1:1 unverändert** übernommen |

> **Das gesamte JavaScript in `tutorial.html` ist die Arbeit des Lehrers.**  
> Ich habe ausschliesslich das visuelle Design (CSS) verbessert und einen `try/catch`  
> in `startGame()` ergänzt, damit Netzwerkfehler sichtbar angezeigt werden statt  
> den Button einzufrieren.

---

## Quellen

| Thema | Quelle |
|---|---|
| Jinja2 Template-Vererbung | [jinja.palletsprojects.com](https://jinja.palletsprojects.com/en/3.x/templates/#template-inheritance) |
| Flask Templates | [flask.palletsprojects.com](https://flask.palletsprojects.com/en/3.x/templating/) |
| CSS Custom Properties | [MDN – Using CSS custom properties](https://developer.mozilla.org/en-US/docs/Web/CSS/Using_CSS_custom_properties) |
| Bootstrap Icons | [icons.getbootstrap.com](https://icons.getbootstrap.com/) |
| Inter Schriftart | [rsms.me/inter](https://rsms.me/inter/) |
| Farbpalette (Azure-Stil) | [Microsoft Fluent Design – Color](https://fluent2.microsoft.design/color) |
| CSS Dark Mode Pattern | [web.dev – color-scheme](https://web.dev/articles/color-scheme) |
| `crypto.randomUUID()` | [MDN – Crypto.randomUUID](https://developer.mozilla.org/en-US/docs/Web/API/Crypto/randomUUID) |
| fetch() API | [MDN – Using Fetch](https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API/Using_Fetch) |
