import 'dart:io';
import 'dart:async';
import 'package:final_year/google_maps.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RegisteredPothole extends StatefulWidget {
  final String image;
  final String city;
  final String locality;
  final String road;
  final String postCode;
  final Color statusColor;
  final String statusText;
  final double latitude;
  final double longitude;
  RegisteredPothole(
      {required this.image,
      required this.city,
      required this.locality,
      required this.road,
      required this.postCode,
      required this.statusColor,
      required this.statusText,
      required this.latitude,
      required this.longitude});

  @override
  State<RegisteredPothole> createState() => _RegisteredPotholeState();
}

class _RegisteredPotholeState extends State<RegisteredPothole> {
  Completer<GoogleMapController> _controller = Completer();
//19.1299114, 72.850171
  static const LatLng _position = const LatLng(19.1299114, 72.850171);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 208, 247, 218),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Pothole Details",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'City',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                        Text(
                          widget.city,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          'Locality',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                        Text(
                          widget.locality,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),

                        // Text(
                        //   'Road',
                        //   style: TextStyle(
                        //       fontSize: 15,
                        //       fontWeight: FontWeight.bold,
                        //       color: Colors.grey),
                        // ),
                        // Text(
                        //   widget.road,
                        //   style: TextStyle(
                        //       fontSize: 15,
                        //       fontWeight: FontWeight.bold,
                        //       color: Colors.black),
                        // ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          'Postal Code',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),

                        Text(
                          widget.postCode,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            Text(
                              'Status:  ',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                            Text(
                              widget.statusText,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: widget.statusColor),
                            ),
                          ],
                        )
                      ],
                    ),
                    Container(
                      height: 150,
                      width: 200,
                      child: Image.network(
                        widget.image,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
              ), //details
              SizedBox(
                height: 50,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Location',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: GoogleMap(
                        onMapCreated: _onMapCreated,
                        markers: {
                          Marker(
                              markerId: MarkerId(_position.toString()),
                              position:
                                  LatLng(widget.latitude, widget.longitude),
                              infoWindow: InfoWindow(
                                title: 'Pothole',
                              ),
                              icon: BitmapDescriptor.defaultMarker),
                        },
                        initialCameraPosition: CameraPosition(
                          target: LatLng(widget.latitude, widget.longitude),
                          zoom: 12.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ) //map
            ],
          ),
        ),
      ),
    );
  }
}
