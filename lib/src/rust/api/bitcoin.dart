// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.9.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'payment_request.dart';

// These function are ignored because they are on traits that is not defined in current crate (put an empty `#[frb]` on it to unignore): `from_str`

class BitcoinAddress {
  final String address;
  final BigInt? amount;
  final String? lightning;
  final PaymentRequest? cashu;

  const BitcoinAddress({
    required this.address,
    this.amount,
    this.lightning,
    this.cashu,
  });

  @override
  int get hashCode =>
      address.hashCode ^ amount.hashCode ^ lightning.hashCode ^ cashu.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BitcoinAddress &&
          runtimeType == other.runtimeType &&
          address == other.address &&
          amount == other.amount &&
          lightning == other.lightning &&
          cashu == other.cashu;
}
