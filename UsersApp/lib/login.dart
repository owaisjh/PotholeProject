// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:final_year/register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'homepage.dart';
import 'package:final_year/walletconnectethereumcreds.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'account.dart';
import 'function.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String email;
  late String password;
  //late String account;

  @override
  Widget build(BuildContext context) {
    var balance;
    return Scaffold(
        backgroundColor: Color(0xFFC1F8CF),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // ignore: prefer_const_constructors
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: const Text(
                      'Log into          your account',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 60.0,
                        color: Color(0xFF488FB1),
                      ),
                    ),
                  ),
                  CupertinoButton(
                    onPressed: () async {
                      var response = await loginMetamask();
                      print(response.body);

                      print(response.statusCode);
                      var x = 1;

                      var jsonData = json.decode(response.body);
                      print(jsonData);
                      var name = jsonData['name'];
                      var balance = jsonData['tokens'].toString();
                      if (response.statusCode == 200) {
                        //balance = await getBalance();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage(
                                      name: name,
                                      balance: balance,
                                    )));
                      } else if (response.statusCode == 401) {
                        //var response = signUpWithAddress();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterPage()));
                      }
                    },
                    color: Colors.white,
                    padding: const EdgeInsets.all(0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.network(
                          'https://i0.wp.com/kindalame.com/wp-content/uploads/2021/05/metamask-fox-wordmark-horizontal.png?fit=1549%2C480&ssl=1',
                          width: 200,
                        ),
                      ],
                    ),
                  ),
                ]),
          ),
        ));
  }
}

Future<dynamic> loginMetamask() async {
  print('Start');
  final connector = WalletConnect(
    bridge: 'https://bridge.walletconnect.org',
    clientMeta: PeerMeta(
      name: 'WalletConnect',
      description: 'WalletConnect Developer App',
      url: 'https://rinkeby.infura.io/v3/',
      icons: [
        'https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
      ],
    ),
  );
  Account.connector = connector;
  // Subscribe to events
  connector.on('connect', (session) => print(session));
  connector.on('session_update', (payload) => print(payload));
  connector.on('disconnect', (session) => print(session));

  //var account;
  // Create a new session
  if (!connector.connected) {
    final session = await connector.createSession(
      chainId: 4,
      onDisplayUri: (uri) async =>
          {print(uri), await launch(uri), Account.uri = uri},
    );

    //print(connector.session);
    //print(connector.sessionStorage);
    //print(session.networkId);
    Account.account = session.accounts[0];

    //Account.sessionId = session.networkId;
    print('hi');
    print(Account.account);
    var response = await loginWithAddress(Account.account);
    print('now');
    // var jsonData = json.decode(response.body);
    // Account.balance = jsonData['tokens'].toString();
    // //Account.balance = response.body['tokens'].toString();
    // print(Account.balance);
    //print(response.body);
    return response;
  }
}
