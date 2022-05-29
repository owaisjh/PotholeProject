import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:government/pothole.dart';
import 'package:government/main.dart';
import 'package:government/signup.dart';
import 'package:shimmer/shimmer.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late WalletConnect connector;
  late SessionStatus session;
  var account;
  Future<String> establishConnection() async {
    connector = WalletConnect(
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

    connector.on('connect', (session) => print(session));
    connector.on('session_update', (payload) => print(payload));
    connector.on('disconnect', (session) => print(session));

    if (!connector.connected) {
      session = await connector.createSession(
        chainId: 80001,
        onDisplayUri: (uri) async {
          print(uri);
          globalUri = uri;
          await launch(uri);
        },
      );
      setState(() {
        account = session.accounts[0];
        globalAccount = session.accounts[0];
        globalConnector = connector;
      });
    }
    if (session.accounts.isEmpty) {
      Fluttertoast.showToast(msg: "Please Install Metamask");
      return "err";
    }
    return session.accounts[0];
  }

  login() async {
    Uri uri = Uri(scheme: 'https', host: url, path: "official/login");
    var res = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode(<String, String>{
        "account-address": globalAccount.toString(),
      }),
    );

    print(res.statusCode);
    if (res.statusCode == 401) {
      Fluttertoast.showToast(msg: "Wallet Address Not Found. Please Sign up!");
      Navigator.push(
          context, MaterialPageRoute(builder: ((context) => SignupPage())));
    } else {
      Fluttertoast.showToast(msg: "Logged In Successfully");

      profileSession = jsonDecode(res.body);
      Navigator.push(
          context, MaterialPageRoute(builder: ((context) => Pothole())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 11, 49, 80),
      body: SafeArea(
          child: Padding(
        padding:
            EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey,
              highlightColor: Colors.white,
              child: Text(
                'Connect \nYour Wallet',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 100,
            ),
            CupertinoButton(
              onPressed: () async {
                String accountAddress = await establishConnection();
                if (accountAddress != "err") {
                  await login();
                } else {
                  Fluttertoast.showToast(msg: "Metamask not found!");
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
            SizedBox(
              height: 15,
            ),
          ],
        ),
      )),
    );
  }
}
