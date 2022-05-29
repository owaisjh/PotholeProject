import 'package:final_year/account.dart';
import 'package:flutter/material.dart';
import 'package:avatar_view/avatar_view.dart';

class MyProfile extends StatefulWidget {
  final String name;
  final String email;
  MyProfile({required this.name, required this.email});
  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * .45,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFFF2BEA1),
                  // borderRadius: BorderRadius.only(
                  //     bottomLeft: Radius.circular(20),
                  //     bottomRight: Radius.circular(20))
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AvatarView(
                      radius: 60,
                      borderWidth: 6,
                      borderColor: Colors.white,
                      avatarType: AvatarType.CIRCLE,
                      imagePath: "assets/images/profile_pic.png",
                      placeHolder: Container(
                        child: Icon(
                          Icons.person,
                          size: 50,
                        ),
                      ),
                      errorWidget: Container(
                        child: Icon(
                          Icons.error,
                          size: 50,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      widget.name,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  elevation: 50,
                  shadowColor: Colors.grey,
                  child: Container(
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.key,
                            size: 50,
                            color: Colors.blue,
                          ),
                          title: Text(
                            'Account Address',
                            style: TextStyle(fontSize: 10),
                          ),
                          subtitle: Text(Account.account),
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(
                            Icons.email_outlined,
                            size: 50,
                            color: Colors.redAccent,
                          ),
                          title: Text(
                            'Email',
                            style: TextStyle(fontSize: 10),
                          ),
                          subtitle: Text(widget.email),
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(
                            Icons.phone,
                            size: 50,
                            color: Colors.amber,
                          ),
                          title: Text(
                            'Contact Number',
                            style: TextStyle(fontSize: 10),
                          ),
                          subtitle: Text('91292191291'),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}
