# Templates

This folder contains all HTML pages of the frontend, written as [Jinja2](https://jinja.palletsprojects.com/) templates.

## Template inheritance

Every page extends `base.html`, which avoids duplicated markup:

```text
base.html          skeleton: <html>, <head>, CSS design system, header
  ├── index.html   {% extends "base.html" %} + {% block content %}
  └── tutorial.html
```

`base.html` defines the placeholder `{% block content %}{% endblock %}`, and each page fills it.

## Files

### `base.html`

- Viewport meta tag for mobile devices
- Inter font and Bootstrap Icons
- CSS design system: colours, spacing and typography as custom properties
- App shell with the shared header and the organisation logo

### `index.html`: start page

- Welcome card with the user name (`{{ user }}` from the authentication header, otherwise `anonymous`)
- Three feature chips (Azure labs, DevOps, security)
- Button to the tutorial room

| Variable | Source | Content |
|---|---|---|
| `{{ user }}` | `g.user` in `routes.py` | Signed-in user name or `anonymous` |
| `{{ title }}` | `SITE_TITLE` in `config.py` | Site title |

### `tutorial.html`: the escape room

- **CSS:** styling of panels, cards, buttons and messages
- **HTML:** start screen, success banner, game area with two panels
- **JavaScript:** all client-side game handling, talking to the backend:

```text
startGame()        POST   /tutorial-room/start          receives the JWT
stopRuntime()      POST   /tutorial-room/runtime/stop
deleteRuntime()    DELETE /tutorial-room/runtime
examineRoom()      GET    /tutorial-room/examine
examineSelected()  GET    /tutorial-room/objects/{id}/examine
interactSelected() POST   /tutorial-room/objects/{id}/interact
resetGame()        POST   /tutorial-room/reset
```

Every request carries `Authorization: Bearer <token>`. On `startGame()` the browser generates a UUID (`crypto.randomUUID()`), the backend returns a JWT for it, and the page keeps it in `gameToken`.

## Origin and changes

| File | Upstream template | Changes in this project |
|---|---|---|
| `base.html` | Minimal page, white background, system font | Rebuilt: dark theme, Inter, CSS variables, header with logo |
| `index.html` | Greeting and a button | Welcome card with feature chips; same variables and route |
| `tutorial.html` | `room_tester.html` from `ma-room-template` | Complete CSS redesign and layout integration; JavaScript largely taken from the template |

> **Licence:** `tutorial.html` is adapted from the room tester in [`ma-room-template`](https://gitlab.com/solvista/ma-room-template) and is licensed under **CC BY-SA 4.0**. The structure and most of the game interaction come from the template; this project added the visual design, the integration into the UI and small error-handling changes.

## References

[Jinja template inheritance](https://jinja.palletsprojects.com/en/3.x/templates/#template-inheritance) · [Flask templates](https://flask.palletsprojects.com/en/3.x/templating/) · [CSS custom properties](https://developer.mozilla.org/en-US/docs/Web/CSS/Using_CSS_custom_properties) · [Bootstrap Icons](https://icons.getbootstrap.com/) · [Inter](https://rsms.me/inter/) · [Fluent colour](https://fluent2.microsoft.design/color) · [color-scheme](https://web.dev/articles/color-scheme) · [crypto.randomUUID](https://developer.mozilla.org/en-US/docs/Web/API/Crypto/randomUUID) · [Fetch API](https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API/Using_Fetch)
