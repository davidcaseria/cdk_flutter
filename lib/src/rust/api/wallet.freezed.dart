// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ParseInputResult {
  Object get field0 => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BitcoinAddress field0) bitcoinAddress,
    required TResult Function(String field0) bolt11Invoice,
    required TResult Function(PaymentRequest field0) paymentRequest,
    required TResult Function(Token field0) token,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BitcoinAddress field0)? bitcoinAddress,
    TResult? Function(String field0)? bolt11Invoice,
    TResult? Function(PaymentRequest field0)? paymentRequest,
    TResult? Function(Token field0)? token,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BitcoinAddress field0)? bitcoinAddress,
    TResult Function(String field0)? bolt11Invoice,
    TResult Function(PaymentRequest field0)? paymentRequest,
    TResult Function(Token field0)? token,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ParseInputResult_BitcoinAddress value)
        bitcoinAddress,
    required TResult Function(ParseInputResult_Bolt11Invoice value)
        bolt11Invoice,
    required TResult Function(ParseInputResult_PaymentRequest value)
        paymentRequest,
    required TResult Function(ParseInputResult_Token value) token,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ParseInputResult_BitcoinAddress value)? bitcoinAddress,
    TResult? Function(ParseInputResult_Bolt11Invoice value)? bolt11Invoice,
    TResult? Function(ParseInputResult_PaymentRequest value)? paymentRequest,
    TResult? Function(ParseInputResult_Token value)? token,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ParseInputResult_BitcoinAddress value)? bitcoinAddress,
    TResult Function(ParseInputResult_Bolt11Invoice value)? bolt11Invoice,
    TResult Function(ParseInputResult_PaymentRequest value)? paymentRequest,
    TResult Function(ParseInputResult_Token value)? token,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParseInputResultCopyWith<$Res> {
  factory $ParseInputResultCopyWith(
          ParseInputResult value, $Res Function(ParseInputResult) then) =
      _$ParseInputResultCopyWithImpl<$Res, ParseInputResult>;
}

/// @nodoc
class _$ParseInputResultCopyWithImpl<$Res, $Val extends ParseInputResult>
    implements $ParseInputResultCopyWith<$Res> {
  _$ParseInputResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ParseInputResult
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ParseInputResult_BitcoinAddressImplCopyWith<$Res> {
  factory _$$ParseInputResult_BitcoinAddressImplCopyWith(
          _$ParseInputResult_BitcoinAddressImpl value,
          $Res Function(_$ParseInputResult_BitcoinAddressImpl) then) =
      __$$ParseInputResult_BitcoinAddressImplCopyWithImpl<$Res>;
  @useResult
  $Res call({BitcoinAddress field0});
}

/// @nodoc
class __$$ParseInputResult_BitcoinAddressImplCopyWithImpl<$Res>
    extends _$ParseInputResultCopyWithImpl<$Res,
        _$ParseInputResult_BitcoinAddressImpl>
    implements _$$ParseInputResult_BitcoinAddressImplCopyWith<$Res> {
  __$$ParseInputResult_BitcoinAddressImplCopyWithImpl(
      _$ParseInputResult_BitcoinAddressImpl _value,
      $Res Function(_$ParseInputResult_BitcoinAddressImpl) _then)
      : super(_value, _then);

  /// Create a copy of ParseInputResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$ParseInputResult_BitcoinAddressImpl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as BitcoinAddress,
    ));
  }
}

/// @nodoc

class _$ParseInputResult_BitcoinAddressImpl
    extends ParseInputResult_BitcoinAddress {
  const _$ParseInputResult_BitcoinAddressImpl(this.field0) : super._();

  @override
  final BitcoinAddress field0;

  @override
  String toString() {
    return 'ParseInputResult.bitcoinAddress(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParseInputResult_BitcoinAddressImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of ParseInputResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ParseInputResult_BitcoinAddressImplCopyWith<
          _$ParseInputResult_BitcoinAddressImpl>
      get copyWith => __$$ParseInputResult_BitcoinAddressImplCopyWithImpl<
          _$ParseInputResult_BitcoinAddressImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BitcoinAddress field0) bitcoinAddress,
    required TResult Function(String field0) bolt11Invoice,
    required TResult Function(PaymentRequest field0) paymentRequest,
    required TResult Function(Token field0) token,
  }) {
    return bitcoinAddress(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BitcoinAddress field0)? bitcoinAddress,
    TResult? Function(String field0)? bolt11Invoice,
    TResult? Function(PaymentRequest field0)? paymentRequest,
    TResult? Function(Token field0)? token,
  }) {
    return bitcoinAddress?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BitcoinAddress field0)? bitcoinAddress,
    TResult Function(String field0)? bolt11Invoice,
    TResult Function(PaymentRequest field0)? paymentRequest,
    TResult Function(Token field0)? token,
    required TResult orElse(),
  }) {
    if (bitcoinAddress != null) {
      return bitcoinAddress(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ParseInputResult_BitcoinAddress value)
        bitcoinAddress,
    required TResult Function(ParseInputResult_Bolt11Invoice value)
        bolt11Invoice,
    required TResult Function(ParseInputResult_PaymentRequest value)
        paymentRequest,
    required TResult Function(ParseInputResult_Token value) token,
  }) {
    return bitcoinAddress(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ParseInputResult_BitcoinAddress value)? bitcoinAddress,
    TResult? Function(ParseInputResult_Bolt11Invoice value)? bolt11Invoice,
    TResult? Function(ParseInputResult_PaymentRequest value)? paymentRequest,
    TResult? Function(ParseInputResult_Token value)? token,
  }) {
    return bitcoinAddress?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ParseInputResult_BitcoinAddress value)? bitcoinAddress,
    TResult Function(ParseInputResult_Bolt11Invoice value)? bolt11Invoice,
    TResult Function(ParseInputResult_PaymentRequest value)? paymentRequest,
    TResult Function(ParseInputResult_Token value)? token,
    required TResult orElse(),
  }) {
    if (bitcoinAddress != null) {
      return bitcoinAddress(this);
    }
    return orElse();
  }
}

abstract class ParseInputResult_BitcoinAddress extends ParseInputResult {
  const factory ParseInputResult_BitcoinAddress(final BitcoinAddress field0) =
      _$ParseInputResult_BitcoinAddressImpl;
  const ParseInputResult_BitcoinAddress._() : super._();

  @override
  BitcoinAddress get field0;

  /// Create a copy of ParseInputResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ParseInputResult_BitcoinAddressImplCopyWith<
          _$ParseInputResult_BitcoinAddressImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ParseInputResult_Bolt11InvoiceImplCopyWith<$Res> {
  factory _$$ParseInputResult_Bolt11InvoiceImplCopyWith(
          _$ParseInputResult_Bolt11InvoiceImpl value,
          $Res Function(_$ParseInputResult_Bolt11InvoiceImpl) then) =
      __$$ParseInputResult_Bolt11InvoiceImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String field0});
}

/// @nodoc
class __$$ParseInputResult_Bolt11InvoiceImplCopyWithImpl<$Res>
    extends _$ParseInputResultCopyWithImpl<$Res,
        _$ParseInputResult_Bolt11InvoiceImpl>
    implements _$$ParseInputResult_Bolt11InvoiceImplCopyWith<$Res> {
  __$$ParseInputResult_Bolt11InvoiceImplCopyWithImpl(
      _$ParseInputResult_Bolt11InvoiceImpl _value,
      $Res Function(_$ParseInputResult_Bolt11InvoiceImpl) _then)
      : super(_value, _then);

  /// Create a copy of ParseInputResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$ParseInputResult_Bolt11InvoiceImpl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ParseInputResult_Bolt11InvoiceImpl
    extends ParseInputResult_Bolt11Invoice {
  const _$ParseInputResult_Bolt11InvoiceImpl(this.field0) : super._();

  @override
  final String field0;

  @override
  String toString() {
    return 'ParseInputResult.bolt11Invoice(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParseInputResult_Bolt11InvoiceImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of ParseInputResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ParseInputResult_Bolt11InvoiceImplCopyWith<
          _$ParseInputResult_Bolt11InvoiceImpl>
      get copyWith => __$$ParseInputResult_Bolt11InvoiceImplCopyWithImpl<
          _$ParseInputResult_Bolt11InvoiceImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BitcoinAddress field0) bitcoinAddress,
    required TResult Function(String field0) bolt11Invoice,
    required TResult Function(PaymentRequest field0) paymentRequest,
    required TResult Function(Token field0) token,
  }) {
    return bolt11Invoice(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BitcoinAddress field0)? bitcoinAddress,
    TResult? Function(String field0)? bolt11Invoice,
    TResult? Function(PaymentRequest field0)? paymentRequest,
    TResult? Function(Token field0)? token,
  }) {
    return bolt11Invoice?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BitcoinAddress field0)? bitcoinAddress,
    TResult Function(String field0)? bolt11Invoice,
    TResult Function(PaymentRequest field0)? paymentRequest,
    TResult Function(Token field0)? token,
    required TResult orElse(),
  }) {
    if (bolt11Invoice != null) {
      return bolt11Invoice(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ParseInputResult_BitcoinAddress value)
        bitcoinAddress,
    required TResult Function(ParseInputResult_Bolt11Invoice value)
        bolt11Invoice,
    required TResult Function(ParseInputResult_PaymentRequest value)
        paymentRequest,
    required TResult Function(ParseInputResult_Token value) token,
  }) {
    return bolt11Invoice(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ParseInputResult_BitcoinAddress value)? bitcoinAddress,
    TResult? Function(ParseInputResult_Bolt11Invoice value)? bolt11Invoice,
    TResult? Function(ParseInputResult_PaymentRequest value)? paymentRequest,
    TResult? Function(ParseInputResult_Token value)? token,
  }) {
    return bolt11Invoice?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ParseInputResult_BitcoinAddress value)? bitcoinAddress,
    TResult Function(ParseInputResult_Bolt11Invoice value)? bolt11Invoice,
    TResult Function(ParseInputResult_PaymentRequest value)? paymentRequest,
    TResult Function(ParseInputResult_Token value)? token,
    required TResult orElse(),
  }) {
    if (bolt11Invoice != null) {
      return bolt11Invoice(this);
    }
    return orElse();
  }
}

abstract class ParseInputResult_Bolt11Invoice extends ParseInputResult {
  const factory ParseInputResult_Bolt11Invoice(final String field0) =
      _$ParseInputResult_Bolt11InvoiceImpl;
  const ParseInputResult_Bolt11Invoice._() : super._();

  @override
  String get field0;

  /// Create a copy of ParseInputResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ParseInputResult_Bolt11InvoiceImplCopyWith<
          _$ParseInputResult_Bolt11InvoiceImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ParseInputResult_PaymentRequestImplCopyWith<$Res> {
  factory _$$ParseInputResult_PaymentRequestImplCopyWith(
          _$ParseInputResult_PaymentRequestImpl value,
          $Res Function(_$ParseInputResult_PaymentRequestImpl) then) =
      __$$ParseInputResult_PaymentRequestImplCopyWithImpl<$Res>;
  @useResult
  $Res call({PaymentRequest field0});
}

/// @nodoc
class __$$ParseInputResult_PaymentRequestImplCopyWithImpl<$Res>
    extends _$ParseInputResultCopyWithImpl<$Res,
        _$ParseInputResult_PaymentRequestImpl>
    implements _$$ParseInputResult_PaymentRequestImplCopyWith<$Res> {
  __$$ParseInputResult_PaymentRequestImplCopyWithImpl(
      _$ParseInputResult_PaymentRequestImpl _value,
      $Res Function(_$ParseInputResult_PaymentRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of ParseInputResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$ParseInputResult_PaymentRequestImpl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as PaymentRequest,
    ));
  }
}

/// @nodoc

class _$ParseInputResult_PaymentRequestImpl
    extends ParseInputResult_PaymentRequest {
  const _$ParseInputResult_PaymentRequestImpl(this.field0) : super._();

  @override
  final PaymentRequest field0;

  @override
  String toString() {
    return 'ParseInputResult.paymentRequest(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParseInputResult_PaymentRequestImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of ParseInputResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ParseInputResult_PaymentRequestImplCopyWith<
          _$ParseInputResult_PaymentRequestImpl>
      get copyWith => __$$ParseInputResult_PaymentRequestImplCopyWithImpl<
          _$ParseInputResult_PaymentRequestImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BitcoinAddress field0) bitcoinAddress,
    required TResult Function(String field0) bolt11Invoice,
    required TResult Function(PaymentRequest field0) paymentRequest,
    required TResult Function(Token field0) token,
  }) {
    return paymentRequest(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BitcoinAddress field0)? bitcoinAddress,
    TResult? Function(String field0)? bolt11Invoice,
    TResult? Function(PaymentRequest field0)? paymentRequest,
    TResult? Function(Token field0)? token,
  }) {
    return paymentRequest?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BitcoinAddress field0)? bitcoinAddress,
    TResult Function(String field0)? bolt11Invoice,
    TResult Function(PaymentRequest field0)? paymentRequest,
    TResult Function(Token field0)? token,
    required TResult orElse(),
  }) {
    if (paymentRequest != null) {
      return paymentRequest(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ParseInputResult_BitcoinAddress value)
        bitcoinAddress,
    required TResult Function(ParseInputResult_Bolt11Invoice value)
        bolt11Invoice,
    required TResult Function(ParseInputResult_PaymentRequest value)
        paymentRequest,
    required TResult Function(ParseInputResult_Token value) token,
  }) {
    return paymentRequest(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ParseInputResult_BitcoinAddress value)? bitcoinAddress,
    TResult? Function(ParseInputResult_Bolt11Invoice value)? bolt11Invoice,
    TResult? Function(ParseInputResult_PaymentRequest value)? paymentRequest,
    TResult? Function(ParseInputResult_Token value)? token,
  }) {
    return paymentRequest?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ParseInputResult_BitcoinAddress value)? bitcoinAddress,
    TResult Function(ParseInputResult_Bolt11Invoice value)? bolt11Invoice,
    TResult Function(ParseInputResult_PaymentRequest value)? paymentRequest,
    TResult Function(ParseInputResult_Token value)? token,
    required TResult orElse(),
  }) {
    if (paymentRequest != null) {
      return paymentRequest(this);
    }
    return orElse();
  }
}

abstract class ParseInputResult_PaymentRequest extends ParseInputResult {
  const factory ParseInputResult_PaymentRequest(final PaymentRequest field0) =
      _$ParseInputResult_PaymentRequestImpl;
  const ParseInputResult_PaymentRequest._() : super._();

  @override
  PaymentRequest get field0;

  /// Create a copy of ParseInputResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ParseInputResult_PaymentRequestImplCopyWith<
          _$ParseInputResult_PaymentRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ParseInputResult_TokenImplCopyWith<$Res> {
  factory _$$ParseInputResult_TokenImplCopyWith(
          _$ParseInputResult_TokenImpl value,
          $Res Function(_$ParseInputResult_TokenImpl) then) =
      __$$ParseInputResult_TokenImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Token field0});
}

/// @nodoc
class __$$ParseInputResult_TokenImplCopyWithImpl<$Res>
    extends _$ParseInputResultCopyWithImpl<$Res, _$ParseInputResult_TokenImpl>
    implements _$$ParseInputResult_TokenImplCopyWith<$Res> {
  __$$ParseInputResult_TokenImplCopyWithImpl(
      _$ParseInputResult_TokenImpl _value,
      $Res Function(_$ParseInputResult_TokenImpl) _then)
      : super(_value, _then);

  /// Create a copy of ParseInputResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$ParseInputResult_TokenImpl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as Token,
    ));
  }
}

/// @nodoc

class _$ParseInputResult_TokenImpl extends ParseInputResult_Token {
  const _$ParseInputResult_TokenImpl(this.field0) : super._();

  @override
  final Token field0;

  @override
  String toString() {
    return 'ParseInputResult.token(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParseInputResult_TokenImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of ParseInputResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ParseInputResult_TokenImplCopyWith<_$ParseInputResult_TokenImpl>
      get copyWith => __$$ParseInputResult_TokenImplCopyWithImpl<
          _$ParseInputResult_TokenImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BitcoinAddress field0) bitcoinAddress,
    required TResult Function(String field0) bolt11Invoice,
    required TResult Function(PaymentRequest field0) paymentRequest,
    required TResult Function(Token field0) token,
  }) {
    return token(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BitcoinAddress field0)? bitcoinAddress,
    TResult? Function(String field0)? bolt11Invoice,
    TResult? Function(PaymentRequest field0)? paymentRequest,
    TResult? Function(Token field0)? token,
  }) {
    return token?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BitcoinAddress field0)? bitcoinAddress,
    TResult Function(String field0)? bolt11Invoice,
    TResult Function(PaymentRequest field0)? paymentRequest,
    TResult Function(Token field0)? token,
    required TResult orElse(),
  }) {
    if (token != null) {
      return token(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ParseInputResult_BitcoinAddress value)
        bitcoinAddress,
    required TResult Function(ParseInputResult_Bolt11Invoice value)
        bolt11Invoice,
    required TResult Function(ParseInputResult_PaymentRequest value)
        paymentRequest,
    required TResult Function(ParseInputResult_Token value) token,
  }) {
    return token(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ParseInputResult_BitcoinAddress value)? bitcoinAddress,
    TResult? Function(ParseInputResult_Bolt11Invoice value)? bolt11Invoice,
    TResult? Function(ParseInputResult_PaymentRequest value)? paymentRequest,
    TResult? Function(ParseInputResult_Token value)? token,
  }) {
    return token?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ParseInputResult_BitcoinAddress value)? bitcoinAddress,
    TResult Function(ParseInputResult_Bolt11Invoice value)? bolt11Invoice,
    TResult Function(ParseInputResult_PaymentRequest value)? paymentRequest,
    TResult Function(ParseInputResult_Token value)? token,
    required TResult orElse(),
  }) {
    if (token != null) {
      return token(this);
    }
    return orElse();
  }
}

abstract class ParseInputResult_Token extends ParseInputResult {
  const factory ParseInputResult_Token(final Token field0) =
      _$ParseInputResult_TokenImpl;
  const ParseInputResult_Token._() : super._();

  @override
  Token get field0;

  /// Create a copy of ParseInputResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ParseInputResult_TokenImplCopyWith<_$ParseInputResult_TokenImpl>
      get copyWith => throw _privateConstructorUsedError;
}
