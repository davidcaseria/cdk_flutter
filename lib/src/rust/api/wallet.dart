// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.9.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'bitcoin.dart';
import 'error.dart';
import 'mint.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'package:freezed_annotation/freezed_annotation.dart' hide protected;
import 'payment_request.dart';
import 'token.dart';
part 'wallet.freezed.dart';

// These functions are ignored because they are not marked as `pub`: `mint_url`, `unit`, `update_balance_streams`
// These function are ignored because they are on traits that is not defined in current crate (put an empty `#[frb]` on it to unignore): `clone`, `clone`, `clone`, `from`, `from`, `from`, `from`

Uint8List generateSeed() => RustLib.instance.api.crateApiWalletGenerateSeed();

String generateHexSeed() =>
    RustLib.instance.api.crateApiWalletGenerateHexSeed();

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

  Future<Wallet?> getWallet({required String mintUrl});

  Future<List<Mint>> listMints();

  Future<List<Wallet>> listWallets();

  // HINT: Make it `#[frb(sync)]` to let it become the default constructor of Dart class.
  static Future<MultiMintWallet> newInstance(
          {required String unit,
          required List<int> seed,
          BigInt? targetProofCount,
          required WalletDatabase localstore}) =>
      RustLib.instance.api.crateApiWalletMultiMintWalletNew(
          unit: unit,
          seed: seed,
          targetProofCount: targetProofCount,
          localstore: localstore);

  static Future<MultiMintWallet> newFromHexSeed(
          {required String unit,
          required String seed,
          BigInt? targetProofCount,
          required WalletDatabase localstore}) =>
      RustLib.instance.api.crateApiWalletMultiMintWalletNewFromHexSeed(
          unit: unit,
          seed: seed,
          targetProofCount: targetProofCount,
          localstore: localstore);

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

  Future<Mint> getMint();

  Future<bool> isTokenSpent({required Token token});

  Future<BigInt> melt({required MeltQuote quote});

  Future<MeltQuote> meltQuote({required String request});

  Stream<MintQuote> mint({required BigInt amount, String? description});

  factory Wallet(
          {required String mintUrl,
          required String unit,
          required List<int> seed,
          BigInt? targetProofCount,
          required WalletDatabase localstore}) =>
      RustLib.instance.api.crateApiWalletWalletNew(
          mintUrl: mintUrl,
          unit: unit,
          seed: seed,
          targetProofCount: targetProofCount,
          localstore: localstore);

  static Wallet newFromHexSeed(
          {required String mintUrl,
          required String unit,
          required String seed,
          BigInt? targetProofCount,
          required WalletDatabase localstore}) =>
      RustLib.instance.api.crateApiWalletWalletNewFromHexSeed(
          mintUrl: mintUrl,
          unit: unit,
          seed: seed,
          targetProofCount: targetProofCount,
          localstore: localstore);

  Future<void> payRequest(
      {required PaymentRequest request,
      required PreparedSend send,
      String? memo,
      bool? includeMemo});

  Future<PreparedSend> preparePayRequest({required PaymentRequest request});

  Future<PreparedSend> prepareSend(
      {required BigInt amount,
      String? pubkey,
      String? memo,
      bool? includeMemo});

  Future<BigInt> receive(
      {required Token token, String? signingKey, String? preimage});

  Future<void> reclaimSend({required Token token});

  Future<Token> send(
      {required PreparedSend send, String? memo, bool? includeMemo});

  Stream<BigInt> streamBalance();
}

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<WalletDatabase>>
abstract class WalletDatabase implements RustOpaqueInterface {
  factory WalletDatabase({required String path}) =>
      RustLib.instance.api.crateApiWalletWalletDatabaseNew(path: path);
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
  final BigInt amount;
  final BigInt? expiry;
  final MintQuoteState state;
  final Token? token;

  const MintQuote({
    required this.id,
    required this.request,
    required this.amount,
    this.expiry,
    required this.state,
    this.token,
  });

  @override
  int get hashCode =>
      id.hashCode ^
      request.hashCode ^
      amount.hashCode ^
      expiry.hashCode ^
      state.hashCode ^
      token.hashCode;

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
          token == other.token;
}

enum MintQuoteState {
  unpaid,
  paid,
  issued,
  ;
}

@freezed
sealed class ParseInputResult with _$ParseInputResult {
  const ParseInputResult._();

  const factory ParseInputResult.bitcoinAddress(
    BitcoinAddress field0,
  ) = ParseInputResult_BitcoinAddress;
  const factory ParseInputResult.paymentRequest(
    PaymentRequest field0,
  ) = ParseInputResult_PaymentRequest;
  const factory ParseInputResult.token(
    Token field0,
  ) = ParseInputResult_Token;
}
