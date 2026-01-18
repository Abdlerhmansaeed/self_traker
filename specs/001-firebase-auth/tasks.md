# Tasks: Firebase Authentication with Google Sign-In

**Input**: Design documents from `/specs/001-firebase-auth/`
**Prerequisites**: plan.md ✓, spec.md ✓, research.md ✓, data-model.md ✓, contracts/ ✓

**Tests**: Required by constitution (unit tests for cubits/use cases, widget tests for presentation).

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story?] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2)
- Include exact file paths in descriptions

## Path Conventions (Flutter Clean Architecture)

- **Feature code**: `lib/features/auth/`
- **Core utilities**: `lib/core/`
- **Localization**: `lib/l10n/` or existing localization system

---

## Phase 1: Setup (Project Dependencies)

**Purpose**: Add Firebase dependencies and configure project

- [X] T001 Add firebase_auth, cloud_firestore, google_sign_in dependencies in pubspec.yaml
- [X] T002 Run flutter pub get and verify dependencies resolve
- [X] T003 [P] Verify google-services.json present in android/app/
- [X] T004 [P] Add GoogleService-Info.plist to ios/Runner/ (if not present)
- [X] T005 [P] Configure iOS URL scheme for Google Sign-In in ios/Runner/Info.plist

---

## Phase 2: Foundational (Core Infrastructure)

**Purpose**: Domain entities, exceptions, and DI registration that ALL user stories depend on

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T006 Create SubscriptionStatus enum in lib/features/auth/domain/entities/subscription_status.dart
- [X] T007 [P] Create NotificationSettings entity in lib/features/auth/domain/entities/notification_settings.dart
- [X] T008 [P] Create UserMetadata entity in lib/features/auth/domain/entities/user_metadata.dart
- [X] T009 Create UserEntity domain entity in lib/features/auth/domain/entities/user_entity.dart
- [X] T010 Create AuthFailure sealed class with all failure types in lib/features/auth/domain/entities/auth_failure.dart
- [X] T011 Update AuthExceptions with Firebase error code mapping in lib/features/auth/exceptions/auth_exceptions.dart
- [X] T012 [P] Create UserModel with Firestore serialization in lib/features/auth/data/models/user_model.dart
- [X] T013 [P] Create UsageModel for usage document in lib/features/auth/data/models/usage_model.dart
- [X] T014 Register FirebaseAuth, FirebaseFirestore, GoogleSignIn in lib/core/di/injection.dart
- [X] T015 Add auth localization keys (English) to localization system
- [X] T016 [P] Add auth localization keys (Arabic) to localization system

**Checkpoint**: Foundation ready - user story implementation can now begin

---

## Phase 3: User Story 1 - Email/Password Registration (Priority: P1) 🎯 MVP

**Goal**: New users can register with email/password, creating user & usage documents in Firestore

**Independent Test**: Register a new user, verify Firestore documents created with default values

### Data Layer for US1

- [X] T017 Define signUpWithEmail, sendVerificationEmail, createUserDocument, createUsageDocument methods in lib/features/auth/data/datasources/auth_remote_data_source.dart
- [X] T018 Implement signUpWithEmail method with FirebaseAuth in lib/features/auth/data/datasources/auth_remote_data_source_impl.dart
- [X] T019 Implement sendVerificationEmail method in lib/features/auth/data/datasources/auth_remote_data_source_impl.dart
- [X] T020 Implement createUserDocument with batch write in lib/features/auth/data/datasources/auth_remote_data_source_impl.dart
- [X] T021 Implement createUsageDocument in batch with user document in lib/features/auth/data/datasources/auth_remote_data_source_impl.dart

### Domain Layer for US1

- [X] T022 Create AuthRepository interface with signUpWithEmail method in lib/features/auth/domain/repositories/auth_repository.dart
- [X] T023 Create AuthRepositoryImpl implementing signUpWithEmail in lib/features/auth/data/repositories/auth_repository_impl.dart
- [X] T024 Create SignUpWithEmailUseCase in lib/features/auth/domain/usecases/sign_up_with_email_usecase.dart
- [X] T025 [P] Create SendVerificationEmailUseCase in lib/features/auth/domain/usecases/send_verification_email_usecase.dart

### Presentation Layer for US1

- [X] T026 Create AuthState with initial, loading, authenticated, unauthenticated, error states in lib/features/auth/presentation/cubit/auth_state.dart
- [X] T027 Create AuthCubit with signUpWithEmail method in lib/features/auth/presentation/cubit/auth_cubit.dart
- [X] T028 Integrate AuthCubit with signup_screen.dart using BlocProvider
- [X] T029 Update signup form validation for password requirements (8+ chars, upper, lower, number) in lib/features/auth/presentation/pages/signup/signup_screen.dart
- [X] T029a Add email format validation in signup_screen.dart (regex pattern, max 320 chars)
- [X] T029b Detect if email exists via Google provider and show auth_error_email_exists_google message in signup_screen.dart
- [X] T030 Display localized error messages on signup failure in signup_screen.dart

### Tests for User Story 1 (Constitution Required)

- [X] T030a [P] [US1] Unit test for SignUpWithEmailUseCase in test/features/auth/domain/usecases/sign_up_with_email_usecase_test.dart
- [X] T030b [P] [US1] Unit test for SendVerificationEmailUseCase in test/features/auth/domain/usecases/send_verification_email_usecase_test.dart
- [X] T030c [P] [US1] Unit test for AuthCubit signup methods in test/features/auth/presentation/cubit/auth_cubit_test.dart
- [ ] T030d [P] [US1] Widget test for signup_screen.dart in test/features/auth/presentation/pages/signup/signup_screen_test.dart

**Checkpoint**: User Story 1 complete - email/password registration works independently

---

## Phase 4: User Story 2 - Google Sign-In (Priority: P1)

**Goal**: Users can sign up or log in instantly with Google account

**Independent Test**: Tap Google Sign-In, select account, verify authentication and Firestore document

### Data Layer for US2

- [X] T031 Add signInWithGoogle method to auth_remote_data_source.dart interface
- [X] T032 Implement signInWithGoogle with GoogleSignIn + FirebaseAuth in auth_remote_data_source_impl.dart
- [X] T033 Implement checkUserExists to determine new vs returning user in auth_remote_data_source_impl.dart

### Domain Layer for US2

- [X] T034 Add signInWithGoogle method to AuthRepository interface
- [X] T035 Implement signInWithGoogle in AuthRepositoryImpl
- [X] T036 Create SignInWithGoogleUseCase in lib/features/auth/domain/usecases/sign_in_with_google_usecase.dart

### Presentation Layer for US2

- [X] T037 Add signInWithGoogle method to AuthCubit
- [X] T038 Handle Google Sign-In cancellation (no error state) in AuthCubit
- [X] T039 Integrate Google Sign-In button with AuthCubit in login_screen.dart
- [X] T040 Display localized error message for Google Sign-In network errors

### Tests for User Story 2 (Constitution Required)

- [X] T040a [P] [US2] Unit test for SignInWithGoogleUseCase in test/features/auth/domain/usecases/sign_in_with_google_usecase_test.dart
- [X] T040b [P] [US2] Unit test for AuthCubit Google sign-in methods in test/features/auth/presentation/cubit/auth_cubit_google_test.dart
- [ ] T040c [P] [US2] Widget test for Google Sign-In button in test/features/auth/presentation/pages/login/login_screen_google_test.dart

**Checkpoint**: User Story 2 complete - Google Sign-In works independently

---

## Phase 5: User Story 3 - Email/Password Login (Priority: P2)

**Goal**: Returning users can log in with email/password

**Independent Test**: Log in with registered credentials, verify navigation to home screen

### Data Layer for US3

- [X] T041 Add signInWithEmail, updateLastLoginAt methods to auth_remote_data_source.dart interface
- [X] T042 Implement signInWithEmail with FirebaseAuth in auth_remote_data_source_impl.dart
- [X] T043 Implement updateLastLoginAt Firestore update in auth_remote_data_source_impl.dart

### Domain Layer for US3

- [X] T044 Add signInWithEmail method to AuthRepository interface
- [X] T045 Implement signInWithEmail in AuthRepositoryImpl
- [X] T046 Create SignInWithEmailUseCase in lib/features/auth/domain/usecases/sign_in_with_email_usecase.dart

### Presentation Layer for US3

- [X] T047 Add signInWithEmail method to AuthCubit
- [X] T048 Integrate login form with AuthCubit in login_screen.dart
- [X] T049 Display localized error for invalid credentials (same message for wrong email/password)
- [X] T049a Load subscription status from user document after successful login in auth_remote_data_source_impl.dart
- [X] T050 Handle unverified email state - show verification prompt with resend option

### Tests for User Story 3 (Constitution Required)

- [ ] T050a [P] [US3] Unit test for SignInWithEmailUseCase in test/features/auth/domain/usecases/sign_in_with_email_usecase_test.dart
- [ ] T050b [P] [US3] Unit test for AuthCubit login methods in test/features/auth/presentation/cubit/auth_cubit_login_test.dart
- [ ] T050c [P] [US3] Widget test for login_screen.dart in test/features/auth/presentation/pages/login/login_screen_test.dart

**Checkpoint**: User Story 3 complete - email/password login works independently

---

## Phase 6: User Story 4 - Password Reset (Priority: P2)

**Goal**: Users can reset forgotten password via email

**Independent Test**: Request password reset, verify email sent (check Firebase Console or email)

### Data Layer for US4

- [X] T051 Add sendPasswordResetEmail method to auth_remote_data_source.dart interface
- [X] T052 Implement sendPasswordResetEmail with FirebaseAuth in auth_remote_data_source_impl.dart

### Domain Layer for US4

- [X] T053 Add sendPasswordResetEmail method to AuthRepository interface
- [X] T054 Implement sendPasswordResetEmail in AuthRepositoryImpl
- [X] T055 Create SendPasswordResetUseCase in lib/features/auth/domain/usecases/send_password_reset_usecase.dart

### Presentation Layer for US4

- [X] T056 Add sendPasswordResetEmail method to AuthCubit
- [X] T057 Integrate forgot password form with AuthCubit in forgot_password_screen.dart
- [X] T058 Display generic success message (security: don't reveal if email exists)

### Tests for User Story 4 (Constitution Required)

- [ ] T058a [P] [US4] Unit test for SendPasswordResetUseCase in test/features/auth/domain/usecases/send_password_reset_usecase_test.dart
- [ ] T058b [P] [US4] Unit test for AuthCubit password reset methods in test/features/auth/presentation/cubit/auth_cubit_reset_test.dart
- [ ] T058c [P] [US4] Widget test for forgot_password_screen.dart in test/features/auth/presentation/pages/forgot_password/forgot_password_screen_test.dart

**Checkpoint**: User Story 4 complete - password reset works independently

---

## Phase 7: User Story 6 - Error Handling with Localization (Priority: P2)

**Goal**: All auth errors display in user's selected language (Arabic or English)

**Independent Test**: Trigger errors in both AR and EN settings, verify correct translations

### Implementation for US6

- [ ] T059 Create AuthErrorMapper utility to map FirebaseAuthException codes to AuthFailure in lib/features/auth/exceptions/auth_error_mapper.dart
- [ ] T060 Implement getLocalizedMessage method on AuthFailure using localization keys
- [ ] T061 Update AuthCubit to emit localized error messages from AuthFailure
- [ ] T062 Implement rate limiting state tracking in AuthCubit (5 attempts, 1-min lockout)
- [ ] T063 Create countdown timer display for rate-limited state in login_screen.dart
- [ ] T064 [P] Verify all error messages display correctly in English
- [ ] T065 [P] Verify all error messages display correctly in Arabic

**Checkpoint**: User Story 6 complete - all errors display in correct language

---

## Phase 8: User Story 5 - Session Persistence & Auto-Login (Priority: P3)

**Goal**: Users stay logged in across app restarts

**Independent Test**: Log in, close app, reopen, verify automatic navigation to home

### Data Layer for US5

- [ ] T066 Add getCurrentUser, authStateChanges methods to auth_remote_data_source.dart interface
- [ ] T067 Implement getCurrentUser returning current FirebaseAuth user in auth_remote_data_source_impl.dart
- [ ] T068 Implement authStateChanges stream wrapper in auth_remote_data_source_impl.dart

### Domain Layer for US5

- [ ] T069 Add getCurrentUser, watchAuthState methods to AuthRepository interface
- [ ] T070 Implement getCurrentUser, watchAuthState in AuthRepositoryImpl
- [ ] T071 Create GetCurrentUserUseCase in lib/features/auth/domain/usecases/get_current_user_usecase.dart
- [ ] T072 [P] Create SignOutUseCase in lib/features/auth/domain/usecases/sign_out_usecase.dart

### Presentation Layer for US5

- [ ] T073 Add checkAuthState method to AuthCubit for app initialization
- [ ] T074 Subscribe to authStateChanges stream in AuthCubit
- [ ] T075 Update app routing to check auth state on startup in lib/core/routing/app_router.dart
- [ ] T076 Navigate to appropriate screen based on auth state and onboarding status
- [ ] T077 Handle invalidated session (show message, navigate to login)

### Tests for User Story 5 (Constitution Required)

- [ ] T077a [P] [US5] Unit test for GetCurrentUserUseCase in test/features/auth/domain/usecases/get_current_user_usecase_test.dart
- [ ] T077b [P] [US5] Unit test for SignOutUseCase in test/features/auth/domain/usecases/sign_out_usecase_test.dart
- [ ] T077c [P] [US5] Unit test for AuthCubit session methods in test/features/auth/presentation/cubit/auth_cubit_session_test.dart

**Checkpoint**: User Story 5 complete - session persistence works independently

---

## Phase 9: Email Verification Banner (Cross-cutting)

**Purpose**: Persistent banner for unverified email users

- [ ] T078 Create EmailVerificationBanner widget in lib/features/auth/presentation/widgets/email_verification_banner.dart
- [ ] T079 Add resendVerificationEmail action to banner
- [ ] T080 Integrate banner into app shell for unverified users
- [ ] T081 Update AuthState to track emailVerified status

---

## Phase 10: Polish & Integration

**Purpose**: Final integration, cleanup, and validation

- [ ] T082 Run flutter analyze and fix all warnings
- [ ] T083 Run build_runner for injectable code generation
- [ ] T084 Verify all auth flows work end-to-end
- [ ] T085 [P] Test signup → login → logout flow
- [ ] T086 [P] Test Google Sign-In → logout flow
- [ ] T087 [P] Test password reset flow
- [ ] T088 Deploy Firestore security rules from contracts/firestore-users.md
- [ ] T089 [P] Deploy Firestore security rules from contracts/firestore-usage.md
- [ ] T090 Run quickstart.md verification checklist

---

## Dependencies & Execution Order

### Phase Dependencies

```
Phase 1 (Setup) ─────────────────────────────────┐
                                                  │
Phase 2 (Foundational) ──────────────────────────┤ BLOCKS all user stories
                                                  │
              ┌───────────────────────────────────┘
              │
              ▼
    ┌─────────┴─────────┬─────────────────┬─────────────────┐
    │                   │                 │                 │
Phase 3 (US1-P1)   Phase 4 (US2-P1)  Phase 5 (US3-P2)  Phase 6 (US4-P2)
Email Signup       Google Sign-In    Email Login       Password Reset
    │                   │                 │                 │
    └─────────┬─────────┴─────────────────┴─────────────────┘
              │
              ▼
         Phase 7 (US6-P2) ─── Error Localization
              │
              ▼
         Phase 8 (US5-P3) ─── Session Persistence
              │
              ▼
         Phase 9 ─── Verification Banner
              │
              ▼
         Phase 10 ─── Polish & Integration
```

### User Story Dependencies

| Story | Can Start After | Dependencies |
|-------|-----------------|--------------|
| US1 (Email Signup) | Phase 2 | None |
| US2 (Google Sign-In) | Phase 2 | None (parallel with US1) |
| US3 (Email Login) | Phase 2 | Can share data layer with US1 |
| US4 (Password Reset) | Phase 2 | None |
| US6 (Error Localization) | US1-US4 | Uses errors from all auth flows |
| US5 (Session) | Phase 2 | Integrates with routing |

### Parallel Opportunities

**Within Phase 2 (Foundational)**:
```
T007 NotificationSettings + T008 UserMetadata → run in parallel
T012 UserModel + T013 UsageModel → run in parallel
T015 English localization + T016 Arabic localization → run in parallel
```

**User Stories After Phase 2**:
```
US1 (Email Signup) + US2 (Google Sign-In) → run in parallel (both P1)
US3 (Email Login) + US4 (Password Reset) → run in parallel (both P2)
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational
3. Complete Phase 3: User Story 1 (Email/Password Registration)
4. **STOP and VALIDATE**: Test registration independently
5. Deploy/demo if ready - users can now register!

### Recommended Order (Incremental)

1. Setup → Foundational → **Foundation ready**
2. US1 (Email Signup) → Test → **MVP: Users can register**
3. US2 (Google Sign-In) → Test → **Users can sign in with Google**
4. US3 (Email Login) → Test → **Returning users can log in**
5. US4 (Password Reset) → Test → **Users can recover accounts**
6. US6 (Error Localization) → Test → **Errors in AR/EN**
7. US5 (Session) → Test → **Auto-login works**
8. Verification Banner → Test → **Unverified users prompted**
9. Polish → Validate → **Production ready**

---

## Notes

- Test tasks included per constitution requirements (unit tests for use cases/cubits, widget tests for screens)
- All tasks include exact file paths
- [P] tasks can run in parallel within their phase
- [USn] labels map tasks to user stories for traceability
- Each user story checkpoint is independently testable
- Commit after each completed task or logical group
