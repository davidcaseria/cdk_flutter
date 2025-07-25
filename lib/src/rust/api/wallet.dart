// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.11.1.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'bitcoin.dart';
import 'bolt11.dart';
import 'error.dart';
import 'mint.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'package:freezed_annotation/freezed_annotation.dart' hide protected;
import 'payment_request.dart';
import 'token.dart';
part 'wallet.freezed.dart';

// These functions are ignored because they are not marked as `pub`: `mint_url`, `unit`, `update_balance_streams`
// These function are ignored because they are on traits that is not defined in current crate (put an empty `#[frb]` on it to unignore): `assert_receiver_is_total_eq`, `assert_receiver_is_total_eq`, `assert_receiver_is_total_eq`, `clone`, `clone`, `clone`, `clone`, `clone`, `cmp`, `eq`, `eq`, `eq`, `fmt`, `fmt`, `fmt`, `from`, `from`, `from`, `from`, `from`, `from`, `into`, `partial_cmp`, `try_into`, `try_into`, `try_into`

ParseInputResult parseInput({required String input}) =>
    RustLib.instance.api.crateApiWalletParseInput(input: input);

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<MultiMintWallet>>
abstract class MultiMintWallet implements RustOpaqueInterface {
  Future<void> addMint({required String mintUrl});

  Future<void> addWallet({required Wallet wallet});

  String get unit;

  set unit(String unit);

  Future<List<Mint>> availableMints({BigInt? amount, List<String>? mintUrls});

  Future<Wallet> createOrGetWallet({required String mintUrl});

  Future<List<MintQuote>> getActiveMintQuotes({String? mintUrl});

  Future<Wallet?> getWallet({required String mintUrl});

  Future<List<Mint>> listMints();

  Future<List<Transaction>> listTransactions(
      {TransactionDirection? direction, String? mintUrl});

  Future<List<Wallet>> listWallets();

  // HINT: Make it `#[frb(sync)]` to let it become the default constructor of Dart class.
  static Future<MultiMintWallet> newInstance(
          {required String unit,
          required List<int> seed,
          BigInt? targetProofCount,
          required WalletDatabase db}) =>
      RustLib.instance.api.crateApiWalletMultiMintWalletNew(
          unit: unit, seed: seed, targetProofCount: targetProofCount, db: db);

  static Future<MultiMintWallet> newFromHexSeed(
          {required String unit,
          required String seed,
          BigInt? targetProofCount,
          required WalletDatabase db}) =>
      RustLib.instance.api.crateApiWalletMultiMintWalletNewFromHexSeed(
          unit: unit, seed: seed, targetProofCount: targetProofCount, db: db);

  Future<void> reclaimReserved();

  Future<void> removeMint({required String mintUrl});

  Future<Wallet?> selectWallet({BigInt? amount, List<String>? mintUrls});

  Stream<BigInt> streamBalance();

  Future<BigInt> totalBalance();
}

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<PreparedSend>>
abstract class PreparedSend implements RustOpaqueInterface {
  BigInt get amount;

  BigInt get fee;

  BigInt get sendFee;

  BigInt get swapFee;

  set amount(BigInt amount);

  set fee(BigInt fee);

  set sendFee(BigInt sendFee);

  set swapFee(BigInt swapFee);
}

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<Wallet>>
abstract class Wallet implements RustOpaqueInterface {
  String get mintUrl;

  String get unit;

  set mintUrl(String mintUrl);

  set unit(String unit);

  Future<BigInt> balance();

  Future<void> cancelSend({required PreparedSend send});

  Future<void> checkAllMintQuotes();

  Future<void> checkPendingMeltQuotes();

  Future<void> checkPendingTransactions();

  Future<List<MintQuote>> getActiveMintQuotes();

  Future<Mint> getMint();

  Future<bool> isTokenSpent({required Token token});

  Future<List<Transaction>> listTransactions({TransactionDirection? direction});

  Future<BigInt> melt({required MeltQuote quote});

  Future<MeltQuote> meltBolt12Quote(
      {required String request, MeltOptions? opts});

  Future<MeltQuote> meltQuote({required String request, MeltOptions? opts});

  Stream<MintQuote> mint({required BigInt amount, String? description});

  factory Wallet(
          {required String mintUrl,
          required String unit,
          required List<int> seed,
          BigInt? targetProofCount,
          required WalletDatabase db}) =>
      RustLib.instance.api.crateApiWalletWalletNew(
          mintUrl: mintUrl,
          unit: unit,
          seed: seed,
          targetProofCount: targetProofCount,
          db: db);

  static Wallet newFromHexSeed(
          {required String mintUrl,
          required String unit,
          required String seed,
          BigInt? targetProofCount,
          required WalletDatabase db}) =>
      RustLib.instance.api.crateApiWalletWalletNewFromHexSeed(
          mintUrl: mintUrl,
          unit: unit,
          seed: seed,
          targetProofCount: targetProofCount,
          db: db);

  Future<void> payRequest(
      {required PreparedSend send, String? memo, bool? includeMemo});

  Future<PreparedSend> preparePayRequest({required PaymentRequest request});

  Future<PreparedSend> prepareSend({required BigInt amount, SendOptions? opts});

  Future<BigInt> receive({required Token token, ReceiveOptions? opts});

  Future<void> reclaimReserved();

  Future<void> reclaimSend({required Token token});

  Future<void> restore();

  Future<void> revertTransaction({required String transactionId});

  Future<Token> send(
      {required PreparedSend send, String? memo, bool? includeMemo});

  Stream<BigInt> streamBalance();
}

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<WalletDatabase>>
abstract class WalletDatabase implements RustOpaqueInterface {
  String get path;

  set path(String path);

  Future<List<Mint>> listMints(
      {String? unit, Uint8List? seed, String? hexSeed});

  // HINT: Make it `#[frb(sync)]` to let it become the default constructor of Dart class.
  static Future<WalletDatabase> newInstance({required String path}) =>
      RustLib.instance.api.crateApiWalletWalletDatabaseNew(path: path);

  Future<void> removeMint({required String mintUrl});
}

class MeltOptions {
  final BigInt? mpp;
  final BigInt? amountlessMsat;

  const MeltOptions({
    this.mpp,
    this.amountlessMsat,
  });

  @override
  int get hashCode => mpp.hashCode ^ amountlessMsat.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeltOptions &&
          runtimeType == other.runtimeType &&
          mpp == other.mpp &&
          amountlessMsat == other.amountlessMsat;
}

class MeltQuote {
  final String id;
  final String request;
  final BigInt amount;
  final BigInt feeReserve;
  final BigInt expiry;

  const MeltQuote({
    required this.id,
    required this.request,
    required this.amount,
    required this.feeReserve,
    required this.expiry,
  });

  @override
  int get hashCode =>
      id.hashCode ^
      request.hashCode ^
      amount.hashCode ^
      feeReserve.hashCode ^
      expiry.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeltQuote &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          request == other.request &&
          amount == other.amount &&
          feeReserve == other.feeReserve &&
          expiry == other.expiry;
}

class MintQuote {
  final String id;
  final String request;
  final BigInt? amount;
  final BigInt? expiry;
  final MintQuoteState state;
  final Token? token;
  final String? error;

  const MintQuote({
    required this.id,
    required this.request,
    this.amount,
    this.expiry,
    required this.state,
    this.token,
    this.error,
  });

  @override
  int get hashCode =>
      id.hashCode ^
      request.hashCode ^
      amount.hashCode ^
      expiry.hashCode ^
      state.hashCode ^
      token.hashCode ^
      error.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MintQuote &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          request == other.request &&
          amount == other.amount &&
          expiry == other.expiry &&
          state == other.state &&
          token == other.token &&
          error == other.error;
}

enum MintQuoteState {
  unpaid,
  paid,
  issued,
  error,
  ;
}

@freezed
sealed class ParseInputResult with _$ParseInputResult {
  const ParseInputResult._();

  const factory ParseInputResult.bitcoinAddress(
    BitcoinAddress field0,
  ) = ParseInputResult_BitcoinAddress;
  const factory ParseInputResult.bolt11Invoice(
    Bolt11Invoice field0,
  ) = ParseInputResult_Bolt11Invoice;
  const factory ParseInputResult.paymentRequest(
    PaymentRequest field0,
  ) = ParseInputResult_PaymentRequest;
  const factory ParseInputResult.token(
    Token field0,
  ) = ParseInputResult_Token;
}

class ReceiveOptions {
  final List<String>? signingKeys;
  final List<String>? preimages;
  final Map<String, String>? metdata;

  const ReceiveOptions({
    this.signingKeys,
    this.preimages,
    this.metdata,
  });

  static Future<ReceiveOptions> default_() =>
      RustLib.instance.api.crateApiWalletReceiveOptionsDefault();

  @override
  int get hashCode =>
      signingKeys.hashCode ^ preimages.hashCode ^ metdata.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReceiveOptions &&
          runtimeType == other.runtimeType &&
          signingKeys == other.signingKeys &&
          preimages == other.preimages &&
          metdata == other.metdata;
}

class SendOptions {
  final String? memo;
  final bool? includeMemo;
  final String? pubkey;
  final Map<String, String>? metadata;

  const SendOptions({
    this.memo,
    this.includeMemo,
    this.pubkey,
    this.metadata,
  });

  static Future<SendOptions> default_() =>
      RustLib.instance.api.crateApiWalletSendOptionsDefault();

  @override
  int get hashCode =>
      memo.hashCode ^
      includeMemo.hashCode ^
      pubkey.hashCode ^
      metadata.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SendOptions &&
          runtimeType == other.runtimeType &&
          memo == other.memo &&
          includeMemo == other.includeMemo &&
          pubkey == other.pubkey &&
          metadata == other.metadata;
}

class Transaction {
  final String id;
  final String mintUrl;
  final TransactionDirection direction;
  final BigInt amount;
  final BigInt fee;
  final String unit;
  final List<String> ys;
  final BigInt timestamp;
  final String? memo;
  final Map<String, String> metadata;
  final TransactionStatus status;

  const Transaction({
    required this.id,
    required this.mintUrl,
    required this.direction,
    required this.amount,
    required this.fee,
    required this.unit,
    required this.ys,
    required this.timestamp,
    this.memo,
    required this.metadata,
    required this.status,
  });

  @override
  int get hashCode =>
      id.hashCode ^
      mintUrl.hashCode ^
      direction.hashCode ^
      amount.hashCode ^
      fee.hashCode ^
      unit.hashCode ^
      ys.hashCode ^
      timestamp.hashCode ^
      memo.hashCode ^
      metadata.hashCode ^
      status.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Transaction &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          mintUrl == other.mintUrl &&
          direction == other.direction &&
          amount == other.amount &&
          fee == other.fee &&
          unit == other.unit &&
          ys == other.ys &&
          timestamp == other.timestamp &&
          memo == other.memo &&
          metadata == other.metadata &&
          status == other.status;
}

enum TransactionDirection {
  incoming,
  outgoing,
  ;
}

enum TransactionStatus {
  pending,
  settled,
  ;
}
