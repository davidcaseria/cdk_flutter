// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.8.0.

// ignore_for_file: unused_import, unused_element, unnecessary_import, duplicate_ignore, invalid_use_of_internal_member, annotate_overrides, non_constant_identifier_names, curly_braces_in_flow_control_structures, prefer_const_literals_to_create_immutables, unused_field

// Static analysis wrongly picks the IO variant, thus ignore this
// ignore_for_file: argument_type_not_assignable

import 'api/bitcoin.dart';
import 'api/error.dart';
import 'api/mint.dart';
import 'api/payment_request.dart';
import 'api/token.dart';
import 'api/wallet.dart';
import 'dart:async';
import 'dart:convert';
import 'frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated_web.dart';

abstract class RustLibApiImplPlatform extends BaseApiImpl<RustLibWire> {
  RustLibApiImplPlatform({
    required super.handler,
    required super.wire,
    required super.generalizedFrbRustBinding,
    required super.portManager,
  });

  CrossPlatformFinalizerArg
      get rust_arc_decrement_strong_count_MultiMintWalletPtr => wire
          .rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerMultiMintWallet;

  CrossPlatformFinalizerArg
      get rust_arc_decrement_strong_count_PreparedSendPtr => wire
          .rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerPreparedSend;

  CrossPlatformFinalizerArg get rust_arc_decrement_strong_count_WalletPtr => wire
      .rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWallet;

  CrossPlatformFinalizerArg
      get rust_arc_decrement_strong_count_WalletDatabasePtr => wire
          .rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletDatabase;

  @protected
  AnyhowException dco_decode_AnyhowException(dynamic raw);

  @protected
  MultiMintWallet
      dco_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerMultiMintWallet(
          dynamic raw);

  @protected
  PreparedSend
      dco_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerPreparedSend(
          dynamic raw);

  @protected
  Wallet
      dco_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWallet(
          dynamic raw);

  @protected
  WalletDatabase
      dco_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletDatabase(
          dynamic raw);

  @protected
  MultiMintWallet
      dco_decode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerMultiMintWallet(
          dynamic raw);

  @protected
  PreparedSend
      dco_decode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerPreparedSend(
          dynamic raw);

  @protected
  Wallet
      dco_decode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWallet(
          dynamic raw);

  @protected
  MultiMintWallet
      dco_decode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerMultiMintWallet(
          dynamic raw);

  @protected
  PreparedSend
      dco_decode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerPreparedSend(
          dynamic raw);

  @protected
  Wallet
      dco_decode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWallet(
          dynamic raw);

  @protected
  MultiMintWallet
      dco_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerMultiMintWallet(
          dynamic raw);

  @protected
  PreparedSend
      dco_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerPreparedSend(
          dynamic raw);

  @protected
  Wallet
      dco_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWallet(
          dynamic raw);

  @protected
  WalletDatabase
      dco_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletDatabase(
          dynamic raw);

  @protected
  RustStreamSink<MintQuote> dco_decode_StreamSink_mint_quote_Sse(dynamic raw);

  @protected
  RustStreamSink<BigInt> dco_decode_StreamSink_u_64_Sse(dynamic raw);

  @protected
  String dco_decode_String(dynamic raw);

  @protected
  BitcoinAddress dco_decode_bitcoin_address(dynamic raw);

  @protected
  bool dco_decode_bool(dynamic raw);

  @protected
  Wallet
      dco_decode_box_autoadd_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWallet(
          dynamic raw);

  @protected
  BitcoinAddress dco_decode_box_autoadd_bitcoin_address(dynamic raw);

  @protected
  bool dco_decode_box_autoadd_bool(dynamic raw);

  @protected
  MeltQuote dco_decode_box_autoadd_melt_quote(dynamic raw);

  @protected
  MintInfo dco_decode_box_autoadd_mint_info(dynamic raw);

  @protected
  MintVersion dco_decode_box_autoadd_mint_version(dynamic raw);

  @protected
  PaymentRequest dco_decode_box_autoadd_payment_request(dynamic raw);

  @protected
  Token dco_decode_box_autoadd_token(dynamic raw);

  @protected
  BigInt dco_decode_box_autoadd_u_64(dynamic raw);

  @protected
  BigInt dco_decode_box_autoadd_usize(dynamic raw);

  @protected
  ContactInfo dco_decode_contact_info(dynamic raw);

  @protected
  Error dco_decode_error(dynamic raw);

  @protected
  int dco_decode_i_32(dynamic raw);

  @protected
  List<Wallet>
      dco_decode_list_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWallet(
          dynamic raw);

  @protected
  List<String> dco_decode_list_String(dynamic raw);

  @protected
  List<ContactInfo> dco_decode_list_contact_info(dynamic raw);

  @protected
  List<List<String>> dco_decode_list_list_String(dynamic raw);

  @protected
  List<Mint> dco_decode_list_mint(dynamic raw);

  @protected
  List<int> dco_decode_list_prim_u_8_loose(dynamic raw);

  @protected
  Uint8List dco_decode_list_prim_u_8_strict(dynamic raw);

  @protected
  List<Transport> dco_decode_list_transport(dynamic raw);

  @protected
  MeltQuote dco_decode_melt_quote(dynamic raw);

  @protected
  Mint dco_decode_mint(dynamic raw);

  @protected
  MintInfo dco_decode_mint_info(dynamic raw);

  @protected
  MintQuote dco_decode_mint_quote(dynamic raw);

  @protected
  MintQuoteState dco_decode_mint_quote_state(dynamic raw);

  @protected
  MintVersion dco_decode_mint_version(dynamic raw);

  @protected
  String? dco_decode_opt_String(dynamic raw);

  @protected
  Wallet?
      dco_decode_opt_box_autoadd_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWallet(
          dynamic raw);

  @protected
  bool? dco_decode_opt_box_autoadd_bool(dynamic raw);

  @protected
  MintInfo? dco_decode_opt_box_autoadd_mint_info(dynamic raw);

  @protected
  MintVersion? dco_decode_opt_box_autoadd_mint_version(dynamic raw);

  @protected
  PaymentRequest? dco_decode_opt_box_autoadd_payment_request(dynamic raw);

  @protected
  Token? dco_decode_opt_box_autoadd_token(dynamic raw);

  @protected
  BigInt? dco_decode_opt_box_autoadd_u_64(dynamic raw);

  @protected
  BigInt? dco_decode_opt_box_autoadd_usize(dynamic raw);

  @protected
  List<String>? dco_decode_opt_list_String(dynamic raw);

  @protected
  List<ContactInfo>? dco_decode_opt_list_contact_info(dynamic raw);

  @protected
  List<List<String>>? dco_decode_opt_list_list_String(dynamic raw);

  @protected
  ParseInputResult dco_decode_parse_input_result(dynamic raw);

  @protected
  PaymentRequest dco_decode_payment_request(dynamic raw);

  @protected
  Token dco_decode_token(dynamic raw);

  @protected
  Transport dco_decode_transport(dynamic raw);

  @protected
  TransportType dco_decode_transport_type(dynamic raw);

  @protected
  BigInt dco_decode_u_64(dynamic raw);

  @protected
  int dco_decode_u_8(dynamic raw);

  @protected
  void dco_decode_unit(dynamic raw);

  @protected
  BigInt dco_decode_usize(dynamic raw);

  @protected
  AnyhowException sse_decode_AnyhowException(SseDeserializer deserializer);

  @protected
  MultiMintWallet
      sse_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerMultiMintWallet(
          SseDeserializer deserializer);

  @protected
  PreparedSend
      sse_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerPreparedSend(
          SseDeserializer deserializer);

  @protected
  Wallet
      sse_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWallet(
          SseDeserializer deserializer);

  @protected
  WalletDatabase
      sse_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletDatabase(
          SseDeserializer deserializer);

  @protected
  MultiMintWallet
      sse_decode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerMultiMintWallet(
          SseDeserializer deserializer);

  @protected
  PreparedSend
      sse_decode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerPreparedSend(
          SseDeserializer deserializer);

  @protected
  Wallet
      sse_decode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWallet(
          SseDeserializer deserializer);

  @protected
  MultiMintWallet
      sse_decode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerMultiMintWallet(
          SseDeserializer deserializer);

  @protected
  PreparedSend
      sse_decode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerPreparedSend(
          SseDeserializer deserializer);

  @protected
  Wallet
      sse_decode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWallet(
          SseDeserializer deserializer);

  @protected
  MultiMintWallet
      sse_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerMultiMintWallet(
          SseDeserializer deserializer);

  @protected
  PreparedSend
      sse_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerPreparedSend(
          SseDeserializer deserializer);

  @protected
  Wallet
      sse_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWallet(
          SseDeserializer deserializer);

  @protected
  WalletDatabase
      sse_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletDatabase(
          SseDeserializer deserializer);

  @protected
  RustStreamSink<MintQuote> sse_decode_StreamSink_mint_quote_Sse(
      SseDeserializer deserializer);

  @protected
  RustStreamSink<BigInt> sse_decode_StreamSink_u_64_Sse(
      SseDeserializer deserializer);

  @protected
  String sse_decode_String(SseDeserializer deserializer);

  @protected
  BitcoinAddress sse_decode_bitcoin_address(SseDeserializer deserializer);

  @protected
  bool sse_decode_bool(SseDeserializer deserializer);

  @protected
  Wallet
      sse_decode_box_autoadd_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWallet(
          SseDeserializer deserializer);

  @protected
  BitcoinAddress sse_decode_box_autoadd_bitcoin_address(
      SseDeserializer deserializer);

  @protected
  bool sse_decode_box_autoadd_bool(SseDeserializer deserializer);

  @protected
  MeltQuote sse_decode_box_autoadd_melt_quote(SseDeserializer deserializer);

  @protected
  MintInfo sse_decode_box_autoadd_mint_info(SseDeserializer deserializer);

  @protected
  MintVersion sse_decode_box_autoadd_mint_version(SseDeserializer deserializer);

  @protected
  PaymentRequest sse_decode_box_autoadd_payment_request(
      SseDeserializer deserializer);

  @protected
  Token sse_decode_box_autoadd_token(SseDeserializer deserializer);

  @protected
  BigInt sse_decode_box_autoadd_u_64(SseDeserializer deserializer);

  @protected
  BigInt sse_decode_box_autoadd_usize(SseDeserializer deserializer);

  @protected
  ContactInfo sse_decode_contact_info(SseDeserializer deserializer);

  @protected
  Error sse_decode_error(SseDeserializer deserializer);

  @protected
  int sse_decode_i_32(SseDeserializer deserializer);

  @protected
  List<Wallet>
      sse_decode_list_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWallet(
          SseDeserializer deserializer);

  @protected
  List<String> sse_decode_list_String(SseDeserializer deserializer);

  @protected
  List<ContactInfo> sse_decode_list_contact_info(SseDeserializer deserializer);

  @protected
  List<List<String>> sse_decode_list_list_String(SseDeserializer deserializer);

  @protected
  List<Mint> sse_decode_list_mint(SseDeserializer deserializer);

  @protected
  List<int> sse_decode_list_prim_u_8_loose(SseDeserializer deserializer);

  @protected
  Uint8List sse_decode_list_prim_u_8_strict(SseDeserializer deserializer);

  @protected
  List<Transport> sse_decode_list_transport(SseDeserializer deserializer);

  @protected
  MeltQuote sse_decode_melt_quote(SseDeserializer deserializer);

  @protected
  Mint sse_decode_mint(SseDeserializer deserializer);

  @protected
  MintInfo sse_decode_mint_info(SseDeserializer deserializer);

  @protected
  MintQuote sse_decode_mint_quote(SseDeserializer deserializer);

  @protected
  MintQuoteState sse_decode_mint_quote_state(SseDeserializer deserializer);

  @protected
  MintVersion sse_decode_mint_version(SseDeserializer deserializer);

  @protected
  String? sse_decode_opt_String(SseDeserializer deserializer);

  @protected
  Wallet?
      sse_decode_opt_box_autoadd_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWallet(
          SseDeserializer deserializer);

  @protected
  bool? sse_decode_opt_box_autoadd_bool(SseDeserializer deserializer);

  @protected
  MintInfo? sse_decode_opt_box_autoadd_mint_info(SseDeserializer deserializer);

  @protected
  MintVersion? sse_decode_opt_box_autoadd_mint_version(
      SseDeserializer deserializer);

  @protected
  PaymentRequest? sse_decode_opt_box_autoadd_payment_request(
      SseDeserializer deserializer);

  @protected
  Token? sse_decode_opt_box_autoadd_token(SseDeserializer deserializer);

  @protected
  BigInt? sse_decode_opt_box_autoadd_u_64(SseDeserializer deserializer);

  @protected
  BigInt? sse_decode_opt_box_autoadd_usize(SseDeserializer deserializer);

  @protected
  List<String>? sse_decode_opt_list_String(SseDeserializer deserializer);

  @protected
  List<ContactInfo>? sse_decode_opt_list_contact_info(
      SseDeserializer deserializer);

  @protected
  List<List<String>>? sse_decode_opt_list_list_String(
      SseDeserializer deserializer);

  @protected
  ParseInputResult sse_decode_parse_input_result(SseDeserializer deserializer);

  @protected
  PaymentRequest sse_decode_payment_request(SseDeserializer deserializer);

  @protected
  Token sse_decode_token(SseDeserializer deserializer);

  @protected
  Transport sse_decode_transport(SseDeserializer deserializer);

  @protected
  TransportType sse_decode_transport_type(SseDeserializer deserializer);

  @protected
  BigInt sse_decode_u_64(SseDeserializer deserializer);

  @protected
  int sse_decode_u_8(SseDeserializer deserializer);

  @protected
  void sse_decode_unit(SseDeserializer deserializer);

  @protected
  BigInt sse_decode_usize(SseDeserializer deserializer);

  @protected
  void sse_encode_AnyhowException(
      AnyhowException self, SseSerializer serializer);

  @protected
  void
      sse_encode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerMultiMintWallet(
          MultiMintWallet self, SseSerializer serializer);

  @protected
  void
      sse_encode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerPreparedSend(
          PreparedSend self, SseSerializer serializer);

  @protected
  void
      sse_encode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWallet(
          Wallet self, SseSerializer serializer);

  @protected
  void
      sse_encode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletDatabase(
          WalletDatabase self, SseSerializer serializer);

  @protected
  void
      sse_encode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerMultiMintWallet(
          MultiMintWallet self, SseSerializer serializer);

  @protected
  void
      sse_encode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerPreparedSend(
          PreparedSend self, SseSerializer serializer);

  @protected
  void
      sse_encode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWallet(
          Wallet self, SseSerializer serializer);

  @protected
  void
      sse_encode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerMultiMintWallet(
          MultiMintWallet self, SseSerializer serializer);

  @protected
  void
      sse_encode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerPreparedSend(
          PreparedSend self, SseSerializer serializer);

  @protected
  void
      sse_encode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWallet(
          Wallet self, SseSerializer serializer);

  @protected
  void
      sse_encode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerMultiMintWallet(
          MultiMintWallet self, SseSerializer serializer);

  @protected
  void
      sse_encode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerPreparedSend(
          PreparedSend self, SseSerializer serializer);

  @protected
  void
      sse_encode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWallet(
          Wallet self, SseSerializer serializer);

  @protected
  void
      sse_encode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletDatabase(
          WalletDatabase self, SseSerializer serializer);

  @protected
  void sse_encode_StreamSink_mint_quote_Sse(
      RustStreamSink<MintQuote> self, SseSerializer serializer);

  @protected
  void sse_encode_StreamSink_u_64_Sse(
      RustStreamSink<BigInt> self, SseSerializer serializer);

  @protected
  void sse_encode_String(String self, SseSerializer serializer);

  @protected
  void sse_encode_bitcoin_address(
      BitcoinAddress self, SseSerializer serializer);

  @protected
  void sse_encode_bool(bool self, SseSerializer serializer);

  @protected
  void
      sse_encode_box_autoadd_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWallet(
          Wallet self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_bitcoin_address(
      BitcoinAddress self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_bool(bool self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_melt_quote(
      MeltQuote self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_mint_info(
      MintInfo self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_mint_version(
      MintVersion self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_payment_request(
      PaymentRequest self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_token(Token self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_u_64(BigInt self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_usize(BigInt self, SseSerializer serializer);

  @protected
  void sse_encode_contact_info(ContactInfo self, SseSerializer serializer);

  @protected
  void sse_encode_error(Error self, SseSerializer serializer);

  @protected
  void sse_encode_i_32(int self, SseSerializer serializer);

  @protected
  void
      sse_encode_list_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWallet(
          List<Wallet> self, SseSerializer serializer);

  @protected
  void sse_encode_list_String(List<String> self, SseSerializer serializer);

  @protected
  void sse_encode_list_contact_info(
      List<ContactInfo> self, SseSerializer serializer);

  @protected
  void sse_encode_list_list_String(
      List<List<String>> self, SseSerializer serializer);

  @protected
  void sse_encode_list_mint(List<Mint> self, SseSerializer serializer);

  @protected
  void sse_encode_list_prim_u_8_loose(List<int> self, SseSerializer serializer);

  @protected
  void sse_encode_list_prim_u_8_strict(
      Uint8List self, SseSerializer serializer);

  @protected
  void sse_encode_list_transport(
      List<Transport> self, SseSerializer serializer);

  @protected
  void sse_encode_melt_quote(MeltQuote self, SseSerializer serializer);

  @protected
  void sse_encode_mint(Mint self, SseSerializer serializer);

  @protected
  void sse_encode_mint_info(MintInfo self, SseSerializer serializer);

  @protected
  void sse_encode_mint_quote(MintQuote self, SseSerializer serializer);

  @protected
  void sse_encode_mint_quote_state(
      MintQuoteState self, SseSerializer serializer);

  @protected
  void sse_encode_mint_version(MintVersion self, SseSerializer serializer);

  @protected
  void sse_encode_opt_String(String? self, SseSerializer serializer);

  @protected
  void
      sse_encode_opt_box_autoadd_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWallet(
          Wallet? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_box_autoadd_bool(bool? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_box_autoadd_mint_info(
      MintInfo? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_box_autoadd_mint_version(
      MintVersion? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_box_autoadd_payment_request(
      PaymentRequest? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_box_autoadd_token(Token? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_box_autoadd_u_64(BigInt? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_box_autoadd_usize(BigInt? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_list_String(List<String>? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_list_contact_info(
      List<ContactInfo>? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_list_list_String(
      List<List<String>>? self, SseSerializer serializer);

  @protected
  void sse_encode_parse_input_result(
      ParseInputResult self, SseSerializer serializer);

  @protected
  void sse_encode_payment_request(
      PaymentRequest self, SseSerializer serializer);

  @protected
  void sse_encode_token(Token self, SseSerializer serializer);

  @protected
  void sse_encode_transport(Transport self, SseSerializer serializer);

  @protected
  void sse_encode_transport_type(TransportType self, SseSerializer serializer);

  @protected
  void sse_encode_u_64(BigInt self, SseSerializer serializer);

  @protected
  void sse_encode_u_8(int self, SseSerializer serializer);

  @protected
  void sse_encode_unit(void self, SseSerializer serializer);

  @protected
  void sse_encode_usize(BigInt self, SseSerializer serializer);
}

// Section: wire_class

class RustLibWire implements BaseWire {
  RustLibWire.fromExternalLibrary(ExternalLibrary lib);

  void rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerMultiMintWallet(
          int ptr) =>
      wasmModule
          .rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerMultiMintWallet(
              ptr);

  void rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerMultiMintWallet(
          int ptr) =>
      wasmModule
          .rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerMultiMintWallet(
              ptr);

  void rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerPreparedSend(
          int ptr) =>
      wasmModule
          .rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerPreparedSend(
              ptr);

  void rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerPreparedSend(
          int ptr) =>
      wasmModule
          .rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerPreparedSend(
              ptr);

  void rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWallet(
          int ptr) =>
      wasmModule
          .rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWallet(
              ptr);

  void rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWallet(
          int ptr) =>
      wasmModule
          .rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWallet(
              ptr);

  void rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletDatabase(
          int ptr) =>
      wasmModule
          .rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletDatabase(
              ptr);

  void rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletDatabase(
          int ptr) =>
      wasmModule
          .rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletDatabase(
              ptr);
}

@JS('wasm_bindgen')
external RustLibWasmModule get wasmModule;

@JS()
@anonymous
extension type RustLibWasmModule._(JSObject _) implements JSObject {
  external void
      rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerMultiMintWallet(
          int ptr);

  external void
      rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerMultiMintWallet(
          int ptr);

  external void
      rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerPreparedSend(
          int ptr);

  external void
      rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerPreparedSend(
          int ptr);

  external void
      rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWallet(
          int ptr);

  external void
      rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWallet(
          int ptr);

  external void
      rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletDatabase(
          int ptr);

  external void
      rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletDatabase(
          int ptr);
}
