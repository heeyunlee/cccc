import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class User {
  const User({
    required this.uid,
    this.lastPlaidSyncTime,
    this.lastLoginDate,
    this.favoriteAccountId,
    required this.accountIds,
  });

  final String uid;
  final DateTime? lastPlaidSyncTime;
  final DateTime? lastLoginDate;
  final String? favoriteAccountId;
  final List<String> accountIds;

  User copyWith({
    String? uid,
    DateTime? lastPlaidSyncTime,
    DateTime? lastLoginDate,
    String? favoriteAccountId,
    List<String>? accountIds,
  }) {
    return User(
      uid: uid ?? this.uid,
      lastPlaidSyncTime: lastPlaidSyncTime ?? this.lastPlaidSyncTime,
      lastLoginDate: lastLoginDate ?? this.lastLoginDate,
      favoriteAccountId: favoriteAccountId ?? this.favoriteAccountId,
      accountIds: accountIds ?? this.accountIds,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'lastPlaidSyncTime': lastPlaidSyncTime,
      'lastLoginDate': lastLoginDate,
      'favoriteAccountId': favoriteAccountId,
      'accountIds': accountIds,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    final String uid = map['uid'] as String;
    final DateTime? lastPlaidSyncTime = map['lastPlaidSyncTime'] == null
        ? null
        : (map['lastPlaidSyncTime'] as Timestamp).toDate();
    final DateTime? lastLoginDate = map['lastLoginDate'] == null
        ? null
        : (map['lastLoginDate'] as Timestamp).toDate();
    final String? favoriteAccountId = map['favoriteAccountId'];
    final List<String> accountsIds =
        map['accountIds'].map<String>((e) => e.toString()).toList();

    return User(
      uid: uid,
      lastPlaidSyncTime: lastPlaidSyncTime,
      lastLoginDate: lastLoginDate,
      favoriteAccountId: favoriteAccountId,
      accountIds: accountsIds,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(uid: $uid, lastPlaidSyncTime: $lastPlaidSyncTime, lastLoginDate: $lastLoginDate, favoriteAccountId: $favoriteAccountId, accountIds: $accountIds)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.uid == uid &&
        other.lastPlaidSyncTime == lastPlaidSyncTime &&
        other.lastLoginDate == lastLoginDate &&
        other.favoriteAccountId == favoriteAccountId &&
        listEquals(other.accountIds, accountIds);
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        lastPlaidSyncTime.hashCode ^
        lastLoginDate.hashCode ^
        favoriteAccountId.hashCode ^
        accountIds.hashCode;
  }
}
