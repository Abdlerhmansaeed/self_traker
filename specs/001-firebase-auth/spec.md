# Feature Specification: Firebase Authentication with Google Sign-In

**Feature Branch**: `001-firebase-auth`  
**Created**: January 18, 2026  
**Status**: Draft  
**Input**: User description: "Implement Auth with Firebase Auth and handle Errors with localization and implement auth with Google using Firebase. User collection structure with comprehensive user profile data."

## Clarifications

### Session 2026-01-18

- Q: When a user tries to register with an email that already exists via Google Sign-In, what should happen? → A: Block registration and require user to sign in with Google first, then add password
- Q: What should be the default language preference for new users? → A: Default to English (en) for all new users
- Q: How should the system handle unverified email accounts attempting to access the app after login? → A: Allow limited app access with a persistent banner prompting verification
- Q: What should happen after multiple consecutive failed login attempts? → A: After 5 failed attempts, enforce 1-minute lockout with localized countdown message
- Q: When should the usage tracking document be initialized for a new user? → A: Create usage document immediately during user registration (alongside user document)

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Email/Password Registration (Priority: P1)

A new user wants to create an account using their email address and password to start tracking their expenses in the Self Tracker app.

**Why this priority**: Email/password is the foundational authentication method that doesn't require third-party dependencies. It establishes the core user creation flow and Firestore user document structure.

**Independent Test**: Can be fully tested by registering a new user with email/password and verifying the user document is created in Firestore with all default values. Delivers immediate value by allowing users to access the app.

**Acceptance Scenarios**:

1. **Given** a user is on the registration screen, **When** they enter a valid email and password meeting security requirements and tap "Sign Up", **Then** a verification email is sent and a user document is created in Firestore with default values (free tier, EGP currency, onboardingCompleted: false)

2. **Given** a user has received a verification email, **When** they click the verification link, **Then** their email is marked as verified and they can proceed to onboarding

3. **Given** a user enters an email that already exists, **When** they tap "Sign Up", **Then** they see a localized error message indicating the email is already registered

4. **Given** a user enters a weak password, **When** they attempt to register, **Then** they see a localized error message with specific password requirements

---

### User Story 2 - Google Sign-In (Priority: P1)

A user wants to quickly sign up or log in using their existing Google account for a seamless authentication experience.

**Why this priority**: Google Sign-In is a critical feature as it provides instant authentication without email verification, reducing friction for user onboarding. Most users prefer social login for convenience.

**Independent Test**: Can be tested by initiating Google Sign-In flow, selecting a Google account, and verifying the user is authenticated and a Firestore user document is created with the Google profile data (displayName, email, photoURL).

**Acceptance Scenarios**:

1. **Given** a new user is on the login screen, **When** they tap "Sign in with Google" and select their Google account, **Then** they are authenticated instantly and a new user document is created in Firestore with their Google profile data

2. **Given** an existing user with a Google-linked account, **When** they tap "Sign in with Google", **Then** they are logged in and their lastLoginAt timestamp is updated

3. **Given** a user cancels the Google Sign-In flow, **When** the Google picker is dismissed, **Then** the user remains on the authentication screen with no error displayed

4. **Given** a network error occurs during Google Sign-In, **When** authentication fails, **Then** the user sees a localized error message about connectivity issues

---

### User Story 3 - Email/Password Login (Priority: P2)

A returning user wants to log into their account using their previously registered email and password.

**Why this priority**: Login is essential for returning users but depends on registration being implemented first.

**Independent Test**: Can be tested by logging in with valid credentials and verifying the user reaches the home screen with their data loaded.

**Acceptance Scenarios**:

1. **Given** a registered user with a verified email, **When** they enter correct credentials and tap "Login", **Then** they are authenticated, lastLoginAt is updated, and they are navigated to the home screen

2. **Given** a user enters incorrect credentials, **When** they tap "Login", **Then** they see a localized error message without revealing which field is incorrect (security best practice)

3. **Given** a user with an unverified email attempts to login, **When** they enter correct credentials, **Then** they see a message prompting them to verify their email with an option to resend verification

---

### User Story 4 - Password Reset (Priority: P2)

A user who has forgotten their password needs to reset it to regain access to their account.

**Why this priority**: Password recovery is essential for user retention but is a secondary flow after primary login paths are established.

**Independent Test**: Can be tested by requesting a password reset, receiving the email, and successfully setting a new password.

**Acceptance Scenarios**:

1. **Given** a user is on the forgot password screen, **When** they enter their registered email and tap "Send Reset Link", **Then** a password reset email is sent and they see a confirmation message

2. **Given** a user enters an unregistered email, **When** they tap "Send Reset Link", **Then** they see a generic success message (to prevent email enumeration attacks)

3. **Given** a user has received a password reset email, **When** they click the link and enter a new valid password, **Then** their password is updated and they can log in with the new password

---

### User Story 5 - Session Persistence & Auto-Login (Priority: P3)

A returning user expects to stay logged in when reopening the app, without needing to authenticate again.

**Why this priority**: Enhances user experience but relies on core authentication being fully functional first.

**Independent Test**: Can be tested by logging in, closing the app completely, reopening it, and verifying the user is automatically taken to the home screen.

**Acceptance Scenarios**:

1. **Given** a user has previously logged in, **When** they open the app, **Then** they are automatically authenticated and navigated to the appropriate screen (home or incomplete onboarding)

2. **Given** a user's session has been invalidated (password changed, account disabled), **When** they open the app, **Then** they are navigated to the login screen with an appropriate message

---

### User Story 6 - Error Handling with Localization (Priority: P2)

Users need to see authentication error messages in their preferred language (Arabic or English) to understand and resolve issues.

**Why this priority**: Critical for user experience in a bilingual app. Users must understand errors to complete authentication.

**Independent Test**: Can be tested by triggering various error conditions (wrong password, network error, etc.) in both Arabic and English language settings and verifying appropriate localized messages appear.

**Acceptance Scenarios**:

1. **Given** a user has their app language set to Arabic, **When** an authentication error occurs, **Then** they see the error message in Arabic

2. **Given** a user has their app language set to English, **When** an authentication error occurs, **Then** they see the error message in English

3. **Given** any authentication error occurs, **When** the error is displayed, **Then** the message is user-friendly (not technical) and suggests corrective action when applicable

---

### Edge Cases

- What happens when a user tries to register with an email that exists but was registered via Google Sign-In? → Block registration, prompt user to sign in with Google first, then optionally add password to their account
- How does system handle network timeout during authentication? → Show localized timeout message with retry option
- What happens if Firebase service is temporarily unavailable? → Show service unavailable message with retry
- How does system handle rapid repeated login attempts? → After 5 failed attempts, enforce 1-minute lockout with localized countdown message
- What happens when Google Play Services is not available on Android? → Show message to update/install Google Play Services
- What happens when user revokes Google permissions after account creation? → Allow re-authentication or password setup

## Requirements *(mandatory)*

### Functional Requirements

#### Registration & Account Creation

- **FR-001**: System MUST allow users to register with email and password
- **FR-002**: System MUST send email verification after email/password registration
- **FR-002a**: System MUST allow unverified users limited app access with a persistent banner prompting email verification
- **FR-003**: System MUST validate password meets security requirements (minimum 8 characters, at least one uppercase, one lowercase, one number)
- **FR-004**: System MUST validate email format before submission
- **FR-005**: System MUST create a user document in Firestore upon successful registration with default values
- **FR-005a**: System MUST create a usage tracking document immediately during user registration (alongside user document)

#### Google Authentication

- **FR-006**: System MUST allow users to authenticate using Google Sign-In
- **FR-007**: System MUST retrieve and store user profile data from Google (displayName, email, photoURL)
- **FR-008**: System MUST handle Google Sign-In cancellation gracefully
- **FR-009**: System MUST create a new user document if the Google account is not linked to an existing user

#### Login & Session Management

- **FR-010**: System MUST allow registered users to login with email and password
- **FR-011**: System MUST persist user session across app restarts
- **FR-012**: System MUST update lastLoginAt timestamp on each successful login
- **FR-013**: System MUST check and load subscription status on login

#### Password Management

- **FR-014**: System MUST allow users to request password reset via email
- **FR-015**: System MUST allow users to set a new password through reset flow
- **FR-016**: System MUST NOT reveal whether an email exists in the system during password reset (security)

#### Error Handling & Localization

- **FR-017**: System MUST display all error messages in the user's selected language (Arabic or English)
- **FR-018**: System MUST provide user-friendly error messages (not technical codes)
- **FR-019**: System MUST handle network connectivity errors with appropriate messaging
- **FR-020**: System MUST handle invalid credentials with secure, non-revealing messages
- **FR-020a**: System MUST enforce 1-minute lockout after 5 consecutive failed login attempts, displaying a localized countdown message

#### User Data Structure

- **FR-021**: System MUST create user document with required fields: email, displayName, createdAt, lastLoginAt
- **FR-022**: System MUST set default values: preferredCurrency (EGP), preferredLanguage (en), subscriptionStatus (free), onboardingCompleted (false)
- **FR-023**: System MUST initialize notification settings with default values (all enabled)
- **FR-024**: System MUST store metadata including onboardingCompleted status and appVersion

### Key Entities

- **User**: Represents an authenticated user with profile data, preferences, and subscription information. Contains fields: email, displayName, photoURL, phoneNumber, preferredCurrency, preferredLanguage, subscriptionStatus, subscriptionExpiration, monthlyBudget, createdAt, lastLoginAt, totalExpenses, notificationSettings, metadata

- **Notification Settings**: Embedded map within User containing boolean preferences for budgetAlerts, weeklyReports, and tips

- **User Metadata**: Embedded map within User containing onboardingCompleted flag, firstExpenseDate, and appVersion

- **Authentication Error**: Represents various error states (invalid credentials, network error, account disabled, email not verified) with localized message keys for Arabic and English

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can complete email/password registration in under 60 seconds (excluding email verification)
- **SC-002**: Users can complete Google Sign-In in under 10 seconds
- **SC-003**: 95% of authentication attempts succeed on first try when credentials are valid
- **SC-004**: All error messages display in correct language within 200ms of error occurrence
- **SC-005**: Session persistence works correctly, with users remaining logged in for 30 days of inactivity
- **SC-006**: Password reset emails are delivered within 2 minutes of request
- **SC-007**: User documents are created in Firestore within 3 seconds of successful authentication
- **SC-008**: App handles offline/poor connectivity gracefully with appropriate user feedback in 100% of cases

## Assumptions

- Firebase project is already configured with Authentication and Firestore enabled
- Google Sign-In is configured in Firebase Console and respective platform configurations (Android/iOS)
- The app already has a localization system in place for Arabic and English
- User will proceed to onboarding flow after authentication (separate feature)
- Default currency is EGP (Egyptian Pound) based on primary target market
- Free tier is the default subscription status for all new users
- Email verification is required for email/password accounts; unverified users get limited app access with persistent verification banner

## Out of Scope

- Apple Sign-In implementation (can be added as separate feature)
- Phone/OTP authentication (can be added as separate feature)
- Multi-factor authentication (MFA)
- Social login linking (merging accounts)
- Account deletion flow
- Biometric authentication (Face ID, fingerprint)
- Onboarding flow implementation (separate feature)
- Subscription/payment processing
