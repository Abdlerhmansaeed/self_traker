# Data Model: Firebase Authentication

**Feature**: 001-firebase-auth  
**Date**: January 18, 2026

## Entities

### UserEntity (Domain Layer)

Represents an authenticated user in the domain layer. Technology-agnostic.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | String | Yes | Unique user identifier (Firebase UID) |
| `email` | String | Yes | User's email address |
| `displayName` | String | No | User's display name |
| `photoURL` | String | No | Profile photo URL (from Google) |
| `phoneNumber` | String | No | Phone number (future use) |
| `preferredCurrency` | String | Yes | Currency code (default: EGP) |
| `preferredLanguage` | String | Yes | Language code (default: en) |
| `subscriptionStatus` | SubscriptionStatus | Yes | Enum: free, pro, premium |
| `subscriptionExpiration` | DateTime | No | When subscription expires |
| `monthlyBudget` | double | No | Optional budget limit |
| `createdAt` | DateTime | Yes | Account creation timestamp |
| `lastLoginAt` | DateTime | Yes | Last successful login |
| `totalExpenses` | int | Yes | Cached expense count |
| `emailVerified` | bool | Yes | Email verification status |
| `notificationSettings` | NotificationSettings | Yes | Notification preferences |
| `metadata` | UserMetadata | Yes | Additional metadata |

### NotificationSettings (Embedded)

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `budgetAlerts` | bool | true | Alert when approaching budget |
| `weeklyReports` | bool | true | Weekly summary notifications |
| `tips` | bool | true | Helpful tips and suggestions |

### UserMetadata (Embedded)

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `onboardingCompleted` | bool | false | Has completed onboarding |
| `firstExpenseDate` | DateTime | null | Date of first expense |
| `appVersion` | String | null | Last used app version |

### SubscriptionStatus (Enum)

```dart
enum SubscriptionStatus {
  free,
  pro,
  premium,
}
```

### AuthFailure (Domain Layer)

Represents authentication failure states. Used for error handling.

| Type | Description | User Message Key |
|------|-------------|------------------|
| `InvalidCredentials` | Wrong email or password | `auth_error_invalid_credentials` |
| `EmailAlreadyInUse` | Email registered (signup) | `auth_error_email_exists` |
| `EmailExistsWithGoogle` | Email registered via Google | `auth_error_email_exists_google` |
| `WeakPassword` | Password doesn't meet requirements | `auth_error_weak_password` |
| `RateLimited` | Too many failed attempts | `auth_error_rate_limited` |
| `NetworkError` | No connectivity | `auth_error_network` |
| `AccountDisabled` | Account suspended | `auth_error_account_disabled` |
| `EmailNotVerified` | Email pending verification | `auth_error_email_not_verified` |
| `Cancelled` | User cancelled (Google) | N/A (no message) |
| `Unknown` | Unexpected error | `auth_error_unknown` |

## Relationships

```
┌─────────────────────────────────────────────────────────────┐
│                        UserEntity                           │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              NotificationSettings                    │   │
│  │  budgetAlerts, weeklyReports, tips                  │   │
│  └─────────────────────────────────────────────────────┘   │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                 UserMetadata                         │   │
│  │  onboardingCompleted, firstExpenseDate, appVersion  │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                              │
                              │ 1:1 (same userId)
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      UsageDocument                          │
│  userId, monthly/{YYYY-MM} subcollection                   │
└─────────────────────────────────────────────────────────────┘
```

## State Transitions

### Authentication State Machine

```
                    ┌──────────────┐
                    │   Initial    │
                    └──────┬───────┘
                           │
                           ▼
         ┌─────────────────────────────────┐
         │      Checking Auth State        │
         └─────────────────┬───────────────┘
                           │
              ┌────────────┴────────────┐
              ▼                         ▼
     ┌────────────────┐        ┌────────────────┐
     │ Unauthenticated│        │ Authenticated  │
     └───────┬────────┘        └───────┬────────┘
             │                         │
     ┌───────┴───────┐         ┌───────┴───────┐
     ▼               ▼         ▼               ▼
┌─────────┐   ┌───────────┐  ┌─────────┐  ┌─────────┐
│ Loading │   │   Error   │  │Verified │  │Unverified│
│(signing)│   │ (failure) │  └─────────┘  │(limited) │
└─────────┘   └───────────┘               └──────────┘
```

### Email Verification States

| State | Can Access App | Restrictions |
|-------|----------------|--------------|
| Verified | Full | None |
| Unverified | Limited | Shows verification banner |

### Rate Limiting States

| Attempt Count | State | UI Action |
|---------------|-------|-----------|
| 0-4 | Normal | Allow login |
| 5+ | Locked | Show countdown, disable login |
| After 60s | Reset | Allow login again |

## Validation Rules

### Email
- Required
- Must match email regex pattern
- Max 320 characters

### Password (Registration)
- Minimum 8 characters
- At least one uppercase letter (A-Z)
- At least one lowercase letter (a-z)
- At least one number (0-9)

### Display Name
- Optional
- Max 100 characters
- Trimmed whitespace
