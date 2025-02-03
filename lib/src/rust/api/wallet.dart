// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.7.1.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'error.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'token.dart';

// These functions are ignored because they are not marked as `pub`: `mint_url`, `unit`, `update_balance_streams`
// These function are ignored because they are on traits that is not defined in current crate (put an empty `#[frb]` on it to unignore): `clone`, `clone`, `clone`, `from`, `from`

Uint8List generateSeed() => RustLib.instance.api.crateApiWalletGenerateSeed();

String generateHexSeed() =>
    RustLib.instance.api.crateApiWalletGenerateHexSeed();

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<MultiMintWallet>>
abstract class MultiMintWallet implements RustOpaqueInterface {
  Future<void> addWallet({required Wallet wallet});

  String get unit;

  set unit(String unit);

  Future<Wallet?> getWallet({required String mintUrl});

  Future<List<String>> listMints();

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

  Stream<BigInt> streamBalance();

  Future<BigInt> totalBalance();
}

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<Wallet>>
abstract class Wallet implements RustOpaqueInterface {
  String get mintUrl;

  String get unit;

  set mintUrl(String mintUrl);

  set unit(String unit);

  Future<BigInt> balance();

  Future<bool> isTokenSpent({required Token token});

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
          required String currencyUnit,
          required String seed,
          BigInt? targetProofCount,
          required WalletDatabase localstore}) =>
      RustLib.instance.api.crateApiWalletWalletNewFromHexSeed(
          mintUrl: mintUrl,
          currencyUnit: currencyUnit,
          seed: seed,
          targetProofCount: targetProofCount,
          localstore: localstore);

  Future<BigInt> receive(
      {required String token, String? p2PkSigningKey, String? preimage});

  Future<String> send({required BigInt amount, String? memo, String? pubkey});

  Stream<BigInt> streamBalance();
}

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<WalletDatabase>>
abstract class WalletDatabase implements RustOpaqueInterface {
  factory WalletDatabase({required String path}) =>
      RustLib.instance.api.crateApiWalletWalletDatabaseNew(path: path);
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
