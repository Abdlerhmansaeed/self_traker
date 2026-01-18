class UserMetadata {
  final bool onboardingCompleted;
  final DateTime? firstExpenseDate;
  final String? appVersion;

  UserMetadata({
    this.onboardingCompleted = false,
    this.firstExpenseDate,
    this.appVersion,
  });

  UserMetadata copyWith({
    bool? onboardingCompleted,
    DateTime? firstExpenseDate,
    String? appVersion,
  }) {
    return UserMetadata(
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      firstExpenseDate: firstExpenseDate ?? this.firstExpenseDate,
      appVersion: appVersion ?? this.appVersion,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'onboardingCompleted': onboardingCompleted,
      'firstExpenseDate': firstExpenseDate,
      'appVersion': appVersion,
    };
  }

  factory UserMetadata.fromMap(Map<String, dynamic> map) {
    return UserMetadata(
      onboardingCompleted: map['onboardingCompleted'] as bool? ?? false,
      firstExpenseDate: map['firstExpenseDate'] is DateTime
          ? map['firstExpenseDate']
          : (map['firstExpenseDate'] != null
              ? DateTime.parse(map['firstExpenseDate'].toString())
              : null),
      appVersion: map['appVersion'] as String?,
    );
  }
}
