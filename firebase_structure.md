📁 users (collection)
  └─ {userId} (document)
      ├─ email: string
      ├─ displayName: string
      ├─ photoURL: string (from social login)
      ├─ phoneNumber: string (optional)
      ├─ preferredCurrency: string (EGP, USD, etc.)
      ├─ preferredLanguage: string (ar, en, ar-en)
      ├─ subscriptionStatus: string (free, pro, premium)
      ├─ subscriptionExpiration: timestamp
      ├─ monthlyBudget: number (optional)
      ├─ createdAt: timestamp
      ├─ lastLoginAt: timestamp
      ├─ totalExpenses: number (cached count)
      ├─ notificationSettings: map
      │   ├─ budgetAlerts: boolean
      │   ├─ weeklyReports: boolean
      │   └─ tips: boolean
      └─ metadata: map
          ├─ onboardingCompleted: boolean
          ├─ firstExpenseDate: timestamp
          └─ appVersion: string

📁 expenses (collection)
  └─ {expenseId} (document)
      ├─ userId: string (indexed)
      ├─ amount: number
      ├─ currency: string
      ├─ category: string
      ├─ description: string
      ├─ date: timestamp
      ├─ createdAt: timestamp
      ├─ createdBy: string (voice, manual, ocr)
      ├─ voiceInput: string (original text, optional)
      ├─ confidence: number (AI confidence score)
      ├─ receiptURL: string (optional - Storage path)
      ├─ isRecurring: boolean
      ├─ recurringId: string (optional - links to recurring template)
      └─ tags: array<string> (optional)

📁 usage (collection)
  └─ {userId} (document)
      └─ 📁 monthly (subcollection)
          └─ {YYYY-MM} (document)
              ├─ voiceCount: number
              ├─ manualCount: number
              ├─ ocrCount: number
              ├─ lastUsed: timestamp
              └─ resetDate: timestamp

📁 categories (collection)
  └─ {userId} (document)
      └─ custom: array<string>
          ["Freelance Income", "Pet Expenses", "Gym"]

📁 budgets (collection)
  └─ {userId} (document)
      └─ 📁 monthly (subcollection)
          └─ {YYYY-MM} (document)
              ├─ totalBudget: number
              ├─ spent: number (cached)
              └─ categories: map
                  ├─ Food: {budget: 2000, spent: 1543}
                  ├─ Transport: {budget: 500, spent: 320}
                  └─ ...

📁 recurring_expenses (collection)
  └─ {recurringId} (document)
      ├─ userId: string (indexed)
      ├─ amount: number
      ├─ currency: string
      ├─ category: string
      ├─ description: string
      ├─ frequency: string (daily, weekly, monthly, yearly)
      ├─ startDate: timestamp
      ├─ endDate: timestamp (optional)
      ├─ lastGenerated: timestamp
      ├─ nextDue: timestamp
      └─ isActive: boolean

📁 family_groups (collection) [Premium Feature]
  └─ {groupId} (document)
      ├─ ownerId: string
      ├─ name: string
      ├─ members: array<string> (userIds)
      ├─ invitePending: array<string> (emails)
      ├─ sharedBudget: number
      ├─ createdAt: timestamp
      └─ settings: map