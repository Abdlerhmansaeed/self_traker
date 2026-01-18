class NotificationSettings {
  final bool budgetAlerts;
  final bool weeklyReports;
  final bool tips;

  NotificationSettings({
    this.budgetAlerts = true,
    this.weeklyReports = true,
    this.tips = true,
  });

  NotificationSettings copyWith({
    bool? budgetAlerts,
    bool? weeklyReports,
    bool? tips,
  }) {
    return NotificationSettings(
      budgetAlerts: budgetAlerts ?? this.budgetAlerts,
      weeklyReports: weeklyReports ?? this.weeklyReports,
      tips: tips ?? this.tips,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'budgetAlerts': budgetAlerts,
      'weeklyReports': weeklyReports,
      'tips': tips,
    };
  }

  factory NotificationSettings.fromMap(Map<String, dynamic> map) {
    return NotificationSettings(
      budgetAlerts: map['budgetAlerts'] as bool? ?? true,
      weeklyReports: map['weeklyReports'] as bool? ?? true,
      tips: map['tips'] as bool? ?? true,
    );
  }
}
