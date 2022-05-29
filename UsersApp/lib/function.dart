import 'package:final_year/walletconnectethereumcreds.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:web3dart/web3dart.dart';
import 'dart:convert';
import 'account.dart';
import 'dart:core';

String privateKey =
    'ac03cb4fb8c335850d2b2d5401ba4e585bff2af05e39aa65293dbbbc68148caf';
//String rpcUrl = 'https://rpc-mumbai.maticvigil.com/';
String rpcUrl = 'https://rinkeby.infura.io/v3/';

String localhost = 'http://10.0.2.2:5000/';

// Future<void> printBalance() async {
//   // start a client we can use to send transactions
//   final client = Web3Client(rpcUrl, http.Client());

//   final credentials = EthPrivateKey.fromHex(privateKey);
//   final address = credentials.address;

//   print(address.hexEip55);
//   print(await client.getBalance(address));

//   await client.dispose();
// }

String url = 'https://eb57-2405-201-1f-f946-dcb8-6bd9-4729-abce.ngrok.io';

Future<dynamic> predictPothole(String image) async {
  print('pothole function');
  var response = await http.post(
    Uri.parse('$url/user/test'),
    headers: {"Accept": "application/json", "Content-type": "application/json"},
    body: jsonEncode({
      "photo": "$image",
    }),
  );
  print(response.body);

  return response;
}

Future<dynamic> reportPothole(
  String lat,
  String long,
  String road,
  String city,
  String locality,
  String postcode,
  String hash,
) async {
  if (road == '') {
    road = 'No road';
  }
  if (locality == "") {
    locality = 'No locality';
  }
  //String state = 'Maharashtra';
  //mongodb
  print('report pothole function');
  var response = await http.post(
    Uri.parse('$url/pothole'),
    headers: {"Accept": "application/json", "Content-type": "application/json"},
    body: jsonEncode({
      "account-address": "${Account.account}",
      "lat": "$lat",
      "long": "$long",
      "road": "$road",
      "city": "$city",
      "locality": "$locality",
      "postcode": "$postcode",
      "hash": "$hash"
    }),
  );
  print('x');
  print(response.body);
  print('y');
  if (response.statusCode == 201) {
    int preLat = int.parse(lat.toString().split(".")[0]);
    int postLat = int.parse(lat.toString().split(".")[1]);

    int preLong = int.parse(long.toString().split(".")[0]);
    int postLong = int.parse(long.toString().split(".")[1]);

    var id = response.body.toString();
    //blockchain'
    print("blockchain started");
    // print(Account.connector);
    // print(Account.uri);
    final EthereumAddress contractAddr =
        EthereumAddress.fromHex('0x4a4F07c2Dc4E870AbF39f081758DCE4d110add63');
    var apiUrl = "https://rinkeby.infura.io/v3/";
    var ethClient = Web3Client(apiUrl, http.Client());

    final _contractAbi = ContractAbi.fromJson('''[
			{
				"anonymous": false,
				"inputs": [
					{
						"indexed": false,
						"internalType": "uint256",
						"name": "id",
						"type": "uint256"
					},
					{
						"indexed": false,
						"internalType": "address",
						"name": "reporter",
						"type": "address"
					},
					{
						"indexed": false,
						"internalType": "string",
						"name": "image",
						"type": "string"
					}
				],
				"name": "IpfsImagehashAdded",
				"type": "event"
			},
			{
				"anonymous": false,
				"inputs": [
					{
						"indexed": false,
						"internalType": "string",
						"name": "id",
						"type": "string"
					},
					{
						"indexed": false,
						"internalType": "address",
						"name": "reporter",
						"type": "address"
					}
				],
				"name": "PotholeAdded",
				"type": "event"
			},
			{
				"anonymous": false,
				"inputs": [
					{
						"indexed": false,
						"internalType": "string",
						"name": "id",
						"type": "string"
					},
					{
						"indexed": false,
						"internalType": "address",
						"name": "fixer",
						"type": "address"
					}
				],
				"name": "PotholeFixed",
				"type": "event"
			},
			{
				"inputs": [
					{
						"internalType": "string",
						"name": "id",
						"type": "string"
					},
					{
						"internalType": "uint256",
						"name": "prelatitude",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "postLatitude",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "preLongitude",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "postLongitude",
						"type": "uint256"
					},
					{
						"internalType": "string",
						"name": "time",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "city",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "area",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "road",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "hash",
						"type": "string"
					}
				],
				"name": "addPotholeUser",
				"outputs": [],
				"stateMutability": "nonpayable",
				"type": "function"
			},
			{
				"inputs": [
					{
						"internalType": "string",
						"name": "id",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "hash",
						"type": "string"
					}
				],
				"name": "fixPotholeOfficial",
				"outputs": [],
				"stateMutability": "nonpayable",
				"type": "function"
			},
			{
				"inputs": [
					{
						"internalType": "string",
						"name": "id",
						"type": "string"
					}
				],
				"name": "getPothole",
				"outputs": [
					{
						"components": [
							{
								"internalType": "address",
								"name": "reportedBy",
								"type": "address"
							},
							{
								"internalType": "string",
								"name": "reportedTime",
								"type": "string"
							}
						],
						"internalType": "struct Storage.Pothole",
						"name": "",
						"type": "tuple"
					},
					{
						"components": [
							{
								"internalType": "uint256",
								"name": "preLat",
								"type": "uint256"
							},
							{
								"internalType": "uint256",
								"name": "postLat",
								"type": "uint256"
							},
							{
								"internalType": "uint256",
								"name": "preLong",
								"type": "uint256"
							},
							{
								"internalType": "uint256",
								"name": "postLong",
								"type": "uint256"
							},
							{
								"internalType": "string",
								"name": "city",
								"type": "string"
							},
							{
								"internalType": "string",
								"name": "reprotedArea",
								"type": "string"
							},
							{
								"internalType": "string",
								"name": "reportedRoad",
								"type": "string"
							}
						],
						"internalType": "struct Storage.Position",
						"name": "",
						"type": "tuple"
					},
					{
						"components": [
							{
								"internalType": "address",
								"name": "user",
								"type": "address"
							},
							{
								"internalType": "address",
								"name": "official",
								"type": "address"
							},
							{
								"internalType": "string",
								"name": "_userImage",
								"type": "string"
							},
							{
								"internalType": "string",
								"name": "_officialsImage",
								"type": "string"
							},
							{
								"internalType": "bool",
								"name": "_isFixed",
								"type": "bool"
							}
						],
						"internalType": "struct Storage.Proof",
						"name": "",
						"type": "tuple"
					}
				],
				"stateMutability": "view",
				"type": "function"
			}
		]''', 'Storage');
    DeployedContract deployedContract =
        DeployedContract(_contractAbi, contractAddr);
    // print('hehe');
    ContractFunction contractFunction =
        deployedContract.function("addPotholeUser");
    // print("here");
    // final result = await ethClient.call(
    //     contract: deployedContract,
    //     function: contractFunction,
    //     params: []);
    EthereumWalletConnectProvider provider =
        EthereumWalletConnectProvider(Account.connector);
    //print(provider);
    var credentials = WalletConnectEthereumCredentials(provider: provider);

    launch(Account.uri);

    final result = await ethClient.sendTransaction(
        credentials,
        Transaction.callContract(
            from: EthereumAddress.fromHex(Account.account),
            contract: deployedContract,
            function: contractFunction,
            parameters: [
              id,
              BigInt.from(preLat),
              BigInt.from(postLat),
              BigInt.from(preLong),
              BigInt.from(postLong),
              DateTime.now().toString(),
              city,
              locality,
              road,
              hash
            ]));
    print('block result');
    print(result);
    print('block over');
  }
  return response;
}

Future<dynamic> loginWithAddress(String account) async {
  print('login function');
  var response = await http.post(
    Uri.parse('$url/user/login'),
    headers: {"Accept": "application/json", "Content-type": "application/json"},
    body: jsonEncode({
      "account-address": "$account",
    }),
  );
  //print(response.body);
  return response;
}

Future<dynamic> signUpWithAddress(
    String name, String email, String contactNo) async {
  print('signup function');
  var response = await http.post(
    Uri.parse('$url/user/signup'),
    headers: {"Accept": "application/json", "Content-type": "application/json"},
    body: jsonEncode({
      "name": "$name",
      "email": "$email",
      "phone-number": "$contactNo",
      "account-address": "${Account.account}",
    }),
  );
  print(response.body);
  return response;
}

Future<dynamic> getBalance() async {
  final client = Web3Client(rpcUrl, http.Client());
  var balance =
      await client.getBalance(EthereumAddress.fromHex(Account.account));
  print("bal");
  print(balance.getInEther);
  return balance.getInEther.toString();
}

Future<List> getUserPotholes() async {
  print('Get user potholes');
  late List potholes;
  var response = await http.post(
    Uri.parse('$url/user_potholes_coordinates'),
    headers: {"Accept": "application/json", "Content-type": "application/json"},
    body: jsonEncode({
      "account-address": "${Account.account}",
    }),
  );
  print(response.body);
  potholes = jsonDecode(response.body);
  return potholes;
}

Future<dynamic> sendAccData(List<Map> accData) async {
  print('accel function');
  print(accData);
  print(Account.account);
  var response = await http.post(
    Uri.parse('$url/accelerometer'),
    headers: {"Accept": "application/json", "Content-type": "application/json"},
    body: jsonEncode({"account": Account.account, "data": accData}),
  );
  print(response.statusCode);
  print(response.body);
  List potholes = jsonDecode(response.body);

  //list of ids, location details
  print("accel blockchain started");
  // print(Account.connector);
  // print(Account.uri);
  final EthereumAddress contractAddr =
      EthereumAddress.fromHex('0x4a4F07c2Dc4E870AbF39f081758DCE4d110add63');
  var apiUrl = "https://rinkeby.infura.io/v3/";
  var ethClient = Web3Client(apiUrl, http.Client());

  final _contractAbi = ContractAbi.fromJson('''[
  		{
  			"anonymous": false,
  			"inputs": [
  				{
  					"indexed": false,
  					"internalType": "uint256",
  					"name": "id",
  					"type": "uint256"
  				},
  				{
  					"indexed": false,
  					"internalType": "address",
  					"name": "reporter",
  					"type": "address"
  				},
  				{
  					"indexed": false,
  					"internalType": "string",
  					"name": "image",
  					"type": "string"
  				}
  			],
  			"name": "IpfsImagehashAdded",
  			"type": "event"
  		},
  		{
  			"anonymous": false,
  			"inputs": [
  				{
  					"indexed": false,
  					"internalType": "string",
  					"name": "id",
  					"type": "string"
  				},
  				{
  					"indexed": false,
  					"internalType": "address",
  					"name": "reporter",
  					"type": "address"
  				}
  			],
  			"name": "PotholeAdded",
  			"type": "event"
  		},
  		{
  			"anonymous": false,
  			"inputs": [
  				{
  					"indexed": false,
  					"internalType": "string",
  					"name": "id",
  					"type": "string"
  				},
  				{
  					"indexed": false,
  					"internalType": "address",
  					"name": "fixer",
  					"type": "address"
  				}
  			],
  			"name": "PotholeFixed",
  			"type": "event"
  		},
  		{
  			"inputs": [
  				{
  					"internalType": "string",
  					"name": "id",
  					"type": "string"
  				},
  				{
  					"internalType": "uint256",
  					"name": "prelatitude",
  					"type": "uint256"
  				},
  				{
  					"internalType": "uint256",
  					"name": "postLatitude",
  					"type": "uint256"
  				},
  				{
  					"internalType": "uint256",
  					"name": "preLongitude",
  					"type": "uint256"
  				},
  				{
  					"internalType": "uint256",
  					"name": "postLongitude",
  					"type": "uint256"
  				},
  				{
  					"internalType": "string",
  					"name": "time",
  					"type": "string"
  				},
  				{
  					"internalType": "string",
  					"name": "city",
  					"type": "string"
  				},
  				{
  					"internalType": "string",
  					"name": "area",
  					"type": "string"
  				},
  				{
  					"internalType": "string",
  					"name": "road",
  					"type": "string"
  				},
  				{
  					"internalType": "string",
  					"name": "hash",
  					"type": "string"
  				}
  			],
  			"name": "addPotholeUser",
  			"outputs": [],
  			"stateMutability": "nonpayable",
  			"type": "function"
  		},
  		{
  			"inputs": [
  				{
  					"internalType": "string",
  					"name": "id",
  					"type": "string"
  				},
  				{
  					"internalType": "string",
  					"name": "hash",
  					"type": "string"
  				}
  			],
  			"name": "fixPotholeOfficial",
  			"outputs": [],
  			"stateMutability": "nonpayable",
  			"type": "function"
  		},
  		{
  			"inputs": [
  				{
  					"internalType": "string",
  					"name": "id",
  					"type": "string"
  				}
  			],
  			"name": "getPothole",
  			"outputs": [
  				{
  					"components": [
  						{
  							"internalType": "address",
  							"name": "reportedBy",
  							"type": "address"
  						},
  						{
  							"internalType": "string",
  							"name": "reportedTime",
  							"type": "string"
  						}
  					],
  					"internalType": "struct Storage.Pothole",
  					"name": "",
  					"type": "tuple"
  				},
  				{
  					"components": [
  						{
  							"internalType": "uint256",
  							"name": "preLat",
  							"type": "uint256"
  						},
  						{
  							"internalType": "uint256",
  							"name": "postLat",
  							"type": "uint256"
  						},
  						{
  							"internalType": "uint256",
  							"name": "preLong",
  							"type": "uint256"
  						},
  						{
  							"internalType": "uint256",
  							"name": "postLong",
  							"type": "uint256"
  						},
  						{
  							"internalType": "string",
  							"name": "city",
  							"type": "string"
  						},
  						{
  							"internalType": "string",
  							"name": "reprotedArea",
  							"type": "string"
  						},
  						{
  							"internalType": "string",
  							"name": "reportedRoad",
  							"type": "string"
  						}
  					],
  					"internalType": "struct Storage.Position",
  					"name": "",
  					"type": "tuple"
  				},
  				{
  					"components": [
  						{
  							"internalType": "address",
  							"name": "user",
  							"type": "address"
  						},
  						{
  							"internalType": "address",
  							"name": "official",
  							"type": "address"
  						},
  						{
  							"internalType": "string",
  							"name": "_userImage",
  							"type": "string"
  						},
  						{
  							"internalType": "string",
  							"name": "_officialsImage",
  							"type": "string"
  						},
  						{
  							"internalType": "bool",
  							"name": "_isFixed",
  							"type": "bool"
  						}
  					],
  					"internalType": "struct Storage.Proof",
  					"name": "",
  					"type": "tuple"
  				}
  			],
  			"stateMutability": "view",
  			"type": "function"
  		}
  	]''', 'Storage');

  DeployedContract deployedContract =
      DeployedContract(_contractAbi, contractAddr);
  // print('hehe');
  ContractFunction contractFunction =
      deployedContract.function("addPotholeUser");
  // print("here");
  // final result = await ethClient.call(
  //     contract: deployedContract,
  //     function: contractFunction,
  //     params: []);
  EthereumWalletConnectProvider provider =
      EthereumWalletConnectProvider(Account.connector);
  //print(provider);
  var credentials = WalletConnectEthereumCredentials(provider: provider);
  for (var pothole in potholes) {
    int preLat = int.parse(pothole['latitude'].toString().split(".")[0]);
    int postLat = int.parse(pothole['latitude'].toString().split(".")[1]);

    int preLong = int.parse(pothole['longitude'].toString().split(".")[0]);
    int postLong = int.parse(pothole['longitude'].toString().split(".")[1]);
    launch(Account.uri);

    final result = await ethClient.sendTransaction(
        credentials,
        Transaction.callContract(
            from: EthereumAddress.fromHex(Account.account),
            contract: deployedContract,
            function: contractFunction,
            parameters: [
              pothole['id'],
              BigInt.from(preLat),
              BigInt.from(postLat),
              BigInt.from(preLong),
              BigInt.from(postLong),
              DateTime.now().toString(),
              pothole['city'],
              pothole['locality'],
              pothole['road'],
              pothole['path']
            ]));
    print('block result');
    print(result);
    print('block over');
  }

  return response;
}

Future<dynamic> getCertificateUrl() async {
  print('certificate function');

  var response = await http.post(
    Uri.parse('$url/fetchCert'),
    headers: {"Accept": "application/json", "Content-type": "application/json"},
    body: jsonEncode({
      "account-address": {Account.account},
    }),
  );

  //var jsonData = json.decode(response.body);

  return response.body;
}

Future<dynamic> addCertificateUrl() async {
  print('add certificate function');

  var response = await http.post(
    Uri.parse('$url/user/addCert'),
    headers: {"Accept": "application/json", "Content-type": "application/json"},
    body: jsonEncode({
      "account-address": Account.account,
    }),
  );

  var certUrl = await http.post(
    Uri.parse('$url/user/fetchCert'),
    headers: {"Accept": "application/json", "Content-type": "application/json"},
    body: jsonEncode({
      "account-address": Account.account,
    }),
  );
  var abc = json.decode(certUrl.body);
  print(abc);
  print("blockchain started");
  // print(Account.connector);
  // print(Account.uri);
  final EthereumAddress contractAddr =
      EthereumAddress.fromHex('0xA819c3CcF0e7e94Ea730C42Ff79b45d7a60F4CB0');
  var apiUrl = "https://rinkeby.infura.io/v3/";
  var ethClient = Web3Client(apiUrl, http.Client());

  final _contractAbi = ContractAbi.fromJson('''[
			{
				"inputs": [
					{
						"internalType": "string",
						"name": "_name",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "_symbol",
						"type": "string"
					}
				],
				"stateMutability": "nonpayable",
				"type": "constructor"
			},
			{
				"anonymous": false,
				"inputs": [
					{
						"indexed": true,
						"internalType": "address",
						"name": "owner",
						"type": "address"
					},
					{
						"indexed": true,
						"internalType": "address",
						"name": "approved",
						"type": "address"
					},
					{
						"indexed": true,
						"internalType": "uint256",
						"name": "tokenId",
						"type": "uint256"
					}
				],
				"name": "Approval",
				"type": "event"
			},
			{
				"anonymous": false,
				"inputs": [
					{
						"indexed": true,
						"internalType": "address",
						"name": "owner",
						"type": "address"
					},
					{
						"indexed": true,
						"internalType": "address",
						"name": "operator",
						"type": "address"
					},
					{
						"indexed": false,
						"internalType": "bool",
						"name": "approved",
						"type": "bool"
					}
				],
				"name": "ApprovalForAll",
				"type": "event"
			},
			{
				"anonymous": false,
				"inputs": [
					{
						"indexed": true,
						"internalType": "address",
						"name": "previousOwner",
						"type": "address"
					},
					{
						"indexed": true,
						"internalType": "address",
						"name": "newOwner",
						"type": "address"
					}
				],
				"name": "OwnershipTransferred",
				"type": "event"
			},
			{
				"anonymous": false,
				"inputs": [
					{
						"indexed": true,
						"internalType": "address",
						"name": "from",
						"type": "address"
					},
					{
						"indexed": true,
						"internalType": "address",
						"name": "to",
						"type": "address"
					},
					{
						"indexed": true,
						"internalType": "uint256",
						"name": "tokenId",
						"type": "uint256"
					}
				],
				"name": "Transfer",
				"type": "event"
			},
			{
				"inputs": [
					{
						"internalType": "address",
						"name": "to",
						"type": "address"
					},
					{
						"internalType": "uint256",
						"name": "tokenId",
						"type": "uint256"
					}
				],
				"name": "approve",
				"outputs": [],
				"stateMutability": "nonpayable",
				"type": "function"
			},
			{
				"inputs": [
					{
						"internalType": "address",
						"name": "owner",
						"type": "address"
					}
				],
				"name": "balanceOf",
				"outputs": [
					{
						"internalType": "uint256",
						"name": "",
						"type": "uint256"
					}
				],
				"stateMutability": "view",
				"type": "function"
			},
			{
				"inputs": [
					{
						"internalType": "uint256",
						"name": "tokenId",
						"type": "uint256"
					}
				],
				"name": "getApproved",
				"outputs": [
					{
						"internalType": "address",
						"name": "",
						"type": "address"
					}
				],
				"stateMutability": "view",
				"type": "function"
			},
			{
				"inputs": [
					{
						"internalType": "string",
						"name": "_uri",
						"type": "string"
					}
				],
				"name": "getTokenID",
				"outputs": [
					{
						"internalType": "uint256",
						"name": "",
						"type": "uint256"
					}
				],
				"stateMutability": "view",
				"type": "function"
			},
			{
				"inputs": [
					{
						"internalType": "address",
						"name": "owner",
						"type": "address"
					},
					{
						"internalType": "address",
						"name": "operator",
						"type": "address"
					}
				],
				"name": "isApprovedForAll",
				"outputs": [
					{
						"internalType": "bool",
						"name": "",
						"type": "bool"
					}
				],
				"stateMutability": "view",
				"type": "function"
			},
			{
				"inputs": [
					{
						"internalType": "string",
						"name": "_tokenURI",
						"type": "string"
					}
				],
				"name": "mintToken",
				"outputs": [
					{
						"internalType": "uint256",
						"name": "",
						"type": "uint256"
					}
				],
				"stateMutability": "nonpayable",
				"type": "function"
			},
			{
				"inputs": [],
				"name": "name",
				"outputs": [
					{
						"internalType": "string",
						"name": "",
						"type": "string"
					}
				],
				"stateMutability": "view",
				"type": "function"
			},
			{
				"inputs": [],
				"name": "owner",
				"outputs": [
					{
						"internalType": "address",
						"name": "",
						"type": "address"
					}
				],
				"stateMutability": "view",
				"type": "function"
			},
			{
				"inputs": [
					{
						"internalType": "uint256",
						"name": "tokenId",
						"type": "uint256"
					}
				],
				"name": "ownerOf",
				"outputs": [
					{
						"internalType": "address",
						"name": "",
						"type": "address"
					}
				],
				"stateMutability": "view",
				"type": "function"
			},
			{
				"inputs": [],
				"name": "renounceOwnership",
				"outputs": [],
				"stateMutability": "nonpayable",
				"type": "function"
			},
			{
				"inputs": [
					{
						"internalType": "address",
						"name": "from",
						"type": "address"
					},
					{
						"internalType": "address",
						"name": "to",
						"type": "address"
					},
					{
						"internalType": "uint256",
						"name": "tokenId",
						"type": "uint256"
					}
				],
				"name": "safeTransferFrom",
				"outputs": [],
				"stateMutability": "nonpayable",
				"type": "function"
			},
			{
				"inputs": [
					{
						"internalType": "address",
						"name": "from",
						"type": "address"
					},
					{
						"internalType": "address",
						"name": "to",
						"type": "address"
					},
					{
						"internalType": "uint256",
						"name": "tokenId",
						"type": "uint256"
					},
					{
						"internalType": "bytes",
						"name": "_data",
						"type": "bytes"
					}
				],
				"name": "safeTransferFrom",
				"outputs": [],
				"stateMutability": "nonpayable",
				"type": "function"
			},
			{
				"inputs": [
					{
						"internalType": "address",
						"name": "operator",
						"type": "address"
					},
					{
						"internalType": "bool",
						"name": "approved",
						"type": "bool"
					}
				],
				"name": "setApprovalForAll",
				"outputs": [],
				"stateMutability": "nonpayable",
				"type": "function"
			},
			{
				"inputs": [
					{
						"internalType": "string",
						"name": "baseURI_",
						"type": "string"
					}
				],
				"name": "setBaseURI",
				"outputs": [],
				"stateMutability": "nonpayable",
				"type": "function"
			},
			{
				"inputs": [
					{
						"internalType": "bytes4",
						"name": "interfaceId",
						"type": "bytes4"
					}
				],
				"name": "supportsInterface",
				"outputs": [
					{
						"internalType": "bool",
						"name": "",
						"type": "bool"
					}
				],
				"stateMutability": "view",
				"type": "function"
			},
			{
				"inputs": [],
				"name": "symbol",
				"outputs": [
					{
						"internalType": "string",
						"name": "",
						"type": "string"
					}
				],
				"stateMutability": "view",
				"type": "function"
			},
			{
				"inputs": [
					{
						"internalType": "uint256",
						"name": "index",
						"type": "uint256"
					}
				],
				"name": "tokenByIndex",
				"outputs": [
					{
						"internalType": "uint256",
						"name": "",
						"type": "uint256"
					}
				],
				"stateMutability": "view",
				"type": "function"
			},
			{
				"inputs": [
					{
						"internalType": "address",
						"name": "owner",
						"type": "address"
					},
					{
						"internalType": "uint256",
						"name": "index",
						"type": "uint256"
					}
				],
				"name": "tokenOfOwnerByIndex",
				"outputs": [
					{
						"internalType": "uint256",
						"name": "",
						"type": "uint256"
					}
				],
				"stateMutability": "view",
				"type": "function"
			},
			{
				"inputs": [
					{
						"internalType": "uint256",
						"name": "tokenId",
						"type": "uint256"
					}
				],
				"name": "tokenURI",
				"outputs": [
					{
						"internalType": "string",
						"name": "",
						"type": "string"
					}
				],
				"stateMutability": "view",
				"type": "function"
			},
			{
				"inputs": [],
				"name": "totalSupply",
				"outputs": [
					{
						"internalType": "uint256",
						"name": "",
						"type": "uint256"
					}
				],
				"stateMutability": "view",
				"type": "function"
			},
			{
				"inputs": [
					{
						"internalType": "address",
						"name": "from",
						"type": "address"
					},
					{
						"internalType": "address",
						"name": "to",
						"type": "address"
					},
					{
						"internalType": "uint256",
						"name": "tokenId",
						"type": "uint256"
					}
				],
				"name": "transferFrom",
				"outputs": [],
				"stateMutability": "nonpayable",
				"type": "function"
			},
			{
				"inputs": [
					{
						"internalType": "address",
						"name": "newOwner",
						"type": "address"
					}
				],
				"name": "transferOwnership",
				"outputs": [],
				"stateMutability": "nonpayable",
				"type": "function"
			}
		]''', 'Storage');
  DeployedContract deployedContract =
      DeployedContract(_contractAbi, contractAddr);
  // print('hehe');
  ContractFunction contractFunction = deployedContract.function("mintToken");
  // print("here");
  // final result = await ethClient.call(
  //     contract: deployedContract,
  //     function: contractFunction,
  //     params: []);
  EthereumWalletConnectProvider provider =
      EthereumWalletConnectProvider(Account.connector);
  //print(provider);
  var credentials = WalletConnectEthereumCredentials(provider: provider);

  launch(Account.uri);

  final result = await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
          from: EthereumAddress.fromHex(Account.account),
          contract: deployedContract,
          function: contractFunction,
          parameters: [
            "https://ipfs.infura.io/ipfs/${certUrl.body.toString()}"
          ]));
  //var jsonData = json.decode(response.body);
  print(result);
  return abc;
}
