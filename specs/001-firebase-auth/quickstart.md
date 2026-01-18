# Quickstart: Firebase Authentication Implementation

**Feature**: 001-firebase-auth  
**Date**: January 18, 2026

## Prerequisites

1. Firebase project configured in Firebase Console
2. Android: `google-services.json` in `android/app/` ✓ (already present)
3. iOS: `GoogleService-Info.plist` in `ios/Runner/`
4. Google Sign-In enabled in Firebase Console Authentication providers
5. SHA-1 fingerprint added to Firebase Console (Android)

## Quick Setup

### 1. Add Dependencies

```yaml
# pubspec.yaml
dependencies:
  firebase_auth: ^5.5.1
  cloud_firestore: ^5.6.5
  google_sign_in: ^6.2.2
```

Run: `flutter pub get`

### 2. Register Dependencies (Injectable)

```dart
// lib/core/di/injection.dart
@module
abstract class AuthModule {
  @lazySingleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;
  
  @lazySingleton
  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  
  @lazySingleton
  GoogleSignIn get googleSignIn => GoogleSignIn();
}
```

### 3. Implement Data Source

```dart
// lib/features/auth/data/datasources/auth_remote_data_source_impl.dart
@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;
  
  // Implement methods...
}
```

### 4. Wire Up Cubit

```dart
// lib/features/auth/presentation/cubit/auth_cubit.dart
@injectable
class AuthCubit extends Cubit<AuthState> {
  final SignInWithEmailUseCase _signInWithEmail;
  final SignInWithGoogleUseCase _signInWithGoogle;
  // ...
}
```

### 5. Connect UI

```dart
// In login screen
BlocProvider(
  create: (_) => getIt<AuthCubit>(),
  child: LoginScreen(),
)
```

## Key Files to Create/Modify

| File | Action | Purpose |
|------|--------|---------|
| `pubspec.yaml` | Modify | Add Firebase dependencies |
| `lib/core/di/injection.dart` | Modify | Register auth dependencies |
| `lib/features/auth/data/models/user_model.dart` | Create | Firestore serialization |
| `lib/features/auth/data/datasources/auth_remote_data_source.dart` | Modify | Define interface methods |
| `lib/features/auth/data/datasources/auth_remote_data_source_impl.dart` | Modify | Firebase implementation |
| `lib/features/auth/domain/entities/user_entity.dart` | Create | Domain user entity |
| `lib/features/auth/domain/entities/auth_failure.dart` | Create | Failure types |
| `lib/features/auth/domain/repositories/auth_repository.dart` | Create | Repository interface |
| `lib/features/auth/data/repositories/auth_repository_impl.dart` | Create | Repository implementation |
| `lib/features/auth/domain/usecases/*.dart` | Create | Use case classes |
| `lib/features/auth/presentation/cubit/auth_cubit.dart` | Create | State management |
| `lib/features/auth/presentation/cubit/auth_state.dart` | Create | State classes |
| `lib/features/auth/exceptions/auth_exceptions.dart` | Modify | Error mapping |

## Testing Quick Commands

```bash
# Run unit tests
flutter test test/features/auth/

# Run with coverage
flutter test --coverage test/features/auth/

# Analyze code
flutter analyze
```

## Verification Checklist

- [ ] Can register with email/password
- [ ] Verification email is sent
- [ ] Can sign in with Google
- [ ] User document created in Firestore
- [ ] Usage document created in Firestore
- [ ] Error messages display in correct language
- [ ] Rate limiting works after 5 failed attempts
- [ ] Session persists after app restart
- [ ] Unverified users see verification banner

## Common Issues

### Google Sign-In Not Working (Android)

1. Verify SHA-1 fingerprint in Firebase Console
2. Run: `cd android && ./gradlew signingReport`
3. Add both debug and release SHA-1

### Google Sign-In Not Working (iOS)

1. Add URL scheme to `ios/Runner/Info.plist`:
```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>com.googleusercontent.apps.YOUR_CLIENT_ID</string>
    </array>
  </dict>
</array>
```

### Firestore Permission Denied

1. Check security rules in Firebase Console
2. Verify user is authenticated before Firestore operations
3. Ensure document path matches `users/{userId}` pattern
