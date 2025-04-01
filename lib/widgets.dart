import 'package:cdk_flutter/src/rust/api/mint.dart';
import 'package:cdk_flutter/src/rust/api/token.dart';
import 'package:cdk_flutter/src/rust/api/wallet.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class MeltQuoteBuilder extends StatefulWidget {
  final String? mintUrl;
  final String request;
  final void Function(BigInt) onSuccess;
  final AsyncWidgetBuilder<MeltQuoteResult> builder;

  const MeltQuoteBuilder({super.key, this.mintUrl, required this.request, required this.onSuccess, required this.builder});

  @override
  MeltQuoteBuilderState createState() => MeltQuoteBuilderState();
}

class MeltQuoteBuilderState extends State<MeltQuoteBuilder> {
  Future<MeltQuoteResult> _createMeltQuoteResult(Wallet wallet) async {
    final quote = await wallet.meltQuote(request: widget.request);
    return MeltQuoteResult(
      quote: quote,
      melt: () async {
        final amount = await wallet.melt(quote: quote);
        widget.onSuccess(amount);
      },
    );
  }

  Widget buildWithWallet(BuildContext context, Wallet wallet) {
    return FutureBuilder<MeltQuoteResult>(
      future: _createMeltQuoteResult(wallet),
      builder: widget.builder,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mintUrl == null) {
      final wallet = context.read<Wallet>();
      return buildWithWallet(context, wallet);
    } else {
      final wallet = context.read<MultiMintWallet>();
      return FutureBuilder<Wallet?>(
        future: wallet.getWallet(mintUrl: widget.mintUrl!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return widget.builder(context, AsyncSnapshot<MeltQuoteResult>.nothing());
          } else if (snapshot.hasData) {
            return buildWithWallet(context, snapshot.data!);
          } else {
            return widget.builder(context, AsyncSnapshot<MeltQuoteResult>.nothing());
          }
        },
      );
    }
  }
}

class MeltQuoteResult {
  final MeltQuote quote;
  final VoidCallback melt;

  const MeltQuoteResult({required this.quote, required this.melt});
}

class MintListBuilder extends StatelessWidget {
  final BigInt? amount;
  final List<String>? availableMintUrls;
  final AsyncWidgetBuilder<List<Mint>> builder;

  const MintListBuilder({super.key, this.amount, this.availableMintUrls, required this.builder});

  @override
  Widget build(BuildContext context) {
    final wallet = context.read<MultiMintWallet>();
    if (availableMintUrls != null) {
      return FutureBuilder<List<Mint>>(
        future: wallet.availableMints(amount: amount, mintUrls: availableMintUrls!),
        builder: builder,
      );
    }
    return FutureBuilder<List<Mint>>(
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

class ReceiveBuilder extends StatelessWidget {
  final String? mintUrl;
  final List<String>? signingKeys;
  final List<String>? preimages;
  final String token;
  final AsyncWidgetBuilder<ReceiveResult> builder;

  const ReceiveBuilder({super.key, this.mintUrl, this.signingKeys, this.preimages, required this.token, required this.builder});

  Widget _buildWithWallet(Wallet wallet) {
    final token = Token.parse(encoded: this.token);
    return FutureBuilder<BigInt?>(
      future: wallet.receive(token: token, opts: ReceiveOptions(signingKeys: signingKeys, preimages: preimages)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return builder(context, AsyncSnapshot<ReceiveResult>.nothing());
        } else if (snapshot.hasData) {
          return builder(context, AsyncSnapshot<ReceiveResult>.withData(ConnectionState.active, ReceiveResult(token, snapshot.data!)));
        } else {
          return builder(context, AsyncSnapshot<ReceiveResult>.nothing());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (mintUrl != null) {
      final wallet = context.read<MultiMintWallet>();
      return FutureBuilder<Wallet?>(
        future: wallet.getWallet(mintUrl: mintUrl!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox();
          } else if (snapshot.hasData) {
            return _buildWithWallet(snapshot.data!);
          } else {
            return const SizedBox();
          }
        },
      );
    }
    final wallet = context.read<Wallet>();
    return _buildWithWallet(wallet);
  }
}

class ReceiveResult {
  final Token token;
  final BigInt receivedAmount;

  const ReceiveResult(this.token, this.receivedAmount);
}

class SendBuilder extends StatelessWidget {
  final String? mintUrl;
  final BigInt amount;
  final String? pubkey;
  final String? memo;
  final bool? includeMemo;
  final Function(String error)? onError;
  final Function(Token token) onSuccess;
  final AsyncWidgetBuilder<PreparedSendResult> builder;

  const SendBuilder(
      {super.key, required this.amount, this.mintUrl, this.pubkey, this.memo, this.includeMemo, this.onError, required this.onSuccess, required this.builder});

  Widget _buildWithWallet(Wallet wallet) {
    return FutureBuilder<PreparedSend>(
      future: wallet.prepareSend(amount: amount, opts: SendOptions(pubkey: pubkey, memo: memo, includeMemo: includeMemo)),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final preparedSend = snapshot.data!;
          send({String? memo, bool? includeMemo}) async {
            try {
              final token = await wallet.send(send: preparedSend, memo: memo, includeMemo: includeMemo);
              onSuccess(token);
            } catch (e) {
              if (onError != null) {
                onError!(e.toString());
              }
            }
          }

          return builder(context, AsyncSnapshot<PreparedSendResult>.withData(ConnectionState.active, PreparedSendResult(preparedSend, send)));
        } else {
          return builder(context, AsyncSnapshot<PreparedSendResult>.nothing());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (mintUrl != null) {
      final wallet = context.read<MultiMintWallet>();
      return FutureBuilder<Wallet?>(
        future: wallet.getWallet(mintUrl: mintUrl!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox();
          } else if (snapshot.hasData) {
            return _buildWithWallet(snapshot.data!);
          } else {
            return const SizedBox();
          }
        },
      );
    }
    final wallet = context.read<Wallet>();
    return _buildWithWallet(wallet);
  }
}

class PreparedSendResult {
  final PreparedSend preparedSend;
  final Function({String? memo, bool? includeMemo}) send;
  const PreparedSendResult(this.preparedSend, this.send);
}

class TransactionListBuilder extends StatelessWidget {
  final String? mintUrl;
  final TransactionDirection? direction;
  final AsyncWidgetBuilder<List<Transaction>> builder;

  const TransactionListBuilder({super.key, this.mintUrl, this.direction, required this.builder});

  @override
  Widget build(BuildContext context) {
    return WalletBalanceBuilder(builder: (context, snapshot) {
      final wallet = context.read<Wallet?>();
      if (wallet != null) {
        return FutureBuilder<List<Transaction>>(
          future: wallet.listTransactions(direction: direction),
          builder: builder,
        );
      } else {
        final multiMintWallet = context.read<MultiMintWallet>();
        return FutureBuilder<List<Transaction>>(
          future: multiMintWallet.listTransactions(direction: direction, mintUrl: mintUrl),
          builder: builder,
        );
      }
    });
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

class MultiMintWalletConsumer extends StatelessWidget {
  final Widget Function(BuildContext context, MultiMintWallet wallet) builder;

  const MultiMintWalletConsumer({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    final wallet = context.read<MultiMintWallet>();
    return builder(context, wallet);
  }
}
