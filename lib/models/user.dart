import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class User {
  const User({
    required this.uid,
    this.plaidAccessToken,
    this.plaidItemId,
    this.plaidRequestId,
    this.lastPlaidSyncTime,
    this.lastLoginDate,
    this.favoriteAccountId,
    required this.accountsIds,
  });

  final String uid;
  final String? plaidAccessToken;
  final String? plaidItemId;
  final String? plaidRequestId;
  final DateTime? lastPlaidSyncTime;
  final DateTime? lastLoginDate;
  final String? favoriteAccountId;
  final List<String> accountsIds;

  User copyWith({
    String? uid,
    String? plaidAccessToken,
    String? plaidItemId,
    String? plaidRequestId,
    DateTime? lastPlaidSyncTime,
    DateTime? lastLoginDate,
    String? favoriteAccountId,
    List<String>? accountsIds,
  }) {
    return User(
      uid: uid ?? this.uid,
      plaidAccessToken: plaidAccessToken ?? this.plaidAccessToken,
      plaidItemId: plaidItemId ?? this.plaidItemId,
      plaidRequestId: plaidRequestId ?? this.plaidRequestId,
      lastPlaidSyncTime: lastPlaidSyncTime ?? this.lastPlaidSyncTime,
      lastLoginDate: lastLoginDate ?? this.lastLoginDate,
      favoriteAccountId: favoriteAccountId ?? this.favoriteAccountId,
      accountsIds: accountsIds ?? this.accountsIds,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'plaidAccessToken': plaidAccessToken,
      'plaidItemId': plaidItemId,
      'plaidRequestId': plaidRequestId,
      'lastPlaidSyncTime': lastPlaidSyncTime,
      'lastLoginDate': lastLoginDate,
      'favoriteAccountId': favoriteAccountId,
      'accountsIds': accountsIds,
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
    final DateTime? lastLoginDate = map['lastLoginDate'] == null
        ? null
        : (map['lastLoginDate'] as Timestamp).toDate();
    final String? favoriteAccountId = map['favoriteAccountId'];
    final List<String> accountsIds =
        map['accountsIds'].map<String>((e) => e.toString()).toList();

    return User(
      uid: uid,
      plaidAccessToken: plaidAccessToken,
      lastPlaidSyncTime: lastPlaidSyncTime,
      plaidItemId: plaidItemId,
      plaidRequestId: plaidRequestId,
      lastLoginDate: lastLoginDate,
      favoriteAccountId: favoriteAccountId,
      accountsIds: accountsIds,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(uid: $uid, plaidAccessToken: $plaidAccessToken, plaidItemId: $plaidItemId, plaidRequestId: $plaidRequestId, lastPlaidSyncTime: $lastPlaidSyncTime, lastLoginDate: $lastLoginDate, favoriteAccountId: $favoriteAccountId, accountsIds: $accountsIds)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.uid == uid &&
        other.plaidAccessToken == plaidAccessToken &&
        other.plaidItemId == plaidItemId &&
        other.plaidRequestId == plaidRequestId &&
        other.lastPlaidSyncTime == lastPlaidSyncTime &&
        other.lastLoginDate == lastLoginDate &&
        other.favoriteAccountId == favoriteAccountId &&
        listEquals(other.accountsIds, accountsIds);
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        plaidAccessToken.hashCode ^
        plaidItemId.hashCode ^
        plaidRequestId.hashCode ^
        lastPlaidSyncTime.hashCode ^
        lastLoginDate.hashCode ^
        favoriteAccountId.hashCode ^
        accountsIds.hashCode;
  }
}
