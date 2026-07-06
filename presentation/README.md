# Abschlusspräsentation (Pitch-Format)

Dieser Ordner enthält die reveal.js-basierte Abschlusspräsentation für die Semesterarbeit
"Cloud-based escape room platform" (Kolloquium / Produkte Vorführung).

## Öffnen

Kein Build oder npm-Install nötig — reveal.js wird direkt über ein CDN geladen.

- Doppelklick auf `index.html`, oder
- lokal servieren, z. B.:

```powershell
cd presentation
python -m http.server 8080
# dann im Browser: http://localhost:8080
```

> Hinweis: Ein direkter `file://`-Aufruf funktioniert meist ebenfalls, ein lokaler Server
> vermeidet aber mögliche Browser-Einschränkungen (z. B. beim Video-Tag).

## Steuerung

- Pfeiltasten / Leertaste: nächste/vorherige Folie
- `S`: Speaker-Notes-Fenster öffnen (enthält Zeit- und Ablaufhinweise pro Folie)
- `ESC`: Übersichtsmodus

## Demo-Video

Die Folie "Live-Demo / Aufzeichnung" bindet `assets/demo.mp4` per HTML5 `<video>`-Tag ein.
Die Videodatei ist **nicht** im Repository enthalten und muss manuell ergänzt werden:

```
presentation/assets/demo.mp4
```

Solange die Datei fehlt, zeigt die Folie einen Fallback-Hinweis an, statt kaputt auszusehen.
Alternativ kann die Folie für eine echte Live-Demo genutzt werden (Browser-Wechsel während der Präsentation).

## Struktur

```
presentation/
├── index.html          # Präsentation (reveal.js über CDN)
├── assets/
│   ├── cover_image.png # Titelbild (aus img/)
│   ├── big_picture.png # Azure-Architekturdiagramm (aus data/)
│   └── demo.mp4         # Demo-Aufzeichnung (manuell ergänzen)
└── README.md
```

## Export als PDF

Reveal.js unterstützt PDF-Export über den Print-Stylesheet-Modus:

1. Präsentation im Browser (Chrome empfohlen) öffnen mit Parameter `?print-pdf`, z. B.
   `http://localhost:8080/index.html?print-pdf`
2. Browser-Druckdialog öffnen (`Strg`+`P`) und als PDF speichern (Ränder: keine)
