import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  const User({
    required this.uid,
    this.lastLoginDate,
  });

  final String uid;
  final DateTime? lastLoginDate;

  User copyWith({
    String? uid,
    DateTime? lastLoginDate,
  }) {
    return User(
      uid: uid ?? this.uid,
      lastLoginDate: lastLoginDate ?? this.lastLoginDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'lastLoginDate': lastLoginDate,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    final String uid = map['uid'] as String;
    final DateTime? lastLoginDate = map['lastLoginDate'] == null
        ? null
        : (map['lastLoginDate'] as Timestamp).toDate().toUtc();

    return User(
      uid: uid,
      lastLoginDate: lastLoginDate,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() => 'User(uid: $uid, lastLoginDate: $lastLoginDate)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.uid == uid &&
        other.lastLoginDate == lastLoginDate;
  }

  @override
  int get hashCode => uid.hashCode ^ lastLoginDate.hashCode;
}
