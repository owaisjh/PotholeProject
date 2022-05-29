import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http/http.dart' as http;
import 'package:final_year/function.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'account.dart';
import 'package:permission_handler/permission_handler.dart';

class CertificatePage extends StatefulWidget {
  final String name;
  final int tokens;

  CertificatePage({required this.name, required this.tokens});
  @override
  State<CertificatePage> createState() => _CertificatePageState();
}

class _CertificatePageState extends State<CertificatePage> {
  late String url;
  late String text;
  getUrl() {
    var response = getCertificateUrl();

    url = response.toString();
  }

  var abc =
      "https://ipfs.infura.io/ipfs/Qmb35uNGxiThEbyip1Xd4R8B2d9yQEgRYeqaCru2gHEECA";

  ReceivePort receivePort = ReceivePort();
  @override
  void initState() {
    //getUrl();

    IsolateNameServer.registerPortWithName(receivePort.sendPort, 'download');
    FlutterDownloader.registerCallback(downloadcallback);
    super.initState();
  }

  static downloadcallback(id, status, progress) {
    SendPort? sendPort = IsolateNameServer.lookupPortByName('download');
    //sendPort.send(progress);
  }

  @override
  Widget build(BuildContext context) {
    bool eligible = (widget.tokens > 200);
    if (eligible) {
      text = "Congratulations, you can redeem this token";
    } else {
      text = "Sorry, you are not eligible for this token yet";
    }
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  text,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Container(height: 300, width: 300, child: Image.network(abc)),
              SizedBox(
                height: 20,
              ),
              MaterialButton(
                  height: 50.0,
                  minWidth: 150.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  color: Colors.blueAccent,
                  splashColor: Colors.white,
                  textColor: Colors.black,
                  disabledColor: Colors.grey,
                  child: Text('Redeem Certificate'),
                  onPressed: eligible
                      ? () async {
                          var certUrl = await addCertificateUrl();
                          print('button');
                          print(certUrl);
                          final status = await Permission.storage.request();

                          if (status.isGranted) {
                            final baseStorage =
                                await getExternalStorageDirectory();
                            final id = await FlutterDownloader.enqueue(
                                //url: abc,
                                url:
                                    'https://ipfs.infura.io/ipfs/${certUrl.toString()}',
                                savedDir: baseStorage!.path,
                                fileName: 'Certificate');
                          }
                        }
                      : null),
            ],
          ),
        ),
      )),
    );
  }
}
