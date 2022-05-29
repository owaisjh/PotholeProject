import 'package:final_year/pothole_registered.dart';
import 'package:flutter/material.dart';
import 'function.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MyPotholes extends StatefulWidget {
  @override
  State<MyPotholes> createState() => _MyPotholesState();
}

class _MyPotholesState extends State<MyPotholes> {
  late List allpotholes = [];
  late List fixedPotholes = [];
  late List unfixedPotholes = [];
  late List potholes = [];
  late bool noPotholes = false;
  void getPotholes() async {
    allpotholes = await getUserPotholes();
    potholes = allpotholes;
    if (potholes.length == 0) {
      setState(() {
        noPotholes = true;
      });
    }
    setState(() {});
    for (var e in allpotholes) {
      if (e[5]) {
        fixedPotholes.add(e);
        print('f');
        print(fixedPotholes);
      } else {
        unfixedPotholes.add(e);
      }
    }

    print(allpotholes);
  }

  @override
  void initState() {
    getPotholes();
    setState(() {});
    super.initState();
  }

  String dropdownValue = 'All Potholes';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (potholes.length == 0)
          ? (noPotholes == false)
              ? SpinKitCircle(
                  color: Color(0xFFF5CEB8),
                  duration: Duration(seconds: 10),
                )
              : Center(
                  child: Text('No potholes reported by you.'),
                )
          : SafeArea(
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: double.infinity,
                      decoration: BoxDecoration(color: Color(0xFFF5CEB8)),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(40, 20, 0, 20),
                          child: DropdownButton<String>(
                            value: dropdownValue,
                            icon: Icon(Icons.keyboard_arrow_down),
                            elevation: 16,
                            style: TextStyle(color: Colors.black),
                            underline: Container(
                              height: 2,
                              color: Color.fromARGB(255, 76, 151, 198),
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue = newValue!;
                                if (newValue == 'Fixed Potholes') {
                                  potholes = fixedPotholes;
                                  if (potholes.length == 0) {
                                    setState(() {
                                      noPotholes = true;
                                    });
                                  }
                                }
                                if (newValue == 'Unfixed Potholes') {
                                  potholes = unfixedPotholes;
                                  if (potholes.length == 0) {
                                    setState(() {
                                      noPotholes = true;
                                    });
                                  }
                                }
                                if (newValue == 'All Potholes') {
                                  potholes = allpotholes;
                                }
                              });
                            },
                            items: <String>[
                              'All Potholes',
                              'Fixed Potholes',
                              'Unfixed Potholes'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SingleChildScrollView(
                            child: Container(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: potholes.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var statusColor;
                                    var statusText;
                                    if (potholes[index][5]) {
                                      statusText = 'Fixed';
                                      statusColor = Colors.green;
                                    } else {
                                      statusText = 'Not Fixed';
                                      statusColor = Colors.red;
                                    }

                                    return Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Pothole #${index + 1}',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(potholes[index][2]
                                                      ['locality']),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Status: ',
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                      Text(
                                                        statusText,
                                                        style: TextStyle(
                                                            color: statusColor,
                                                            fontSize: 20),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFFC1F8CF)),
                                                    child: TextButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        RegisteredPothole(
                                                                          image:
                                                                              'https://ipfs.infura.io/ipfs/${potholes[index][3]}',
                                                                          city: potholes[index][2]
                                                                              [
                                                                              'city'],
                                                                          locality:
                                                                              potholes[index][2]['locality'],
                                                                          road: potholes[index][2]
                                                                              [
                                                                              'road'],
                                                                          postCode:
                                                                              potholes[index][2]['postal_code'],
                                                                          statusColor:
                                                                              statusColor,
                                                                          statusText:
                                                                              statusText,
                                                                          latitude:
                                                                              potholes[index][1]['coordinates'][0],
                                                                          longitude:
                                                                              potholes[index][1]['coordinates'][1],
                                                                        )));
                                                      },
                                                      child: Container(
                                                          color:
                                                              Color(0xFFC1F8CF),
                                                          child: Text(
                                                            'View Details',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          )),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Container(
                                                height: 100,
                                                width: 100,
                                                child: Image.network(
                                                  "https://ipfs.infura.io/ipfs/${potholes[index][3]}",
                                                  fit: BoxFit.contain,
                                                  scale: 1,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
