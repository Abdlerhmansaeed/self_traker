<!--
Sync Impact Report
==================
Version change: N/A → 1.0.0 (Initial ratification)
Modified principles: None (initial version)
Added sections:
  - Core Principles (I-V)
  - Technology Stack & Constraints
  - Development Workflow
  - Governance
Removed sections: None
Templates requiring updates:
  - plan-template.md: ⚠ pending (verify alignment with principles)
  - spec-template.md: ⚠ pending (verify alignment with principles)
  - tasks-template.md: ⚠ pending (verify alignment with principles)
Follow-up TODOs: None
-->

# Voice Expense Tracker Constitution

## Core Principles

### I. Clean Architecture & Feature-First Organization

All code MUST follow Clean Architecture principles with feature-first organization:
- **Data Layer**: Data sources (remote/local), models, repository implementations
- **Domain Layer**: Entities, repository interfaces, use cases
- **Presentation Layer**: Cubits/BLoCs, pages, widgets

Each feature MUST be self-contained within `lib/features/{feature_name}/` with clear
layer separation. Cross-feature dependencies MUST flow through domain layer abstractions.
Shared utilities belong in `lib/core/`.

**Rationale**: Ensures maintainability, testability, and allows features to evolve
independently. Prevents tight coupling that hinders scalability.

### II. BLoC/Cubit State Management

All UI state MUST be managed via BLoC or Cubit pattern using `flutter_bloc`:
- State classes MUST use `equatable` for proper equality comparison
- States MUST be immutable and use `copyWith` for updates
- Cubits MUST be registered via `injectable` for dependency injection
- Business logic MUST NOT exist in widgets; widgets only dispatch events/call methods

**Rationale**: Provides predictable state management, facilitates testing, and maintains
clear separation between UI and business logic.

### III. User Data Privacy & Security

User financial data MUST be treated with highest priority:
- All expense data MUST be tied to authenticated `userId`
- Firebase Security Rules MUST enforce user-only access to their data
- Sensitive data (voice recordings) MUST NOT be persisted longer than processing requires
- AI parsing MUST NOT store or learn from individual user financial data
- Error messages MUST NOT expose internal system details or user data

**Rationale**: Financial data is sensitive. Users trust the app with their spending
habits. This trust must never be violated.

### IV. Voice Input Reliability

Voice expense entry is the core differentiator and MUST be reliable:
- Speech recognition MUST support Arabic (ar-SA) and English locales
- AI parsing MUST handle ambiguous input gracefully with confidence scores
- Multiple expenses in single input MUST be detected and presented for confirmation
- User MUST always confirm/edit parsed expenses before saving
- Fallback to manual entry MUST always be available

**Rationale**: Voice input reduces friction but introduces ambiguity. User confirmation
prevents incorrect expense logging that erodes trust.

### V. Offline-First & Performance

The app MUST remain functional with degraded connectivity:
- Local caching MUST enable viewing recent expenses offline
- Expense creation MUST queue locally when offline and sync when connected
- UI MUST remain responsive (<16ms frame budget) during data operations
- Heavy operations (AI parsing, sync) MUST run asynchronously with loading indicators

**Rationale**: Users track expenses in various contexts (stores, transit) where
connectivity is unreliable. Poor performance degrades user experience.

## Technology Stack & Constraints

**Required Stack**:
- Framework: Flutter (multi-platform: Android, iOS, Web, Desktop)
- State Management: `flutter_bloc` + `equatable`
- Dependency Injection: `injectable` + `get_it`
- Backend: Firebase (Auth, Firestore, Storage)
- AI Services: Google Generative AI (expense parsing)
- Routing: `go_router`

**Constraints**:
- Minimum SDK: Dart ^3.9.2
- All dependencies MUST be declared in `pubspec.yaml`
- New dependencies MUST be justified and reviewed for security
- Platform-specific code MUST be minimized; prefer Flutter plugins

## Development Workflow

**Code Quality Gates**:
- All code MUST pass `flutter analyze` with zero errors
- Widget tests MUST exist for all presentation layer components
- Unit tests MUST exist for all cubits and use cases
- Integration tests SHOULD cover critical user journeys (voice expense flow)

**Documentation Requirements**:
- Public APIs MUST have dartdoc comments
- Complex business logic MUST include inline rationale comments
- Feature READMEs SHOULD explain architecture decisions

**Git Workflow**:
- Commits MUST follow conventional commit format
- Feature branches MUST be rebased before merge
- PRs MUST reference related issues/specs

## Governance

This constitution supersedes all other development practices for Voice Expense Tracker.
All code changes MUST comply with these principles.

**Amendment Process**:
1. Propose amendment with rationale in a dedicated PR
2. Document migration plan for existing code if breaking
3. Update version following semantic versioning:
   - MAJOR: Principle removal or incompatible redefinition
   - MINOR: New principle or section added
   - PATCH: Clarifications, wording improvements
4. Update all dependent templates and documentation

**Compliance**:
- Code reviews MUST verify constitutional compliance
- Non-compliant code MUST NOT be merged
- Exceptions MUST be documented with justification and remediation plan

**Version**: 1.0.0 | **Ratified**: 2026-01-17 | **Last Amended**: 2026-01-17
