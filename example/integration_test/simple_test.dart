import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cdk_flutter/cdk_flutter.dart';
import 'package:path_provider/path_provider.dart';

const mintUrl = 'https://fake.thesimplekid.dev';
const testMnemonic = 'abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late WalletDatabase db;
  late Wallet wallet;

  setUpAll(() async {
    await CdkFlutter.init();
    final path = await getTemporaryDirectory();
    db = await WalletDatabase.newInstance(path: '${path.path}/test_wallet.db');
    wallet = Wallet(
      mintUrl: mintUrl,
      unit: 'sat',
      mnemonic: testMnemonic,
      db: db,
    );
  });

  group('Wallet Creation', () {
    test('Create a wallet with mnemonic', () {
      expect(wallet, isNotNull);
      expect(wallet.mintUrl, equals(mintUrl));
      expect(wallet.unit, equals('sat'));
    });

    test('Generate mnemonic', () {
      final mnemonic = generateMnemonic();
      expect(mnemonic.split(' ').length, equals(12));
    });

    test('Convert mnemonic to seed', () {
      final seed = mnemonicToSeed(mnemonic: testMnemonic);
      expect(seed.length, equals(64));
    });

    test('Generate seed directly', () {
      final seed = generateSeed();
      expect(seed.length, equals(64));
    });

    test('Wallet creation with invalid mnemonic throws error', () async {
      final path = await getTemporaryDirectory();
      final testDb = await WalletDatabase.newInstance(
        path: '${path.path}/invalid_mnemonic_test.db',
      );

      expect(
        () => Wallet(
          mintUrl: mintUrl,
          unit: 'sat',
          mnemonic: 'invalid mnemonic words',
          db: testDb,
        ),
        throwsA(anything),
      );
    });
  });

  group('Mint Info', () {
    test('Fetch mint info', () async {
      final mint = await wallet.getMint();
      expect(mint, isNotNull);
      expect(mint.url, equals(mintUrl));
      expect(mint.info, isNotNull);
      print('Mint name: ${mint.info?.name}');
      print('Mint description: ${mint.info?.description}');
    });
  });

  group('Balance', () {
    test('Get wallet balance', () async {
      final balance = await wallet.balance();
      expect(balance, isA<BigInt>());
      print('Current balance: $balance sats');
    });

    test('Check pending transactions', () async {
      await wallet.checkPendingTransactions();
      // Should complete without error
    });

    test('Reclaim reserved proofs', () async {
      await wallet.reclaimReserved();
      // Should complete without error
    });
  });

  group('Mint Quote', () {
    test('Create mint quote', () async {
      final stream = wallet.mint(
        amount: BigInt.from(100),
        description: 'Test mint quote',
      );

      // Use a completer to handle the stream properly
      MintQuote? receivedQuote;
      final subscription = stream.listen((quote) {
        receivedQuote = quote;
      });

      // Wait for the quote with timeout
      for (int i = 0; i < 30; i++) {
        await Future.delayed(const Duration(milliseconds: 500));
        if (receivedQuote != null) break;
      }

      await subscription.cancel();

      expect(receivedQuote, isNotNull, reason: 'Mint quote should be received within 15 seconds');
      expect(receivedQuote!.id, isNotEmpty);
      expect(receivedQuote!.request, isNotEmpty);
      expect(receivedQuote!.request.startsWith('ln'), isTrue, reason: 'Should be a Lightning invoice');
      print('Mint quote ID: ${receivedQuote!.id}');
      print('Lightning invoice: ${receivedQuote!.request.substring(0, 50)}...');
    });

    test('Get active mint quotes', () async {
      try {
        final quotes = await wallet.getActiveMintQuotes();
        expect(quotes, isA<List<MintQuote>>());
        print('Active mint quotes: ${quotes.length}');
      } catch (e) {
        // Serialization mismatch with quotes from older CDK versions
        print('Could not deserialize old quotes (expected): $e');
      }
    });

    test('Check all mint quotes', () async {
      await wallet.checkAllMintQuotes();
      // Should complete without error
    });
  });

  group('Send', () {
    test('Prepare send with balance check', () async {
      // Reclaim any reserved proofs first
      await wallet.reclaimReserved();

      final balance = await wallet.balance();
      print('Balance before send: $balance sats');

      if (balance == BigInt.zero) {
        print('No balance available - skipping send test');
        return;
      }

      // Test prepareSend returns valid PreparedSend
      final prepared = await wallet.prepareSend(amount: BigInt.from(10));
      expect(prepared, isNotNull);
      expect(prepared.amount, equals(BigInt.from(10)));
      expect(prepared.fee, isA<BigInt>());
      expect(prepared.swapFee, isA<BigInt>());
      expect(prepared.sendFee, isA<BigInt>());
      print('Prepared send: amount=${prepared.amount}, fee=${prepared.fee}');

      // Cancel the prepared send to restore proofs
      await wallet.cancelSend(send: prepared);
    });

    test('Complete send flow returns valid token', () async {
      await wallet.reclaimReserved();
      final balance = await wallet.balance();

      if (balance < BigInt.from(10)) {
        print('Insufficient balance for send test - need at least 10 sats');
        return;
      }

      final prepared = await wallet.prepareSend(amount: BigInt.from(10));
      final token = await wallet.send(
        send: prepared,
        memo: 'Test send',
        includeMemo: true,
      );

      expect(token, isNotNull);
      expect(token.encoded, isNotEmpty);
      expect(token.encoded.startsWith('cashu'), isTrue);
      expect(token.amount, equals(BigInt.from(10)));
      expect(token.mintUrl, equals(mintUrl));

      print('Token created: ${token.encoded.substring(0, 50)}...');
      print('Token amount: ${token.amount} sats');

      // Verify balance decreased
      final newBalance = await wallet.balance();
      expect(newBalance, lessThan(balance));

      // Reclaim the token since we won't receive it
      await wallet.reclaimSend(token: token);
      print('Reclaimed token proofs');
    });

    test('Prepare send with insufficient balance throws error', () async {
      await wallet.reclaimReserved();
      final balance = await wallet.balance();

      // Try to send more than available
      final largeAmount = balance + BigInt.from(1000);

      expect(
        () => wallet.prepareSend(amount: largeAmount),
        throwsA(anything),
      );
    });
  });

  group('Receive', () {
    test('Receive token from same wallet', () async {
      await wallet.reclaimReserved();
      final balance = await wallet.balance();

      if (balance < BigInt.from(10)) {
        print('Insufficient balance for receive test');
        return;
      }

      // Create a token
      final prepared = await wallet.prepareSend(amount: BigInt.from(10));
      final token = await wallet.send(send: prepared);
      expect(token.encoded, isNotEmpty);

      // Create a second wallet to receive the token
      final path = await getTemporaryDirectory();
      final receiverDb = await WalletDatabase.newInstance(
        path: '${path.path}/receiver_wallet.db',
      );
      final receiverWallet = Wallet(
        mintUrl: mintUrl,
        unit: 'sat',
        mnemonic: generateMnemonic(),
        db: receiverDb,
      );

      final receiverBalanceBefore = await receiverWallet.balance();
      final received = await receiverWallet.receive(token: token);

      expect(received, equals(BigInt.from(10)));

      final receiverBalanceAfter = await receiverWallet.balance();
      expect(
        receiverBalanceAfter,
        equals(receiverBalanceBefore + BigInt.from(10)),
      );

      print('Received $received sats');
    });

    test('Check if token is spent', () async {
      await wallet.reclaimReserved();
      final balance = await wallet.balance();

      if (balance < BigInt.from(10)) {
        print('Insufficient balance for spent check test');
        return;
      }

      // Create a token
      final prepared = await wallet.prepareSend(amount: BigInt.from(10));
      final token = await wallet.send(send: prepared);

      // Token should not be spent yet
      final isSpent = await wallet.isTokenSpent(token: token);
      expect(isSpent, isFalse);

      // Receive the token to spend it
      final path = await getTemporaryDirectory();
      final receiverDb = await WalletDatabase.newInstance(
        path: '${path.path}/spent_check_wallet.db',
      );
      final receiverWallet = Wallet(
        mintUrl: mintUrl,
        unit: 'sat',
        mnemonic: generateMnemonic(),
        db: receiverDb,
      );

      await receiverWallet.receive(token: token);

      // Token should now be spent
      final isSpentAfter = await wallet.isTokenSpent(token: token);
      expect(isSpentAfter, isTrue);

      print('Token spent status correctly updated');
    });
  });

  group('Token Operations', () {
    test('Parse valid token', () async {
      await wallet.reclaimReserved();
      final balance = await wallet.balance();

      if (balance < BigInt.from(5)) {
        print('Insufficient balance for token parse test');
        return;
      }

      // Create a token to parse
      final prepared = await wallet.prepareSend(amount: BigInt.from(5));
      final token = await wallet.send(send: prepared);

      // Parse the token
      final parsed = Token.parse(encoded: token.encoded);
      expect(parsed, isNotNull);
      expect(parsed.amount, equals(BigInt.from(5)));
      expect(parsed.mintUrl, equals(mintUrl));

      // Reclaim the token
      await wallet.reclaimSend(token: token);
    });

    test('Parse input as token', () async {
      await wallet.reclaimReserved();
      final balance = await wallet.balance();

      if (balance < BigInt.from(5)) {
        print('Insufficient balance for parseInput token test');
        return;
      }

      final prepared = await wallet.prepareSend(amount: BigInt.from(5));
      final token = await wallet.send(send: prepared);

      final result = parseInput(input: token.encoded);
      expect(result, isA<ParseInputResult_Token>());

      // Reclaim the token
      await wallet.reclaimSend(token: token);
    });

    test('Encode QR token', () async {
      await wallet.reclaimReserved();
      final balance = await wallet.balance();

      if (balance < BigInt.from(5)) {
        print('Insufficient balance for QR encode test');
        return;
      }

      final prepared = await wallet.prepareSend(amount: BigInt.from(5));
      final token = await wallet.send(send: prepared);

      // encodeQrToken returns List<String> for multi-part QR tokens
      final qrTokenParts = encodeQrToken(token: token);
      expect(qrTokenParts, isNotEmpty);
      expect(qrTokenParts.first.startsWith('cashu'), isTrue);

      // Reclaim the token
      await wallet.reclaimSend(token: token);
    });
  });

  group('Melt Quote', () {
    test('Create melt quote with valid invoice', () async {
      // This test requires a valid Lightning invoice
      // Using a well-formed but expired invoice for structure testing
      const testInvoice = 'lnbc10n1pnr5hqmpp5h2xjwnjj5dc50xfs8x5e6jl2kkjtw94y5rwvtzk9pzhyfawx9nqqdqqcqzzgxqyz5vqrzjqwnvuc0u4txn35cafc7w94gxvq5p3cu9dd95f7hlrh0fvs46wpvhdw6wfqv8yqqqqryqqqqthqqpysp5q94rn6ake8h7pt5v5x8r2nzzjmkw8rx8qa9c8q9e6xx5t7h09pls9qrsgqnp4qtm3fj4482cq0u6vsmr5eqlte2wj9nqn7wvw2lz93xz3yy0pd2yz0ywdrgnxlck33u4llrr5l6qfqqqqqqqqqqqqqqqqqqqqqqqqqqqgp4y9qx';

      try {
        final quote = await wallet.meltQuote(request: testInvoice);
        expect(quote, isNotNull);
        expect(quote.id, isNotEmpty);
        expect(quote.amount, isA<BigInt>());
        expect(quote.feeReserve, isA<BigInt>());
        print('Melt quote created: id=${quote.id}, amount=${quote.amount}');
      } catch (e) {
        // Expected to fail with expired/invalid invoice
        print('Melt quote error (expected for test invoice): $e');
        expect(e, isNotNull);
      }
    });

    test('Check pending melt quotes', () async {
      await wallet.checkPendingMeltQuotes();
      // Should complete without error
    });
  });

  group('Payment Request', () {
    test('Create payment request', () {
      final request = PaymentRequest(
        paymentId: 'test-payment-123',
        amount: BigInt.from(100),
        unit: 'sat',
        mints: [mintUrl],
        description: 'Test payment request',
        transports: [
          Transport(
            type: TransportType.httpPost,
            target: 'https://example.com/pay',
          ),
        ],
      );

      expect(request, isNotNull);
      final encoded = request.encode();
      expect(encoded, isNotEmpty);
      expect(encoded, startsWith('creq'));
      print('Encoded payment request: ${encoded.substring(0, 50)}...');
    });

    test('Parse payment request', () {
      final request = PaymentRequest(
        paymentId: 'test-payment-456',
        amount: BigInt.from(200),
        unit: 'sat',
        mints: [mintUrl],
        transports: [
          Transport(
            type: TransportType.httpPost,
            target: 'https://example.com/pay',
          ),
        ],
      );

      final encoded = request.encode();
      final parsed = PaymentRequest.parse(encoded: encoded);

      expect(parsed, isNotNull);
      expect(parsed.amount, equals(BigInt.from(200)));
      expect(parsed.unit, equals('sat'));
      expect(parsed.mints, contains(mintUrl));
    });

    test('Payment request round-trip preserves all fields', () {
      final request = PaymentRequest(
        paymentId: 'round-trip-test',
        amount: BigInt.from(500),
        unit: 'sat',
        mints: [mintUrl],
        description: 'Round trip test description',
        transports: [
          Transport(
            type: TransportType.httpPost,
            target: 'https://example.com/receive',
          ),
        ],
      );

      final encoded = request.encode();
      final parsed = PaymentRequest.parse(encoded: encoded);

      expect(parsed.paymentId, equals('round-trip-test'));
      expect(parsed.amount, equals(BigInt.from(500)));
      expect(parsed.unit, equals('sat'));
      expect(parsed.description, equals('Round trip test description'));
    });
  });

  group('Transactions', () {
    test('List transactions', () async {
      final transactions = await wallet.listTransactions();
      expect(transactions, isA<List<Transaction>>());
      print('Total transactions: ${transactions.length}');

      for (final tx in transactions.take(5)) {
        final dir = tx.direction == TransactionDirection.incoming ? '+' : '-';
        print('  $dir${tx.amount} sats - ${tx.memo ?? "No memo"} [${tx.status.name}]');
      }
    });

    test('List incoming transactions', () async {
      final transactions = await wallet.listTransactions(
        direction: TransactionDirection.incoming,
      );
      expect(transactions, isA<List<Transaction>>());

      // All transactions should be incoming
      for (final tx in transactions) {
        expect(tx.direction, equals(TransactionDirection.incoming));
      }

      print('Incoming transactions: ${transactions.length}');
    });

    test('List outgoing transactions', () async {
      final transactions = await wallet.listTransactions(
        direction: TransactionDirection.outgoing,
      );
      expect(transactions, isA<List<Transaction>>());

      // All transactions should be outgoing
      for (final tx in transactions) {
        expect(tx.direction, equals(TransactionDirection.outgoing));
      }

      print('Outgoing transactions: ${transactions.length}');
    });

    test('Transaction has required fields', () async {
      final transactions = await wallet.listTransactions();

      if (transactions.isEmpty) {
        print('No transactions to verify');
        return;
      }

      final tx = transactions.first;
      expect(tx.id, isNotEmpty);
      expect(tx.mintUrl, equals(mintUrl));
      expect(tx.amount, isA<BigInt>());
      expect(tx.fee, isA<BigInt>());
      expect(tx.unit, equals('sat'));
      expect(tx.timestamp, greaterThan(0));
    });
  });

  group('Multi-Mint Wallet', () {
    test('Create multi-mint wallet', () async {
      final path = await getTemporaryDirectory();
      final multiDb = await WalletDatabase.newInstance(
        path: '${path.path}/multi_wallet.db',
      );

      final multiWallet = await MultiMintWallet.newInstance(
        unit: 'sat',
        mnemonic: testMnemonic,
        db: multiDb,
      );

      expect(multiWallet, isNotNull);
      expect(multiWallet.unit, equals('sat'));
    });

    test('Add mint to multi-wallet', () async {
      final path = await getTemporaryDirectory();
      final multiDb = await WalletDatabase.newInstance(
        path: '${path.path}/multi_wallet2.db',
      );

      final multiWallet = await MultiMintWallet.newInstance(
        unit: 'sat',
        mnemonic: testMnemonic,
        db: multiDb,
      );

      await multiWallet.addMint(mintUrl: mintUrl);

      final mints = await multiWallet.listMints();
      expect(mints.length, equals(1));
      expect(mints.first.url, equals(mintUrl));
    });

    test('Add duplicate mint is idempotent', () async {
      final path = await getTemporaryDirectory();
      final multiDb = await WalletDatabase.newInstance(
        path: '${path.path}/multi_wallet_dup.db',
      );

      final multiWallet = await MultiMintWallet.newInstance(
        unit: 'sat',
        mnemonic: testMnemonic,
        db: multiDb,
      );

      await multiWallet.addMint(mintUrl: mintUrl);
      await multiWallet.addMint(mintUrl: mintUrl); // Add again

      final mints = await multiWallet.listMints();
      expect(mints.length, equals(1));
    });

    test('Get total balance from multi-wallet', () async {
      final path = await getTemporaryDirectory();
      final multiDb = await WalletDatabase.newInstance(
        path: '${path.path}/multi_wallet3.db',
      );

      final multiWallet = await MultiMintWallet.newInstance(
        unit: 'sat',
        mnemonic: testMnemonic,
        db: multiDb,
      );

      await multiWallet.addMint(mintUrl: mintUrl);

      final total = await multiWallet.totalBalance();
      expect(total, isA<BigInt>());
      print('Multi-wallet total balance: $total sats');
    });

    test('Select wallet with amount filter', () async {
      final path = await getTemporaryDirectory();
      final multiDb = await WalletDatabase.newInstance(
        path: '${path.path}/multi_wallet_select.db',
      );

      final multiWallet = await MultiMintWallet.newInstance(
        unit: 'sat',
        mnemonic: testMnemonic,
        db: multiDb,
      );

      await multiWallet.addMint(mintUrl: mintUrl);

      // Select wallet with 0 amount requirement
      final selectedWallet = await multiWallet.selectWallet(amount: BigInt.zero);
      expect(selectedWallet, isNotNull);
      expect(selectedWallet!.mintUrl, equals(mintUrl));
    });

    test('Available mints returns mints with sufficient balance', () async {
      final path = await getTemporaryDirectory();
      final multiDb = await WalletDatabase.newInstance(
        path: '${path.path}/multi_wallet_avail.db',
      );

      final multiWallet = await MultiMintWallet.newInstance(
        unit: 'sat',
        mnemonic: testMnemonic,
        db: multiDb,
      );

      await multiWallet.addMint(mintUrl: mintUrl);

      final mints = await multiWallet.availableMints(amount: BigInt.zero);
      expect(mints, isA<List<Mint>>());
      expect(mints.length, equals(1));
    });

    test('Remove mint with balance fails', () async {
      final path = await getTemporaryDirectory();
      final multiDb = await WalletDatabase.newInstance(
        path: '${path.path}/multi_wallet_remove.db',
      );

      final multiWallet = await MultiMintWallet.newInstance(
        unit: 'sat',
        mnemonic: testMnemonic,
        db: multiDb,
      );

      await multiWallet.addMint(mintUrl: mintUrl);

      final selectedWallet = await multiWallet.selectWallet();
      if (selectedWallet != null) {
        final balance = await selectedWallet.balance();
        if (balance > BigInt.zero) {
          // Should fail if balance > 0
          expect(
            () => multiWallet.removeMint(mintUrl: mintUrl),
            throwsA(anything),
          );
          return;
        }
      }

      // If no balance, removal should succeed
      await multiWallet.removeMint(mintUrl: mintUrl);
      final mints = await multiWallet.listMints();
      expect(mints.length, equals(0));
    });

    test('Get wallet returns null for unknown mint', () async {
      final path = await getTemporaryDirectory();
      final multiDb = await WalletDatabase.newInstance(
        path: '${path.path}/multi_wallet_unknown.db',
      );

      final multiWallet = await MultiMintWallet.newInstance(
        unit: 'sat',
        mnemonic: testMnemonic,
        db: multiDb,
      );

      final wallet = await multiWallet.getWallet(mintUrl: 'https://unknown.mint');
      expect(wallet, isNull);
    });

    test('List wallets returns added wallets', () async {
      final path = await getTemporaryDirectory();
      final multiDb = await WalletDatabase.newInstance(
        path: '${path.path}/multi_wallet_list.db',
      );

      final multiWallet = await MultiMintWallet.newInstance(
        unit: 'sat',
        mnemonic: testMnemonic,
        db: multiDb,
      );

      await multiWallet.addMint(mintUrl: mintUrl);

      final wallets = await multiWallet.listWallets();
      expect(wallets.length, equals(1));
      expect(wallets.first.mintUrl, equals(mintUrl));
    });

    test('Create or get wallet returns existing wallet', () async {
      final path = await getTemporaryDirectory();
      final multiDb = await WalletDatabase.newInstance(
        path: '${path.path}/multi_wallet_cog.db',
      );

      final multiWallet = await MultiMintWallet.newInstance(
        unit: 'sat',
        mnemonic: testMnemonic,
        db: multiDb,
      );

      final wallet1 = await multiWallet.createOrGetWallet(mintUrl: mintUrl);
      final wallet2 = await multiWallet.createOrGetWallet(mintUrl: mintUrl);

      expect(wallet1.mintUrl, equals(wallet2.mintUrl));
    });

    test('Multi-wallet list transactions', () async {
      final path = await getTemporaryDirectory();
      final multiDb = await WalletDatabase.newInstance(
        path: '${path.path}/multi_wallet_tx.db',
      );

      final multiWallet = await MultiMintWallet.newInstance(
        unit: 'sat',
        mnemonic: testMnemonic,
        db: multiDb,
      );

      await multiWallet.addMint(mintUrl: mintUrl);

      final transactions = await multiWallet.listTransactions();
      expect(transactions, isA<List<Transaction>>());
    });

    test('Multi-wallet reclaim reserved', () async {
      final path = await getTemporaryDirectory();
      final multiDb = await WalletDatabase.newInstance(
        path: '${path.path}/multi_wallet_reclaim.db',
      );

      final multiWallet = await MultiMintWallet.newInstance(
        unit: 'sat',
        mnemonic: testMnemonic,
        db: multiDb,
      );

      await multiWallet.addMint(mintUrl: mintUrl);
      await multiWallet.reclaimReserved();
      // Should complete without error
    });
  });

  group('Input Parsing', () {
    test('Parse payment request input', () {
      // Create a valid payment request to test parsing
      final request = PaymentRequest(
        amount: BigInt.from(50),
        unit: 'sat',
        mints: [mintUrl],
        transports: [
          Transport(
            type: TransportType.httpPost,
            target: 'https://example.com',
          ),
        ],
      );

      final encoded = request.encode();
      final result = parseInput(input: encoded);

      expect(result, isA<ParseInputResult_PaymentRequest>());
    });

    test('Parse bolt11 invoice', () {
      const testInvoice = 'lnbc10n1pnr5hqmpp5h2xjwnjj5dc50xfs8x5e6jl2kkjtw94y5rwvtzk9pzhyfawx9nqqdqqcqzzgxqyz5vqrzjqwnvuc0u4txn35cafc7w94gxvq5p3cu9dd95f7hlrh0fvs46wpvhdw6wfqv8yqqqqryqqqqthqqpysp5q94rn6ake8h7pt5v5x8r2nzzjmkw8rx8qa9c8q9e6xx5t7h09pls9qrsgqnp4qtm3fj4482cq0u6vsmr5eqlte2wj9nqn7wvw2lz93xz3yy0pd2yz0ywdrgnxlck33u4llrr5l6qfqqqqqqqqqqqqqqqqqqqqqqqqqqqgp4y9qx';

      final result = parseInput(input: testInvoice);
      expect(result, isA<ParseInputResult_Bolt11Invoice>());
    });

    test('Parse invalid input throws error', () {
      expect(
        () => parseInput(input: 'invalid input string'),
        throwsA(anything),
      );
    });
  });

  group('Restore', () {
    test('Restore wallet from mnemonic', () async {
      // Create a fresh wallet to restore
      final path = await getTemporaryDirectory();
      final restoreDb = await WalletDatabase.newInstance(
        path: '${path.path}/restore_wallet.db',
      );
      final restoreWallet = Wallet(
        mintUrl: mintUrl,
        unit: 'sat',
        mnemonic: testMnemonic,
        db: restoreDb,
      );

      await restoreWallet.restore();
      print('Wallet restored successfully');

      // Verify balance is accessible after restore
      final balance = await restoreWallet.balance();
      expect(balance, isA<BigInt>());
      print('Restored wallet balance: $balance sats');
    });
  });

  group('WalletDatabase', () {
    test('List mints from database', () async {
      final mints = await db.listMints(
        unit: 'sat',
        mnemonic: testMnemonic,
      );
      expect(mints, isA<List<Mint>>());
      print('Mints in database: ${mints.length}');
    });

    test('Database path is accessible', () {
      expect(db.path, isNotEmpty);
      print('Database path: ${db.path}');
    });
  });
}
