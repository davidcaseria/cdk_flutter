// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Error {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) cdk,
    required TResult Function(String field0) database,
    required TResult Function(String field0) hex,
    required TResult Function() invalidInput,
    required TResult Function(String field0) protocol,
    required TResult Function(String field0) url,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String field0)? cdk,
    TResult? Function(String field0)? database,
    TResult? Function(String field0)? hex,
    TResult? Function()? invalidInput,
    TResult? Function(String field0)? protocol,
    TResult? Function(String field0)? url,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String field0)? cdk,
    TResult Function(String field0)? database,
    TResult Function(String field0)? hex,
    TResult Function()? invalidInput,
    TResult Function(String field0)? protocol,
    TResult Function(String field0)? url,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Error_Cdk value) cdk,
    required TResult Function(Error_Database value) database,
    required TResult Function(Error_Hex value) hex,
    required TResult Function(Error_InvalidInput value) invalidInput,
    required TResult Function(Error_Protocol value) protocol,
    required TResult Function(Error_Url value) url,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Error_Cdk value)? cdk,
    TResult? Function(Error_Database value)? database,
    TResult? Function(Error_Hex value)? hex,
    TResult? Function(Error_InvalidInput value)? invalidInput,
    TResult? Function(Error_Protocol value)? protocol,
    TResult? Function(Error_Url value)? url,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Error_Cdk value)? cdk,
    TResult Function(Error_Database value)? database,
    TResult Function(Error_Hex value)? hex,
    TResult Function(Error_InvalidInput value)? invalidInput,
    TResult Function(Error_Protocol value)? protocol,
    TResult Function(Error_Url value)? url,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ErrorCopyWith<$Res> {
  factory $ErrorCopyWith(Error value, $Res Function(Error) then) =
      _$ErrorCopyWithImpl<$Res, Error>;
}

/// @nodoc
class _$ErrorCopyWithImpl<$Res, $Val extends Error>
    implements $ErrorCopyWith<$Res> {
  _$ErrorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Error
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$Error_CdkImplCopyWith<$Res> {
  factory _$$Error_CdkImplCopyWith(
          _$Error_CdkImpl value, $Res Function(_$Error_CdkImpl) then) =
      __$$Error_CdkImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String field0});
}

/// @nodoc
class __$$Error_CdkImplCopyWithImpl<$Res>
    extends _$ErrorCopyWithImpl<$Res, _$Error_CdkImpl>
    implements _$$Error_CdkImplCopyWith<$Res> {
  __$$Error_CdkImplCopyWithImpl(
      _$Error_CdkImpl _value, $Res Function(_$Error_CdkImpl) _then)
      : super(_value, _then);

  /// Create a copy of Error
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$Error_CdkImpl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$Error_CdkImpl extends Error_Cdk {
  const _$Error_CdkImpl(this.field0) : super._();

  @override
  final String field0;

  @override
  String toString() {
    return 'Error.cdk(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Error_CdkImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of Error
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$Error_CdkImplCopyWith<_$Error_CdkImpl> get copyWith =>
      __$$Error_CdkImplCopyWithImpl<_$Error_CdkImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) cdk,
    required TResult Function(String field0) database,
    required TResult Function(String field0) hex,
    required TResult Function() invalidInput,
    required TResult Function(String field0) protocol,
    required TResult Function(String field0) url,
  }) {
    return cdk(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String field0)? cdk,
    TResult? Function(String field0)? database,
    TResult? Function(String field0)? hex,
    TResult? Function()? invalidInput,
    TResult? Function(String field0)? protocol,
    TResult? Function(String field0)? url,
  }) {
    return cdk?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String field0)? cdk,
    TResult Function(String field0)? database,
    TResult Function(String field0)? hex,
    TResult Function()? invalidInput,
    TResult Function(String field0)? protocol,
    TResult Function(String field0)? url,
    required TResult orElse(),
  }) {
    if (cdk != null) {
      return cdk(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Error_Cdk value) cdk,
    required TResult Function(Error_Database value) database,
    required TResult Function(Error_Hex value) hex,
    required TResult Function(Error_InvalidInput value) invalidInput,
    required TResult Function(Error_Protocol value) protocol,
    required TResult Function(Error_Url value) url,
  }) {
    return cdk(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Error_Cdk value)? cdk,
    TResult? Function(Error_Database value)? database,
    TResult? Function(Error_Hex value)? hex,
    TResult? Function(Error_InvalidInput value)? invalidInput,
    TResult? Function(Error_Protocol value)? protocol,
    TResult? Function(Error_Url value)? url,
  }) {
    return cdk?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Error_Cdk value)? cdk,
    TResult Function(Error_Database value)? database,
    TResult Function(Error_Hex value)? hex,
    TResult Function(Error_InvalidInput value)? invalidInput,
    TResult Function(Error_Protocol value)? protocol,
    TResult Function(Error_Url value)? url,
    required TResult orElse(),
  }) {
    if (cdk != null) {
      return cdk(this);
    }
    return orElse();
  }
}

abstract class Error_Cdk extends Error {
  const factory Error_Cdk(final String field0) = _$Error_CdkImpl;
  const Error_Cdk._() : super._();

  String get field0;

  /// Create a copy of Error
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$Error_CdkImplCopyWith<_$Error_CdkImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$Error_DatabaseImplCopyWith<$Res> {
  factory _$$Error_DatabaseImplCopyWith(_$Error_DatabaseImpl value,
          $Res Function(_$Error_DatabaseImpl) then) =
      __$$Error_DatabaseImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String field0});
}

/// @nodoc
class __$$Error_DatabaseImplCopyWithImpl<$Res>
    extends _$ErrorCopyWithImpl<$Res, _$Error_DatabaseImpl>
    implements _$$Error_DatabaseImplCopyWith<$Res> {
  __$$Error_DatabaseImplCopyWithImpl(
      _$Error_DatabaseImpl _value, $Res Function(_$Error_DatabaseImpl) _then)
      : super(_value, _then);

  /// Create a copy of Error
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$Error_DatabaseImpl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$Error_DatabaseImpl extends Error_Database {
  const _$Error_DatabaseImpl(this.field0) : super._();

  @override
  final String field0;

  @override
  String toString() {
    return 'Error.database(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Error_DatabaseImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of Error
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$Error_DatabaseImplCopyWith<_$Error_DatabaseImpl> get copyWith =>
      __$$Error_DatabaseImplCopyWithImpl<_$Error_DatabaseImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) cdk,
    required TResult Function(String field0) database,
    required TResult Function(String field0) hex,
    required TResult Function() invalidInput,
    required TResult Function(String field0) protocol,
    required TResult Function(String field0) url,
  }) {
    return database(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String field0)? cdk,
    TResult? Function(String field0)? database,
    TResult? Function(String field0)? hex,
    TResult? Function()? invalidInput,
    TResult? Function(String field0)? protocol,
    TResult? Function(String field0)? url,
  }) {
    return database?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String field0)? cdk,
    TResult Function(String field0)? database,
    TResult Function(String field0)? hex,
    TResult Function()? invalidInput,
    TResult Function(String field0)? protocol,
    TResult Function(String field0)? url,
    required TResult orElse(),
  }) {
    if (database != null) {
      return database(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Error_Cdk value) cdk,
    required TResult Function(Error_Database value) database,
    required TResult Function(Error_Hex value) hex,
    required TResult Function(Error_InvalidInput value) invalidInput,
    required TResult Function(Error_Protocol value) protocol,
    required TResult Function(Error_Url value) url,
  }) {
    return database(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Error_Cdk value)? cdk,
    TResult? Function(Error_Database value)? database,
    TResult? Function(Error_Hex value)? hex,
    TResult? Function(Error_InvalidInput value)? invalidInput,
    TResult? Function(Error_Protocol value)? protocol,
    TResult? Function(Error_Url value)? url,
  }) {
    return database?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Error_Cdk value)? cdk,
    TResult Function(Error_Database value)? database,
    TResult Function(Error_Hex value)? hex,
    TResult Function(Error_InvalidInput value)? invalidInput,
    TResult Function(Error_Protocol value)? protocol,
    TResult Function(Error_Url value)? url,
    required TResult orElse(),
  }) {
    if (database != null) {
      return database(this);
    }
    return orElse();
  }
}

abstract class Error_Database extends Error {
  const factory Error_Database(final String field0) = _$Error_DatabaseImpl;
  const Error_Database._() : super._();

  String get field0;

  /// Create a copy of Error
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$Error_DatabaseImplCopyWith<_$Error_DatabaseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$Error_HexImplCopyWith<$Res> {
  factory _$$Error_HexImplCopyWith(
          _$Error_HexImpl value, $Res Function(_$Error_HexImpl) then) =
      __$$Error_HexImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String field0});
}

/// @nodoc
class __$$Error_HexImplCopyWithImpl<$Res>
    extends _$ErrorCopyWithImpl<$Res, _$Error_HexImpl>
    implements _$$Error_HexImplCopyWith<$Res> {
  __$$Error_HexImplCopyWithImpl(
      _$Error_HexImpl _value, $Res Function(_$Error_HexImpl) _then)
      : super(_value, _then);

  /// Create a copy of Error
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$Error_HexImpl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$Error_HexImpl extends Error_Hex {
  const _$Error_HexImpl(this.field0) : super._();

  @override
  final String field0;

  @override
  String toString() {
    return 'Error.hex(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Error_HexImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of Error
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$Error_HexImplCopyWith<_$Error_HexImpl> get copyWith =>
      __$$Error_HexImplCopyWithImpl<_$Error_HexImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) cdk,
    required TResult Function(String field0) database,
    required TResult Function(String field0) hex,
    required TResult Function() invalidInput,
    required TResult Function(String field0) protocol,
    required TResult Function(String field0) url,
  }) {
    return hex(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String field0)? cdk,
    TResult? Function(String field0)? database,
    TResult? Function(String field0)? hex,
    TResult? Function()? invalidInput,
    TResult? Function(String field0)? protocol,
    TResult? Function(String field0)? url,
  }) {
    return hex?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String field0)? cdk,
    TResult Function(String field0)? database,
    TResult Function(String field0)? hex,
    TResult Function()? invalidInput,
    TResult Function(String field0)? protocol,
    TResult Function(String field0)? url,
    required TResult orElse(),
  }) {
    if (hex != null) {
      return hex(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Error_Cdk value) cdk,
    required TResult Function(Error_Database value) database,
    required TResult Function(Error_Hex value) hex,
    required TResult Function(Error_InvalidInput value) invalidInput,
    required TResult Function(Error_Protocol value) protocol,
    required TResult Function(Error_Url value) url,
  }) {
    return hex(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Error_Cdk value)? cdk,
    TResult? Function(Error_Database value)? database,
    TResult? Function(Error_Hex value)? hex,
    TResult? Function(Error_InvalidInput value)? invalidInput,
    TResult? Function(Error_Protocol value)? protocol,
    TResult? Function(Error_Url value)? url,
  }) {
    return hex?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Error_Cdk value)? cdk,
    TResult Function(Error_Database value)? database,
    TResult Function(Error_Hex value)? hex,
    TResult Function(Error_InvalidInput value)? invalidInput,
    TResult Function(Error_Protocol value)? protocol,
    TResult Function(Error_Url value)? url,
    required TResult orElse(),
  }) {
    if (hex != null) {
      return hex(this);
    }
    return orElse();
  }
}

abstract class Error_Hex extends Error {
  const factory Error_Hex(final String field0) = _$Error_HexImpl;
  const Error_Hex._() : super._();

  String get field0;

  /// Create a copy of Error
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$Error_HexImplCopyWith<_$Error_HexImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$Error_InvalidInputImplCopyWith<$Res> {
  factory _$$Error_InvalidInputImplCopyWith(_$Error_InvalidInputImpl value,
          $Res Function(_$Error_InvalidInputImpl) then) =
      __$$Error_InvalidInputImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$Error_InvalidInputImplCopyWithImpl<$Res>
    extends _$ErrorCopyWithImpl<$Res, _$Error_InvalidInputImpl>
    implements _$$Error_InvalidInputImplCopyWith<$Res> {
  __$$Error_InvalidInputImplCopyWithImpl(_$Error_InvalidInputImpl _value,
      $Res Function(_$Error_InvalidInputImpl) _then)
      : super(_value, _then);

  /// Create a copy of Error
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$Error_InvalidInputImpl extends Error_InvalidInput {
  const _$Error_InvalidInputImpl() : super._();

  @override
  String toString() {
    return 'Error.invalidInput()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$Error_InvalidInputImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) cdk,
    required TResult Function(String field0) database,
    required TResult Function(String field0) hex,
    required TResult Function() invalidInput,
    required TResult Function(String field0) protocol,
    required TResult Function(String field0) url,
  }) {
    return invalidInput();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String field0)? cdk,
    TResult? Function(String field0)? database,
    TResult? Function(String field0)? hex,
    TResult? Function()? invalidInput,
    TResult? Function(String field0)? protocol,
    TResult? Function(String field0)? url,
  }) {
    return invalidInput?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String field0)? cdk,
    TResult Function(String field0)? database,
    TResult Function(String field0)? hex,
    TResult Function()? invalidInput,
    TResult Function(String field0)? protocol,
    TResult Function(String field0)? url,
    required TResult orElse(),
  }) {
    if (invalidInput != null) {
      return invalidInput();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Error_Cdk value) cdk,
    required TResult Function(Error_Database value) database,
    required TResult Function(Error_Hex value) hex,
    required TResult Function(Error_InvalidInput value) invalidInput,
    required TResult Function(Error_Protocol value) protocol,
    required TResult Function(Error_Url value) url,
  }) {
    return invalidInput(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Error_Cdk value)? cdk,
    TResult? Function(Error_Database value)? database,
    TResult? Function(Error_Hex value)? hex,
    TResult? Function(Error_InvalidInput value)? invalidInput,
    TResult? Function(Error_Protocol value)? protocol,
    TResult? Function(Error_Url value)? url,
  }) {
    return invalidInput?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Error_Cdk value)? cdk,
    TResult Function(Error_Database value)? database,
    TResult Function(Error_Hex value)? hex,
    TResult Function(Error_InvalidInput value)? invalidInput,
    TResult Function(Error_Protocol value)? protocol,
    TResult Function(Error_Url value)? url,
    required TResult orElse(),
  }) {
    if (invalidInput != null) {
      return invalidInput(this);
    }
    return orElse();
  }
}

abstract class Error_InvalidInput extends Error {
  const factory Error_InvalidInput() = _$Error_InvalidInputImpl;
  const Error_InvalidInput._() : super._();
}

/// @nodoc
abstract class _$$Error_ProtocolImplCopyWith<$Res> {
  factory _$$Error_ProtocolImplCopyWith(_$Error_ProtocolImpl value,
          $Res Function(_$Error_ProtocolImpl) then) =
      __$$Error_ProtocolImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String field0});
}

/// @nodoc
class __$$Error_ProtocolImplCopyWithImpl<$Res>
    extends _$ErrorCopyWithImpl<$Res, _$Error_ProtocolImpl>
    implements _$$Error_ProtocolImplCopyWith<$Res> {
  __$$Error_ProtocolImplCopyWithImpl(
      _$Error_ProtocolImpl _value, $Res Function(_$Error_ProtocolImpl) _then)
      : super(_value, _then);

  /// Create a copy of Error
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$Error_ProtocolImpl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$Error_ProtocolImpl extends Error_Protocol {
  const _$Error_ProtocolImpl(this.field0) : super._();

  @override
  final String field0;

  @override
  String toString() {
    return 'Error.protocol(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Error_ProtocolImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of Error
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$Error_ProtocolImplCopyWith<_$Error_ProtocolImpl> get copyWith =>
      __$$Error_ProtocolImplCopyWithImpl<_$Error_ProtocolImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) cdk,
    required TResult Function(String field0) database,
    required TResult Function(String field0) hex,
    required TResult Function() invalidInput,
    required TResult Function(String field0) protocol,
    required TResult Function(String field0) url,
  }) {
    return protocol(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String field0)? cdk,
    TResult? Function(String field0)? database,
    TResult? Function(String field0)? hex,
    TResult? Function()? invalidInput,
    TResult? Function(String field0)? protocol,
    TResult? Function(String field0)? url,
  }) {
    return protocol?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String field0)? cdk,
    TResult Function(String field0)? database,
    TResult Function(String field0)? hex,
    TResult Function()? invalidInput,
    TResult Function(String field0)? protocol,
    TResult Function(String field0)? url,
    required TResult orElse(),
  }) {
    if (protocol != null) {
      return protocol(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Error_Cdk value) cdk,
    required TResult Function(Error_Database value) database,
    required TResult Function(Error_Hex value) hex,
    required TResult Function(Error_InvalidInput value) invalidInput,
    required TResult Function(Error_Protocol value) protocol,
    required TResult Function(Error_Url value) url,
  }) {
    return protocol(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Error_Cdk value)? cdk,
    TResult? Function(Error_Database value)? database,
    TResult? Function(Error_Hex value)? hex,
    TResult? Function(Error_InvalidInput value)? invalidInput,
    TResult? Function(Error_Protocol value)? protocol,
    TResult? Function(Error_Url value)? url,
  }) {
    return protocol?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Error_Cdk value)? cdk,
    TResult Function(Error_Database value)? database,
    TResult Function(Error_Hex value)? hex,
    TResult Function(Error_InvalidInput value)? invalidInput,
    TResult Function(Error_Protocol value)? protocol,
    TResult Function(Error_Url value)? url,
    required TResult orElse(),
  }) {
    if (protocol != null) {
      return protocol(this);
    }
    return orElse();
  }
}

abstract class Error_Protocol extends Error {
  const factory Error_Protocol(final String field0) = _$Error_ProtocolImpl;
  const Error_Protocol._() : super._();

  String get field0;

  /// Create a copy of Error
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$Error_ProtocolImplCopyWith<_$Error_ProtocolImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$Error_UrlImplCopyWith<$Res> {
  factory _$$Error_UrlImplCopyWith(
          _$Error_UrlImpl value, $Res Function(_$Error_UrlImpl) then) =
      __$$Error_UrlImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String field0});
}

/// @nodoc
class __$$Error_UrlImplCopyWithImpl<$Res>
    extends _$ErrorCopyWithImpl<$Res, _$Error_UrlImpl>
    implements _$$Error_UrlImplCopyWith<$Res> {
  __$$Error_UrlImplCopyWithImpl(
      _$Error_UrlImpl _value, $Res Function(_$Error_UrlImpl) _then)
      : super(_value, _then);

  /// Create a copy of Error
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$Error_UrlImpl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$Error_UrlImpl extends Error_Url {
  const _$Error_UrlImpl(this.field0) : super._();

  @override
  final String field0;

  @override
  String toString() {
    return 'Error.url(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Error_UrlImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of Error
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$Error_UrlImplCopyWith<_$Error_UrlImpl> get copyWith =>
      __$$Error_UrlImplCopyWithImpl<_$Error_UrlImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) cdk,
    required TResult Function(String field0) database,
    required TResult Function(String field0) hex,
    required TResult Function() invalidInput,
    required TResult Function(String field0) protocol,
    required TResult Function(String field0) url,
  }) {
    return url(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String field0)? cdk,
    TResult? Function(String field0)? database,
    TResult? Function(String field0)? hex,
    TResult? Function()? invalidInput,
    TResult? Function(String field0)? protocol,
    TResult? Function(String field0)? url,
  }) {
    return url?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String field0)? cdk,
    TResult Function(String field0)? database,
    TResult Function(String field0)? hex,
    TResult Function()? invalidInput,
    TResult Function(String field0)? protocol,
    TResult Function(String field0)? url,
    required TResult orElse(),
  }) {
    if (url != null) {
      return url(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Error_Cdk value) cdk,
    required TResult Function(Error_Database value) database,
    required TResult Function(Error_Hex value) hex,
    required TResult Function(Error_InvalidInput value) invalidInput,
    required TResult Function(Error_Protocol value) protocol,
    required TResult Function(Error_Url value) url,
  }) {
    return url(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Error_Cdk value)? cdk,
    TResult? Function(Error_Database value)? database,
    TResult? Function(Error_Hex value)? hex,
    TResult? Function(Error_InvalidInput value)? invalidInput,
    TResult? Function(Error_Protocol value)? protocol,
    TResult? Function(Error_Url value)? url,
  }) {
    return url?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Error_Cdk value)? cdk,
    TResult Function(Error_Database value)? database,
    TResult Function(Error_Hex value)? hex,
    TResult Function(Error_InvalidInput value)? invalidInput,
    TResult Function(Error_Protocol value)? protocol,
    TResult Function(Error_Url value)? url,
    required TResult orElse(),
  }) {
    if (url != null) {
      return url(this);
    }
    return orElse();
  }
}

abstract class Error_Url extends Error {
  const factory Error_Url(final String field0) = _$Error_UrlImpl;
  const Error_Url._() : super._();

  String get field0;

  /// Create a copy of Error
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$Error_UrlImplCopyWith<_$Error_UrlImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
