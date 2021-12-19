// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'personal_finance_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PersonalFinanceCategory _$PersonalFinanceCategoryFromJson(
    Map<String, dynamic> json) {
  return _PersonalFinanceCategory.fromJson(json);
}

/// @nodoc
class _$PersonalFinanceCategoryTearOff {
  const _$PersonalFinanceCategoryTearOff();

  _PersonalFinanceCategory call(
      {required String primary, required String detailed}) {
    return _PersonalFinanceCategory(
      primary: primary,
      detailed: detailed,
    );
  }

  PersonalFinanceCategory fromJson(Map<String, Object?> json) {
    return PersonalFinanceCategory.fromJson(json);
  }
}

/// @nodoc
const $PersonalFinanceCategory = _$PersonalFinanceCategoryTearOff();

/// @nodoc
mixin _$PersonalFinanceCategory {
  String get primary => throw _privateConstructorUsedError;
  String get detailed => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PersonalFinanceCategoryCopyWith<PersonalFinanceCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PersonalFinanceCategoryCopyWith<$Res> {
  factory $PersonalFinanceCategoryCopyWith(PersonalFinanceCategory value,
          $Res Function(PersonalFinanceCategory) then) =
      _$PersonalFinanceCategoryCopyWithImpl<$Res>;
  $Res call({String primary, String detailed});
}

/// @nodoc
class _$PersonalFinanceCategoryCopyWithImpl<$Res>
    implements $PersonalFinanceCategoryCopyWith<$Res> {
  _$PersonalFinanceCategoryCopyWithImpl(this._value, this._then);

  final PersonalFinanceCategory _value;
  // ignore: unused_field
  final $Res Function(PersonalFinanceCategory) _then;

  @override
  $Res call({
    Object? primary = freezed,
    Object? detailed = freezed,
  }) {
    return _then(_value.copyWith(
      primary: primary == freezed
          ? _value.primary
          : primary // ignore: cast_nullable_to_non_nullable
              as String,
      detailed: detailed == freezed
          ? _value.detailed
          : detailed // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$PersonalFinanceCategoryCopyWith<$Res>
    implements $PersonalFinanceCategoryCopyWith<$Res> {
  factory _$PersonalFinanceCategoryCopyWith(_PersonalFinanceCategory value,
          $Res Function(_PersonalFinanceCategory) then) =
      __$PersonalFinanceCategoryCopyWithImpl<$Res>;
  @override
  $Res call({String primary, String detailed});
}

/// @nodoc
class __$PersonalFinanceCategoryCopyWithImpl<$Res>
    extends _$PersonalFinanceCategoryCopyWithImpl<$Res>
    implements _$PersonalFinanceCategoryCopyWith<$Res> {
  __$PersonalFinanceCategoryCopyWithImpl(_PersonalFinanceCategory _value,
      $Res Function(_PersonalFinanceCategory) _then)
      : super(_value, (v) => _then(v as _PersonalFinanceCategory));

  @override
  _PersonalFinanceCategory get _value =>
      super._value as _PersonalFinanceCategory;

  @override
  $Res call({
    Object? primary = freezed,
    Object? detailed = freezed,
  }) {
    return _then(_PersonalFinanceCategory(
      primary: primary == freezed
          ? _value.primary
          : primary // ignore: cast_nullable_to_non_nullable
              as String,
      detailed: detailed == freezed
          ? _value.detailed
          : detailed // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_PersonalFinanceCategory implements _PersonalFinanceCategory {
  const _$_PersonalFinanceCategory(
      {required this.primary, required this.detailed});

  factory _$_PersonalFinanceCategory.fromJson(Map<String, dynamic> json) =>
      _$$_PersonalFinanceCategoryFromJson(json);

  @override
  final String primary;
  @override
  final String detailed;

  @override
  String toString() {
    return 'PersonalFinanceCategory(primary: $primary, detailed: $detailed)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PersonalFinanceCategory &&
            const DeepCollectionEquality().equals(other.primary, primary) &&
            const DeepCollectionEquality().equals(other.detailed, detailed));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(primary),
      const DeepCollectionEquality().hash(detailed));

  @JsonKey(ignore: true)
  @override
  _$PersonalFinanceCategoryCopyWith<_PersonalFinanceCategory> get copyWith =>
      __$PersonalFinanceCategoryCopyWithImpl<_PersonalFinanceCategory>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PersonalFinanceCategoryToJson(this);
  }
}

abstract class _PersonalFinanceCategory implements PersonalFinanceCategory {
  const factory _PersonalFinanceCategory(
      {required String primary,
      required String detailed}) = _$_PersonalFinanceCategory;

  factory _PersonalFinanceCategory.fromJson(Map<String, dynamic> json) =
      _$_PersonalFinanceCategory.fromJson;

  @override
  String get primary;
  @override
  String get detailed;
  @override
  @JsonKey(ignore: true)
  _$PersonalFinanceCategoryCopyWith<_PersonalFinanceCategory> get copyWith =>
      throw _privateConstructorUsedError;
}
