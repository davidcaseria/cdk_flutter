library;

import 'package:cdk_flutter/src/rust/frb_generated.dart';

export 'src/rust/api/error.dart';
export 'src/rust/api/key.dart';
export 'src/rust/api/mint.dart';
export 'src/rust/api/payment_request.dart';
export 'src/rust/api/token.dart';
export 'src/rust/api/wallet.dart';
export 'widgets.dart';

class CdkFlutter {
  static Future<void> init() async {
    await RustLib.init();
  }
}
