import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  const User({
    required this.uid,
    this.plaidAccessToken,
    this.plaidItemId,
    this.plaidRequestId,
    this.lastPlaidSyncTime,
  });

  final String uid;
  final String? plaidAccessToken;
  final String? plaidItemId;
  final String? plaidRequestId;
  final DateTime? lastPlaidSyncTime;

  // factory User.fromJson(Map<String, dynamic> json) {
  //   final String uid = json['uid'] as String;
  //   final String? plaidAccessToken = json['plaidAccessToken'] as String?;
  //   final String? plaidItemId = json['plaidItemId'] as String?;
  //   final String? plaidRequestId = json['plaidRequestId'] as String?;
  //   final DateTime? lastPlaidSyncTime = json['lastPlaidSyncTime'] == null
  //       ? null
  //       : (json['lastPlaidSyncTime'] as Timestamp).toDate();

  //   return User(
  //     uid: uid,
  //     plaidAccessToken: plaidAccessToken,
  //     plaidItemId: plaidItemId,
  //     plaidRequestId: plaidRequestId,
  //     lastPlaidSyncTime: lastPlaidSyncTime,
  //   );
  // }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'uid': uid,
  //     'plaidAccessToken': plaidAccessToken,
  //     'plaidItemId': plaidItemId,
  //     'plaidRequestId': plaidRequestId,
  //     'lastPlaidSyncTime': lastPlaidSyncTime?.toIso8601String(),
  //   };
  // }

  User copyWith({
    String? uid,
    String? plaidAccessToken,
    String? plaidItemId,
    String? plaidRequestId,
    DateTime? lastPlaidSyncTime,
  }) {
    return User(
      uid: uid ?? this.uid,
      plaidAccessToken: plaidAccessToken ?? this.plaidAccessToken,
      plaidItemId: plaidItemId ?? this.plaidItemId,
      plaidRequestId: plaidRequestId ?? this.plaidRequestId,
      lastPlaidSyncTime: lastPlaidSyncTime ?? this.lastPlaidSyncTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'plaidAccessToken': plaidAccessToken,
      'plaidItemId': plaidItemId,
      'plaidRequestId': plaidRequestId,
      'lastPlaidSyncTime': lastPlaidSyncTime?.millisecondsSinceEpoch,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    final String uid = map['uid'] as String;
    final String? plaidAccessToken = map['plaidAccessToken'] as String?;
    final String? plaidItemId = map['plaidItemId'] as String?;
    final String? plaidRequestId = map['plaidRequestId'] as String?;
    final DateTime? lastPlaidSyncTime = map['lastPlaidSyncTime'] == null
        ? null
        : (map['lastPlaidSyncTime'] as Timestamp).toDate();

    return User(
      uid: uid,
      plaidAccessToken: plaidAccessToken,
      lastPlaidSyncTime: lastPlaidSyncTime,
      plaidItemId: plaidItemId,
      plaidRequestId: plaidRequestId,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(uid: $uid, plaidAccessToken: $plaidAccessToken, plaidItemId: $plaidItemId, plaidRequestId: $plaidRequestId, lastPlaidSyncTime: $lastPlaidSyncTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.uid == uid &&
        other.plaidAccessToken == plaidAccessToken &&
        other.plaidItemId == plaidItemId &&
        other.plaidRequestId == plaidRequestId &&
        other.lastPlaidSyncTime == lastPlaidSyncTime;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        plaidAccessToken.hashCode ^
        plaidItemId.hashCode ^
        plaidRequestId.hashCode ^
        lastPlaidSyncTime.hashCode;
  }
}
