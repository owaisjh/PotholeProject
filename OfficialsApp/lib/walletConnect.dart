import 'walletconnectethereumcreds.dart';
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
  late final connector;
  var account;
  Future<void> connectSomething() async {
    print('Start');
    connector = WalletConnect(
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

//
  }

  interact() async {
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
    // launch("https://metamask.app.link/");
    var hash = await ethClient.sendTransaction(
      credentials,
      Transaction(
        from: EthereumAddress.fromHex(account),
        to: EthereumAddress.fromHex(
            '0x727C5689FBB037221A236593d8b5Cee8C9B31B95'),
        value: EtherAmount.fromUnitAndValue(EtherUnit.ether, 1),
      ),
    );

    print(hash);
  }

  contractInteraction() async {
    final EthereumAddress contractAddr =
        EthereumAddress.fromHex('0x45Efc5F69C75aD9ea7594903eE704Ad69b55B7E8');
    var apiUrl = "https://rpc-mumbai.maticvigil.com/";
    // var httpClient = Client();
    var ethClient = Web3Client(apiUrl, Client());

    EthereumWalletConnectProvider provider =
        EthereumWalletConnectProvider(connector);
    print("hi");
    var credentials = WalletConnectEthereumCredentials(provider: provider);
    print("hi");

    // final token = Token(address: contractAddr, client: ethClient);
    // final value = await token.getValue(credentials: credentials);
    // print(value);
    final _contractAbi = ContractAbi.fromJson(
        '[ { "inputs": [], "name": "getValue", "outputs": [ { "internalType": "uint256", "name": "", "type": "uint256" } ], "stateMutability": "view", "type": "function" }, { "inputs": [ { "internalType": "uint256", "name": "b", "type": "uint256" } ], "name": "setvalue", "outputs": [], "stateMutability": "nonpayable", "type": "function" } ]',
        'test');
    DeployedContract deployedContract =
        DeployedContract(_contractAbi, contractAddr);
    ContractFunction contractFunction = deployedContract.function("getValue");
    print("here");
    final result = await ethClient.call(
        contract: deployedContract, function: contractFunction, params: []);
    print(result);
    // Transaction val = Transaction.callContract(
    //     contract: deployedContract,
    //     function: contractFunction,
    //     parameters: [BigInt.from(5)],
    //     from: EthereumAddress.fromHex(account));
    // var c = await ethClient.sendTransaction(credentials, val);

    // print(c);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: GestureDetector(
                    onTap: () async => connectSomething(),
                    child: Container(
                      color: Colors.blueAccent,
                      child: Text("Connect"),
                    )),
              ),
              Container(
                child: GestureDetector(
                    onTap: () async => contractInteraction(),
                    child: Container(
                      color: Colors.blueAccent,
                      child: Text("Interact"),
                    )),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
