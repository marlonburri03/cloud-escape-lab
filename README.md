# Cloud-based escape room platform

![Titelbild](./img/cover_image.png)
*Das Image wurde mit Microsoft Copilot erstellt.*

---

# Inhaltsverzeichnis

[[ _TOC_ ]]

---

## 1 Einleitung

In dieser Arbeit wird eine Cloud-basierte Escape-Room-Plattform entwickelt, welche zur interaktiven Vermittlung von IT-Wissen dient. Die Plattform ermöglicht es Lernenden, technische Herausforderungen und Rätsel in einer praxisnahen und spielerischen Umgebung zu lösen. Ziel ist es, theoretische Inhalte aus der IT-Ausbildung mit realitätsnahen Szenarien zu kombinieren und dadurch den Lernerfolg nachhaltig zu verbessern.

Die Plattform basiert auf einer Cloud-nativen Microservice-Architektur[^1] und wird im Azure Tenant der Contoso University umgesetzt. Escape Rooms werden automatisiert über GitLab CI/CD Pipelines[^2] bereitgestellt und betrieben. Die Azure-seitige Deployment-Authentifizierung erfolgt passwortlos über Microsoft Entra ID[^3] via OIDC[^4]. Das Frontend ist mit Azure Container Apps[^5] Built-in Authentication (EasyAuth[^6]) abgesichert: unauthentifizierte Requests werden automatisch auf die Microsoft-Loginseite weitergeleitet. Die Infrastruktur wird mithilfe von Infrastructure as Code[^7] (OpenTofu[^8] / Terraform) automatisiert und reproduzierbar bereitgestellt.

Die Arbeit dient als proof of concept (POC)[^9] für eine moderne und interaktive Lernplattform im Bereich der IT-Ausbildung. Sofern sich das Konzept bewährt, ist eine Weiterentwicklung mit zusätzlichen Szenarien und Funktionen vorgesehen.

Die Arbeit stützt sich auf das im dritten Semester des Lehrgangs zum dipl. Informatiker HF mit Vertiefung in Cloud Native erarbeitete Fachwissen und wurde von Marlon Burri als Einzelarbeit konzipiert und umgesetzt.

> **Lizenz- und Herkunftshinweis zum Tutorial Room**
> Dieses Repository enthält abgeleitete Inhalte aus dem Repository [`ma-room-template`](https://gitlab.com/solvista/ma-room-template), das unter **Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)**[^10] veröffentlicht wurde.
> Betroffen sind insbesondere `frontend/app/templates/tutorial.html`, `backend/app/rooms/tutorial/` sowie die dazugehörigen Dokumentationsabschnitte.
> Eigene Anpassungen umfassen vor allem das UI-/CSS-Redesign, die inhaltliche Contoso-/Cloud-Escape-Lab-Einbettung und projektspezifische Integration in Frontend und Backend.
> Die konkreten Attribution-Hinweise stehen in [`NOTICE`](./NOTICE), der vollständige Lizenztext in [`LICENSE`](./LICENSE).

## 1.1 Behandelte Module

- Microservices mit Python
- Relationale Datenbanken
- Datensicherheit
- Containersicherheit
- Netzwerk
- Projektmanagement
- Infrastructure as Code (IaC)
- Function as a Service (FaaS)
- Microsoft Azure Cloud

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

- Microsoft Azure Portal & CLI
- GitLab
- Jira[^11] (SCRUM-Board[^12])
- Visual Studio Code
- Docker / Docker Compose
- OpenTofu (Terraform)
- Microsoft Entra ID
- AI-Tools (ChatGPT, Claude, Copilot etc.)
- JavaScript / TypeScript
- Python
- PostgreSQL
- Azure Functions

## 2.5 Vorgaben, Methoden und Werkzeuge

__Projektmethodik:__

Für die Umsetzung des Projekts wird SCRUM als agile Projektmanagementmethode eingesetzt. Die Entwicklung erfolgt iterativ in mehreren Sprints[^13], wodurch regelmässig funktionsfähige Zwischenstände entstehen, welche überprüft und bei Bedarf angepasst werden können. Nach jedem Sprint werden Reviews und Retrospektiven durchgeführt, um den aktuellen Projektstand zu evaluieren und das weitere Vorgehen gezielt zu optimieren.

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

![RisikoMatrix](img/risiko_analyse.png)
*Screenshot von meiner Risiko Matrix aus data/RisikoMatrix.xlsx.*

| Risiko-ID | Beschreibung | Wahrscheinlichkeit | Auswirkung | Risiko-Level | Farbe | Massnahmen |
|---|---|---|---|---|---|---|
| R1 | Hohe Komplexität der Architektur erschwert die Umsetzung und Fehlersuche | 4 (hoch) | 4 (hoch) | 16 | 🔴 Sehr hoch | Fokus auf MVP[^14], klare Architektur sowie schrittweise Umsetzung der Kernfunktionen |
| R2 | Zeitlicher Aufwand überschreitet den verfügbaren Rahmen der Semesterarbeit | 4 (hoch) | 4 (hoch) | 16 | 🔴 Sehr hoch | Priorisierung der wichtigsten Funktionen und iterative Umsetzung |
| R3 | Fehler oder Probleme in GitLab CI/CD Pipelines verhindern automatisierte Deployments | 3 (mittel) | 4 (hoch) | 12 | 🟠 Hoch | Schrittweiser Aufbau der Pipeline sowie regelmässige Tests |
| R4 | Probleme bei der Integration von Microsoft Entra ID und Authentifizierung | 3 (mittel) | 4 (hoch) | 12 | 🟠 Hoch | Frühzeitige Implementierung und kontinuierliches Testing der Authentifizierung |
| R5 | Fehlerhafte Infrastrukturdefinitionen in OpenTofu führen zu fehlerhaften Deployments | 3 (mittel) | 3 (mittel) | 9 | 🟡 Mittel | Regelmässige Validierung der Infrastruktur sowie Verwendung separater Testumgebungen |

__SWOT-Analyse:__

Im Rahmen der Konzeptionsphase wurde eine SWOT-Analyse durchgeführt, um die Stärken, Schwächen, Chancen und Risiken des Projekts systematisch zu erfassen. Diese Analyse dient als Grundlage für strategische Entscheidungen im weiteren Verlauf der Arbeit.

![SWOTAnalyse](img/swot_analyse.png)
*Screenshot von meiner SWOT-Analyse aus data/SWOT_Analyse.xlsx.*


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

Die folgende Gantt-Übersicht visualisiert die Sprint-Planung und die zugehörigen Releases (MVP, MLP, MMP). Das Diagramm wird direkt im README als Mermaid gepflegt und ist konsistent mit der obigen Tabelle.

```mermaid
gantt
  title Gantt Chart
  dateFormat YYYY-MM-DD
  axisFormat %b '%y

  section Sprints
  Sprint 0 :crit, sprint0, 2026-04-27, 2026-05-08
  Sprint 1 :sprint1, 2026-05-11, 2026-05-31
  Sprint 2 :sprint2, 2026-06-01, 2026-06-21
  Sprint 3 :sprint3, 2026-06-22, 2026-07-06

  section Releases
  MVP :crit, mvp, 2026-05-31, 1d
  MLP :crit, mlp, 2026-06-21, 1d
  MMP :crit, mmp, 2026-07-06, 1d
```

*Gantt‑Übersicht der Sprints und Releases*

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

Die Definition of Ready (DoR)[^15] legt fest, welche Voraussetzungen eine User Story erfüllen muss, damit sie in ein Sprint Backlog aufgenommen werden kann. Ziel der DoR ist es, sicherzustellen, dass User Stories fachlich verstanden, technisch planbar und innerhalb des Sprint-Zeitrahmens realistisch umsetzbar sind.

Im Rahmen dieser Semesterarbeit dient die Definition of Ready zusätzlich als Qualitätskontrolle für die Vorbereitung technischer sowie organisatorischer Aufgaben innerhalb der Cloud-basierten Escape-Room-Plattform.

__Inhaltliche Anforderungen:__
- Die User Story enthält eine verständliche Beschreibung nach dem Scrum-Framework.
- Der fachliche oder technische Mehrwert der Story für das Projekt ist klar ersichtlich.
- Akzeptanzkriterien wurden definiert.
- Die Story unterstützt die Ziele des jeweiligen Releases (MVP, MLP oder MMP).

__Technische Anforderungen:__
- Technische Abhängigkeiten sowie benötigte Ressourcen wurden identifiziert.
- Betroffene Komponenten wie Frontend, Backend, Datenbank oder Cloud-Infrastruktur sind bekannt.
- Risiken, mögliche Blocker oder offene technische Fragen wurden analysiert.
- Falls erforderlich, wurden Vorbereitungen für Infrastruktur, Container oder CI/CD vorgenommen.

__Planbarkeit:__
- Die User Story kann innerhalb eines Sprints realistisch umgesetzt werden.
- Grössere Aufgaben wurden in Subtasks aufgeteilt.
- Story Points wurden anhand der Fibonacci-Folge geschätzt.
- Die Priorisierung der Story wurde festgelegt.
- Die Story wurde im Sprint Planning besprochen und freigegeben.

Die Definition of Ready gilt einheitlich für sämtliche User Stories des Projekts und wird nicht individuell pro Story angepasst.

## 3.3 Definition of Done (DoD)

Die Definition of Done (DoD) beschreibt die Kriterien, welche erfüllt sein müssen, damit eine User Story als vollständig abgeschlossen gilt. Ziel der DoD ist es, eine einheitliche Qualitätssicherung für Entwicklung, Testing, Dokumentation und Deployment sicherzustellen.

__Umsetzung der Anforderungen:__
- Alle definierten Akzeptanzkriterien wurden vollständig umgesetzt.
- Die Funktionalität erfüllt den vorgesehenen fachlichen oder technischen Zweck.
- Der Code wurde erfolgreich implementiert und getestet.

__Validierung und Qualitätssicherung:__
- Funktionale Tests oder manuelle Überprüfungen wurden durchgeführt.
- Fehler oder technische Probleme wurden analysiert und behoben.
- Falls relevant, wurden Container, APIs oder Cloud-Ressourcen erfolgreich getestet.
- Die Lösung funktioniert innerhalb der vorgesehenen Entwicklungs- oder Cloud-Umgebung.

__Dokumentation und Nachvollziehbarkeit:__
- Wichtige technische Entscheidungen sowie Umsetzungsschritte wurden dokumentiert.
- Änderungen im GitLab-Repository sind nachvollziehbar versioniert.
- Die zugehörigen Commits und Merge Requests[^16] sind mit Jira verknüpft.
- Relevante Anpassungen an Infrastruktur oder Deployment-Prozessen wurden dokumentiert.

__Integration und Abschluss:__
- Die User Story wurde erfolgreich in das Gesamtprojekt integriert.
- Falls relevant, wurde die CI/CD-Pipeline erfolgreich durchlaufen.
- Die Story wurde im Sprint Review präsentiert und akzeptiert.
- Der Status der Story wurde in Jira auf Done gesetzt.

Im Jira-Projekt ist eine Automation Rule hinterlegt, welche beim Erstellen neuer User Stories automatisch die wichtigsten DoD-Kriterien ergänzt. Dadurch wird sichergestellt, dass sämtliche Stories nach denselben Qualitätsstandards umgesetzt und überprüft werden.

## 3.4 Projektsprints und Releases

### 3.4.2 Sprint 1 – MVP Release

__Sprint Planning:__

**Zeitplan:**
11.05.2026 – 31.05.2026

**Beschreibung:**
Der erste produktive Sprint dient der Umsetzung eines Minimum Viable Product (MVP) der Escape-Room-Plattform. Im Rahmen dieses Sprints werden die grundlegende Plattformarchitektur definiert, die Basisstruktur der Anwendung aufgebaut sowie ein erster spielbarer Escape Room entwickelt. Die erarbeiteten Komponenten bilden die technische Grundlage für die Weiterentwicklung der Plattform in den folgenden Sprints. Nach Vollendung des Sprints steht ein funktionaler Prototyp mit ersten Interaktionsmöglichkeiten zur Verfügung.

**Meilenstein:** MVP mit grundlegender Plattformarchitektur und erstem spielbaren Escape Room umgesetzt.

__Sprint Review:__

**Status:**
Der Sprint wurde erfolgreich abgeschlossen. Der definierte Meilenstein wurde erreicht und sämtliche geplanten User Stories konnten innerhalb des vorgesehenen Zeitraums umgesetzt werden.

**Übersicht des Backlogs:**
Die folgenden Aufgaben wurden innerhalb des Sprints geplant, bearbeitet und erfolgreich abgeschlossen:

* [S3M-6, Define project structure and architecture](https://marlon-burri.atlassian.net/browse/S3M-6)✅-DONE
* [S3M-12, Define CI/CD pipeline concept](https://marlon-burri.atlassian.net/browse/S3M-12)✅-DONE
* [S3M-13, Basic Frontend UI](https://marlon-burri.atlassian.net/browse/S3M-13)✅-DONE
* [S3M-14, Game State Management](https://marlon-burri.atlassian.net/browse/S3M-14)✅-DONE
* [S3M-15, Tutorial Escape Room](https://marlon-burri.atlassian.net/browse/S3M-15)✅-DONE
* [S3M-16, Interaction System](https://marlon-burri.atlassian.net/browse/S3M-16)✅-DONE
* [S3M-17, Feedback System](https://marlon-burri.atlassian.net/browse/S3M-17)✅-DONE
* [S3M-19, Define Project Documentation](https://marlon-burri.atlassian.net/browse/S3M-19)✅-DONE

**Risikoverlauf:**

Die nachfolgende Tabelle zeigt den Stand aller Risiken aus der initialen Risikoanalyse am Ende von Sprint 1.

| Risiko-ID | Beschreibung | Score vorher | Score nachher | Status | Bemerkung |
|-----------|--------------|:------------:|:-------------:|:------:|-----------|
| R1 | Hohe Komplexität der Architektur erschwert die Umsetzung und Fehlersuche | 🔴 16 | 🟠 12 | ↓ | MVP erfolgreich umgesetzt; schrittweise Umsetzungsstrategie bewährt sich. Eintrittswahrscheinlichkeit sinkt von 4 auf 3. |
| R2 | Zeitlicher Aufwand überschreitet den verfügbaren Rahmen der Semesterarbeit | 🔴 16 | 🔴 16 | → | Sprint-Ziele erreicht, jedoch hat das Erkunden von GitLab-Plattform-Features mehr Zeit gekostet als geplant. Risiko bleibt unverändert hoch. |
| R3 | Fehler oder Probleme in GitLab CI/CD Pipelines verhindern automatisierte Deployments | 🟠 12 | 🟡 8 | ↓ | Frühe Pipeline-Checks für `terraform validate`, `terraform fmt -check` und `tflint`[^17] wurden eingeführt. Merge-Request-Pipelines laufen automatisiert und reduzieren Integrationsfehler frühzeitig. |
| R4 | Probleme bei der Integration von Microsoft Entra ID und Authentifizierung | 🟠 12 | 🟠 12 | → | Entra-ID-Absicherung der Anwendung war in Sprint 1 noch nicht umgesetzt. Die produktive Azure-OIDC-Anbindung für Deployments wurde später über ein environment-basiertes Federated Credential realisiert. |
| R5 | Fehlerhafte Infrastrukturdefinitionen in OpenTofu führen zu fehlerhaften Deployments | 🟡 9 | 🟡 6 | ↓ | `tflint` und `terraform validate` sind früh in der Pipeline verankert. Die eigentliche produktive Infrastruktur wurde zu diesem Zeitpunkt noch nicht ausgerollt. |

__Sprint Retrospective:__

Für die Retrospektive habe ich wie im vergangenen Semester die Mad, Sad, Glad Methode auf einem Miro-Board angewendet. Sie erlaubt eine kompakte, ehrliche Einschätzung des Sprints aus drei verschiedenen Blickwinkeln.

![Sprint1Retro](./img/sprint1retro.png)
*Screenshot vom Miro Board für die Retrospektive des Sprint 1.*

**Lessons Learned:**

- **GitLab Managed Terraform State von Anfang an nutzen:** Der Self-managed Remote State[^18] im Azure Storage Account hat den Bootstrap-Code unnötig vergrössert. Mit dem GitLab-integrierten Backend wäre der Bootstrap etwa halb so gross – und die Pipeline-Konfiguration für State-Locking deutlich einfacher.
- **OIDC-Vertrauensmodell früh festlegen:** Für produktive Azure-Deployments hat sich ein klares, environment-basiertes Federated Credential als robuster erwiesen als späte Nacharbeiten an der Pipeline-Authentifizierung.
- **Plattform-Features gezielt einführen, nicht explorativ:** GitLab bietet viele nützliche Features (Pages, Releases, Cleanup Policies). Die explorative Herangehensweise hat jedoch deutlich mehr Zeit gekostet als geplant. In zukünftigen Sprints werden Platform-Features als explizite User Stories geplant, damit der Aufwand sichtbar und steuerbar bleibt.
- **Frühe Pipeline-Checks zahlen sich aus:** `terraform validate`, `terraform fmt -check`, `tflint`, `checkov`, `pip-audit` und später Trivy liefern früh Rückmeldung und verhindern, dass Infrastruktur- oder Dependency-Probleme erst beim Azure-Deploy sichtbar werden.


### 3.4.3 Sprint 2 – MLP Release

__Sprint Planning:__

**Zeitplan:**
01.06.2026 – 21.06.2026

**Beschreibung:**
Der zweite Sprint führt das bestehende MVP in Richtung Minimum Lovable Product (MLP) weiter. Im Fokus stehen die Containerisierung der Anwendungskomponenten, der Aufbau der Azure-Zielumgebung mit OpenTofu, die Integration in die bestehende Landing Zone sowie eine durchgängige GitLab-CI/CD-Pipeline für Build, Deployment, Routing und Observability. Ziel ist eine belastbare Delivery-Kette, mit der die Plattform reproduzierbar in der Cloud betrieben und schrittweise erweitert werden kann.

**Meilenstein:** Erstes Ende-zu-Ende-Deployment der containerisierten Plattform nach Azure mit OpenTofu, GitLab CI/CD, OIDC-Authentifizierung, Monitoring & Logging sowie funktionierendem Routing über das zentrale Application Gateway[^19] umgesetzt.

__Sprint Review:__

**Status:**
Der Sprint wurde erfolgreich abgeschlossen. Der definierte Meilenstein wurde erreicht und die zentralen technischen Grundlagen für den produktiven Cloud-Betrieb wurden umgesetzt. Der Integrationsaufwand in der Landing Zone sowie die Fehlersuche rund um Routing und OIDC waren höher als ursprünglich erwartet, konnten im Sprint jedoch gelöst werden.

**Übersicht des Backlogs:**
Die folgenden Aufgaben wurden innerhalb des Sprints geplant, bearbeitet und erfolgreich abgeschlossen:

* [S3M-20, Monitoring & Logging](https://marlon-burri.atlassian.net/browse/S3M-20)✅-DONE
* [S3M-21, Azure Infrastructure Deployment](https://marlon-burri.atlassian.net/browse/S3M-21)✅-DONE
* [S3M-22, OpenTofu Infrastructure as Code](https://marlon-burri.atlassian.net/browse/S3M-22)✅-DONE
* [S3M-23, Frontend Containerization](https://marlon-burri.atlassian.net/browse/S3M-23)✅-DONE
* [S3M-24, Azure Container Registry Integration](https://marlon-burri.atlassian.net/browse/S3M-24)[^20]✅-DONE
* [S3M-25, GitLab CI/CD Implementation](https://marlon-burri.atlassian.net/browse/S3M-25)✅-DONE
* [S3M-26, Frontend Deployment to Azure](https://marlon-burri.atlassian.net/browse/S3M-26)✅-DONE
* [S3M-27, Azure Landing Zone Integration](https://marlon-burri.atlassian.net/browse/S3M-27)✅-DONE

**Risikoverlauf:**

Die nachfolgende Tabelle zeigt den Stand aller Risiken aus der initialen Risikoanalyse am Ende von Sprint 2.

| Risiko-ID | Beschreibung | Score vorher | Score nachher | Status | Bemerkung |
|-----------|--------------|:------------:|:-------------:|:------:|-----------|
| R1 | Hohe Komplexität der Architektur erschwert die Umsetzung und Fehlersuche | 🟠 12 | 🟡 8 | ↓ | Mit Container Apps, Private DNS und Application Gateway wurde die Zielarchitektur erfolgreich integriert und erstmals produktiv deployed. Die Komplexität bleibt relevant, ist durch die validierte Zielumgebung und die gewonnenen Betriebskenntnisse jedoch spürbar besser beherrschbar. |
| R2 | Zeitlicher Aufwand überschreitet den verfügbaren Rahmen der Semesterarbeit | 🔴 16 | 🟠 12 | ↓ | Der Aufwand für Landing-Zone-Integration, OIDC-Debugging und externe Abhängigkeiten war zwar hoch, durch das erfolgreiche Deployment der Umgebung wurden jedoch wesentliche Unsicherheiten abgebaut. Die verbleibende Umsetzung bleibt zeitlich anspruchsvoll, ist nun aber besser planbar als zu Sprintbeginn. |
| R3 | Fehler oder Probleme in GitLab CI/CD Pipelines verhindern automatisierte Deployments | 🟡 8 | 🟢 4 | ↓ | Die GitLab-Pipeline deckt nun Linting, Build, Deploy und Image-Promotion ab. Durch das eigene CI/CD-Image und regelmässige End-to-End-Deployments sinkt die Eintrittswahrscheinlichkeit von 2 auf 1. |
| R4 | Probleme bei der Integration von Microsoft Entra ID und Authentifizierung | 🟠 12 | 🟡 8 | ↓ | Die Azure-Authentifizierung der Pipeline via OIDC und Federated Credentials funktioniert produktiv. Die applikationsseitige Entra-ID-Absicherung des Frontends bleibt für Sprint 3 bestehen. |
| R5 | Fehlerhafte Infrastrukturdefinitionen in OpenTofu führen zu fehlerhaften Deployments | 🟡 6 | 🟢 4 | ↓ | Die Infrastruktur wurde erfolgreich mit OpenTofu in Azure ausgerollt. Reale Deployments haben Konfigurationsfehler bei Routing und DNS sichtbar gemacht und bereinigt, wodurch das Restrisiko weiter sinkt. |

__Sprint Retrospective:__

Für die Retrospektive habe ich erneut die Mad, Sad, Glad Methode auf einem Miro-Board angewendet. Sie hat sich bereits im vorherigen Sprint bewährt und erlaubt eine strukturierte Reflexion über technische Fortschritte, Blocker und persönliche Rahmenbedingungen.

![Sprint2Retro](./img/sprint2retro.png)
*Screenshot vom Miro-Board für die Retrospektive des Sprint 2.*

**Lessons Learned:**

- **Application Gateway und DNS frühzeitig vollständig planen:** Die Fehlersuche rund um das Application Gateway entstand durch einen fehlenden Backend-Hostname sowie einen nicht konfigurierten internen DNS-Eintrag. Netzwerk- und Routing-Anforderungen sollten bereits vor dem ersten Deployment vollständig dokumentiert und validiert werden.
- **Landing-Zone-Integrationen benötigen grosszügige Zeitreserven:** Die technische Integration in die bestehende Azure-Landing-Zone war deutlich komplexer als erwartet. Künftige Sprintplanungen sollten für bestehende Governance-, Netzwerk- und Sicherheitsvorgaben zusätzliche Pufferzeiten berücksichtigen.
- **Federated Credentials früh validieren:** Das Debugging der GitLab-OIDC-Anbindung zeigte, dass bereits kleine Abweichungen im Subject-Matching dazu führen können, dass Azure keine passende Federated Identity[^21] findet. Die Authentifizierung sollte deshalb möglichst früh im Projekt validiert werden, bevor weitere Pipeline-Komponenten aufgebaut werden.
- **Branch-Strategie und OIDC-Design gemeinsam betrachten:** Die Einschränkungen beim Subject-Matching haben gezeigt, dass CI/CD-Architektur und Branching-Konzept eng zusammenhängen. Namenskonventionen und Federated-Credential-Regeln sollten bereits in der Designphase aufeinander abgestimmt werden.
- **Eigene CI/CD-Images können langfristig Aufwand reduzieren:** Da kein geeignetes öffentliches Image mit Azure CLI und Docker CLI verfügbar war, wurde ein eigenes CI/CD-Image erstellt. Obwohl dies initial Mehraufwand verursacht, vereinfacht es die Pipeline-Konfiguration und sorgt für reproduzierbare Build-Umgebungen.
- **End-to-End-Deployments decken Infrastrukturprobleme zuverlässig auf:** Viele der identifizierten Probleme wurden erst während vollständiger Deployments sichtbar. Regelmässige End-to-End-Tests helfen dabei, Integrationsfehler frühzeitig zu erkennen und die Fehlersuche einzugrenzen.
- **Containerisierung vereinfacht den Betrieb erheblich:** Die erfolgreiche Containerisierung von Frontend und Backend hat die Grundlage für konsistente Deployments geschaffen. Unterschiede zwischen Entwicklungs- und Zielumgebung konnten dadurch deutlich reduziert werden.
- **Sprintplanung sollte auch persönliche Faktoren berücksichtigen:** Begrenzte Verfügbarkeit durch private Termine und das Sommerwetter hatten einen spürbaren Einfluss auf die Produktivität. Eine realistische Kapazitätsplanung verbessert die Vorhersagbarkeit zukünftiger Sprints.


### 3.4.4 Sprint 3   – MMP Release

__Sprint Planning:__

**Zeitplan:**
22.06.2026 – 06.07.2026

**Beschreibung:**
Der dritte produktive Sprint dient der Fertigstellung des Projekts in Richtung Minimum Marketable Product (MMP). Aufbauend auf der in Sprint 2 erfolgreich deployten Azure-Umgebung liegt der Schwerpunkt auf der Absicherung des Frontends mit Microsoft Entra ID inklusive gruppenbasiertem Zugriff, der weiteren Automatisierung des Betriebs über GitLab-Pipelines sowie auf Testing, Bugfixing und technischer Härtung der Gesamtlösung. Parallel dazu werden die Projektdokumentation finalisiert und die Inhalte für die Schlusspräsentation vorbereitet.

**Meilenstein:** Einsatzfähige und dokumentierte MMP-Version der Escape-Room-Plattform mit Entra-ID-geschütztem Frontend, stabilen End-to-End-Deployments, abgeschlossenen Tests sowie finalisierter Dokumentation und Präsentationsgrundlage umgesetzt.

__Sprint Review:__

**Status:**
Sprint 3 läuft noch bis 06.07.2026. Die folgenden User Stories wurden bisher abgeschlossen.

**Abgeschlossene User Stories:**

* Entra ID App Registration (Bootstrap-Modul `entra_auth`): App Registration, Service Principal, Client Secret, Redirect URI und Implicit Grant für EasyAuth konfiguriert.
* EasyAuth auf der Frontend Container App (`infra/modules/aca_auth`): ACA Built-in Authentication via `authConfigs/current` Sub-Ressource aktiviert; unauthentifizierte Requests werden automatisch auf die Microsoft-Loginseite weitergeleitet.
* AGW Health Probe[^22]: Eigene Health Probe (`/healthz`) konfiguriert, damit der Application Gateway das Frontend nach Aktivierung von EasyAuth weiterhin als gesund einzustufen vermag.
* Projektdokumentation: ADR-009[^23] (EasyAuth auf ACA), `identity-and-access.md`, `deploy.md` und README aktualisiert.

**Offene User Stories (geplant bis 06.07.2026):**

* Deployment des AGW Header-Rewrite (X-Forwarded-Host) im Contoso Connectivity-Repository für korrekten OAuth2-Callback.
* App Roles (`Escape.Player`, `Escape.Admin`) für gruppenbasierte Autorisierung.
* Entra-Variablen in die GitLab-Pipeline integrieren (Protected Variables `TF_VAR_entra_client_id` und `TF_VAR_entra_client_secret`).

**Risikoverlauf Sprint 3 (Zwischenstand):**

| Risiko-ID | Beschreibung | Score vorher | Score nachher | Status | Bemerkung |
|-----------|--------------|:------------:|:-------------:|:------:|-----------|
| R1 | Hohe Komplexität der Architektur erschwert die Umsetzung und Fehlersuche | 🟡 8 | 🟡 6 | ↓ | EasyAuth-Integration erforderte tiefes Verständnis der ACA-API-Struktur und des AGW-Proxy-Verhaltens. Beide Probleme sind analysiert und gelöst. |
| R2 | Zeitlicher Aufwand überschreitet den verfügbaren Rahmen der Semesterarbeit | 🟠 12 | 🟠 10 | ↓ | Die AGW-Header-Rewrite-Abhängigkeit verlangsamt den Abschluss der Authentifizierung. Risiko sinkt, da eine klare technische Lösung vorliegt. |
| R3 | Fehler oder Probleme in GitLab CI/CD Pipelines verhindern automatisierte Deployments | 🟢 4 | 🟢 4 | → | Keine Änderungen in diesem Bereich. |
| R4 | Probleme bei der Integration von Microsoft Entra ID und Authentifizierung | 🟡 8 | 🟡 6 | ↓ | EasyAuth ist aktiv und der Login funktioniert. Ausstehend: AGW Rewrite Rule für korrekten OAuth2-Callback-Host. |
| R5 | Fehlerhafte Infrastrukturdefinitionen in OpenTofu führen zu fehlerhaften Deployments | 🟢 4 | 🟢 4 | → | Keine neuen Infrastrukturprobleme in Sprint 3. |

__Sprint Retrospective:__

Der Sprint ist noch in Gange (Abschluss 06.07.2026). Die Retrospektive wird nach Sprintende auf einem Miro-Board nachgeführt und hier ergänzt.

__Lessons Learned:__

- **ACA EasyAuth benötigt eine eigene API-Ressource:** EasyAuth auf ACA wird über den ARM-Sub-Ressourcentyp `Microsoft.App/containerApps/authConfigs/current` konfiguriert. Der `azurerm_container_app`-Provider stellt diese Ressource nicht bereit und setzt bei jedem Deployment (`PUT`) alle Auth-Einstellungen zurück. Die Lösung besteht darin, EasyAuth mit dem `azure/azapi`-Provider zu verwalten und in der `azurerm_container_app`-Ressource ein `lifecycle { ignore_changes = [secret] }` zu setzen.
- **AGW überschreibt den `Host`-Header — EasyAuth baut daraus die OAuth2-Redirect-URI:** Das Contoso Application Gateway setzt den `Host`-Header im Backend-Request auf den internen ACA-FQDN. EasyAuth konstruiert daraus die `redirect_uri` für Entra ID — und dieser interne FQDN ist im Browser nicht erreichbar. Die korrekte Lösung ist eine AGW Rewrite Rule, die den Header `X-Forwarded-Host: escape.contoso.example` injiziert, kombiniert mit `forwardProxy.convention = "Standard"` in der EasyAuth-Konfiguration. Das ist ein bekanntes Muster für Reverse-Proxy-Szenarien, das in der Dokumentation jedoch kaum beschrieben wird.
- **AGW sendet `X-Original-Host` nicht automatisch:** Entgegen einiger Dokumentationsquellen fügt Azure AGW v2 den Header `X-Original-Host` **nicht** automatisch hinzu. Automatisch injiziert werden ausschliesslich `X-Forwarded-For`, `X-Forwarded-Proto` und `X-Forwarded-Port`.
- **Health Probe und EasyAuth müssen koordiniert werden:** Sobald EasyAuth aktiv ist, gibt der Endpunkt `/` für nicht-authentifizierte AGW-Health-Probes HTTP 302 zurück. Der AGW bewertet den Backend-Pool als unhealthy und liefert für alle User 502. Lösung: `/healthz` von der EasyAuth-Prüfung ausschliessen (`excludedPaths`) und die AGW Health Probe auf diesen Pfad umleiten.

---

# 4 Lösungsdesign

Zu Beginn des Projekts wurden die grundlegenden Rahmenbedingungen für die technische Umsetzung definiert. Dabei standen insbesondere die Engineering-Prinzipien, das Delivery-Modell sowie die Zielarchitektur in Azure im Fokus. Ziel ist eine wartbare, sichere und erweiterbare Plattform, welche die Entwicklung und den Betrieb mehrerer Escape-Room-Szenarien unterstützt.

## 4.1 Arbeitsweise und Engineering-Prinzipien

Die Umsetzung folgt einem Engineering-Ansatz, bei dem Infrastruktur, Anwendungscode und Deployment als integriertes Gesamtsystem betrachtet werden. Änderungen sollen reproduzierbar, nachvollziehbar und mit minimalem manuellem Aufwand ausgerollt werden können.

Daraus ergeben sich folgende Grundprinzipien:

- **Infrastructure as Code (IaC):** Sämtliche Azure-Ressourcen werden deklarativ beschrieben, versioniert und automatisiert bereitgestellt.
- **Automation First:** Nach der initialen Einrichtung erfolgen Änderungen ausschliesslich über definierte CI/CD-Prozesse anstelle manueller Anpassungen im Azure-Portal.
- **Security by Design:** Die Authentifizierung gegenüber Azure-Diensten erfolgt über Managed Identities[^24] und Microsoft Entra ID. Dadurch können statische Zugangsdaten vermieden und Sicherheitsrisiken reduziert werden.

Diese Prinzipien stellen sicher, dass Änderungen nachvollziehbar bleiben, Deployments konsistent durchgeführt werden und der Betriebsaufwand auch bei wachsendem Projektumfang beherrschbar bleibt.

## 4.2 Lösungsdesign in Azure

Das Azure-Design trennt bewusst zwischen einer stabilen Plattform und fachlich wechselnden Escape-Room-Inhalten. Shared Services werden zentral bereitgestellt, während einzelne Themes unabhängig erweitert und ausgerollt werden können. Dadurch bleibt die Basis stabil, auch wenn sich der fachliche Inhalt regelmässig verändert.

Vor dem regulären Betrieb ist ein einmaliger Bootstrap notwendig. Dabei werden das Terraform State Backend und die Identität für die Authentifizierung gegenüber Azure vorbereitet. Danach laufen alle weiteren Änderungen automatisiert über den definierten CI/CD-Workflow.

| Ebene | Rolle im Lösungsdesign |
|---|---|
| **Bootstrap** | Schafft die technischen Voraussetzungen für automatisierte Deployments |
| **Plattform-Stack**[^25] | Enthält die gemeinsame Azure-Basis wie Netzwerk, Security, Persistenz und zentrale Plattformdienste |
| **Theme-Stack** | Kapselt einen einzelnen Escape Room mit seinen themenspezifischen Ressourcen |

Entscheidend ist, dass Theme-Stacks nur definierte Outputs des Plattform-Stacks verwenden, diesen aber nicht verändern. Dadurch lassen sich neue Inhalte ergänzen, ohne die Gesamtarchitektur oder bestehende Deployments zu destabilisieren.

### 4.2.1 Big Picture

Das Big Picture zeigt in erster Linie, wie die Lösung in Azure aufgebaut ist. Im Fokus stehen die zentralen Plattformkomponenten, ihre Abhängigkeiten sowie der eingehende und ausgehende Traffic Flow zwischen den beteiligten Services. Damit macht die Darstellung sichtbar, über welche Entry Points Requests in die Plattform gelangen, wie sie intern weitergeleitet werden und welche Komponenten für ausgehende Kommunikation zuständig sind.

Im Zentrum steht der Plattform-Stack als gemeinsame Basis. Er bündelt die wiederverwendbaren Foundation-Services, auf die die einzelnen Escape-Room-Themes aufbauen. Die Theme-Stacks ergänzen darauf ihre eigenen Workloads, ohne die gemeinsame Basis zu verändern. Dadurch entsteht eine modulare Architektur mit klaren Verantwortlichkeiten, sauber getrennten Zuständigkeiten und einem nachvollziehbaren Routing- und Security-Modell.

![Architecture](data/Big_Picture.png)
*Big Picture der Azure-Zielarchitektur inklusive Ingress- und Egress-Flow*

### 4.2.2 Delivery-Flow

```mermaid
flowchart LR
  DEV[Entwickler<br/>git push]

  subgraph GL[GitLab CI/CD]
    direction TB
    PPIPE[Plattform-Pipeline]
    TPIPE[Theme-Pipeline]
  end

  OIDC[OIDC-Föderation<br/>Azure-Identität]

  PSTACK[Plattform-Stack]
  TSTACK[Theme-Stack]

  DEV --> PPIPE
  DEV --> TPIPE
  PPIPE --> OIDC
  TPIPE --> OIDC
  OIDC --> PSTACK
  OIDC --> TSTACK
  PSTACK -. definierte Outputs .-> TSTACK
```

## 4.3 Gitflow und Delivery-Modell

Für die tägliche Arbeit wird ein schlankes Gitflow-Modell eingesetzt. `main` bleibt jederzeit in einem stabilen und releasefähigen Zustand. Neue Features, Fixes und Hotfixes werden isoliert in eigenen Branches umgesetzt und erst nach Review integriert.

```
main
 ├── feature/<beschreibung>
 ├── fix/<beschreibung>
 └── hotfix/<beschreibung>
```

Der Merge nach `main` erfolgt ausschliesslich über Merge Requests. So bleibt jede Änderung nachvollziehbar und durchläuft vor der Integration die definierten Quality Gates. Die Pipeline fungiert dabei als technisches Merge-Gate und prüft Codequalität, Security, Build-Fähigkeit und geplante Infrastrukturänderungen, bevor ein Merge oder Deployment möglich ist.

Releases werden zusätzlich über Tags markiert, damit wichtige Projektstände wie MVP, MLP und MMP eindeutig referenzierbar bleiben. Das unterstützt einen klaren Release-Stand, kontrollierte Integration und eine saubere Nachvollziehbarkeit über den gesamten Lifecycle.

---

# 5 Umsetzung

Dieses Kapitel beschreibt die technische Umsetzung der deployte Plattformarchitektur. Im Fokus stehen die konkreten Implementierungsentscheide, ihre Begründung und das Zusammenspiel der beteiligten Komponenten. Die Darstellung folgt dem natürlichen Ablauf: vom einmaligen Bootstrap über die Infrastrukturbereitstellung und die CI/CD-Pipeline bis hin zum Routing und der Netzwerkanbindung.

## 5.1 Erstmaliges Deployment (Bootstrap)

Der Bootstrap-Prozess löst ein strukturelles Henne-Ei-Problem, das bei vollständig codegetriebenen CI/CD-Setups mit Remote-State unvermeidbar auftritt: Die GitLab-Pipeline benötigt für das Deployment via OIDC eine Managed Identity sowie ein Remote-State-Backend in Azure — beides existiert jedoch erst nach einem erstmaligen, manuell ausgelösten Deployment.

Die Lösung besteht in einem einmaligen, lokal ausgeführten `terraform apply` des Bootstrap-Stacks[^26] (`bootstrap/`). Dieser Stack ist bewusst vom automatisierten Pipeline-Prozess entkoppelt und wird ausschliesslich von einem Admin-Account (mit Entra-ID-Berechtigungen) ausgeführt. Er erstellt ausschliesslich die folgenden Infrastrukturgrundlagen:

| Ressource | Zweck |
|---|---|
| Azure Storage Account `sttfstatescape` | Remote-Backend für alle Terraform-State-Dateien |
| User-Assigned Managed Identity `mi-maker-escape` | OIDC-Identität für die GitLab CI/CD-Pipeline |
| OIDC Federated Identity Credential | Verknüpft GitLab-Jobs des Environments `production` mit der Azure-Identität |
| Entra ID App Registration `cloud-escape-lab` | Identität für die Frontend-Authentifizierung via EasyAuth |
| Service Principal + Client Secret | Credential für die EasyAuth-Konfiguration auf der Container App |

Der Bootstrap-Stack ist intern in drei Module gegliedert:

| Modul | Enthaltene Ressourcen |
|---|---|
| `state_backend` | Resource Group, Storage Account, Blob Container, User RBAC auf Storage |
| `maker_identity` | Managed Identity, Federated Credential, Rolle Contributor + UAA auf Subscription, Storage Blob Data Contributor |
| `entra_auth` | App Registration, Service Principal, Client Secret, Owner-Zuweisungen |

Nach erfolgreichem Bootstrap stehen zwei Outputs zur Verfügung: `entra_client_id` und `entra_client_secret`. Diese werden lokal in `infra/secrets.auto.tfvars` (gitignored) eingetragen und in der GitLab-Pipeline als Protected Variables (`TF_VAR_entra_client_id`, `TF_VAR_entra_client_secret`) hinterlegt. Ab diesem Zeitpunkt übernimmt der automatisierte CI/CD-Prozess alle weiteren Infrastrukturveränderungen.

### Kaltstart der Container Images

Ein zweites strukturelles Problem ergibt sich beim allerersten `terraform apply` des Platform-Stacks: Azure Container Apps referenzieren bei ihrer Erstellung ein Container-Image aus der ACR, das zu diesem Zeitpunkt noch nicht existiert. Terraform bricht den Vorgang in diesem Fall ab, da die referenzierte Ressource nicht auflösbar ist.

Um diesen Kaltstart zu ermöglichen, werden die Container-Images für Frontend und Backend einmalig manuell gebaut und in die ACR gepusht, bevor das IaC zum ersten Mal ausgeführt wird. Dafür wird `az acr build` eingesetzt, das den Build-Vorgang direkt in der Azure Cloud-Umgebung ausführt — eine lokale Container-Runtime ist nicht erforderlich:

```bash
az acr build --registry acrlabprodescape --image frontend:bootstrap ./frontend/
az acr build --registry acrlabprodescape --image backend:bootstrap ./backend/
```

Nach diesem einmaligen Schritt werden Images ausschliesslich über die GitLab-Pipeline erstellt und mit einem Commit-SHA als Tag versioniert. Das `bootstrap`-Tag dient ausschliesslich als Platzhalter für die Erstkonfiguration.

### Übergang zum automatisierten Betrieb

Der Bootstrap gliedert sich in drei klar abgegrenzte Phasen:

| Phase | Ausführung | Inhalt |
|---|---|---|
| 1 – Bootstrap | Lokal, einmalig (Admin-Account) | `bootstrap/` terraform apply — erstellt State-Backend, OIDC-Identität und Entra App Registration. Outputs (`entra_client_id`, `entra_client_secret`) in `infra/secrets.auto.tfvars` und als GitLab Protected Variables hinterlegen. |
| 2 – Kaltstart | Lokal, einmalig | Initiale Container-Images in ACR pushen, danach `infra/` terraform apply |
| 3 – Automatisierter Betrieb | GitLab CI/CD, dauerhaft | Lint / Plan → manueller Terraform-Apply → Image Build & Scan → manueller Image-Deploy |

Mit Abschluss von Phase 2 läuft der Delivery-Prozess reproduzierbar über GitLab, produktive Infrastruktur- und Image-Rollouts bleiben derzeit jedoch bewusst manuell freizugeben.

## 5.2 Infrastructure as Code mit OpenTofu

Die gesamte Azure-Infrastruktur wird deklarativ mit OpenTofu beschrieben, das zur Terraform-CLI kompatibel ist und unter einer freien Lizenz steht. Die Wahl von OpenTofu gegenüber dem proprietären Terraform CLI folgt dem Open-Source-First-Prinzip und vermeidet Abhängigkeiten von lizenzbezogenen Einschränkungen.

### State-Trennung

Der Infrastrukturcode ist im aktuell implementierten Stand in zwei getrennte Zuständigkeiten aufgeteilt:

```
bootstrap/   → lokaler Terraform-State             (lokal, einmalig, Admin-Account)
infra/       → key: infrastructure.tfstate         (Remote-State in Azure Blob Storage)
```

Der Bootstrap-Stack erstellt die Voraussetzungen für OIDC, Remote-State und Frontend-Authentifizierung und wird lokal mit einem Admin-Account ausgeführt. Die Entra-Credentials (`entra_client_id`, `entra_client_secret`) werden als Output bereitgestellt und dem `infra/`-Stack als Variablen übergeben — lokal via `secrets.auto.tfvars`, in der Pipeline via GitLab Protected Variables. Der produktiv genutzte Plattform-Stack `infra/` verwaltet anschliessend die laufende Azure-Umgebung. Ein separater Theme-Stack ist architektonisch vorgesehen, im Repository aktuell aber noch nicht umgesetzt.

### Modulstruktur des Platform-Stacks

Der Platform-Stack (`infra/`) ist in klar abgegrenzte Terraform-Module gegliedert:

| Modul | Enthaltene Ressourcen |
|---|---|
| `network` | Subnets `snet-aca` (delegiert an `Microsoft.App/environments`) und `snet-pe` |
| `acr` | Azure Container Registry (`acrlabprodescape`, Basic SKU) |
| `aca_env` | Container App Environment[^27] `cae-lab-prod-escape` (internal LB, VNet-integriert) |
| `aca_app` | Container App Instanzen für Frontend und Backend |
| `aca_auth` | EasyAuth-Konfiguration auf der Frontend Container App (Entra ID, Redirect zu Login, Audience-Validierung) |

Jedes Modul exponiert ausschliesslich die Outputs, die von anderen Modulen oder von der Pipeline benötigt werden. Intern bleibt die Implementierung gekapselt, sodass einzelne Module refaktoriert werden können, ohne State-Abhängigkeiten zu gefährden.

### Deployte Azure-Ressourcen

Die folgende Übersicht zeigt den aktuell deployte Plattformzustand:

| Ressource | Name | Kenndaten |
|---|---|---|
| Container App Environment | `cae-lab-prod-escape` | Internal LB, `internal = true`, statische IP `10.20.18.156` |
| Container App (Frontend) | `ca-lab-prod-escape-frontend` | Target Port 8000, Transport HTTP, System-Assigned MI, min 1 / max 3 Replicas |
| Container App (Backend) | `ca-lab-prod-escape-backend` | Target Port 5001, Transport HTTP, System-Assigned MI, min 1 / max 1 Replica |
| Container Registry | `acrlabprodescape` | Basic SKU, Image Pull via System-Assigned MI |
| Log Analytics Workspace | `law-lab-prod-escape` | Retention 30 Tage |
| Private DNS Zone[^28] | `examplepebble-00000000.northeurope.azurecontainerapps.io` | A-Records `@` und `*` → `10.20.18.156`, VNet-linked |
| Subnet ACA | `snet-aca`, `10.20.18.128/27` | Delegiert an `Microsoft.App/environments` |
| Subnet PE | `snet-pe`, `10.20.18.192/27` | Für zukünftige Private Endpoints |

Die Private DNS Zone wird von OpenTofu automatisch beim Erstellen des Container App Environments ausgelesen und im Spoke-VNet verankert. Die A-Records `@` und `*` zeigen beide auf die statische IP des internen Load Balancers, sodass alle Container App FQDNs innerhalb des VNets auflösbar sind.

## 5.3 CI/CD-Pipeline

Die GitLab CI/CD-Pipeline automatisiert den gesamten Delivery-Prozess vom Code-Commit bis zum produktiven Deployment in Azure.

### Pipelinestruktur

Aktuell existiert eine GitLab-Pipeline mit unterschiedlichem Verhalten für Merge Requests und `main`:

| Stage | Inhalt |
|---|---|
| Merge Request | `terraform fmt -check`, `terraform validate`, `tflint`, `checkov` sowie `pip-audit` für Frontend und Backend |
| `main` - Plan | automatisches `terraform plan` für `infra/` |
| `main` - Apply | manueller `terraform apply` für Infrastrukturänderungen |
| `main` - Build | Docker Build und Push von Frontend- und Backend-Images mit Commit-SHA-Tag plus `latest` |
| `main` - Image Scan | Trivy-Scan der frisch publizierten Images |
| `main` - Deploy | manueller `terraform apply` mit `frontend_image_tag` und `backend_image_tag` zur Revision-Aktualisierung der Container Apps |

Das abschliessende Deploy aktualisiert ausschliesslich die Image-Tag-Referenz. Container App Revisions in Azure werden dabei automatisch erstellt, da jede Image-Tag-Änderung eine neue Revision auslöst.

### Passwortlose Authentifizierung via OIDC

Die Pipeline authentifiziert sich gegenüber Azure über OpenID Connect (OIDC) ohne statische Credentials. Für jede Pipeline-Ausführung stellt GitLab ein kurzlebiges OIDC-Token aus. Die Managed Identity `mi-maker-escape` vertraut dabei auf das Subject `project_path:<your-gitlab-group>/cloud-escape-lab:environment:production`. Azure-Zugriff ist damit auf die GitLab-Jobs beschränkt, die explizit im Environment `production` laufen.

Die MR-Lint-Jobs benötigen keinen Azure-Login. Azure-authentifizierte Schritte werden erst auf `main` aktiv, wenn ein Job das produktive GitLab-Environment verwendet.

### Quality Gates als technisches Merge-Gate

Die Quality-Stage auf Merge Requests prüft aktuell vor allem Terraform-Syntax und grundlegende Sicherheits-/Abhängigkeitsbefunde. Verbindlich ausgeführt werden `terraform fmt -check` und `terraform validate`; `tflint`, `checkov` und `pip-audit` liefern zusätzliche Hinweise, sind im momentanen Stand jedoch als `allow_failure` beziehungsweise `soft-fail` konfiguriert. Dockerfile-spezifische Linter wie `hadolint` oder Python-Linting via `ruff` sind im aktuellen Pipeline-Code nicht enthalten.

## 5.4 Öffentlicher Zugriff, DNS und Routing

### Architektonische Einordnung

Der öffentliche Zugriff auf die Plattform erfolgt ausschliesslich über den zentralen Application Gateway WAFv2 in der Hub-Subscription der Contoso. Dieses Hub-and-Spoke-Modell hat drei direkte Auswirkungen auf das Projekt:

- **Governance:** TLS-Zertifikate, WAF[^29]-Policies und Firewall-Regeln werden von Contoso zentral verwaltet. Das Projekt muss diese Aspekte nicht selbst betreiben.
- **Security:** Die WAF mit OWASP CRS schützt vor häufigen Angriffsvektoren, ohne eine eigene WAF-Konfiguration im Spoke zu erfordern.
- **Einschränkung:** Das Projekt hat keinen direkten schreibenden Zugriff auf die Application-Gateway-Konfiguration. Neue Routing-Einträge werden einmalig pro Theme via Change Request an Contoso beantragt.

### DNS-Konfiguration

Der Hostname `escape.contoso.example` ist im Contoso-internen DNS als CNAME-Eintrag auf `contoso-appgw-prod.northeurope.cloudapp.azure.com` hinterlegt. Dieser Schritt liegt ausserhalb der automatisierten Infrastruktur und wurde einmalig über ein Change Request an Contoso vorgenommen.

### TLS-Terminierung und internes Routing

Das Application Gateway terminiert TLS am Edge mit dem zentral verwalteten Wildcard-Zertifikat `*.contoso.example`. Die Weiterleitung in den Spoke erfolgt im aktuellen Azure-Stand ebenfalls über **HTTPS auf Port 443**. Die Backend-Pools zeigen auf die internen Hostnamen `cel-frontend.internal.contoso.example` und `cel-backend.internal.contoso.example`; für den TLS-Handshake setzt das Application Gateway dabei den Host-Header auf die jeweiligen Container-App-FQDNs `ca-lab-prod-escape-frontend.examplepebble-00000000.northeurope.azurecontainerapps.io` bzw. `ca-lab-prod-escape-backend.examplepebble-00000000.northeurope.azurecontainerapps.io` und verwendet das Trusted Root Certificate `backend-trusted-root-ca`.

Das Application Gateway löst die Container App FQDNs über die Private DNS Zone im Spoke auf:

```
escape.contoso.example  →  CNAME  →  contoso-appgw-prod.northeurope.cloudapp.azure.com
  AppGW → Backend Pool `pool-escape-contoso-example`     → cel-frontend.internal.contoso.example
      TLS host override                                   → ca-lab-prod-escape-frontend.examplepebble-00000000.northeurope.azurecontainerapps.io
  AppGW → Backend Pool `pool-escape-contoso-example-pr0` → cel-backend.internal.contoso.example
      TLS host override                                   → ca-lab-prod-escape-backend.examplepebble-00000000.northeurope.azurecontainerapps.io
```

### Path-basiertes Routing[^30]

Auf dem Listener `escape.contoso.example:443` leitet das Application Gateway Anfragen anhand des URL-Pfads an die zuständige Container App weiter:

| URL-Pfad | Ziel | Backend |
|---|---|---|
| `/` und alle übrigen Pfade | Frontend Container App | `ca-lab-prod-escape-frontend`, HTTPS:443 via `pool-escape-contoso-example` |
| `/tutorial-room`, `/tutorial-room/*` | Backend Container App | `ca-lab-prod-escape-backend`, HTTPS:443 via `pool-escape-contoso-example-pr0` |

Die produktive Health-Probe des Application Gateways trifft auf `/tutorial-room/ping` der Backend Container App sowie auf `/healthz` der Frontend Container App. Der Pfad `/healthz` ist in der EasyAuth-Konfiguration als `excludedPath` hinterlegt und liefert ohne Login-Anforderung `200 {"status":"ok"}` zurück.

Das Frontend ist mit Azure Container Apps Built-in Authentication (EasyAuth) über Microsoft Entra ID abgesichert: unauthentifizierte Requests werden automatisch auf die Microsoft-Loginseite weitergeleitet. Nur Benutzer des Contoso-Tenants können sich anmelden; die Audience-Validierung (`api://<client_id>`) stellt sicher, dass ausschliesslich Tokens für diese Applikation akzeptiert werden. Technische Details zur EasyAuth-Implementierung und zur Proxy-Konfiguration sind in [Abschnitt 5.6](#56-entra-id-easyauth-auf-aca) und in [ADR-009](./docs/decisions/adr-009-easyauth-on-aca-behind-agw.md) beschrieben.

## 5.6 Entra ID EasyAuth auf ACA

### Überblick

Die Frontend Container App `ca-lab-prod-escape-frontend` ist mit **Azure Container Apps Built-in Authentication (EasyAuth v2)** abgesichert. Die Konfiguration erfolgt vollständig über Infrastructure as Code im Modul `infra/modules/aca_auth`.

### Warum `azapi_resource` statt `azurerm_container_app`

EasyAuth auf ACA wird über den ARM-Sub-Ressourcentyp `Microsoft.App/containerApps/authConfigs/current` konfiguriert — **nicht** über den Hauptresourcentyp `azurerm_container_app`. Die Gründe:

- Der `hashicorp/azurerm`-Provider stellt `authConfigs/current` nicht bereit.
- Jeder `PUT`-Request des Providers (ausgelöst bei jeder Infrastrukturänderung oder neuem Image) setzt die EasyAuth-Einstellungen zurück.

Das Modul `aca_auth` verwendet daher den `azure/azapi`-Provider:

| Terraform-Ressource | Zweck |
|---|---|
| `azapi_resource.auth_config` | Erstellt / aktualisiert `authConfigs/current` |
| `azapi_update_resource.app_secret` | Patcht das AAD-Client-Secret in die Secrets-Liste der Container App, ohne andere Felder zu überschreiben |
| `terraform_data.revision_trigger` + `replace_triggered_by` | Erzwingt bei jeder neuen ACA-Revision eine Neuanwendung von EasyAuth (da eine neue Revision technisch eine neue Ressourcenversion ist) |

In der `azurerm_container_app`-Ressource ist zusätzlich `lifecycle { ignore_changes = [secret] }` gesetzt, damit Terraform die von EasyAuth verwalteten Secrets nicht beim nächsten Apply löscht.

### Problem: AGW überschreibt den `Host`-Header

Das Contoso Application Gateway setzt im Backend-Request den `Host`-Header auf den internen ACA-FQDN:

```
Host: ca-lab-prod-escape-frontend.examplepebble-00000000.northeurope.azurecontainerapps.io
```

EasyAuth konstruiert daraus die OAuth2-`redirect_uri`. Diese wird an Entra ID übergeben und im Browser als Callback-URL verwendet — der interne ACA-FQDN ist im Browser jedoch nicht erreichbar. Das Resultat ist ein Entra-Fehler `AADSTS50011` (Redirect-URI-Mismatch) oder `AADSTS900971` (fehlende Redirect-URI).

### Lösung: AGW Rewrite Rule + `forwardProxy`

Der Application Gateway injiziert via Rewrite Rule den Header `X-Forwarded-Host: escape.contoso.example` in alle Backend-Requests. EasyAuth liest diesen Header und baut die korrekte Redirect-URI:

```
https://escape.contoso.example/.auth/login/aad/callback
```

Konfiguriert wird das zweiseitig:

**EasyAuth (`infra/modules/aca_auth/main.tf`):**
```hcl
httpSettings = {
  forwardProxy = {
    convention = "Standard"   # liest X-Forwarded-Host
  }
}
```

**AGW Routing YAML (`contoso-connectivity/envs/prod/routing/cloud-escape-lab.yaml`):**
```yaml
inject_request_headers:
  X-Forwarded-Host: escape.contoso.example
```

Die `inject_request_headers`-Funktion ist ein neues Feature des AGW-Moduls in `contoso-connectivity/modules/app_gateway`, das im Rahmen dieses Projekts als Pull Request eingebracht wurde.

> **Hinweis:** Azure AGW v2 injiziert `X-Original-Host` **nicht** automatisch (entgegen einigen Dokumentationsquellen). Automatisch hinzugefügte Headers sind ausschliesslich `X-Forwarded-For`, `X-Forwarded-Proto` und `X-Forwarded-Port`.

### Health Probe Koordination

Sobald EasyAuth aktiv ist, liefert der Endpunkt `/` für nicht-authentifizierte Health-Probes HTTP 302 (Redirect zu Entra ID). Der AGW bewertet den Backend-Pool als unhealthy und antwortet allen Benutzern mit 502.

Lösung:

- EasyAuth: `globalValidation.excludedPaths = ["/healthz"]` — Anfragen an `/healthz` umgehen die Auth-Prüfung.
- AGW: `probe_path: /healthz` in der Routing-Konfiguration — die Health Probe trifft auf den unauthentifizierten Endpunkt.

### Entra App Registration

Die App Registration wird vom `bootstrap/modules/entra_auth`-Modul verwaltet:

| Eigenschaft | Wert |
|---|---|
| Application (Client) ID | `00000000-0000-0000-0000-000000000005` |
| Redirect URI | `https://escape.contoso.example/.auth/login/aad/callback` |
| Implicit Grant (`id_token`) | Aktiviert — erforderlich für den EasyAuth Hybrid Flow |
| Tenant | `00000000-0000-0000-0000-000000000001` |



## 5.5 Managed Identity und ACR-Zugriff

Beide Container Apps verwenden eine **System-Assigned Managed Identity**, über die sie Container-Images direkt aus der ACR beziehen. Die Managed Identity erhält auf der ACR die Rolle `AcrPull`, die ausschliesslich das Lesen und Pullen von Images erlaubt — keine Write-Rechte. Statische Zugangsdaten für die Registry sind damit vollständig eliminiert.

```
Container App (System MI)
  └─ AcrPull-Rollenzuweisung
       └─ acrlabprodescape.azurecr.io
            ├─ frontend:bootstrap  (Kaltstart)
            └─ frontend:<sha>      (CI/CD-Betrieb)
```

Dieses Muster gilt identisch für die Backend Container App. Die Rollenzuweisungen werden durch OpenTofu als `azurerm_role_assignment`-Ressourcen verwaltet und sind damit reproduzierbar und auditierbar.

---

# 6 Testverfahren

Dieses Kapitel beschreibt das Testkonzept für das Cloud Escape Lab. Im Fokus stehen **nicht** die Rätsel-Inhalte des Tutorial Rooms selbst, sondern die **Plattform**, die diese Räume betreibt. Die Tests werden direkt gegen die produktive URL **https://escape.contoso.example/** durchgeführt, um die tatsächliche Produktionsreife der Plattform zu belegen.

**Abgrenzung:** Der Tutorial Room (`frontend/app/templates/tutorial.html`, `backend/app/rooms/tutorial/` inkl. Rätsel-Logik) wurde **inhaltlich nicht gross erweitert oder verändert**. Er basiert auf dem Template [`ma-room-template`](https://gitlab.com/solvista/ma-room-template) meines Dozenten Fachdozent (siehe [`NOTICE`](./NOTICE)). Die eigentliche Rätsel-Logik ist daher nicht Gegenstand dieses Testverfahrens, sie dient lediglich als Inhalt, um die selbst entwickelte Plattform (Routing, Auth, IaC, CI/CD etc.) ende-zu-ende zu testen.

**ℹ️ Hinweis:** In GitLab kann es vorkommen, dass GIFs nicht korrekt angezeigt werden oder pausiert wirken. Bitte die Seite neu laden oder alternativ einen anderen Browser verwenden.

&nbsp;

```mermaid
flowchart TD
    A[Definition der Testfälle] --> B[Vorbereitung: Browser + Testaccount + Produktivumgebung]
    B --> C[Manuelle Ausführung gegen https://escape.contoso.example/]
    C --> D{Test erfolgreich?}
    D -->|Ja| E[Screenshot/GIF + Dokumentation ergänzen]
    D -->|Nein| F[Fehleranalyse + Dokumentation]
```

&nbsp;

### Umgesetzte Änderungen im Rahmen von S3M-31

Im Zuge der End-to-End-Testvorbereitung wurden zusätzlich mehrere Anpassungen an der Plattform umgesetzt, damit die Benutzerführung sauber getestet und später auf mehrere Escape Rooms erweitert werden kann:

- **Startseite als Room-Katalog:** Die bisherige Startseite mit einem einzelnen Button wurde auf ein kartenbasiertes Room-Auswahl-Layout umgestellt. Der Tutorial Room wird als erste spielbare Karte mit Vorschaubild angezeigt; zusätzliche Platzhalter für einen **Terraform Room** und einen **CI/CD Room** bereiten die Plattform auf weitere Szenarien vor.
- **Grössere Tutorial-Room-Ansicht:** Das Frontend des Tutorial Rooms wurde so angepasst, dass das Hintergrundbild deutlich grösser dargestellt wird und die Spieloberfläche mehr Platz erhält. Dadurch wirkt der Room stärker wie eine eigentliche Spielfläche und ist ohne die bisherigen kleinen Scroll-Bereiche nutzbarer.
- **Bugfix beim Exit Terminal:** Das Eingabefeld für den vierstelligen Code wird nun sprachunabhängig über die stabile Objekt-ID statt über einen lokalisierten Anzeigenamen eingeblendet. Damit funktioniert die Code-Eingabe sowohl lokal als auch in der Azure-Deployment-Variante zuverlässig.
- **Leaderboard für Abschlusszeiten:** Für den Tutorial Room wurde ein Leaderboard eingeführt, das die gemessene Abschlusszeit pro Benutzer speichert und im Startbereich des Rooms als Top-10-Liste anzeigt. Die Anzeige der eigenen Zeit erfolgt zusätzlich direkt nach dem erfolgreichen Abschluss des Rooms.
- **Persistenz-Hinweis zum Leaderboard:** Das Leaderboard ist fachlich für einen produktiven Betrieb gedacht und soll Zeiten über mehrere Deployments hinweg behalten. Damit dies in Azure dauerhaft funktioniert, muss das Backend über `DATABASE_URI` auf eine **externe Datenbank** (z. B. PostgreSQL) zeigen; eine reine lokale SQLite-Datei im Container wäre für diese Anforderung nicht ausreichend.

&nbsp;

## 6.1 Testfälle

| Testfall 1 | Öffentliche Erreichbarkeit & TLS-Zertifikat |
|------------------------|----------------------------------------------------------------------------------------------------------------------------------|
| Voraussetzungen        | - Browser mit Netzwerkzugriff auf das Internet<br>- Keine VPN-/Contoso-Netz-Pflicht, da Zugriff über das öffentliche Application Gateway erfolgt |
| Erwartetes Ergebnis    | `https://escape.contoso.example/` ist öffentlich erreichbar. Der Browser zeigt ein gültiges TLS-Zertifikat für `*.contoso.example` (Contoso-verwaltetes Wildcard-Zertifikat am Application Gateway, vgl. Abschnitt 5.4), keine Zertifikatswarnung. |
| Testablauf             | 1. `https://escape.contoso.example/` im Browser aufrufen<br>2. Zertifikatsdetails prüfen (Aussteller, Gültigkeit, Domain)<br>3. Sicherstellen, dass kein „Nicht sicher“-Hinweis erscheint |
| Effektives Ergebnis    | `https://escape.contoso.example/` war öffentlich erreichbar. Der Browser zeigt ein gültiges TLS-Zertifikat für `*.contoso.example` an, keine Zertifikatswarnung wurde angezeigt. Ergebnis entspricht dem erwarteten Verhalten. |
| Screenshot / Logfiles | ![Testcase1](img/testcase1.gif)<br>*TLS-Zertifikatsdetails im Browser* |
| Problemstellungen      | Keine. |
| Testergebnis           | ✅ Erfolgreich |

&nbsp;

| Testfall 2 | Erzwungene Authentifizierung ohne aktive Session (EasyAuth-Redirect) |
|------------------------|----------------------------------------------------------------------------------------------------------------------------------|
| Voraussetzungen        | - Browser ohne bestehende Session auf `escape.contoso.example` (z. B. privates/Inkognito-Fenster) |
| Erwartetes Ergebnis    | Aufruf von `/` ohne aktive Session führt zu einem automatischen Redirect auf die Microsoft-Login-Seite (`login.microsoftonline.com`). Kein Seiteninhalt wird ohne Login ausgeliefert (vgl. Abschnitt 5.6, EasyAuth v2). |
| Testablauf             | 1. Inkognito-Fenster öffnen<br>2. `https://escape.contoso.example/` aufrufen<br>3. Weiterleitung auf Microsoft-Login beobachten<br>4. Sicherstellen, dass keine Inhalte der Startseite sichtbar werden |
| Effektives Ergebnis    | Der Aufruf von `/` ohne aktive Session führte zu einem automatischen Redirect auf die Microsoft-Login-Seite (`login.microsoftonline.com`). Es wurde kein Seiteninhalt ohne Login ausgeliefert. Ergebnis entspricht dem erwarteten Verhalten. |
| Screenshot / Logfiles | ![Testcase2](img/testcase2.gif)<br>*automatischer Redirect zu Microsoft-Login* |
| Problemstellungen      | Keine. |
| Testergebnis           | ✅ Erfolgreich |

&nbsp;

| Testfall 3 | Erfolgreicher Login via Microsoft Entra ID (Contoso-Tenant) |
|------------------------|----------------------------------------------------------------------------------------------------------------------------------|
| Voraussetzungen        | - Gültiger Contoso-Account (Mitglied des Tenants `00000000-0000-0000-0000-000000000001`) |
| Erwartetes Ergebnis    | Nach Login mit einem Contoso-Account erfolgt der Redirect zurück auf `https://escape.contoso.example/.auth/login/aad/callback` und anschliessend auf die Startseite. Der Nutzer sieht die Plattform-Startseite, die Session bleibt für Folge-Requests bestehen (Cookie). |
| Testablauf             | 1. Auf der Microsoft-Login-Seite mit Contoso-Account anmelden<br>2. Redirect-Kette beobachten (Callback-URL, finale Landing-Page)<br>3. Seite neu laden und prüfen, dass kein erneuter Login nötig ist (Session-Cookie aktiv) |
| Effektives Ergebnis    | Nach Login mit einem Contoso-Account erfolgte der Redirect zurück auf `https://escape.contoso.example/.auth/login/aad/callback` und anschliessend auf die Startseite. Die Session blieb für Folge-Requests bestehen (Cookie), ein erneutes Laden der Seite erforderte keinen erneuten Login. Ergebnis entspricht dem erwarteten Verhalten. |
| Screenshot / Logfiles | ![Testcase3](img/testcase3.gif)<br>*erfolgreicher Login und Landing-Page* |
| Problemstellungen      | Keine. |
| Testergebnis           | ✅ Erfolgreich |

&nbsp;

| Testfall 4 | Health-Probe-Pfade bleiben ohne Login erreichbar |
|------------------------|----------------------------------------------------------------------------------------------------------------------------------|
| Voraussetzungen        | - Browser/REST-Client ohne aktive Session |
| Erwartetes Ergebnis    | `https://escape.contoso.example/healthz` (Frontend) liefert ohne Login HTTP 200 `{"status":"ok"}`, da als `excludedPath` in der EasyAuth-Konfiguration hinterlegt (vgl. Abschnitt 5.4/5.6). Dies ist Voraussetzung dafür, dass das Application Gateway den Backend-Pool als „healthy“ einstuft. |
| Testablauf             | 1. Inkognito-Fenster/REST-Client ohne Session verwenden<br>2. `GET https://escape.contoso.example/healthz` aufrufen<br>3. Statuscode und Payload prüfen (kein Redirect zu Microsoft-Login) |
| Effektives Ergebnis    | `GET https://escape.contoso.example/healthz` lieferte ohne aktive Session HTTP 200 mit `{"status":"ok"}`, ohne Redirect zum Microsoft-Login. Der `excludedPath` in der EasyAuth-Konfiguration funktioniert wie vorgesehen. Ergebnis entspricht dem erwarteten Verhalten. |
| Screenshot / Logfiles | ![Testcase4](img/testcase4.gif)<br>*`/healthz` ohne Login, HTTP 200* |
| Problemstellungen      | Keine. |
| Testergebnis           | ✅ Erfolgreich |

&nbsp;

| Testfall 5 | Path-basiertes Routing über das Application Gateway |
|------------------------|----------------------------------------------------------------------------------------------------------------------------------|
| Voraussetzungen        | - Aktive, eingeloggte Session auf `escape.contoso.example` |
| Erwartetes Ergebnis    | Anfragen an `/` (und übrige Pfade) werden an die Frontend Container App weitergeleitet, Anfragen an `/tutorial-room` bzw. `/tutorial-room/*` an die Backend Container App (vgl. Routing-Tabelle in Abschnitt 5.4). Beide sind über denselben Hostnamen erreichbar, liefern aber erkennbar unterschiedliche Inhalte/Antworten (Frontend-HTML vs. Backend-JSON-API). |
| Testablauf             | 1. `https://escape.contoso.example/` aufrufen → Frontend-Seite prüfen<br>2. `https://escape.contoso.example/tutorial-room/ping` aufrufen → Backend-JSON-Antwort prüfen<br>3. Entwicklertools/Netzwerk-Tab auf Antwort-Header (z. B. Server/Content-Type) vergleichen |
| Effektives Ergebnis    | Anfragen an `/` wurden an die Frontend Container App weitergeleitet, Anfragen an `/tutorial-room/*` an die Backend Container App. Beide waren über denselben Hostnamen erreichbar und lieferten erkennbar unterschiedliche Inhalte (Frontend-HTML vs. Backend-JSON-API). Ergebnis entspricht dem erwarteten Verhalten. |
| Screenshot / Logfiles | ![Testcase5](img/testcase5.gif)<br>*Frontend- vs. Backend-Antwort über denselben Host* |
| Problemstellungen      | Keine. |
| Testergebnis           | ✅ Erfolgreich |

&nbsp;

| Testfall 6 | WAF-Schutz des zentralen Contoso Application Gateways |
|------------------------|----------------------------------------------------------------------------------------------------------------------------------|
| Voraussetzungen        | - Aktive Session<br>- Zugriff auf ein Formularfeld oder einen Query-Parameter der Plattform |
| Erwartetes Ergebnis    | Ein einfacher, offensichtlich schädlicher Payload (z. B. `<script>alert(1)</script>` oder `' OR 1=1 --` als Query-Parameter) wird von der OWASP-CRS-WAF am Application Gateway blockiert (HTTP 403), bevor er die Plattform erreicht (vgl. Abschnitt 5.4, zentrale WAFv2). |
| Testablauf             | 1. URL mit angehängtem Test-Payload aufrufen, z. B. `https://escape.contoso.example/?q=<script>alert(1)</script>`<br>2. Statuscode der Antwort prüfen<br>3. Sicherstellen, dass kein Payload-Reflect in der Antwort enthalten ist |
| Effektives Ergebnis    | Der Test-Payload (`<script>alert(1)</script>` als Query-Parameter) wurde von der OWASP-CRS-WAF am zentralen Application Gateway mit HTTP 403 blockiert, bevor er die Plattform erreichte. Kein Payload-Reflect in der Antwort feststellbar. Ergebnis entspricht dem erwarteten Verhalten. |
| Screenshot / Logfiles | ![Testcase6](img/testcase6.gif)<br>*WAF-Blockierung (403) im Netzwerk-Tab* |
| Problemstellungen      | Keine. |
| Testergebnis           | ✅ Erfolgreich |

&nbsp;

| Testfall 7 | End-to-End Test: Tutorial Room laden und starten |
|------------------------|----------------------------------------------------------------------------------------------------------------------------------|
| Voraussetzungen        | - Eingeloggte Session<br>- Tutorial Room über `/tutorial` im Frontend erreichbar |
| Erwartetes Ergebnis    | Die Plattform liefert den Tutorial Room korrekt aus. Seite lädt, Spiel kann gestartet werden, erste Interaktion (Lichtschalter) funktioniert. **Es wird bewusst keine Tiefenprüfung der Rätsel-Logik durchgeführt**, da diese aus dem Template [`ma-room-template`](https://gitlab.com/solvista/ma-room-template) stammt. Dieser Test ist ein reiner Integrations-Test der Plattform, nicht ein Test des Rätsel-Inhalts. |
| Testablauf             | 1. `https://escape.contoso.example/tutorial` aufrufen<br>2. **Start Game** klicken<br>3. Prüfen, dass der Raumzustand geladen wird und der Lichtschalter sichtbar ist<br>4. Eine einzelne Interaktion (Lichtschalter) auslösen und Reaktion prüfen |
| Effektives Ergebnis    | Der Tutorial Room wurde in der Azure-Umgebung korrekt geladen. Nach Klick auf **Start Game** erschien die Spielansicht unmittelbar, der Raumzustand wurde korrekt initialisiert und der Lichtschalter konnte erfolgreich verwendet werden. |
| Screenshot / Logfiles | ![Testcase7](img/testcase7.gif)<br>*Platzhalter: Tutorial Room lädt und startet in Produktion* |
| Problemstellungen      | Keine. |
| Testergebnis           | ✅ Erfolgreich |

&nbsp;

| Testfall 8 | Vollständiger Benutzerfluss bis zum erfolgreichen Abschluss |
|------------------------|----------------------------------------------------------------------------------------------------------------------------------|
| Voraussetzungen        | - Eingeloggte Session<br>- Tutorial Room gestartet |
| Erwartetes Ergebnis    | Der Benutzer kann den Tutorial Room vollständig durchspielen und am Ende erscheint der Erfolgsbanner. Damit ist der komplette Benutzerfluss vom Start bis zum Abschluss in der Plattform validiert. |
| Testablauf             | 1. **Light Switch** auswählen und **Interact** klicken<br>2. **Professor's Desk** auswählen und **Examine** klicken<br>3. Im Dropdown **Office Key** wählen und mit dem Schreibtisch **Interact** ausführen<br>4. **Research Journal** auswählen und **Examine** klicken<br>5. **Exit Terminal** auswählen, den Code eingeben und **Interact** klicken |
| Effektives Ergebnis    | Der vollständige Benutzerfluss konnte ohne Unterbruch durchgespielt werden. Alle vorgesehenen Interaktionen funktionierten, der 4-stellige Code konnte eingegeben werden und am Ende wurde der Erfolgsbanner wie erwartet angezeigt. |
| Screenshot / Logfiles | ![Testcase8](img/testcase8.gif)<br>*Platzhalter: vollständiger Durchlauf bis zum Win-Banner* |
| Problemstellungen      | Keine. |
| Testergebnis           | ✅ Erfolgreich |

&nbsp;

| Testfall 9 | Spiel zurücksetzen und Ausgangszustand prüfen |
|------------------------|----------------------------------------------------------------------------------------------------------------------------------|
| Voraussetzungen        | - Eingeloggte Session<br>- Tutorial Room gestartet<br>- Mindestens eine Interaktion wurde bereits ausgeführt |
| Erwartetes Ergebnis    | Nach Klick auf **Reset** wird der Room auf den Anfangszustand zurückgesetzt. Bereits freigeschaltete Objekte verschwinden wieder und der Benutzer sieht erneut nur den initialen Einstieg des Rooms. |
| Testablauf             | 1. Spiel starten und mindestens den **Light Switch** betätigen<br>2. Prüfen, dass zusätzliche Objekte sichtbar wurden<br>3. **Reset** klicken<br>4. Prüfen, dass der initiale Zustand wiederhergestellt wurde |
| Effektives Ergebnis    | Nach dem Reset wurde der Tutorial Room erfolgreich auf den Ausgangszustand zurückgesetzt. Bereits freigeschaltete Objekte waren nicht mehr sichtbar und der initiale Startzustand des Rooms wurde korrekt wiederhergestellt. |
| Screenshot / Logfiles | ![Testcase9](img/testcase9.gif)<br>*Platzhalter: Fortschritt wird per Reset auf Anfang zurückgesetzt* |
| Problemstellungen      | Keine. |
| Testergebnis           | ✅ Erfolgreich |

&nbsp;

| Testfall 10 | Runtime beenden, löschen und neu starten |
|------------------------|----------------------------------------------------------------------------------------------------------------------------------|
| Voraussetzungen        | - Eingeloggte Session<br>- Tutorial Room gestartet |
| Erwartetes Ergebnis    | Sowohl **Stop Room** als auch **Delete Room** beenden die aktuelle Runtime sichtbar im Frontend. Anschliessend kann mit **Start Game** wieder ein neuer, sauberer Room gestartet werden. |
| Testablauf             | 1. Spiel starten und mindestens eine Interaktion ausführen<br>2. **Stop Room** klicken und prüfen, dass wieder die Startansicht erscheint<br>3. Room erneut mit **Start Game** starten<br>4. Danach **Delete Room** klicken und erneut die Rückkehr zur Startansicht prüfen<br>5. Mit **Start Game** sicherstellen, dass ein frischer Room wieder gestartet werden kann |
| Effektives Ergebnis    | Sowohl **Stop Room** als auch **Delete Room** führten zuverlässig zurück auf die Startansicht. Anschliessend konnte der Tutorial Room jeweils erneut mit **Start Game** gestartet werden, wobei jedes Mal eine frische Runtime bereitstand. |
| Screenshot / Logfiles | ![Testcase10](img/testcase10.gif)<br>*Platzhalter: Stop/Delete der Runtime und erneuter sauberer Start* |
| Problemstellungen      | Keine. |
| Testergebnis           | ✅ Erfolgreich |

&nbsp;

## 6.2 Testresultat

**Testabschlussrate**: 4 von 4 Testfällen erfolgreich (100% Erfolgsquote)

Die durchgeführten Tests belegen, dass der End-to-End-Prozess des Tutorial Rooms technisch zuverlässig funktioniert. Der Benutzerfluss vom Laden der Seite über den Spielstart bis zum erfolgreichen Abschluss arbeitet stabil. Auch das Zurücksetzen des Spielzustands sowie das Stoppen, Löschen und erneute Starten der Runtime funktionieren wie erwartet in der produktionsnahen Azure-Umgebung.

&nbsp;

```mermaid
%%{init: {'theme': 'base', 'themeVariables': { 'pie1': '#90EE90', 'pie2': '#FFB6C6'}}}%%
pie title Testabschlussrate (4 Testfälle)
    "Erfolgreich (4)" : 100
    "Fehlgeschlagen (0)" : 0
```

__Erfolgreiche Testfälle:__

| # | Testfall | Beschreibung |
|---|----------|-------------|
| 7 | Tutorial Room laden und starten | Die Seite lädt korrekt, der Room startet erfolgreich und erste Interaktionen funktionieren. |
| 8 | Vollständiger Benutzerfluss | Der Tutorial Room kann vollständig bis zum Erfolgsbanner durchgespielt werden. |
| 9 | Spiel zurücksetzen | Der Fortschritt wird korrekt verworfen und der initiale Zustand wiederhergestellt. |
| 10 | Runtime beenden und neu starten | Stop Room und Delete Room funktionieren, anschliessend lässt sich ein frischer Room erneut starten. |

__Kritische Befunde:__
Es wurden keine kritischen Fehler festgestellt.

__Fazit:__
Das System ist für den Tutorial Room funktionsfähig und stabil. Die zentralen End-to-End-Abläufe der Plattform bewähren sich in der Praxis, und die Anwendung unterstützt den vorgesehenen Benutzerfluss in der Azure-Umgebung zuverlässig.

&nbsp;

---

# 7 Projektabschluss

## 7.1 Abschliessende Risikobilanz

## 7.2 Technisches Fazit

## 7.3 Persönliches Fazit

## 7.4 Mögliche Weiterentwicklung

---

# 8 Schlusswort

## 8.1 Quellenverzeichnis

* Microsoft Copilot (2026, Mai 03). *Prompt: Erstelle ein Titelbild für einen Escape-Room-Proof-of-Concept auf Azure.* Microsoft Copilot: https://copilot.microsoft.com/
* GitLab-Repository *solvista/ma-room-template* (2026, April 28). *Escape-Room-Vorlage*: https://gitlab.com/solvista/ma-room-template
* REST API Tutorial (2026, Mai 04). *RESTful API Design*: https://restfulapi.net/
* Pallets Projects (2026, Mai 11). *Flask Documentation*: https://flask.palletsprojects.com/
* APIFlask Contributors (2026, Mai 11). *APIFlask Documentation*: https://apiflask.com/
* Pallets Projects (2026, Mai 12). *Flask-SQLAlchemy – Quickstart*: https://flask-sqlalchemy.palletsprojects.com/
* SQLite Consortium (2026, Mai 12). *SQLite Documentation*: https://www.sqlite.org/
* PyJWT Maintainers (2026, Mai 18). *PyJWT Documentation*: https://pyjwt.readthedocs.io/
* jwt.io (2026, Mai 18). *Introduction to JSON Web Tokens*: https://jwt.io/introduction
* Flask-CORS Maintainers (2026, Mai 19). *Flask-CORS Documentation*: https://flask-cors.readthedocs.io/
* Pallets Projects (2026, Mai 25). *Jinja2 Template Designer Documentation*: https://jinja.palletsprojects.com/
* Google Fonts (2026, Mai 26). *Google Icons for UI*: https://fonts.google.com/icons
* Microsoft (2026, Mai 27). *Fluent 2 Design System Color*: https://fluent2.microsoft.design/color
* Tailwind Labs (2026, Mai 28). *Tailwind CSS – Customizing Colors*: https://tailwindcss.com/docs/customizing-colors
* MDN Web Docs (2026, Mai 28). *Using CSS custom properties*: https://developer.mozilla.org/en-US/docs/Web/CSS/Using_CSS_custom_properties
* web.dev (2026, Mai 29). *prefers-color-scheme / color-scheme*: https://web.dev/articles/color-scheme
* OpenTofu Contributors (2026, Juni 01). *OpenTofu Documentation*: https://opentofu.org/
* Azure / HashiCorp (2026, Juni 02). *azapi Terraform Provider Documentation*: https://registry.terraform.io/providers/Azure/azapi/latest/docs
* Microsoft Learn (2026, Juni 03). *Authenticate to Azure using OIDC and Terraform*: https://learn.microsoft.com/en-us/azure/developer/terraform/authenticate-to-azure
* Microsoft Learn (2026, Juni 04). *Authentication and authorization in Azure Container Apps*: https://learn.microsoft.com/en-us/azure/container-apps/authentication
* Microsoft Learn (2026, Juni 08). *Azure Container Registry Documentation*: https://learn.microsoft.com/en-us/azure/container-registry/
* Microsoft Learn (2026, Juni 09): *Managed identities for Azure resources*. https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview
* Microsoft Learn (2026, Juni 10): *Azure RBAC best practices*. https://learn.microsoft.com/en-us/azure/role-based-access-control/best-practices
* Microsoft Learn (2026, Juni 15): *What is Azure Application Gateway?*. https://learn.microsoft.com/en-us/azure/application-gateway/overview
* Microsoft Learn (2026, Juni 16): *Azure Web Application Firewall on Application Gateway*. https://learn.microsoft.com/en-us/azure/web-application-firewall/ag/ag-overview
* GitLab (2026, Juni 22). *Connect to cloud services (OIDC)*: https://docs.gitlab.com/ee/ci/cloud_services/
* Bridgecrew / Prisma Cloud (2026, Juni 23). *Checkov Documentation*: https://www.checkov.io/
* Terraform Linters (2026, Juni 23). *TFLint Documentation*: https://github.com/terraform-linters/tflint
* Aqua Security (2026, Juni 24). *Trivy Documentation*: https://aquasecurity.github.io/trivy/
* Python Packaging Authority (2026, Juni 24). *pip-audit Documentation*: https://pypi.org/project/pip-audit/

## 8.2 Glossar

[^1]: **Microservice-Architektur:** Architekturstil, bei dem eine Anwendung aus mehreren unabhängig entwickel- und betreibbaren Diensten (z. B. Frontend, Backend, Room-API) besteht, die über definierte Schnittstellen kommunizieren.
[^2]: **CI/CD-Pipeline:** Automatisierter GitLab-Workflow, der Lint-, Plan-, Build-, Scan- und Deploy-Schritte bei jedem Commit bzw. Merge nach `main` ausführt.
[^3]: **Microsoft Entra ID:** Identity- und Access-Management-Dienst von Microsoft, der Benutzer, Gruppen und den Zugriff auf die Plattform verwaltet.
[^4]: **OIDC (OpenID Connect):** Authentifizierungsprotokoll, über das die GitLab-Pipeline sich mittels kurzlebiger Tokens gegenüber Azure authentifiziert, ohne statische Zugangsdaten zu speichern.
[^5]: **Azure Container Apps (ACA):** Vollständig verwalteter Serverless-Container-Dienst in Azure, auf dem Frontend und Backend dieses Projekts betrieben werden.
[^6]: **EasyAuth:** Built-in Authentication von Azure Container Apps (bzw. App Service), die unauthentifizierte Requests automatisch auf die Entra-ID-Login-Seite umleitet.
[^7]: **Infrastructure as Code (IaC):** Ansatz, bei dem Cloud-Infrastruktur deklarativ als Code beschrieben, versioniert und automatisiert bereitgestellt wird, statt manuell im Portal konfiguriert zu werden.
[^8]: **OpenTofu:** Zur Terraform-CLI kompatibles, quelloffenes IaC-Tool, mit dem die gesamte Azure-Infrastruktur dieses Projekts beschrieben wird.
[^9]: **Proof of Concept (POC):** Machbarkeitsnachweis, der zeigt, dass ein Konzept technisch umsetzbar ist, ohne bereits ein vollständig produktionsreifes Endprodukt zu sein.
[^10]: **CC BY-SA 4.0:** Creative-Commons-Lizenz „Namensnennung – Weitergabe unter gleichen Bedingungen“, unter der das `ma-room-template` (Basis des Tutorial Rooms) veröffentlicht wurde.
[^11]: **Jira:** Werkzeug zur Verwaltung von User Stories, Sprints und Projektfortschritt, das für das Projektmanagement dieser Arbeit eingesetzt wurde.
[^12]: **SCRUM:** Agile Projektmanagement-Methode mit iterativen Sprints, Reviews und Retrospektiven, nach der dieses Projekt organisiert wurde.
[^13]: **Sprint:** Fest definiertes Zeitfenster (hier 2–3 Wochen), in dem ein festgelegter Umfang an User Stories umgesetzt wird.
[^14]: **MVP / MLP / MMP:** Release-Stufen dieses Projekts: Minimum Viable Product (Sprint 1, Grundfunktionalität), Minimum Lovable Product (Sprint 2, erweiterte Interaktivität) und Minimum Marketable Product (Sprint 3, Produktionsreife).
[^15]: **Definition of Ready (DoR) / Definition of Done (DoD):** Vorab vereinbarte Kriterien, wann eine User Story bearbeitet werden darf (DoR) bzw. als abgeschlossen gilt (DoD).
[^16]: **Merge Request / Quality Gate:** Code-Review-Prozess in GitLab, bei dem definierte automatisierte Prüfungen (Terraform-Validierung, Sicherheits-Scans) vor einem Merge nach `main` bestehen müssen.
[^17]: **Trivy / Checkov / tflint / pip-audit:** In der Pipeline eingesetzte Tools zur Container-Image-Sicherheitsanalyse (Trivy), Terraform-Sicherheitsprüfung (Checkov), Terraform-Best-Practice-Linting (tflint) und Python-Abhängigkeitsprüfung auf bekannte CVEs (pip-audit).
[^18]: **Remote State / State-Backend:** Zentral in Azure Blob Storage abgelegter Terraform-Zustand, der Konflikte bei parallelen Änderungen verhindert und den aktuellen Infrastrukturstatus nachvollziehbar macht.
[^19]: **Application Gateway (AGW):** Zentraler, von der Contoso verwalteter Layer-7-Load-Balancer und Reverse Proxy, über den sämtlicher öffentlicher Zugriff auf die Plattform erfolgt.
[^20]: **Azure Container Registry (ACR):** Privates Registry für Container-Images, aus dem die Container Apps ihre Images über Managed Identity beziehen.
[^21]: **Federated Identity Credential:** Vertrauensbeziehung zwischen einer Managed Identity in Azure und einem definierten Subject (z. B. einem GitLab-Environment), die passwortlose Authentifizierung via OIDC ermöglicht.
[^22]: **Health Probe:** Regelmässiger Prüf-Request (z. B. auf `/healthz`), mit dem das Application Gateway die Verfügbarkeit eines Backend-Pools überwacht.
[^23]: **ADR (Architecture Decision Record):** Kurzdokument, das eine einzelne Architekturentscheidung inklusive Kontext, Alternativen und Konsequenzen festhält.
[^24]: **Managed Identity:** Von Azure verwaltete Identität (System- oder User-Assigned), über die eine Ressource ohne gespeicherte Zugangsdaten auf andere Azure-Dienste zugreifen kann.
[^25]: **Plattform-Stack / Theme-Stack:** Architektonische Trennung zwischen der gemeinsamen, stabilen Azure-Basis (Plattform-Stack, `infra/`) und den fachlich wechselnden Escape-Room-Inhalten (Theme-Stack).
[^26]: **Bootstrap-Stack:** Einmalig lokal ausgeführter Terraform-Stack (`bootstrap/`), der die Grundvoraussetzungen (State-Backend, OIDC-Identität, Entra App Registration) für den automatisierten Betrieb schafft.
[^27]: **Container App Environment:** Isolierte Laufzeitumgebung für mehrere Container Apps, inklusive internem Load Balancer und VNet-Integration.
[^28]: **Private DNS Zone:** Im Spoke-VNet verankerte DNS-Zone, über die interne Hostnamen der Container Apps aufgelöst werden.
[^29]: **WAF (Web Application Firewall):** Sicherheitskomponente am Application Gateway (WAFv2, OWASP CRS), die eingehenden Traffic auf bekannte Angriffsmuster prüft und blockiert.
[^30]: **Path-based Routing:** Routing-Mechanismus am Application Gateway, der Requests anhand des URL-Pfads (z. B. `/` vs. `/tutorial-room/*`) an unterschiedliche Backend-Dienste weiterleitet.
[^31]: **SQLite:** Dateibasierte, im Container-Filesystem gespeicherte Datenbank, in der aktuell die Spielzustände abgelegt werden (vgl. R-DATA-001 in `docs/risks-and-limitations.md`).
