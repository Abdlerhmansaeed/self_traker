# Research: Firebase Authentication with Google Sign-In

**Feature**: 001-firebase-auth  
**Date**: January 18, 2026

## Research Tasks

### 1. Firebase Auth Flutter SDK Best Practices

**Decision**: Use `firebase_auth` package with `google_sign_in` for Google authentication

**Rationale**:
- Official Firebase SDK for Flutter with full feature support
- Handles token management, session persistence automatically
- Built-in support for multiple auth providers
- Well-documented with active maintenance

**Alternatives Considered**:
- Direct REST API calls: Rejected - requires manual token management, no offline support
- Third-party auth wrappers: Rejected - adds dependency without clear benefit

**Best Practices**:
- Use `FirebaseAuth.instance.authStateChanges()` stream for reactive auth state
- Handle `FirebaseAuthException` codes for specific error mapping
- Use `idToken` for secure backend communication if needed
- Enable email enumeration protection in Firebase Console

### 2. Firestore User Document Pattern

**Decision**: Create user document on first authentication with atomic batch writes

**Rationale**:
- Single write operation for user + usage documents ensures consistency
- Using `set()` with merge allows updates without overwriting
- Timestamps handled server-side with `FieldValue.serverTimestamp()`

**Alternatives Considered**:
- Cloud Functions trigger: Rejected - adds latency, complexity for simple use case
- Lazy creation: Rejected - clarification specified immediate creation

**Best Practices**:
- Use batch writes for creating user + usage documents atomically
- Use `merge: true` to prevent accidental data overwrites
- Store sensitive data (subscription) as separate subcollection if needed later
- Index `userId` fields for query performance

### 3. Error Handling & Localization Strategy

**Decision**: Map Firebase error codes to localized message keys

**Rationale**:
- Firebase provides specific error codes (`wrong-password`, `user-not-found`, etc.)
- Mapping to keys allows localization without code changes
- Generic messages prevent security information leakage

**Error Code Mapping**:
| Firebase Code | User-Facing Key | Security Note |
|---------------|-----------------|---------------|
| `wrong-password` | `auth_error_invalid_credentials` | Don't reveal which field is wrong |
| `user-not-found` | `auth_error_invalid_credentials` | Same message as wrong password |
| `email-already-in-use` | `auth_error_email_exists` | OK to reveal on signup |
| `weak-password` | `auth_error_weak_password` | Show requirements |
| `too-many-requests` | `auth_error_rate_limited` | Show countdown |
| `network-request-failed` | `auth_error_network` | Suggest retry |
| `user-disabled` | `auth_error_account_disabled` | Contact support |

**Alternatives Considered**:
- Show Firebase error messages directly: Rejected - not localized, may leak info
- Single generic error: Rejected - poor UX, users can't fix issues

### 4. Google Sign-In Configuration

**Decision**: Use `google_sign_in` package with Firebase integration

**Rationale**:
- Official Google package, handles platform differences
- Seamless integration with Firebase Auth
- Returns `GoogleSignInAccount` with profile data

**Configuration Requirements**:
- Android: `google-services.json` (already present), SHA-1/SHA-256 fingerprints in Firebase Console
- iOS: `GoogleService-Info.plist`, URL scheme in Info.plist
- Web: OAuth client ID in Firebase Console

**Best Practices**:
- Request minimal scopes (`email`, `profile`)
- Handle `PlatformException` for Google Play Services issues
- Silently sign in on app start for seamless UX

### 5. Rate Limiting Implementation

**Decision**: Client-side rate limiting with timestamp tracking

**Rationale**:
- Firebase Auth has built-in rate limiting but doesn't provide countdown
- Client-side tracking allows UI countdown display
- 5 attempts / 1-minute lockout per clarification

**Implementation**:
- Track failed attempts with timestamps in cubit state
- Clear failed attempts on successful login or after lockout period
- Show countdown timer during lockout

**Alternatives Considered**:
- Server-side rate limiting only: Rejected - no countdown UI possible
- Shared Preferences persistence: Rejected - easily bypassed, unnecessary complexity

### 6. Email Verification Flow

**Decision**: Allow limited access with persistent banner for unverified users

**Rationale**:
- Per clarification: unverified users get limited access
- Reduces drop-off during registration
- Banner provides constant reminder without blocking

**Implementation**:
- Check `user.emailVerified` after login
- Store verification status in auth state
- Show `EmailVerificationBanner` widget in app shell when unverified
- Provide "Resend verification" action in banner

### 7. Session Persistence

**Decision**: Use Firebase Auth's built-in persistence with auth state listener

**Rationale**:
- Firebase Auth persists sessions automatically on mobile/desktop
- `authStateChanges()` stream fires on app start with current user
- 30-day session per success criteria (Firebase default)

**Best Practices**:
- Listen to `authStateChanges()` in app initialization
- Navigate based on auth state and onboarding completion
- Handle `userChanges()` for real-time profile updates

## Dependencies to Add

```yaml
dependencies:
  firebase_auth: ^5.5.1
  cloud_firestore: ^5.6.5
  google_sign_in: ^6.2.2
```

## Localization Keys Required

```yaml
# English (en)
auth_error_invalid_credentials: "Invalid email or password. Please try again."
auth_error_email_exists: "An account with this email already exists."
auth_error_email_exists_google: "This email is registered with Google. Please sign in with Google."
auth_error_weak_password: "Password must be at least 8 characters with uppercase, lowercase, and number."
auth_error_rate_limited: "Too many attempts. Please wait {countdown} seconds."
auth_error_network: "Network error. Please check your connection and try again."
auth_error_account_disabled: "This account has been disabled. Contact support for help."
auth_error_email_not_verified: "Please verify your email to access all features."
auth_success_password_reset: "Password reset email sent. Check your inbox."
auth_success_verification_sent: "Verification email sent. Check your inbox."
auth_error_unknown: "An unexpected error occurred. Please try again."

# Arabic (ar)
auth_error_invalid_credentials: "البريد الإلكتروني أو كلمة المرور غير صحيحة. يرجى المحاولة مرة أخرى."
auth_error_email_exists: "يوجد حساب بهذا البريد الإلكتروني بالفعل."
auth_error_email_exists_google: "هذا البريد مسجل بحساب جوجل. يرجى تسجيل الدخول بجوجل."
auth_error_weak_password: "يجب أن تكون كلمة المرور 8 أحرف على الأقل مع حرف كبير وصغير ورقم."
auth_error_rate_limited: "محاولات كثيرة. يرجى الانتظار {countdown} ثانية."
auth_error_network: "خطأ في الشبكة. يرجى التحقق من اتصالك والمحاولة مرة أخرى."
auth_error_account_disabled: "تم تعطيل هذا الحساب. تواصل مع الدعم للمساعدة."
auth_error_email_not_verified: "يرجى تأكيد بريدك الإلكتروني للوصول لجميع الميزات."
auth_success_password_reset: "تم إرسال رابط إعادة تعيين كلمة المرور. تحقق من بريدك."
auth_success_verification_sent: "تم إرسال رابط التحقق. تحقق من بريدك."
auth_error_unknown: "حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى."
```

## Security Considerations

1. **Email enumeration protection**: Use same error message for wrong-password and user-not-found
2. **Password reset security**: Always show success message regardless of email existence
3. **Rate limiting**: Prevent brute-force attacks with client + server rate limits
4. **Secure storage**: Firebase handles token storage securely per platform
5. **Google account conflict**: Block email registration if Google account exists (per clarification)
