# Firestore Schema: Users Collection

**Collection**: `users`  
**Document ID**: `{userId}` (Firebase Auth UID)

## Document Structure

```json
{
  "email": "string (required)",
  "displayName": "string | null",
  "photoURL": "string | null",
  "phoneNumber": "string | null",
  "preferredCurrency": "string (required, default: 'EGP')",
  "preferredLanguage": "string (required, default: 'en')",
  "subscriptionStatus": "string (required, enum: 'free' | 'pro' | 'premium', default: 'free')",
  "subscriptionExpiration": "timestamp | null",
  "monthlyBudget": "number | null",
  "createdAt": "timestamp (required, server timestamp)",
  "lastLoginAt": "timestamp (required, server timestamp)",
  "totalExpenses": "number (required, default: 0)",
  "notificationSettings": {
    "budgetAlerts": "boolean (default: true)",
    "weeklyReports": "boolean (default: true)",
    "tips": "boolean (default: true)"
  },
  "metadata": {
    "onboardingCompleted": "boolean (default: false)",
    "firstExpenseDate": "timestamp | null",
    "appVersion": "string | null"
  }
}
```

## Example Document

### New Email/Password User

```json
{
  "email": "user@example.com",
  "displayName": null,
  "photoURL": null,
  "phoneNumber": null,
  "preferredCurrency": "EGP",
  "preferredLanguage": "en",
  "subscriptionStatus": "free",
  "subscriptionExpiration": null,
  "monthlyBudget": null,
  "createdAt": "2026-01-18T10:30:00Z",
  "lastLoginAt": "2026-01-18T10:30:00Z",
  "totalExpenses": 0,
  "notificationSettings": {
    "budgetAlerts": true,
    "weeklyReports": true,
    "tips": true
  },
  "metadata": {
    "onboardingCompleted": false,
    "firstExpenseDate": null,
    "appVersion": "1.0.0"
  }
}
```

### New Google Sign-In User

```json
{
  "email": "user@gmail.com",
  "displayName": "John Doe",
  "photoURL": "https://lh3.googleusercontent.com/...",
  "phoneNumber": null,
  "preferredCurrency": "EGP",
  "preferredLanguage": "en",
  "subscriptionStatus": "free",
  "subscriptionExpiration": null,
  "monthlyBudget": null,
  "createdAt": "2026-01-18T10:30:00Z",
  "lastLoginAt": "2026-01-18T10:30:00Z",
  "totalExpenses": 0,
  "notificationSettings": {
    "budgetAlerts": true,
    "weeklyReports": true,
    "tips": true
  },
  "metadata": {
    "onboardingCompleted": false,
    "firstExpenseDate": null,
    "appVersion": "1.0.0"
  }
}
```

## Indexes

| Fields | Order | Purpose |
|--------|-------|---------|
| `email` | ASC | User lookup by email |
| `subscriptionStatus` | ASC | Filter by subscription tier |
| `createdAt` | DESC | Sort users by registration date |

## Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      // Users can only read/write their own document
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      // Validate required fields on create
      allow create: if request.auth != null 
        && request.auth.uid == userId
        && request.resource.data.keys().hasAll(['email', 'preferredCurrency', 'preferredLanguage', 'subscriptionStatus', 'createdAt', 'lastLoginAt', 'totalExpenses', 'notificationSettings', 'metadata']);
      
      // Prevent modification of certain fields
      allow update: if request.auth != null 
        && request.auth.uid == userId
        && request.resource.data.createdAt == resource.data.createdAt;  // Can't change createdAt
    }
  }
}
```
