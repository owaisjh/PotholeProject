import 'dart:convert';
import 'dart:io';

import 'package:final_year/pothole_registered.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';

import 'function.dart';

class Loading extends StatefulWidget {
  final String photo;

  Loading(this.photo);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  late bool functionDone = false;
  late bool potholeAlreadyRegistered = false;
  late Position position;
  Future<void> getPermission() async {
    //LocationPermission permission = await Geolocator.requestPermission();
    position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    //print(position.latitude);
  }

  Future<void> abc() async {
    var photo = widget.photo;

    final bytes = File(photo).readAsBytesSync();
    String base64Image = base64Encode(bytes);
    var response = await predictPothole(base64Image);
    print(response);
    var jsonData = json.decode(response.body);

    var a = 1;
    var hash;
    if (a == 1 || jsonData["classLabel"] == "Plain") {
      //toast
    }
    if (a == 1 || jsonData["classLabel"] == "Pothole") {
      print('xyz');
      hash = jsonData['Hash'];
      var x = await Geolocator()
          .placemarkFromCoordinates(position.latitude, position.longitude);

      var response = await reportPothole(
          position.latitude.toString(),
          position.longitude.toString(),
          x[0].thoroughfare,
          x[0].locality,
          x[0].subLocality,
          x[0].postalCode,
          hash);

      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 401) {
        potholeAlreadyRegistered = true;
        setState(() {});
      } else if (response.statusCode == 201) {
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RegisteredPothole(
                      image: "https://ipfs.infura.io/ipfs/$hash",
                      city: x[0].locality,
                      locality: x[0].subLocality,
                      road: x[0].thoroughfare,
                      postCode: x[0].postalCode,
                      statusText: 'Not Fixed',
                      statusColor: Colors.red,
                      latitude: position.latitude,
                      longitude: position.longitude,
                    )));
      }
      ;
    }
  }

  @override
  void initState() {
    getPermission();
    abc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 208, 247, 218),
        body: potholeAlreadyRegistered
            ? SafeArea(
                child: Center(
                    child: Text(
                        'This pothole already exists. We have increased its priority.')))
            : SafeArea(
                child: Center(
                child: SpinKitCircle(size: 50, color: Colors.orangeAccent),
              )));
  }
}
