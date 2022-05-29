import 'dart:async';
import 'package:final_year/function.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class RecordData extends StatefulWidget {
  @override
  State<RecordData> createState() => _RecordDataState();
}

class _RecordDataState extends State<RecordData> {
  List<double>? _accelerometerValues;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  List<Map> accData = [];
  Map<String, double> sensorData = {};
  var position;

  String recording = 'Not Recording';
  printSubscription() {
    print(_streamSubscriptions);
  }

  startRecording() {
    _streamSubscriptions.add(
      accelerometerEvents.listen(
        (AccelerometerEvent event) async {
          position = await Geolocator()
              .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
          //print(event);
          sensorData = {
            'x': event.x,
            'y': event.y,
            'z': event.z,
            'lat': position.latitude,
            'long': position.longitude,
          };
          accData.add(sensorData);
          setState(() {
            _accelerometerValues = <double>[event.x, event.y, event.z];
          });
        },
      ),
    );
  }

  stopRecording() {
    print('STOP-----------------');
    print(accData);
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final accelerometer =
        _accelerometerValues?.map((double v) => v.toStringAsFixed(1)).toList();

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Accelerometer: $accelerometer'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(recording),
                ],
              ),
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
                child: Text('Start recording'),
                onPressed: () async {
                  setState(() {
                    recording = 'Recording....';
                  });
                  startRecording();
                }),
            SizedBox(
              height: 40,
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
                child: Text('Stop recording'),
                onPressed: () async {
                  setState(() {
                    recording = 'Recording over';
                    stopRecording();
                  });
                }),
            SizedBox(
              height: 50,
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
                child: Text('Send data'),
                onPressed: () async {
                  await sendAccData(accData);
                }),
          ],
        ),
      ),
    );
  }
}
