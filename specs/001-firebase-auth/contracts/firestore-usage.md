# Firestore Schema: Usage Collection

**Collection**: `usage`  
**Document ID**: `{userId}` (Firebase Auth UID)

## Document Structure

```json
{
  // Parent document can be empty or contain aggregate data
}
```

## Subcollection: `monthly`

**Path**: `usage/{userId}/monthly/{YYYY-MM}`  
**Document ID**: Year-month format (e.g., `2026-01`)

```json
{
  "voiceCount": "number (required, default: 0)",
  "manualCount": "number (required, default: 0)",
  "ocrCount": "number (required, default: 0)",
  "lastUsed": "timestamp | null",
  "resetDate": "timestamp (required, first day of month)"
}
```

## Example Documents

### Parent Document (usage/{userId})

```json
{
  // Empty or future aggregate fields
}
```

### Monthly Subcollection (usage/{userId}/monthly/2026-01)

```json
{
  "voiceCount": 15,
  "manualCount": 42,
  "ocrCount": 3,
  "lastUsed": "2026-01-18T14:30:00Z",
  "resetDate": "2026-01-01T00:00:00Z"
}
```

### Initial Monthly Document (new user)

```json
{
  "voiceCount": 0,
  "manualCount": 0,
  "ocrCount": 0,
  "lastUsed": null,
  "resetDate": "2026-01-01T00:00:00Z"
}
```

## Indexes

| Fields | Order | Purpose |
|--------|-------|---------|
| None required | - | Document accessed by known path |

## Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Usage collection
    match /usage/{userId} {
      // Users can only read/write their own usage document
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      // Monthly subcollection
      match /monthly/{monthId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
        
        // Validate month ID format (YYYY-MM)
        allow create: if monthId.matches('^[0-9]{4}-[0-9]{2}$');
      }
    }
  }
}
```

## Creation Logic

When a new user registers:

1. Create parent `usage/{userId}` document (empty or with defaults)
2. Create `usage/{userId}/monthly/{currentMonth}` document with:
   - All counts set to 0
   - `lastUsed` set to null
   - `resetDate` set to first day of current month

This is done atomically with user document creation using a batch write.
