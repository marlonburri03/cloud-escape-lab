# Abschlusspräsentation (Pitch-Format)

Dieser Ordner enthält die reveal.js-basierte Abschlusspräsentation für die Semesterarbeit
"Cloud-based escape room platform" (Kolloquium / Produkte Vorführung).

Der visuelle Stil orientiert sich an der Contoso-Vorlage der letzten Semesterarbeit
(`SemArbeit2_Präsentation_MB.pptx`): Farbschema (Blau `#0028A5`, Cyan, Grün, Gelb, Orange,
Karmesin), Schrift "Source Sans Pro", sowie Kopf-/Fusszeile mit Datum, Breadcrumb und
Seitenzahl. Foliendramaturgie: Titel → Problem → Ziel der Arbeit → Ablauf/Live-Demo →
Lösungsübersicht → GitLab Pipeline → Mehrwert → Reflexion &amp; Ausblick.

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

## Export als PDF

Reveal.js unterstützt PDF-Export über den Print-Stylesheet-Modus:

1. Präsentation im Browser (Chrome empfohlen) öffnen mit Parameter `?print-pdf`, z. B.
   `http://localhost:8080/index.html?print-pdf`
2. Browser-Druckdialog öffnen (`Strg`+`P`) und als PDF speichern (Ränder: keine)
