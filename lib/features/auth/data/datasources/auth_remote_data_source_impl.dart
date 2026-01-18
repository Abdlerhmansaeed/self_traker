import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import '../models/user_model.dart';
import '../models/usage_model.dart';
import 'auth_remote_data_source.dart';

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSourceImpl({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn();

  @override
  User? getCurrentFirebaseUser() => _firebaseAuth.currentUser;

  @override
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      // Check if email is already registered with Google
      final isGoogleLinked = await checkEmailExistsWithGoogle(email);
      if (isGoogleLinked) {
        throw FirebaseAuthException(
          code: 'email-exists-with-google',
          message: 'This email is registered with Google Sign-In',
        );
      }

      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('User creation failed');
      }

      // Update display name
      await user.updateDisplayName(displayName);
      await user.reload();

      // Create user and usage documents atomically
      await _createUserAndUsageDocuments(
        userId: user.uid,
        email: email,
        displayName: displayName,
        photoURL: user.photoURL,
      );

      // Send verification email
      try {
        await user.sendEmailVerification();
      } catch (e) {
        // Verification email failed, but user is created - continue
      }

      // Get and return the user document
      final userDoc = await getUserDocument(user.uid);
      return userDoc ?? _createDefaultUserModel(user);
    } on FirebaseAuthException {
      rethrow;
    }
  }

  @override
  Future<void> sendVerificationEmail() async {
    final user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  @override
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('Sign-in failed');
      }

      // Update last login time
      await updateLastLoginAt(user.uid);

      // Get user document from Firestore
      final userModel = await getUserDocument(user.uid);
      return userModel ?? _createDefaultUserModel(user);
    } on FirebaseAuthException {
      rethrow;
    }
  }

  @override
  Future<void> updateLastLoginAt(String userId) async {
    await _firestore.collection('users').doc(userId).update({
      'lastLoginAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google sign in cancelled');
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      final user = userCredential.user;

      if (user == null) {
        throw Exception('Google sign-in failed');
      }

      // Check if this is a new user
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        // Create user document for new Google users
        await _createUserAndUsageDocuments(
          userId: user.uid,
          email: user.email!,
          displayName: user.displayName,
          photoURL: user.photoURL,
        );
      } else {
        // Update last login for existing users
        await updateLastLoginAt(user.uid);
      }

      // Get user document from Firestore
      final userModel = await getUserDocument(user.uid);
      return userModel ?? _createDefaultUserModel(user);
    } on FirebaseAuthException {
      rethrow;
    }
  }

  @override
  Future<bool> checkUserExists(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return doc.exists;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> signOut() async {
    await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
  }

  @override
  Future<void> createUserDocument({
    required String userId,
    required String email,
    String? displayName,
    String? photoURL,
    required String preferredCurrency,
    required String preferredLanguage,
  }) async {
    final now = DateTime.now();
    final userModel = UserModel(
      id: userId,
      email: email,
      displayName: displayName,
      photoURL: photoURL,
      phoneNumber: null,
      preferredCurrency: preferredCurrency,
      preferredLanguage: preferredLanguage,
      subscriptionStatus: 'free',
      subscriptionExpiration: null,
      monthlyBudget: null,
      createdAt: now,
      lastLoginAt: now,
      totalExpenses: 0,
      emailVerified: false,
      notificationSettings: {
        'budgetAlerts': true,
        'weeklyReports': true,
        'tips': true,
      },
      metadata: {'onboardingCompleted': false},
    );

    await _firestore
        .collection('users')
        .doc(userId)
        .set(userModel.toFirestore(), SetOptions(merge: true));
  }

  @override
  Future<void> createUsageDocument({required String userId}) async {
    final usageModel = UsageModel.createNewForUser(userId);
    await _firestore
        .collection('usage')
        .doc(userId)
        .set(usageModel.toFirestore(), SetOptions(merge: true));
  }

  @override
  Future<UserModel?> getUserDocument(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() ?? {}, userId);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Create user and usage documents atomically with batch write
  Future<void> _createUserAndUsageDocuments({
    required String userId,
    required String email,
    String? displayName,
    String? photoURL,
    String preferredCurrency = 'EGP',
    String preferredLanguage = 'en',
  }) async {
    final batch = _firestore.batch();
    final now = DateTime.now();

    // Create user document
    final userModel = UserModel(
      id: userId,
      email: email,
      displayName: displayName,
      photoURL: photoURL,
      phoneNumber: null,
      preferredCurrency: preferredCurrency,
      preferredLanguage: preferredLanguage,
      subscriptionStatus: 'free',
      subscriptionExpiration: null,
      monthlyBudget: null,
      createdAt: now,
      lastLoginAt: now,
      totalExpenses: 0,
      emailVerified: false,
      notificationSettings: {
        'budgetAlerts': true,
        'weeklyReports': true,
        'tips': true,
      },
      metadata: {'onboardingCompleted': false},
    );

    batch.set(
      _firestore.collection('users').doc(userId),
      userModel.toFirestore(),
    );

    // Create usage document
    final usageModel = UsageModel.createNewForUser(userId);
    batch.set(
      _firestore.collection('usage').doc(userId),
      usageModel.toFirestore(),
    );

    await batch.commit();
  }

  /// Create a default UserModel from Firebase User
  UserModel _createDefaultUserModel(User user) {
    final now = DateTime.now();
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoURL: user.photoURL,
      phoneNumber: user.phoneNumber,
      preferredCurrency: 'EGP',
      preferredLanguage: 'en',
      subscriptionStatus: 'free',
      subscriptionExpiration: null,
      monthlyBudget: null,
      createdAt: now,
      lastLoginAt: now,
      totalExpenses: 0,
      emailVerified: user.emailVerified,
      notificationSettings: {
        'budgetAlerts': true,
        'weeklyReports': true,
        'tips': true,
      },
      metadata: {'onboardingCompleted': false},
    );
  }

  @override
  Future<bool> checkEmailExistsWithGoogle(String email) async {
    try {
      final signInMethods = await _firebaseAuth.fetchSignInMethodsForEmail(
        email,
      );
      // Check if 'google.com' is in the sign-in methods
      return signInMethods.contains('google.com');
    } on FirebaseAuthException catch (e) {
      // If the email doesn't exist, fetchSignInMethodsForEmail returns an empty list
      // If there's an error, we'll assume it's not a Google account
      if (e.code == 'invalid-email') {
        return false;
      }
      rethrow;
    }
  }
}
