import 'package:equatable/equatable.dart';
import 'notification_settings.dart';
import 'subscription_status.dart';
import 'user_metadata.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final String? photoURL;
  final String? phoneNumber;
  final String preferredCurrency;
  final String preferredLanguage;
  final SubscriptionStatus subscriptionStatus;
  final DateTime? subscriptionExpiration;
  final double? monthlyBudget;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final int totalExpenses;
  final bool emailVerified;
  final NotificationSettings notificationSettings;
  final UserMetadata metadata;

  const UserEntity({
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

  UserEntity copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoURL,
    String? phoneNumber,
    String? preferredCurrency,
    String? preferredLanguage,
    SubscriptionStatus? subscriptionStatus,
    DateTime? subscriptionExpiration,
    double? monthlyBudget,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    int? totalExpenses,
    bool? emailVerified,
    NotificationSettings? notificationSettings,
    UserMetadata? metadata,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      preferredCurrency: preferredCurrency ?? this.preferredCurrency,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
      subscriptionExpiration:
          subscriptionExpiration ?? this.subscriptionExpiration,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      totalExpenses: totalExpenses ?? this.totalExpenses,
      emailVerified: emailVerified ?? this.emailVerified,
      notificationSettings:
          notificationSettings ?? this.notificationSettings,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        photoURL,
        phoneNumber,
        preferredCurrency,
        preferredLanguage,
        subscriptionStatus,
        subscriptionExpiration,
        monthlyBudget,
        createdAt,
        lastLoginAt,
        totalExpenses,
        emailVerified,
        notificationSettings,
        metadata,
      ];
}
