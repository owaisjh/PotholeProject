import 'package:final_year/function.dart';
import 'package:final_year/walletconnectethereumcreds.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

class WalletConnector extends StatefulWidget {
  const WalletConnector({Key? key}) : super(key: key);

  @override
  State<WalletConnector> createState() => _WalletConnectorState();
}

class _WalletConnectorState extends State<WalletConnector> {
  Future<void> connectSomething() async {
    print('Start');
    final connector = WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      clientMeta: PeerMeta(
        name: 'WalletConnect',
        description: 'WalletConnect Developer App',
        url: 'https://rpc-mumbai.maticvigil.com/',
        icons: [
          'https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
        ],
      ),
    );

    // Subscribe to events
    connector.on('connect', (session) => print(session));
    connector.on('session_update', (payload) => print(payload));
    connector.on('disconnect', (session) => print(session));

    var account;
    // Create a new session
    if (!connector.connected) {
      final session = await connector.createSession(
        chainId: 80001,
        onDisplayUri: (uri) async => {print(uri), await launch(uri)},
      );
      setState(() {
        account = session.accounts[0];
      });
    }

    var apiUrl = "https://rpc-mumbai.maticvigil.com/";
    //var httpClient = Client();
    var ethClient = Web3Client(apiUrl, Client());
    print(connector.session);
    EthereumWalletConnectProvider provider =
        EthereumWalletConnectProvider(connector);

    var credentials = WalletConnectEthereumCredentials(provider: provider);

    //var credentials = ethClient.
    print(credentials);
    print('creds');
    //print(ethClient.getBalance(account));

    var hash = await ethClient.sendTransaction(
      credentials,
      Transaction(
        from: EthereumAddress.fromHex(account),
        to: EthereumAddress.fromHex(
            '0x727C5689FBB037221A236593d8b5Cee8C9B31B95'),
        value: EtherAmount.fromUnitAndValue(EtherUnit.ether, 1),
      ),
    );
    launch("https://metamask.app.link/");
    print(hash);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
            child: Container(
          child: GestureDetector(
              onTap: () async => connectSomething(),
              child: Container(
                color: Colors.blueAccent,
                child: Text("press me"),
              )),
        )),
      ),
    );
  }
}
