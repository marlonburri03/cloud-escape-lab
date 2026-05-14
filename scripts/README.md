# scripts/

Hilfs-Scripts für den lokalen Entwicklungsworkflow.

## `frontend-local.ps1`

Baut, startet und testet den Frontend-Container lokal in einem Schritt.

### Voraussetzungen

- Docker Desktop läuft
- PowerShell 5.1+ oder PowerShell 7

### Verwendung

Alle Befehle werden aus dem Repo-Root ausgeführt.

```powershell
# Alles auf einmal: bauen, starten, /healthz + / + /tutorial testen
.\scripts\frontend-local.ps1

# Nur Endpoints testen (Container muss laufen)
.\scripts\frontend-local.ps1 -Action test

# Logs live verfolgen (Ctrl+C zum Beenden)
.\scripts\frontend-local.ps1 -Action logs

# Container stoppen und entfernen
.\scripts\frontend-local.ps1 -Action down

# Container und Image entfernen
.\scripts\frontend-local.ps1 -Action clean

# Auf anderem Host-Port starten
.\scripts\frontend-local.ps1 -Port 8080
```

### Aktionen im Überblick

| `-Action` | Was passiert |
|---|---|
| `up` (Standard) | Build + Run + Test in einem Durchlauf |
| `build` | Nur Docker-Image bauen |
| `run` | Vorhandenen Container neu starten |
| `test` | `/healthz`, `/` und `/tutorial` aufrufen |
| `logs` | Live-Log-Ausgabe des Containers |
| `down` | Container stoppen und entfernen |
| `clean` | Container + Image entfernen |

### Erreichbare Endpoints (Standard-Port 8000)

| URL | Inhalt |
|---|---|
| <http://localhost:8000/> | Landing Page |
| <http://localhost:8000/tutorial> | Tutorial-Stub |
| <http://localhost:8000/healthz> | Health Check (JSON) |
| <http://localhost:8000/docs> | APIFlask Swagger UI |
| <http://localhost:8000/redoc> | ReDoc API-Dokumentation |

### Parameter

| Parameter | Default | Beschreibung |
|---|---|---|
| `-Action` | `up` | Auszuführende Aktion (siehe Tabelle oben) |
| `-Port` | `8000` | Host-Port, auf dem der Container exponiert wird |
| `-Tag` | `local` | Tag des lokalen Images (`escape-frontend:<Tag>`) |
