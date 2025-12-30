# TrailQuest

## Video
https://youtu.be/ABbJbTuJaC4

## Description
TrailQuest is an offline iOS application that transforms a regular walk into a structured route-based quest with checkpoints and a recorded completion result. This format allows the app to be used not only for casual walks, but also as a foundation for more complex quest-based and event-driven scenarios.
The user selects a predefined route—such as a park or city walk—views checkpoints on a map, and completes them in any order by confirming their presence on site. Each checkpoint requires explicit validation, which makes the experience feel like a completed task rather than simple movement on a map.
After finishing a route, the user receives a summary of the results and can save the attempt to history or share it. The application is designed to be fully autonomous: routes are available offline, no registration or accounts are required, and all data is stored locally. This approach reduces friction on first launch and makes the app suitable for parks and tourist areas with unstable connectivity.
## Motivation and Problem Statement
Most walking and route-based applications either focus on fitness metrics or rely on rigid, predefined scenarios with a fixed order of points. In the first case, walks often lack structure and a clear sense of completion; in the second, users lose flexibility and the ability to adapt the experience to their preferences.
The core problem lies in balancing structure and freedom. Users benefit from having a goal and a clear outcome, but overly rigid scenarios turn routes into instructions rather than personal experiences.
TrailQuest addresses this problem through a checkpoint-based model without enforcing a strict order of completion. The route defines boundaries and a goal, while the user decides which checkpoints to visit and in what sequence. Each confirmed checkpoint creates a sense of progress, and completing the route provides a clear and memorable result.
This model is not limited to walking. It can be applied to events, team-based quests, sports orientation, or cultural routes. Walking routes serve as the most accessible and illustrative example of this broader concept.
## Target Audience
TrailQuest is designed for users who want a structured yet flexible route experience with a clear goal and a recorded result—without registration, server dependencies, or constant internet access.
Thanks to its universal checkpoint-based model, the application can be used in various scenarios:
- Individual and family walks, where structure helps turn a walk into a completed experience.
- Quests and events, including team activities and team-building scenarios.
- Sports use cases, such as orientation or running along predefined checkpoints.
- Cultural routes and excursions, where checkpoints can provide contextual information.
In all cases, TrailQuest targets users who value structure, engagement, and freedom of choice rather than rigid, predefined scenarios.
## Core Concept
At the core of TrailQuest is a universal route model composed of checkpoints that can be visited in any order. The route defines the goal and boundaries but does not enforce a fixed path.
Progress is determined by checkpoint validation rather than time or distance. Users decide how to move between checkpoints based on context, interest, or physical ability.
Once all checkpoints are confirmed, the route is considered complete and stored as a separate attempt. This approach creates a clear sense of completion and allows results to be reused for history or analysis. Although demonstrated through walking routes, the underlying concept remains activity-agnostic.
## User Flow
1. **First launch and onboarding**
	A short onboarding flow explains the core concept of the application.
2. **Route selection**
	The user selects a route from the catalog and views route details with a map and checkpoints.
3. **Route start**
	The route enters an active state and the main tracking screen is displayed.
4. **Route completion**
	The user freely chooses the order of checkpoint visits while monitoring progress, time, and distance.
5. **Checkpoint check-in**
	Each checkpoint is validated using a code, QR scan, or BLE-based check-in.
6. **Route completion confirmation**
	After all checkpoints are validated, the user manually finishes the route.
7. **Summary and persistence**
	A summary screen is shown and the attempt is saved to local history.
8. **Additional sections**
	The History tab allows viewing, deleting, and sharing results.
	The Profile tab provides local personalization options.
## Features
- Offline route catalog
- Detailed route previews with maps and checkpoints
- Active route mode with progress and timing
- Multiple checkpoint validation methods (code / QR / BLE)
- Explicit route completion
- Local history of completed routes
- Result sharing
- Local profile without registration
## Application Structure
The application is built around a tab-based interface with three main sections:
- Routes — route catalog and route initiation
- History — completed route management
- Profile — local personalization and data reset
Onboarding is shown only on first launch. The active route screen is presented on top of the tab interface for the duration of a route.
## Architecture and Code Organization
The project follows a lightweight MVVM approach tailored to an offline-first application.
The UI is implemented in SwiftUI and organized by screens and features. Screen logic is handled by ObservableObject view models, while data access and infrastructure are isolated in service layers (Source/Services/*). Shared styling and theming are injected through the SwiftUI Environment.
This structure provides clear separation of concerns while remaining simple and appropriate for the scale of the project.
The application is implemented as a Development Pod and hosted by a lightweight sandbox app, allowing the core logic, UI, resources, and localization to remain modular and reusable. This structure reflects a deliberate architectural choice aimed at clarity, separation of concerns, and ease of iteration.
## Data Management
All data in TrailQuest is stored locally and separated by responsibility:
- Route content — static parks.json file
- Completion history — CoreData with one-to-many relationships
- User profile — UserDefaults
- Temporary state — in-memory state during an active session
This design aligns with the offline concept and minimizes architectural complexity.
## Platform Integration
TrailQuest integrates with iOS system frameworks to interact with the real world:
- MapKit — route and checkpoint visualization
- CoreLocation — coordinates, distance calculation, and iBeacon ranging
- AVFoundation — QR code scanning
- CoreBluetooth — BLE-based check-ins
Permissions are requested contextually, only when a feature is used.
## Design Decisions
Key design decisions include:
- an offline-first approach without servers or accounts;
- a universal checkpoint-based route model;
- avoiding live GPS tracking in favor of reproducible results;
- a demo route that works without requesting permissions;
- storing completion history as an independent entity.
## Limitations
- static route content;
- no cross-device synchronization;
- distance is an estimate based on route points;
- check-ins depend on system permissions;
- no recovery of an active session after app restart;
- maps are used for visualization only, without navigation.
## Future Improvements
- managed route content updates;
- active session recovery;
- optional cross-device history synchronization;
- improved map-based navigation;
- extended route analytics and comparisons.
## Reflection
Working on TrailQuest allowed me to systematically address gaps in my computer science fundamentals while applying real-world mobile development experience. I have over four years of experience as an iOS developer in fintech, but I entered the field as a self-taught engineer without formal computer science education. Completing CS50x became an important step toward structuring my knowledge.
Over the past year, I have been actively studying SwiftUI, although my professional work still primarily relies on UIKit. TrailQuest became my first fully SwiftUI-based application and required a shift to declarative thinking, where UI is driven by state rather than imperative updates.
The most challenging part of the project was managing the active route as a cohesive flow. The tracking screen combines maps, timers, progress tracking, multiple check-in methods, permission handling, and result persistence. This required careful consideration of responsibility boundaries and architectural trade-offs.
The project was also an exercise in deliberate simplification. I intentionally avoided backend services, accounts, and live GPS tracking to focus on a clear offline-first experience. This allowed the project to reach a finished and coherent state without unnecessary complexity.
For me, TrailQuest represents more than a course assignment. It reflects a transition from fragmented practical knowledge toward a more structured engineering approach to system design and platform integration.
## Academic Honesty
AI assistance was used for routine refactoring tasks (such as standardizing Swift file headers), for helping identify and remove unused files, and for drafting documentation text. All architectural decisions, application logic, and final code changes were designed, reviewed, and implemented by me. No external collaborators or third-party code were used beyond standard platform frameworks.

## Testing

The project includes a focused set of unit tests covering the most critical and risk-prone parts of the application. The goal of the test suite is not full coverage, but validation of core domain logic, data integrity, and edge cases that could affect user experience or data consistency.

### Covered Areas

#### Route Loading and Parsing
**TQParksServiceTests**
- Successful parsing of route data from `parks_test.json`, including checkpoints and optional fields.
- Error handling when the JSON file is missing.
- Error handling for invalid or malformed JSON structure.

These tests ensure that route content loading is reliable and fails predictably in case of configuration issues.

#### Active Route Logic
**TrailDistanceCalculatorTests**
- Total distance calculation across all route segments.
- Distance calculation for partially completed routes.
- Edge cases where zero or one checkpoint results in zero distance.

This validates that distance values remain stable and deterministic without relying on live GPS tracking.

#### Data Formatting
**DurationMapperTests**
- Zero duration maps to a localized zero state.
- Negative time intervals are safely clamped to zero.
- Positive durations are formatted using a consistent `hh:mm:ss` representation.

These tests protect against incorrect or misleading time displays in route summaries.

#### Persistence Layer (CoreData)
**CoreDataCompetitionStoreTests**
- Creating and fetching records sorted by `startDate` (descending).
- Preventing duplicate records (`recordAlreadyExists`).
- Deleting individual records.
- Deleting all records.
- Attempting to delete a non-existent record returns `recordNotFound`.
- Change stream events are emitted correctly (`.created`, `.deleted`).

This suite verifies CoreData CRUD operations, error handling, and change notifications used by the UI.

### Summary

The current test set covers the primary functional risks of the application:
- route loading and parsing,
- distance calculation,
- time formatting,
- CoreData persistence and consistency guarantees.
