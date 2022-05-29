import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:government/main.dart';
import 'package:government/pothole.dart';
import 'package:government/walletconnectethereumcreds.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

import 'style.dart';
import 'package:http/http.dart' as http;
import 'colors.dart';
import 'package:web3dart/web3dart.dart';

// ignore: must_be_immutable
class PotholeDetail extends StatefulWidget {
  final String id;
  final String imagePath;
  final double lat;
  final double long;
  final int index;
  var location;
  PotholeDetail(
      this.id, this.imagePath, this.lat, this.long, this.index, this.location);

  @override
  State<PotholeDetail> createState() => _PotholeDetailState();
}

class _PotholeDetailState extends State<PotholeDetail> {
  late GoogleMapController mapController;
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  bool isLoading = false;
  retreiveProof(String id) async {
    final EthereumAddress contractAddr =
        EthereumAddress.fromHex('0x4a4F07c2Dc4E870AbF39f081758DCE4d110add63');
    var apiUrl = "https://rinkeby.infura.io/v3/";
    var ethClient = Web3Client(apiUrl, Client());
    final _contractAbi = ContractAbi.fromJson(
        '[ { "anonymous": false, "inputs": [ { "indexed": false, "internalType": "uint256", "name": "id", "type": "uint256" }, { "indexed": false, "internalType": "address", "name": "reporter", "type": "address" }, { "indexed": false, "internalType": "string", "name": "image", "type": "string" } ], "name": "IpfsImagehashAdded", "type": "event" }, { "anonymous": false, "inputs": [ { "indexed": false, "internalType": "string", "name": "id", "type": "string" }, { "indexed": false, "internalType": "address", "name": "reporter", "type": "address" } ], "name": "PotholeAdded", "type": "event" }, { "anonymous": false, "inputs": [ { "indexed": false, "internalType": "string", "name": "id", "type": "string" }, { "indexed": false, "internalType": "address", "name": "fixer", "type": "address" } ], "name": "PotholeFixed", "type": "event" }, { "inputs": [ { "internalType": "string", "name": "id", "type": "string" }, { "internalType": "uint256", "name": "prelatitude", "type": "uint256" }, { "internalType": "uint256", "name": "postLatitude", "type": "uint256" }, { "internalType": "uint256", "name": "preLongitude", "type": "uint256" }, { "internalType": "uint256", "name": "postLongitude", "type": "uint256" }, { "internalType": "string", "name": "time", "type": "string" }, { "internalType": "string", "name": "city", "type": "string" }, { "internalType": "string", "name": "area", "type": "string" }, { "internalType": "string", "name": "road", "type": "string" }, { "internalType": "string", "name": "hash", "type": "string" } ], "name": "addPotholeUser", "outputs": [], "stateMutability": "nonpayable", "type": "function" }, { "inputs": [ { "internalType": "string", "name": "id", "type": "string" }, { "internalType": "string", "name": "hash", "type": "string" } ], "name": "fixPotholeOfficial", "outputs": [], "stateMutability": "nonpayable", "type": "function" }, { "inputs": [ { "internalType": "string", "name": "id", "type": "string" } ], "name": "getPothole", "outputs": [ { "components": [ { "internalType": "address", "name": "reportedBy", "type": "address" }, { "internalType": "string", "name": "reportedTime", "type": "string" } ], "internalType": "struct Storage.Pothole", "name": "", "type": "tuple" }, { "components": [ { "internalType": "uint256", "name": "preLat", "type": "uint256" }, { "internalType": "uint256", "name": "postLat", "type": "uint256" }, { "internalType": "uint256", "name": "preLong", "type": "uint256" }, { "internalType": "uint256", "name": "postLong", "type": "uint256" }, { "internalType": "string", "name": "city", "type": "string" }, { "internalType": "string", "name": "reprotedArea", "type": "string" }, { "internalType": "string", "name": "reportedRoad", "type": "string" } ], "internalType": "struct Storage.Position", "name": "", "type": "tuple" }, { "components": [ { "internalType": "address", "name": "user", "type": "address" }, { "internalType": "address", "name": "official", "type": "address" }, { "internalType": "string", "name": "_userImage", "type": "string" }, { "internalType": "string", "name": "_officialsImage", "type": "string" }, { "internalType": "bool", "name": "_isFixed", "type": "bool" } ], "internalType": "struct Storage.Proof", "name": "", "type": "tuple" } ], "stateMutability": "view", "type": "function" } ]',
        'Storage');
    DeployedContract deployedContract =
        DeployedContract(_contractAbi, contractAddr);
    ContractFunction contractFunction = deployedContract.function("getPothole");
    print("here" + id);
    final result = await ethClient.call(
        sender: EthereumAddress.fromHex(globalAccount),
        contract: deployedContract,
        function: contractFunction,
        params: [id]);
    print(result);
  }

  Future<String> addProof(String url, String id) async {
    final EthereumAddress contractAddr =
        EthereumAddress.fromHex('0x4a4F07c2Dc4E870AbF39f081758DCE4d110add63');
    var apiUrl = "https://rinkeby.infura.io/v3/";
    var ethClient = Web3Client(apiUrl, Client());
    EthereumWalletConnectProvider provider =
        EthereumWalletConnectProvider(globalConnector);
    var credentials = WalletConnectEthereumCredentials(provider: provider);
    final _contractAbi = ContractAbi.fromJson(
        '[ { "anonymous": false, "inputs": [ { "indexed": false, "internalType": "uint256", "name": "id", "type": "uint256" }, { "indexed": false, "internalType": "address", "name": "reporter", "type": "address" }, { "indexed": false, "internalType": "string", "name": "image", "type": "string" } ], "name": "IpfsImagehashAdded", "type": "event" }, { "anonymous": false, "inputs": [ { "indexed": false, "internalType": "string", "name": "id", "type": "string" }, { "indexed": false, "internalType": "address", "name": "reporter", "type": "address" } ], "name": "PotholeAdded", "type": "event" }, { "anonymous": false, "inputs": [ { "indexed": false, "internalType": "string", "name": "id", "type": "string" }, { "indexed": false, "internalType": "address", "name": "fixer", "type": "address" } ], "name": "PotholeFixed", "type": "event" }, { "inputs": [ { "internalType": "string", "name": "id", "type": "string" }, { "internalType": "uint256", "name": "prelatitude", "type": "uint256" }, { "internalType": "uint256", "name": "postLatitude", "type": "uint256" }, { "internalType": "uint256", "name": "preLongitude", "type": "uint256" }, { "internalType": "uint256", "name": "postLongitude", "type": "uint256" }, { "internalType": "string", "name": "time", "type": "string" }, { "internalType": "string", "name": "city", "type": "string" }, { "internalType": "string", "name": "area", "type": "string" }, { "internalType": "string", "name": "road", "type": "string" }, { "internalType": "string", "name": "hash", "type": "string" } ], "name": "addPotholeUser", "outputs": [], "stateMutability": "nonpayable", "type": "function" }, { "inputs": [ { "internalType": "string", "name": "id", "type": "string" }, { "internalType": "string", "name": "hash", "type": "string" } ], "name": "fixPotholeOfficial", "outputs": [], "stateMutability": "nonpayable", "type": "function" }, { "inputs": [ { "internalType": "string", "name": "id", "type": "string" } ], "name": "getPothole", "outputs": [ { "components": [ { "internalType": "address", "name": "reportedBy", "type": "address" }, { "internalType": "string", "name": "reportedTime", "type": "string" } ], "internalType": "struct Storage.Pothole", "name": "", "type": "tuple" }, { "components": [ { "internalType": "uint256", "name": "preLat", "type": "uint256" }, { "internalType": "uint256", "name": "postLat", "type": "uint256" }, { "internalType": "uint256", "name": "preLong", "type": "uint256" }, { "internalType": "uint256", "name": "postLong", "type": "uint256" }, { "internalType": "string", "name": "city", "type": "string" }, { "internalType": "string", "name": "reprotedArea", "type": "string" }, { "internalType": "string", "name": "reportedRoad", "type": "string" } ], "internalType": "struct Storage.Position", "name": "", "type": "tuple" }, { "components": [ { "internalType": "address", "name": "user", "type": "address" }, { "internalType": "address", "name": "official", "type": "address" }, { "internalType": "string", "name": "_userImage", "type": "string" }, { "internalType": "string", "name": "_officialsImage", "type": "string" }, { "internalType": "bool", "name": "_isFixed", "type": "bool" } ], "internalType": "struct Storage.Proof", "name": "", "type": "tuple" } ], "stateMutability": "view", "type": "function" } ]',
        'Storage');
    DeployedContract deployedContract =
        DeployedContract(_contractAbi, contractAddr);
    ContractFunction contractFunction =
        deployedContract.function("fixPotholeOfficial");
    Transaction val = Transaction.callContract(
        contract: deployedContract,
        function: contractFunction,
        parameters: [
          id,
          url,
        ],
        from: EthereumAddress.fromHex(globalAccount));
    setState(() {
      isLoading = true;
    });
    await launch(globalUri);
    var c = await ethClient.sendTransaction(credentials, val);
    sleep(Duration(milliseconds: 500));
    Fluttertoast.showToast(msg: "Transaction Successful " + c.toString());
    setState(() {
      isLoading = false;
    });
    return c.toString();
  }

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  @override
  void initState() {
    final marker = Marker(
      markerId: MarkerId(widget.index.toString()),
      position: LatLng(widget.lat, widget.long),
      // icon: BitmapDescriptor.,
      infoWindow: InfoWindow(
        title: 'Pothole ${widget.index}',
        snippet: 'Reported today',
      ),
    );
    markers[MarkerId(widget.index.toString())] = marker;
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          customAppBar(context),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
            child: Stack(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PrimaryText(
                    text: 'Pothole #${widget.index.toString()}',
                    size: 38,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PrimaryText(
                                text: 'City',
                                color: AppColors.lightGray,
                                size: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              PrimaryText(
                                  text: widget.location["city"],
                                  size: 14,
                                  fontWeight: FontWeight.w600),
                              SizedBox(
                                height: 20,
                              ),
                              PrimaryText(
                                text: 'Locality',
                                color: AppColors.lightGray,
                                size: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              PrimaryText(
                                  text: widget.location["locality"],
                                  size: 14,
                                  fontWeight: FontWeight.w600),
                              SizedBox(
                                height: 20,
                              ),
                              PrimaryText(
                                text: 'Postal Code',
                                color: AppColors.lightGray,
                                size: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              PrimaryText(
                                  text:
                                      widget.location["postal_code"].toString(),
                                  size: 14,
                                  fontWeight: FontWeight.w600),
                              SizedBox(
                                height: 20,
                              ),
                              PrimaryText(
                                text: 'Road',
                                color: AppColors.lightGray,
                                size: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              PrimaryText(
                                  text: widget.location["road"].toString(),
                                  size: 14,
                                  fontWeight: FontWeight.w600),
                            ]),
                      ),
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromARGB(255, 216, 216, 216),
                                      blurRadius: 20)
                                ]),
                            height: 200,
                            child: Image.network(
                              widget.imagePath,
                              fit: BoxFit.contain,
                              width: 150,
                              height: 150,
                            ),
                          ),
                          Row(
                            children: [
                              MaterialButton(
                                onPressed: () async {
                                  print(widget.id);
                                  // await retreiveProof(widget.id);
                                  final photo = await ImagePicker.pickImage(
                                      source: ImageSource.camera);
                                  final bytes =
                                      File(photo.path).readAsBytesSync();
                                  String base64Image = base64Encode(bytes);
                                  setState(() {
                                    isLoading = true;
                                  });
                                  Uri uri = Uri(
                                      scheme: 'https',
                                      host: url,
                                      path: "official/test");
                                  // print("img_pan : $base64Image");
                                  var res = await http.post(
                                    uri,
                                    headers: <String, String>{
                                      'Content-Type': 'application/json',
                                      'Accept': 'application/json'
                                    },
                                    body: jsonEncode(<String, String>{
                                      'photo': base64Image,
                                    }),
                                  );

                                  var _result = jsonDecode(res.body);
                                  print(_result.toString());
                                  setState(() {
                                    isLoading = true;
                                  });
                                  String txHash =
                                      await addProof(_result, widget.id);
                                  print("gere" + txHash);
                                  Uri uri1 = Uri(
                                      scheme: 'https',
                                      host: url,
                                      path: "update/pothole_status");
                                  var res1 = await http.post(
                                    uri1,
                                    headers: <String, String>{
                                      'Content-Type': 'application/json',
                                      'Accept': 'application/json'
                                    },
                                    body: jsonEncode(<String, String>{
                                      'id': widget.id,
                                      'transaction_hash': txHash,
                                      'fixed_path': _result.toString()
                                    }),
                                  );
                                  var _result1 = res1.body;
                                  // print(_result1);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) => Pothole())));
                                },
                                color: Colors.white,
                                child: Icon(
                                  Icons.check,
                                  size: 18,
                                  color: Colors.green,
                                ),
                                padding: EdgeInsets.all(16),
                                shape: CircleBorder(),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  PrimaryText(
                      text: 'Location', fontWeight: FontWeight.w700, size: 22),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                          target: LatLng(widget.lat, widget.long), zoom: 14),
                      markers: markers.values.toSet(),
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      scrollGesturesEnabled: false,
                      rotateGesturesEnabled: false,
                      myLocationEnabled: false,
                    ),
                  ),
                ],
              ),
              isLoading
                  ? Positioned(
                      top: MediaQuery.of(context).size.height * 0.3,
                      left: MediaQuery.of(context).size.width * 0.22,
                      child: Center(
                        child: new BackdropFilter(
                          filter:
                              new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: new Container(
                            width: 150.0,
                            height: 150.0,
                            decoration: new BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.grey.shade200.withOpacity(0.5)),
                            child: new Center(
                                child:
                                    new Image.asset("assets/metamask-1.gif")),
                          ),
                        ),
                      ))
                  : Text("")
            ]),
          ),
        ],
      ),
    );
  }

  Padding customAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                      width: 1, color: Color.fromARGB(255, 189, 189, 189))),
              child: Icon(Icons.chevron_left),
            ),
          ),
        ],
      ),
    );
  }
}
