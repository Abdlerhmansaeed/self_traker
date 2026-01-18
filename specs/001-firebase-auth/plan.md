# Implementation Plan: Firebase Authentication with Google Sign-In

**Branch**: `001-firebase-auth` | **Date**: January 18, 2026 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/001-firebase-auth/spec.md`

## Summary

Implement Firebase Authentication with email/password registration, Google Sign-In, and comprehensive error handling with Arabic/English localization. Creates user documents in Firestore with profile data, preferences, and usage tracking. Follows Clean Architecture with feature-first organization using BLoC/Cubit pattern.

## Technical Context

**Language/Version**: Dart ^3.9.2, Flutter (multi-platform)  
**Primary Dependencies**: firebase_auth, cloud_firestore, google_sign_in, flutter_bloc, equatable, injectable, get_it, go_router  
**Storage**: Firebase Firestore (users, usage collections)  
**Testing**: flutter_test (widget tests for presentation, unit tests for cubits/use cases)  
**Target Platform**: Android, iOS, Web, Desktop (via Flutter)
**Project Type**: Mobile application with Firebase backend  
**Performance Goals**: Registration <60s, Google Sign-In <10s, Firestore writes <3s, error display <200ms  
**Constraints**: Offline-capable (queue operations), <16ms frame budget, bilingual (AR/EN)  
**Scale/Scope**: Single-feature auth module within existing Flutter app structure

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Compliance | Notes |
|-----------|------------|-------|
| I. Clean Architecture | ✅ PASS | Feature structure exists at `lib/features/auth/` with data/domain/presentation layers |
| II. BLoC/Cubit State Management | ✅ PASS | Will use Cubit for auth state, injectable for DI |
| III. User Data Privacy & Security | ✅ PASS | All data tied to userId, Firebase Security Rules enforced |
| IV. Voice Input Reliability | N/A | Not applicable to authentication feature |
| V. Offline-First & Performance | ✅ PASS | Firebase SDK handles offline persistence, async operations |

**Gate Status**: ✅ PASSED - No violations

## Project Structure

### Documentation (this feature)

```text
specs/001-firebase-auth/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output (Firestore schema)
└── tasks.md             # Phase 2 output (created by /speckit.tasks)
```

### Source Code (existing Flutter structure)

```text
lib/
├── core/
│   ├── di/                    # Dependency injection (injectable)
│   ├── routing/               # go_router configuration
│   └── extensions/            # Shared utilities
└── features/
    └── auth/
        ├── data/
        │   ├── datasources/
        │   │   ├── auth_remote_data_source.dart      # Abstract interface
        │   │   └── auth_remote_data_source_impl.dart # Firebase implementation
        │   ├── models/
        │   │   ├── user_model.dart                   # Firestore serialization
        │   │   └── auth_error_model.dart             # Error mapping
        │   └── repositories/
        │       └── auth_repository_impl.dart         # Repository implementation
        ├── domain/
        │   ├── entities/
        │   │   ├── user_entity.dart                  # Domain user entity
        │   │   └── auth_failure.dart                 # Failure types
        │   ├── repositories/
        │   │   └── auth_repository.dart              # Abstract repository
        │   └── usecases/
        │       ├── sign_up_with_email_usecase.dart
        │       ├── sign_in_with_email_usecase.dart
        │       ├── sign_in_with_google_usecase.dart
        │       ├── send_password_reset_usecase.dart
        │       ├── sign_out_usecase.dart
        │       └── get_current_user_usecase.dart
        ├── exceptions/
        │   └── auth_exceptions.dart                  # Firebase exception mapping
        └── presentation/
            ├── cubit/
            │   ├── auth_cubit.dart                   # Main auth state management
            │   └── auth_state.dart                   # Auth states (equatable)
            ├── pages/
            │   ├── login/
            │   ├── signup/
            │   ├── forgot_password/
            │   └── reset_password/
            └── widgets/
                ├── email_verification_banner.dart    # Persistent banner
                └── [existing widgets]

test/
├── features/
│   └── auth/
│       ├── data/
│       │   └── datasources/
│       │       └── auth_remote_data_source_test.dart
│       ├── domain/
│       │   └── usecases/
│       │       └── sign_up_with_email_usecase_test.dart
│       └── presentation/
│           └── cubit/
│               └── auth_cubit_test.dart
```

**Structure Decision**: Follows existing Clean Architecture feature-first organization already present in `lib/features/auth/`. Extends current skeleton with full implementation.
