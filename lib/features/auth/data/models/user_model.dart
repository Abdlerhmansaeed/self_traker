import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/notification_settings.dart';
import '../../domain/entities/subscription_status.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/user_metadata.dart';

class UserModel {
  final String id;
  final String email;
  final String? displayName;
  final String? photoURL;
  final String? phoneNumber;
  final String preferredCurrency;
  final String preferredLanguage;
  final String subscriptionStatus;
  final DateTime? subscriptionExpiration;
  final double? monthlyBudget;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final int totalExpenses;
  final bool emailVerified;
  final Map<String, dynamic> notificationSettings;
  final Map<String, dynamic> metadata;

  UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.photoURL,
    this.phoneNumber,
    required this.preferredCurrency,
    required this.preferredLanguage,
    required this.subscriptionStatus,
    this.subscriptionExpiration,
    this.monthlyBudget,
    required this.createdAt,
    required this.lastLoginAt,
    required this.totalExpenses,
    required this.emailVerified,
    required this.notificationSettings,
    required this.metadata,
  });

  /// Convert UserModel to UserEntity (domain layer)
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      displayName: displayName,
      photoURL: photoURL,
      phoneNumber: phoneNumber,
      preferredCurrency: preferredCurrency,
      preferredLanguage: preferredLanguage,
      subscriptionStatus: _parseSubscriptionStatus(subscriptionStatus),
      subscriptionExpiration: subscriptionExpiration,
      monthlyBudget: monthlyBudget,
      createdAt: createdAt,
      lastLoginAt: lastLoginAt,
      totalExpenses: totalExpenses,
      emailVerified: emailVerified,
      notificationSettings: NotificationSettings.fromMap(notificationSettings),
      metadata: UserMetadata.fromMap(metadata),
    );
  }

  /// Convert UserModel to Firestore JSON
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'phoneNumber': phoneNumber,
      'preferredCurrency': preferredCurrency,
      'preferredLanguage': preferredLanguage,
      'subscriptionStatus': subscriptionStatus,
      'subscriptionExpiration': subscriptionExpiration,
      'monthlyBudget': monthlyBudget,
      'createdAt': createdAt,
      'lastLoginAt': lastLoginAt,
      'totalExpenses': totalExpenses,
      'emailVerified': emailVerified,
      'notificationSettings': notificationSettings,
      'metadata': metadata,
    };
  }

  /// Create UserModel from Firestore document
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromMap(data, doc.id);
  }

  /// Create UserModel from Map
  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      email: map['email'] as String,
      displayName: map['displayName'] as String?,
      photoURL: map['photoURL'] as String?,
      phoneNumber: map['phoneNumber'] as String?,
      preferredCurrency: map['preferredCurrency'] as String? ?? 'EGP',
      preferredLanguage: map['preferredLanguage'] as String? ?? 'en',
      subscriptionStatus: map['subscriptionStatus'] as String? ?? 'free',
      subscriptionExpiration: map['subscriptionExpiration'] is Timestamp
          ? (map['subscriptionExpiration'] as Timestamp).toDate()
          : (map['subscriptionExpiration'] != null
                ? DateTime.parse(map['subscriptionExpiration'].toString())
                : null),
      monthlyBudget: (map['monthlyBudget'] as num?)?.toDouble(),
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.parse(map['createdAt'].toString()),
      lastLoginAt: map['lastLoginAt'] is Timestamp
          ? (map['lastLoginAt'] as Timestamp).toDate()
          : DateTime.parse(map['lastLoginAt'].toString()),
      totalExpenses: map['totalExpenses'] as int? ?? 0,
      emailVerified: map['emailVerified'] as bool? ?? false,
      notificationSettings: Map<String, dynamic>.from(
        map['notificationSettings'] as Map? ??
            {'budgetAlerts': true, 'weeklyReports': true, 'tips': true},
      ),
      metadata: Map<String, dynamic>.from(
        map['metadata'] as Map? ?? {'onboardingCompleted': false},
      ),
    );
  }

  static SubscriptionStatus _parseSubscriptionStatus(String status) {
    switch (status) {
      case 'pro':
        return SubscriptionStatus.pro;
      case 'premium':
        return SubscriptionStatus.premium;
      case 'free':
      default:
        return SubscriptionStatus.free;
    }
  }
}
