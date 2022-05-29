// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:government/potholeDetails.dart';
import 'package:government/profile.dart';
import 'package:government/style.dart';
import 'package:http/http.dart' as http;
import 'colors.dart';
import 'package:government/main.dart';

class Pothole extends StatefulWidget {
  const Pothole() : super();

  @override
  _PotholeState createState() => _PotholeState();
}

class _PotholeState extends State<Pothole> {
  late double curLat;
  late double curLong;
  late GoogleMapController mapController;
  List<Widget> data = [];
  var tempData;
  var sortData;
  Uri uri =
      Uri(scheme: 'https', host: url, path: "notfixed_potholes_coordinates");
  void getData() async {
    var res = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
    );
    var a = jsonDecode(res.body);
    print("reachedn " + a[0][0]);
    List<Widget> children = [];
    for (int i = 0; i < a.length; i++) {
      children.add(
        potholeCard(
            a[i][0],
            "https://ipfs.infura.io/ipfs/" + a[i][3],
            "Pothole #$i",
            "Reported Today",
            a[i][1]["coordinates"][0].toDouble(),
            a[i][1]["coordinates"][1].toDouble(),
            i,
            a[i][2],
            a[i][8].toString()),
      );
    }
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    print(a);
    setState(() {
      data = children;
      curLat = position.latitude;
      curLong = position.longitude;
      tempData = a;
      sortData = a;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.30,
            color: Color.fromARGB(255, 11, 49, 80),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.18,
                ),
                Expanded(
                  child: ListView(children: data),
                ),
              ],
            ),
          ),
          Positioned(
            right: 30,
            top: 30,
            child: GestureDetector(
              onTap: (() {
                Navigator.push(context,
                    MaterialPageRoute(builder: ((context) => Profile())));
              }),
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.person,
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              left: 30,
              top: 35,
              child: Text(
                "Pothole Repair",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal),
              )),
          Positioned(
              top: 90,
              left: 35,
              child: Row(
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      elevation: MaterialStateProperty.all(15),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    child: Text(
                      "Sort By Distance",
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () async {
                      final distances = [];
                      for (int i = 0; i < tempData.length; i++) {
                        double dis = await Geolocator().distanceBetween(
                            curLat,
                            curLong,
                            tempData[i][1]["coordinates"][0].toDouble(),
                            tempData[i][1]["coordinates"][1].toDouble());
                        distances.add({"index": i, "value": dis});
                      }
                      distances
                          .sort(((a, b) => a["value"].compareTo(b["value"])));
                      print(distances);
                      List<Widget> children = [];
                      for (int j = 0; j < distances.length; j++) {
                        int i = distances[j]["index"];
                        children.add(potholeCard(
                            tempData[i][0],
                            "https://ipfs.infura.io/ipfs/" + tempData[i][3],
                            "Pothole #$i",
                            "Reported Today",
                            tempData[i][1]["coordinates"][0].toDouble(),
                            tempData[i][1]["coordinates"][1].toDouble(),
                            i,
                            tempData[i][2],
                            tempData[i][8].toString()));
                      }
                      setState(() {
                        data = children;
                      });
                    },
                  ),
                ],
              )),
          Positioned(
              top: 90,
              right: 35,
              child: Row(
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      elevation: MaterialStateProperty.all(15),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    child: Text(
                      "Sort By Priority",
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () async {
                      final prioritiess = [];
                      for (int i = 0; i < sortData.length; i++) {
                        prioritiess.add({"index": i, "value": sortData[i][8]});
                      }
                      prioritiess
                          .sort(((a, b) => a["value"].compareTo(b["value"])));
                      final priorities = prioritiess.reversed.toList();
                      List<Widget> children = [];
                      for (int j = 0; j < priorities.length; j++) {
                        int i = priorities[j]["index"];
                        children.add(potholeCard(
                            tempData[i][0],
                            "https://ipfs.infura.io/ipfs/" + tempData[i][3],
                            "Pothole #$i",
                            "Reported Today",
                            tempData[i][1]["coordinates"][0].toDouble(),
                            tempData[i][1]["coordinates"][1].toDouble(),
                            i,
                            tempData[i][2],
                            tempData[i][8].toString()));
                      }
                      setState(() {
                        data = children;
                      });
                    },
                  ),
                ],
              )),
        ],
      ),
    ));
  }

  Widget potholeCard(String id, String imagePath, String name, String weight,
      double lat, double long, int index, var location, String priority) {
    return GestureDetector(
      onTap: () => {},
      child: Container(
        margin: EdgeInsets.only(right: 25, left: 20, top: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(blurRadius: 10, color: AppColors.lighterGray)],
          color: AppColors.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 123, 172, 212),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            )),
                        child: Text(
                          priority,
                          style: TextStyle(color: Colors.white),
                        )),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 25, left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Lat: ${lat.toStringAsFixed(3)}, Long: ${long.toStringAsFixed(3)}",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontStyle: FontStyle.italic),
                          )
                        ],
                      ),
                      SizedBox(height: 15),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.2,
                        child: PrimaryText(
                            text: name, size: 22, fontWeight: FontWeight.w700),
                      ),
                      PrimaryText(
                          text: weight, size: 16, color: AppColors.lightGray),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => PotholeDetail(
                                id, imagePath, lat, long, index, location))));
                  },
                  child: Row(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 45, vertical: 20),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 123, 172, 212),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            )),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              height: 90,
              width: 100,
              transform: Matrix4.translationValues(0, 50, 0.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(255, 189, 189, 189),
                        blurRadius: 20)
                  ]),
              child: Image.network(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
