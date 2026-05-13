# Cloud-based escape room platform

![Titelbild](./img/cover_image.png)
*Das Image wurde mit Microsoft Copilot erstellt.*

---

# Inhaltsverzeichnis

[[ _TOC_ ]]

---

## 1 Einleitung

In dieser Arbeit wird eine Cloud-basierte Escape-Room-Plattform entwickelt, welche zur interaktiven Vermittlung von IT-Wissen dient. Die Plattform ermöglicht es Lernenden, technische Herausforderungen und Rätsel in einer praxisnahen und spielerischen Umgebung zu lösen. Ziel ist es, theoretische Inhalte aus der IT-Ausbildung mit realitätsnahen Szenarien zu kombinieren und dadurch den Lernerfolg nachhaltig zu verbessern.

Die Plattform basiert auf einer Cloud-nativen Microservice-Architektur und wird im Azure Tenant der Contoso University umgesetzt. Escape Rooms werden automatisiert über GitLab CI/CD Pipelines bereitgestellt und betrieben. Zusätzlich erfolgt die Authentifizierung über Microsoft Entra ID, wodurch eine sichere und kontrollierte Nutzung gewährleistet wird. Die Infrastruktur wird mithilfe von Infrastructure as Code (OpenTofu / Terraform) automatisiert und reproduzierbar bereitgestellt.

Die Arbeit dient als proof of concept (POC) für eine moderne und interaktive Lernplattform im Bereich der IT-Ausbildung. Sofern sich das Konzept bewährt, ist eine Weiterentwicklung mit zusätzlichen Szenarien und Funktionen vorgesehen.

Die Arbeit stützt sich auf das im dritten Semester des Lehrgangs zum dipl. Informatiker HF mit Vertiefung in Cloud Native erarbeitete Fachwissen und wurde von Marlon Burri als Einzelarbeit konzipiert und umgesetzt.

## 1.1 Behandelte Module

Microservices mit Python
Relationale Datenbanken
Datensicherheit
Containersicherheit
Netzwerk
Projektmanagement
Infrastructure as Code (IaC)
Function as a Service (FaaS)
Microsoft Azure Cloud

---

# Projektorganisation

```mermaid
flowchart TB
  subgraph Projekthierarchie[Projekthierarchie]
    direction TB

    subgraph Lehrgangsleitung
      Lehrgangsleiter[Lehrgangsleiter]
    end

    subgraph Projektbegleitung
      direction LR
      Projektleiter[Projektleiter]
      Fachdozent[Fachdozent]
    end

    subgraph Studierender
      Stud[Marlon Burri]
    end
  end

  Lehrgangsleiter <--> Projektleiter
  Lehrgangsleiter <--> Fachdozent
  Projektleiter <--> Stud
  Fachdozent <--> Stud

  linkStyle default stroke:#94a3b8,stroke-width:1.5px;
  style Projekthierarchie fill:#f8fafc,stroke:#e2e8f0,color:#334155,stroke-width:1px;
  style Lehrgangsleitung fill:#f8fafc,stroke:#dbe2ea,color:#334155,stroke-width:1px;
  style Projektbegleitung fill:#f8fafc,stroke:#dbe2ea,color:#334155,stroke-width:1px;
  style Studierender fill:#f8fafc,stroke:#dbe2ea,color:#334155,stroke-width:1px;

  classDef mentors fill:#f1f5f9,color:#334155,stroke:#cbd5e1,stroke-width:1.5px;
  classDef student fill:#dcfce7,color:#166534,stroke:#86efac,stroke-width:1.5px;

  class Lehrgangsleiter,Projektleiter,Fachdozent mentors;
  class Stud student;
  ```

## 2.1 Problemstellung

In der heutigen IT-Ausbildung werden technische Inhalte häufig theoretisch oder anhand isolierter Übungen vermittelt. Dies erschwert es Lernenden, komplexe Zusammenhänge praxisnah zu verstehen und in realistischen Szenarien anzuwenden.

Zusätzlich erfordern viele technische Themen ein hohes Mass an Eigeninitiative und praktischem Verständnis, welches durch klassische Lernmethoden nur begrenzt gefördert wird. Moderne Lernansätze wie Gamification oder interaktive Challenges gewinnen deshalb zunehmend an Bedeutung.

Mit dieser Arbeit soll eine Cloud-basierte Escape-Room-Plattform entwickelt werden, welche IT-Wissen spielerisch und praxisorientiert vermittelt. Die Plattform kombiniert moderne Cloud-Technologien, Microservices, CI/CD sowie Infrastructure as Code und ermöglicht Lernenden, technische Herausforderungen innerhalb realistischer Szenarien zu lösen.

## 2.2 Aufgabenstellung

Basierend auf der beschriebenen Problemstellung ist das Ziel dieser Arbeit die Entwicklung einer Cloud-basierten Escape-Room-Plattform für die interaktive Vermittlung von IT-Wissen. Die Plattform soll mindestens ein vollständig spielbares Escape-Room-Szenario bereitstellen und eine moderne Cloud-native Architektur verwenden.

Zur Umsetzung wird eine Microservice-Architektur eingesetzt, bei welcher Frontend, Backend und Spiellogik voneinander getrennt entwickelt und betrieben werden. Die Bereitstellung der Plattform erfolgt automatisiert über GitLab CI/CD Pipelines. Zusätzlich wird die Infrastruktur mithilfe von OpenTofu (Terraform) als Infrastructure as Code umgesetzt.

## 2.3 Ziele

- Entwicklung einer funktionalen Cloud-basierten Escape-Room-Plattform mit mindestens einem vollständig spielbaren Szenario
- Umsetzung einer Microservice-Architektur mit getrennten Komponenten für Frontend, Backend und Spiellogik
- Aufbau einer automatisierten CI/CD Pipeline mit GitLab für Build, Testing und Deployment
- Integration einer Authentifizierungslösung mittels Microsoft Entra ID inklusive rollenbasierter Zugriffskontrolle
- Automatisierte Bereitstellung der Infrastruktur mithilfe von OpenTofu (Terraform)
- Implementierung mindestens einer Azure Function zur Verarbeitung von Spielinteraktionen
- Einsatz einer relationalen Datenbank zur Speicherung von Spielständen, Sessions oder Benutzerinformationen
- Erstellung einer vollständigen Projektdokumentation inklusive Architekturübersicht, Deployment-Prozess und Lessons Learned

## 2.4 Sachmittel

Microsoft Azure Portal & CLI
GitLab
Jira (SCRUM-Board)
Visual Studio Code
Docker / Docker Compose
OpenTofu (Terraform)
Microsoft Entra ID
AI-Tools (ChatGPT, Claude, Copilot etc.)
JavaScript / TypeScript
Python
PostgreSQL
Azure Functions

## 2.5 Vorgaben, Methoden und Werkzeuge

__Projektmethodik:__  

Für die Umsetzung des Projekts wird SCRUM als agile Projektmanagementmethode eingesetzt. Die Entwicklung erfolgt iterativ in mehreren Sprints, wodurch regelmässig funktionsfähige Zwischenstände entstehen, welche überprüft und bei Bedarf angepasst werden können. Nach jedem Sprint werden Reviews und Retrospektiven durchgeführt, um den aktuellen Projektstand zu evaluieren und das weitere Vorgehen gezielt zu optimieren.

__Projektmanagement:__  

Für die Planung, Organisation und Steuerung des Projekts wird Jira eingesetzt. Sämtliche User Stories, Tasks, Sprint-Planungen sowie Fortschritte werden zentral verwaltet, um eine strukturierte und nachvollziehbare Projektorganisation sicherzustellen.

__Versionsverwaltung und Dokumentation:__  

GitLab wird für die Versionsverwaltung, Dokumentation sowie die Nachverfolgung sämtlicher Änderungen verwendet. Der gesamte Quellcode, die Infrastrukturdefinitionen sowie die technische Dokumentation werden zentral in einem GitLab-Repository verwaltet.

Die Projektdokumentation erfolgt fortlaufend in Markdown-Dateien innerhalb des Repositories und wird durch Commit Messages ergänzt, um die Nachvollziehbarkeit aller Änderungen sicherzustellen. Zusätzlich wird GitLab CI/CD zur Automatisierung von Build-, Test- und Deployment-Prozessen eingesetzt.

__Systemarchitektur und technische Umsetzung:__  

Die Plattform basiert auf einer Cloud-nativen Microservice-Architektur und wird im Azure Tenant der Contoso University umgesetzt. Einzelne Komponenten wie Frontend, Backend, Spiellogik sowie serverlose Funktionen werden voneinander getrennt entwickelt und betrieben, um eine flexible, skalierbare und wartbare Architektur zu gewährleisten.

Das Frontend wird mit JavaScript beziehungsweise TypeScript umgesetzt. Für die Backend- und API-Komponenten wird Python verwendet. Die Kommunikation zwischen den einzelnen Diensten erfolgt über definierte Schnittstellen und APIs.

Die Plattform wird containerisiert betrieben. Dafür werden Docker und Docker Compose eingesetzt, um die einzelnen Services lokal sowie in der Cloud reproduzierbar bereitzustellen.

__Cloud und Infrastruktur:__    

Die Bereitstellung der Infrastruktur erfolgt mittels Infrastructure as Code unter Verwendung von OpenTofu (Terraform-kompatibel). Dadurch kann die gesamte Umgebung automatisiert, standardisiert und reproduzierbar bereitgestellt werden.

Das Terraform-Statefile wird zentral in einem Azure Storage Account gespeichert, um eine konsistente Verwaltung der Infrastruktur sicherzustellen. Sämtliche Azure-Ressourcen werden innerhalb des Azure Tenants der Contoso University erstellt und verwaltet.

__CI/CD und Deployment:__

Für die Automatisierung von Build-, Test- und Deployment-Prozessen wird GitLab CI/CD eingesetzt. Änderungen am Quellcode lösen automatisierte Pipelines aus, welche die Container erstellen, testen und anschliessend in die Zielumgebung deployen.

Die Plattform soll so aufgebaut werden, dass Escape-Room-Szenarien automatisiert bereitgestellt und aktualisiert werden können. Dadurch wird ein effizienter und standardisierter Deployment-Prozess ermöglicht.

__Test und Validierung:__  
  
Das Testing erfolgt kontinuierlich während der gesamten Entwicklung. Nach der Implementierung einzelner Funktionen werden Funktions-, Integrations- sowie Deployment-Tests durchgeführt.

Am Ende des Projekts erfolgt zusätzlich ein End-to-End-Test der gesamten Plattform inklusive Authentifizierung, Deployment, Datenhaltung und Spiellogik, um die korrekte Funktionsweise der Lösung sicherzustellen.

__Arbeitsumgebung:__

Die Entwicklung des Projekts erfolgt vollständig auf meinem persönlichen Laptop. Der gesamte Quellcode wird lokal entwickelt und anschliessend in das zentrale GitLab-Repository übertragen.

Als Entwicklungsumgebung wird Visual Studio Code verwendet, da dieser Editor eine effiziente Arbeitsweise mit Erweiterungen für Docker, Git, Python, Azure und OpenTofu ermöglicht.

Zusätzlich werden AI-gestützte Werkzeuge wie ChatGPT, Claude oder GitHub Copilot unterstützend für Recherche, Problemlösung und Codeunterstützung verwendet.

__Nicht Teil des Projektes:__  

Die vollständige produktive Einführung der Plattform ist nicht Bestandteil dieser Semesterarbeit. Ziel der Arbeit ist die Entwicklung eines funktionsfähigen Proof of Concept (POC), welcher die technische Machbarkeit sowie die grundlegende Architektur der Lösung demonstriert.

Eine spätere Erweiterung der Plattform mit zusätzlichen Escape-Room-Szenarien, erweiterten Spielmechaniken oder produktiven Betriebsprozessen ist möglich, jedoch nicht Bestandteil dieser Arbeit.

__Risikoanalyse:__

m Rahmen des Projekts wird eine Risikoanalyse durchgeführt, um potenzielle technische sowie organisatorische Risiken frühzeitig zu identifizieren und geeignete Massnahmen zu definieren.

Das Risiko-Level wird anhand der Eintrittswahrscheinlichkeit sowie der möglichen Auswirkungen eines Risikos bewertet. Beide Faktoren werden auf einer Skala von 1 bis 5 eingestuft und anschliessend kombiniert.

Die Eintrittswahrscheinlichkeit beschreibt, wie wahrscheinlich das Eintreten eines Risikos ist. Die Auswirkung beschreibt die möglichen Folgen auf das Projekt bei Eintritt des Risikos.

Das Risiko-Level wird in folgende Kategorien eingeteilt:
* 🔴 __Sehr hoch__ (15–25)
* 🟠 __Hoch__ (10–14)
* 🟡 __Mittel__ (5–9)
* 🟢 __Niedrig__ (1–4)


---

# 3 Projektplan

Für die Semesterarbeit wurden vier Sprints geplant. Auf einen klassischen Gantt-Plan wurde bewusst verzichtet, da die Umsetzung agil nach dem SCRUM-Framework erfolgt. Stattdessen wurden die Sprints mit fixen Zeitfenstern und klaren Zielen definiert, um den Fortschritt trotzdem strukturiert verfolgen und steuern zu können.

**Der Zeitplan für die Projektsprints sieht wie folgt aus:**

| Sprint   | Titel                              | Zeitraum                | Ziel                                                                                                                  |
|----------|----------------------------------- |-------------------------|-----------------------------------------------------------------------------------------------------------------------|
| Sprint 0 | Setup und Planung                  | 27.04.2026 – 08.05.2026 | Projektinitialisierung (GitLab, Jira, Azure-Setup, Backlog-Erstellung etc.)                                           |
| Sprint 1 | Core Platform & Game Engine        | 11.05.2026 – 31.05.2026 | Frontend Grundstruktur, Game Engine (State, Actions), erster Escape Room (Tutorial), einfache Interaktionen |
| Sprint 2 | Interaktivität & Cloud Integration | 01.06.2026 – 21.06.2026 | Erweiterte Interaktionen, mehrere Räume / Szenarien, Cloud Deployment (erste Version), Microservices einführen            |
| Sprint 3 | DevOps, Auth & Finalisierung       | 22.06.2026 – 06.07.2026 | Auth mit Microsoft Entra ID, Escape Rooms via GitLab Pipelines starten, Testing, Bugfixing, Dokumentation, Präsentation.                            |
  
Die folgende Gantt-Übersicht visualisiert die Sprint-Planung und die zugehörigen Releases (MVP[^34], MLP[^35], MMP[^36]). Das Diagramm wird direkt im README als Mermaid gepflegt und ist konsistent mit der obigen Tabelle.

```mermaid
gantt
  title Gantt Chart
  dateFormat YYYY-MM-DD

  section Sprints
  Sprint 0 :crit, sprint0, 2025-10-31, 2025-11-06
  Sprint 1 :sprint1, 2025-11-07, 2025-11-27
  Sprint 2 :sprint2, 2025-11-28, 2025-12-18
  Sprint 3 :sprint3, 2025-12-19, 2026-01-08
  Sprint 4 :sprint4, 2026-01-09, 2026-01-28

  section Releases
  MVP :crit, mvp, 2025-11-27, 1d
  MLP :crit, mlp, 2025-12-18, 1d
  MMP :crit, mmp, 2026-01-08, 1d
```

*Gantt‑Übersicht der Sprints und Releases*

Datenbasis: siehe [data/Gantt_Chart.csv](data/Gantt_Chart.csv).

## 3.1 Product Roadmap

Die Product Roadmap zeigt die übergeordnete Planung und Entwicklungsrichtung des Projekts über die gesamte Dauer der Semesterarbeit hinweg.
Sie dient als Leitfaden für die Umsetzung der definierten Releases (MVP, MLP, MMP) und ist eng an die Sprint-Struktur des SCRUM-Frameworks angelehnt.
Da das Projekt iterativ aufgebaut ist, können Anpassungen während der Umsetzung jederzeit vorgenommen werden, um flexibel auf neue Erkenntnisse und Herausforderungen zu reagieren.

Sprint 0 und Sprint 4 sind in der Roadmap nicht aufgeführt, da in diesen Sprints kein Produkt bzw. Release entstehen wird.

__Übersicht der Releases:__

| Release                          | Zeitraum (Sprint) | Ziel / Inhalt                | Hauptfokus                                                                                                                  |
|----------------------------------|-------------------|------------------------------|-----------------------------------------------------------------------------------------------------------------------|
| MVP (Minimum Viable Product)     | Sprint 1          | Grundlegende Architektur und Funktionsfähigkeit des automatisierten Bestellprozesses mit Camunda. Einrichtung der Entwicklungsumgebung, Definition der Systemarchitektur und Umsetzung eines lauffähigen Prototyps zur automatisierten Erstellung von Azure Subscriptions. | Funktionsfähigkeit, Architektur, Basisprozess |
| MLP (Minimum Lovable Product)    | Sprint 2          | Erweiterung des MVP um zusätzliche Funktionalitäten, wie erweiterte Governance-Tags, Prozessoptimierungen und Benutzerfreundlichkeit. Der Prozess soll robust und nachvollziehbar sein und sich leicht erweitern lassen. | Nutzerfreundlichkeit, Stabilität, Governance |
| MMP (Minimum Marketable Product) | Sprint 3          | Fertigstellung des Projekts mit Fokus auf Einsatzfähigkeit im Betrieb. Finalisierung der Dokumentation, Tests, Optimierung der Endlösung. | Produktionsreife, Abschluss           |

## 3.2 Definition of Ready (DoR)

Die Definition of Ready[^24] legt fest, welche Voraussetzungen eine User Story erfüllen muss, damit sie ins Sprint Backlog aufgenommen werden kann. Die DoR Kriterien stellen sicher, dass die User Story technisch planbar, fachlich verstanden und innerhalb des Sprint-Zeitrahmens realistisch Umsetzbar ist. Im Rahmen der Semesterarbeit dient die DoR zudem als Qualitätssicherung für die korrekte Vorbereitung jeder User Story.

* __Inhaltliche Anforderungen:__ Die User Story enthält eine klare Beschreibung nach dem im Scrum Framework definierten Schema und beschreibt den fachlichen oder technischen Mehrwert für das Projekt. Die Akzeptanzkriterien wurden definiert und die User Story trägt messbar zu den übergeordneten Zielen der Semesterarbeit bei. 

* __Technische Anforderungen:__ Alle technischen Abhängigkeiten wurden identifiziert. Externe Abhängigkeiten und benötigte Ressourcen sind, falls erforderlich dokumentiert. Potenzielle Risiken und Blocker wurden erkannt und, sofern möglich, vorab behoben.

* __Planbarkeit:__ Die User Story ist so zugeschnitten, dass sie innerhalb eines Sprints abgeschlossen werden kann. Sie wurde bei Bedarf in Tasks oder Subtasks unterteilt, der Aufwand wurde in Story Points geschätzt und die Priorität über das MVP/MLP/MMP-Label definiert. Die Story wurde im Sprint Planning besprochen.

Die Definition of Ready gilt einheitlich für alle User Stories im Projekt und wird nicht individuell in die Beschreibung eingefügt.

## 3.3 Definition of Done (DoD)

Die Definition of Done[^23] beschreibt die Kriterien, die erfüllt sein müssen, damit eine User Story als vollständig abgeschlossen gilt. Sie stellt sicher, dass alle fachlichen, technischen und dokumentarischen Anforderungen erfüllt sind.

* __Umsetzung der Anforderungen:__ Alle Akzeptanzkriterien der User Story wurden vollständig umgesetzt, die Funktionalität wurde getestet und erfüllt den definierten Zweck.

* __Validierung und Qualitätssicherung:__ Funktionale Tests oder manuelle Überprüfungen wurden durchgeführt. Mögliche Probleme oder Abweichungen wurden analysiert und behoben.

* __Dokumentation und Nachvollziehbarkeit:__ Alle Ergebnisse, Entscheidungen und technischen Schritte sind in der Projektdokumentation festgehalten. Änderungen im Repository sind sauber beschrieben, nachvollziehbar versioniert und mit Jira verknüpft.

* __Abnahme und Integration:__ Die User Story wurde im Rahmen der Sprint Review vorgestellt, akzeptiert und in Jira auf Done gesetzt. Falls relevant, wurde die Lösung in das Gesamtprojekt integriert.

Im Jira-Projekt ist eine Automation Rule hinterlegt, die beim Anlegen neuer User Stories automatisch die DoD-Kriterien in das Beschreibungsfeld einfügt. Dadurch wird sichergestellt, dass alle Stories nach denselben Qualitätsmassstäben umgesetzt und überprüft werden.

## 3.4 Projekt Sprints

### 3.4.1 Sprint 0

__Sprint Planning:__

__Sprint Review:__

Abgeschlossene User Stories:

__Risikoverlauf Sprint 0:__

__Sprint Retrospective:__

__Lessons Learned:__


### 3.4.2 Sprint 1

__Sprint Planning:__

__Sprint Review:__

Abgeschlossene User Stories:

__Risikoverlauf Sprint 1:__

__Sprint Retrospective:__

__Lessons Learned:__


### 3.4.3 Sprint 2

__Sprint Planning:__

__Sprint Review:__

Abgeschlossene User Stories:

__Risikoverlauf Sprint 2:__

__Sprint Retrospective:__

__Lessons Learned:__


### 3.4.4 Sprint 3

__Sprint Planning:__

__Sprint Review:__

Abgeschlossene User Stories:

__Risikoverlauf Sprint 3:__

__Sprint Retrospective:__

__Lessons Learned:__


### 3.4.5 Sprint 4

__Sprint Planning:__

__Sprint Review:__

Abgeschlossene User Stories:

__Risikoverlauf Sprint 4:__

__Sprint Retrospective:__

__Lessons Learned:__


---

# 4 Lösungsdesign

---

# 5 Umsetzung

---

# 6 Testverfahren

---

# 7 Projektabschluss

## 7.1 Abschliessende Risikobilanz

## 7.2 Technisches Fazit

## 7.3 Persönliches Fazit

## 7.4 Mögliche Weiterentwicklung

---

# 8 Schlusswort

## 8.1 Quellenverzeichnis

## 8.2 Glossar
