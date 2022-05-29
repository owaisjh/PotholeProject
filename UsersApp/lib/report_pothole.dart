// import 'dart:convert';
// import 'dart:io';
// import 'package:final_year/pothole_registered.dart';
import 'package:final_year/record_data.dart';
import 'package:final_year/loading.dart';
import 'package:flutter/material.dart';
//import 'package:final_year/widgets/category_card.dart';
//import 'package:flutter_spinkit/flutter_spinkit.dart';
//import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
//import 'function.dart';
//import 'account.dart';
//import 'package:geolocator/geolocator.dart';

class ReportPothole extends StatefulWidget {
  const ReportPothole();

  @override
  State<ReportPothole> createState() => _ReportPotholeState();
}

class _ReportPotholeState extends State<ReportPothole> {
  //var aphoto;
  //late Position position;
  // Future<void> getPermission() async {
  //   //LocationPermission permission = await Geolocator.requestPermission();
  //   position = await Geolocator()
  //       .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //   print(position.latitude);
  // }

  @override
  void initState() {
    //getPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ImagePicker _picker = ImagePicker();

    return Scaffold(
      backgroundColor: Color(0xFFF5CEB8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    // final photo =
                    //     await _picker.pickImage(source: ImageSource.camera);

                    // if (photo != null) {
                    //   Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => Loading(photo.path)));
                    // }
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                              height: 150,
                              child: Column(children: <Widget>[
                                ListTile(
                                  onTap: () async {
                                    // close the modal
                                    //Navigator.of(context).pop();
                                    // show the camera
                                    final photo = await _picker.pickImage(
                                        source: ImageSource.camera);

                                    if (photo != null) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Loading(photo.path)));
                                    }

                                    // if (photo != null) {
                                    //   print('hello');
                                    //   final bytes =
                                    //       File(photo.path).readAsBytesSync();
                                    //   String base64Image = base64Encode(bytes);
                                    //   var response =
                                    //       await predictPothole(base64Image);
                                    //   //print(response);
                                    //   var jsonData = json.decode(response.body);
                                    //   var a = 1;
                                    //   var hash;
                                    //   if (a == 1 ||
                                    //       jsonData["classLabel"] == "Pothole") {
                                    //     print('xyz');
                                    //     hash = jsonData['hash'];
                                    //     var x = await Geolocator()
                                    //         .placemarkFromCoordinates(
                                    //             position.latitude,
                                    //             position.longitude);
                                    //     var response = await reportPothole(
                                    //         position.latitude.toString(),
                                    //         position.longitude.toString(),
                                    //         x[0].thoroughfare,
                                    //         x[0].locality,
                                    //         x[0].subLocality,
                                    //         x[0].postalCode,
                                    //         hash);
                                    //     print('response');
                                    //     print(response.body);
                                    //     // print(x[0].postalCode);
                                    //     // print(x[0].locality);
                                    //     // //print(x[0].subAdministrativeArea);
                                    //     // print(x[0].subLocality);
                                    //     // print(x[0].subThoroughfare);
                                    //   }
                                    //   Navigator.push(
                                    //       context,
                                    //       MaterialPageRoute(
                                    //           builder: (context) =>
                                    //               RegisteredPothole(
                                    //                 image:
                                    //                     "https://ipfs.infura.io/ipfs/$hash",
                                    //                 city: 'Mumbai',
                                    //                 locality:
                                    //                     'Jogeshwari (East)',
                                    //                 road: 'XYZ Road',
                                    //                 postCode: '400060',
                                    //                 statusText: 'Not Fixed',
                                    //                 statusColor: Colors.red,
                                    //                 latitude: position.latitude,
                                    //                 longitude:
                                    //                     position.longitude,
                                    //               )));
                                    // }
                                    print('here');
                                  },
                                  leading: Icon(
                                    Icons.photo_camera,
                                    color: Colors.blue,
                                  ),
                                  title: Text("Take a picture"),
                                ),
                                ListTile(
                                  onTap: () async {
                                    // close the modal
                                    //Navigator.of(context).pop();
                                    // show the camera
                                    final photo = await _picker.pickImage(
                                        source: ImageSource.gallery);
                                    if (photo != null) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Loading(photo.path)));
                                    }

                                    // if (photo != null) {
                                    //   final bytes =
                                    //       File(photo.path).readAsBytesSync();
                                    //   String base64Image = base64Encode(bytes);
                                    //   var response =
                                    //       await predictPothole(base64Image);
                                    //   print(response);
                                    //   var jsonData = json.decode(response.body);
                                    //   var a = 1;
                                    //   var hash;
                                    //   if (a == 1 ||
                                    //       jsonData["classLabel"] == "Pothole") {
                                    //     print('xyz');
                                    //     hash = jsonData['Hash'];
                                    //     var x = await Geolocator()
                                    //         .placemarkFromCoordinates(
                                    //             position.latitude,
                                    //             position.longitude);
                                    //     var response = await reportPothole(
                                    //         position.latitude.toString(),
                                    //         position.longitude.toString(),
                                    //         x[0].thoroughfare,
                                    //         x[0].locality,
                                    //         x[0].subLocality,
                                    //         x[0].postalCode,
                                    //         hash);
                                    //     print(response.body);
                                    //     Navigator.push(
                                    //         context,
                                    //         MaterialPageRoute(
                                    //             builder: (context) =>
                                    //                 RegisteredPothole(
                                    //                   image:
                                    //                       "https://ipfs.infura.io/ipfs/$hash",
                                    //                   city: 'Mumbai',
                                    //                   locality:
                                    //                       'Jogeshwari (East)',
                                    //                   road: 'XYZ Road',
                                    //                   postCode: '400060',
                                    //                   statusText: 'Not Fixed',
                                    //                   statusColor: Colors.red,
                                    //                   latitude:
                                    //                       position.latitude,
                                    //                   longitude:
                                    //                       position.longitude,
                                    //                 )));
                                    //   }
                                    // }
                                    // ;
                                  },
                                  leading: Icon(
                                    Icons.image_search,
                                    color: Colors.blue,
                                  ),
                                  title: Text("Choose a picture"),
                                )
                              ]));
                        });
                  },
                  child: Container(
                    height: 150,
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Spacer(),
                        Image.asset(
                          "assets/images/capture_image.png",
                          height: 100,
                          width: 100,
                        ),
                        Spacer(),
                        Text("Capture image",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Spacer()
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => RecordData()));
                  },
                  child: Container(
                    height: 150,
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Spacer(),
                        Image.asset(
                          "assets/images/accelerometer.png",
                          height: 100,
                          width: 100,
                        ),
                        Spacer(),
                        Text("Record Data",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Spacer(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
