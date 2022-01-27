import 'dart:convert';

import 'supported_methods.dart';

/// Metadata that captures information about the Auth features of an
/// institution.
class AuthMetadata {
  const AuthMetadata({
    this.supportedMethods,
  });

  /// Metadata specifically related to which auth methods an institution
  /// supports.
  final SupportedMethods? supportedMethods;

  AuthMetadata copyWith({
    SupportedMethods? supportedMethods,
  }) {
    return AuthMetadata(
      supportedMethods: supportedMethods ?? this.supportedMethods,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'supported_methods': supportedMethods?.toMap(),
    };
  }

  factory AuthMetadata.fromMap(Map<String, dynamic> map) {
    return AuthMetadata(
      supportedMethods: map['supported_methods'] != null
          ? SupportedMethods.fromMap(map['supported_methods'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthMetadata.fromJson(String source) =>
      AuthMetadata.fromMap(json.decode(source));

  @override
  String toString() => 'AuthMetadata(supportedMethods: $supportedMethods)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthMetadata && other.supportedMethods == supportedMethods;
  }

  @override
  int get hashCode => supportedMethods.hashCode;
}
