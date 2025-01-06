import 'package:cdk_flutter/src/rust/api/wallet.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class MintListBuilder extends StatelessWidget {
  final AsyncWidgetBuilder<List<String>> builder;

  const MintListBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    final wallet = context.read<MultiMintWallet>();
    return FutureBuilder<List<String>>(
      future: wallet.listMints(),
      builder: builder,
    );
  }
}

class MintQuoteBuilder extends StatefulWidget {
  final String? mintUrl;
  final BigInt amount;
  final void Function(MintQuote quote)? listener;
  final AsyncWidgetBuilder<MintQuote> builder;

  const MintQuoteBuilder({super.key, required this.amount, this.mintUrl, this.listener, required this.builder});

  @override
  MintQuoteBuilderState createState() => MintQuoteBuilderState();
}

class MintQuoteBuilderState extends State<MintQuoteBuilder> {
  final ValueNotifier<MintQuote?> _mintQuoteNotifier = ValueNotifier<MintQuote?>(null);

  @override
  void dispose() {
    _mintQuoteNotifier.dispose();
    super.dispose();
  }

  void _updateMintQuote(MintQuote? mintQuote) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mintQuoteNotifier.value = mintQuote;
    });
  }

  ValueListenableBuilder<MintQuote?> buildWithWallet(Wallet wallet) {
    final stream = wallet.mint(amount: widget.amount);
    return ValueListenableBuilder<MintQuote?>(
      valueListenable: _mintQuoteNotifier,
      builder: (context, mintQuote, child) {
        if (mintQuote != null && widget.listener != null) {
          widget.listener!(mintQuote);
        }
        return StreamBuilder<MintQuote>(
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _updateMintQuote(snapshot.data);
            }
            return widget.builder(context, snapshot);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mintUrl == null) {
      final wallet = context.read<Wallet>();
      return buildWithWallet(wallet);
    } else {
      final wallet = context.read<MultiMintWallet>();
      return FutureBuilder<Wallet?>(
        future: wallet.getWallet(mintUrl: widget.mintUrl!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return widget.builder(context, AsyncSnapshot<MintQuote>.nothing());
          } else if (snapshot.hasData) {
            return buildWithWallet(snapshot.data!);
          } else {
            return widget.builder(context, AsyncSnapshot<MintQuote>.nothing());
          }
        },
      );
    }
  }
}

class WalletBalanceBuilder extends StatelessWidget {
  final AsyncWidgetBuilder<BigInt> builder;

  const WalletBalanceBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    final wallet = context.read<Wallet?>();
    if (wallet != null) {
      return StreamBuilder<BigInt>(
        stream: wallet.streamBalance(),
        builder: builder,
      );
    } else {
      final multiMintWallet = context.read<MultiMintWallet>();
      return StreamBuilder<BigInt>(
        stream: multiMintWallet.streamBalance(),
        builder: builder,
      );
    }
  }
}

class WalletConsumer extends StatelessWidget {
  final String? mintUrl;
  final Widget Function(BuildContext context, Wallet wallet) builder;

  const WalletConsumer({super.key, this.mintUrl, required this.builder});

  @override
  Widget build(BuildContext context) {
    if (mintUrl != null) {
      final wallet = context.read<MultiMintWallet>();
      return FutureBuilder<Wallet?>(
        future: wallet.getWallet(mintUrl: mintUrl!),
        builder: (context, snapshot) {
          // TODO: handle error
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox();
          } else if (snapshot.hasData) {
            return builder(context, snapshot.data!);
          } else {
            return const SizedBox();
          }
        },
      );
    }
    final wallet = context.read<Wallet>();
    return builder(context, wallet);
  }
}

class WalletProvider extends StatelessWidget {
  final Wallet wallet;
  final Widget child;

  const WalletProvider({super.key, required this.wallet, required this.child});

  @override
  Widget build(BuildContext context) {
    return Provider<Wallet>.value(
      value: wallet,
      child: child,
    );
  }
}

class MultiMintWalletProvider extends StatelessWidget {
  final MultiMintWallet wallet;
  final Widget child;

  const MultiMintWalletProvider({super.key, required this.wallet, required this.child});

  @override
  Widget build(BuildContext context) {
    return Provider<MultiMintWallet>.value(
      value: wallet,
      child: child,
    );
  }
}
