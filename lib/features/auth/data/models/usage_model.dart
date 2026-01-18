import 'package:cloud_firestore/cloud_firestore.dart';

class UsageModel {
  final String userId;
  final Map<String, dynamic> monthly;
  final DateTime createdAt;
  final DateTime updatedAt;

  UsageModel({
    required this.userId,
    required this.monthly,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convert UsageModel to Firestore JSON
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'monthly': monthly,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// Create UsageModel from Firestore document
  factory UsageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UsageModel(
      userId: data['userId'] as String,
      monthly: Map<String, dynamic>.from(data['monthly'] as Map? ?? {}),
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.parse(data['createdAt'].toString()),
      updatedAt: data['updatedAt'] is Timestamp
          ? (data['updatedAt'] as Timestamp).toDate()
          : DateTime.parse(data['updatedAt'].toString()),
    );
  }

  /// Create UsageModel from Map
  factory UsageModel.fromMap(Map<String, dynamic> map, String userId) {
    return UsageModel(
      userId: userId,
      monthly: Map<String, dynamic>.from(map['monthly'] as Map? ?? {}),
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.parse(map['createdAt'].toString()),
      updatedAt: map['updatedAt'] is Timestamp
          ? (map['updatedAt'] as Timestamp).toDate()
          : DateTime.parse(map['updatedAt'].toString()),
    );
  }

  /// Create an empty usage document for new users
  factory UsageModel.createNewForUser(String userId) {
    final now = DateTime.now();
    return UsageModel(
      userId: userId,
      monthly: {},
      createdAt: now,
      updatedAt: now,
    );
  }
}
