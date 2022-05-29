import 'package:final_year/homepage.dart';
import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'account.dart';
import 'function.dart';

//import 'checker.dart';
//import 'loading.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late String email;
  late String name;
  late String contactNo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFC1F8CF),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 80, bottom: 50, left: 50),
              child: Text(
                'Register here.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 60.0,
                  color: Color(0xFF488FB1),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(40.0),
              child: Form(
                //autovalidateMode: AutovalidateMode.always,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      enabled: false,
                      initialValue: Account.account,
                      decoration: InputDecoration(
                          labelText: "Account",
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.key)),
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.blueGrey),

                      // validator: (String value) {
                      //     return value.contains('@') ? null : 'Enter a valid email';
                      // },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: "Enter email",
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.email)),
                      keyboardType: TextInputType.emailAddress,

                      onChanged: (value) {
                        email = value;
                      },
                      // validator: (String value) {
                      //     return value.contains('@') ? null : 'Enter a valid email';
                      // },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: "Enter your name",
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.person_outline)),
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        name = value.trimRight();
                        //print(username);
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Enter contact number",
                        fillColor: Colors.white,
                        hintText: 'Contact Number',
                        prefixIcon: Icon(Icons.phone, color: Colors.grey),
                      ),

                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        contactNo = value.trimRight();
                      },
                      // validator: (value){
                      //   return value.length == 10 ? null : 'Enter a valid phone number';
                      // },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 60.0),
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
                        child: Text('Create User'),
                        onPressed: () async {
                          var response =
                              await signUpWithAddress(name, email, contactNo);
                          if (response.statusCode == 200) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage(
                                          name: 'Dhairya',
                                          balance: '20',
                                        )));
                          }
                        }),
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
