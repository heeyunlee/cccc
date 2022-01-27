import 'dart:convert';

/// Metadata specifically related to which auth methods an institution supports.
class SupportedMethods {
  const SupportedMethods({
    required this.instantAuth,
    required this.instantMatch,
    required this.automatedMicroDeposits,
  });

  /// Indicates if instant auth is supported.
  final bool instantAuth;

  /// Indicates if instant match is supported.
  final bool instantMatch;

  /// Indicates if automated microdeposits are supported.
  final bool automatedMicroDeposits;

  SupportedMethods copyWith({
    bool? instantAuth,
    bool? instantMatch,
    bool? automatedMicroDeposits,
  }) {
    return SupportedMethods(
      instantAuth: instantAuth ?? this.instantAuth,
      instantMatch: instantMatch ?? this.instantMatch,
      automatedMicroDeposits:
          automatedMicroDeposits ?? this.automatedMicroDeposits,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'instant_auth': instantAuth,
      'instant_match': instantMatch,
      'automated_micro_deposits': automatedMicroDeposits,
    };
  }

  factory SupportedMethods.fromMap(Map<String, dynamic> map) {
    return SupportedMethods(
      instantAuth: map['instant_auth'] ?? false,
      instantMatch: map['instant_match'] ?? false,
      automatedMicroDeposits: map['automated_micro_deposits'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory SupportedMethods.fromJson(String source) =>
      SupportedMethods.fromMap(json.decode(source));

  @override
  String toString() =>
      'SupportedMethods(instantAuth: $instantAuth, instantMatch: $instantMatch, automatedMicroDeposits: $automatedMicroDeposits)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SupportedMethods &&
        other.instantAuth == instantAuth &&
        other.instantMatch == instantMatch &&
        other.automatedMicroDeposits == automatedMicroDeposits;
  }

  @override
  int get hashCode =>
      instantAuth.hashCode ^
      instantMatch.hashCode ^
      automatedMicroDeposits.hashCode;
}
