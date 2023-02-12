// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'personal_finance_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PersonalFinanceCategory _$PersonalFinanceCategoryFromJson(
    Map<String, dynamic> json) {
  return _PersonalFinanceCategory.fromJson(json);
}

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
      _$PersonalFinanceCategoryCopyWithImpl<$Res, PersonalFinanceCategory>;
  @useResult
  $Res call({String primary, String detailed});
}

/// @nodoc
class _$PersonalFinanceCategoryCopyWithImpl<$Res,
        $Val extends PersonalFinanceCategory>
    implements $PersonalFinanceCategoryCopyWith<$Res> {
  _$PersonalFinanceCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? primary = null,
    Object? detailed = null,
  }) {
    return _then(_value.copyWith(
      primary: null == primary
          ? _value.primary
          : primary // ignore: cast_nullable_to_non_nullable
              as String,
      detailed: null == detailed
          ? _value.detailed
          : detailed // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PersonalFinanceCategoryCopyWith<$Res>
    implements $PersonalFinanceCategoryCopyWith<$Res> {
  factory _$$_PersonalFinanceCategoryCopyWith(_$_PersonalFinanceCategory value,
          $Res Function(_$_PersonalFinanceCategory) then) =
      __$$_PersonalFinanceCategoryCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String primary, String detailed});
}

/// @nodoc
class __$$_PersonalFinanceCategoryCopyWithImpl<$Res>
    extends _$PersonalFinanceCategoryCopyWithImpl<$Res,
        _$_PersonalFinanceCategory>
    implements _$$_PersonalFinanceCategoryCopyWith<$Res> {
  __$$_PersonalFinanceCategoryCopyWithImpl(_$_PersonalFinanceCategory _value,
      $Res Function(_$_PersonalFinanceCategory) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? primary = null,
    Object? detailed = null,
  }) {
    return _then(_$_PersonalFinanceCategory(
      primary: null == primary
          ? _value.primary
          : primary // ignore: cast_nullable_to_non_nullable
              as String,
      detailed: null == detailed
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
            other is _$_PersonalFinanceCategory &&
            (identical(other.primary, primary) || other.primary == primary) &&
            (identical(other.detailed, detailed) ||
                other.detailed == detailed));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, primary, detailed);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PersonalFinanceCategoryCopyWith<_$_PersonalFinanceCategory>
      get copyWith =>
          __$$_PersonalFinanceCategoryCopyWithImpl<_$_PersonalFinanceCategory>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PersonalFinanceCategoryToJson(
      this,
    );
  }
}

abstract class _PersonalFinanceCategory implements PersonalFinanceCategory {
  const factory _PersonalFinanceCategory(
      {required final String primary,
      required final String detailed}) = _$_PersonalFinanceCategory;

  factory _PersonalFinanceCategory.fromJson(Map<String, dynamic> json) =
      _$_PersonalFinanceCategory.fromJson;

  @override
  String get primary;
  @override
  String get detailed;
  @override
  @JsonKey(ignore: true)
  _$$_PersonalFinanceCategoryCopyWith<_$_PersonalFinanceCategory>
      get copyWith => throw _privateConstructorUsedError;
}
