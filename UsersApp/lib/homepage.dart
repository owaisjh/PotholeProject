import 'package:final_year/MyProfile.dart';
import 'package:final_year/certificatepage.dart';
import 'package:final_year/mypotholes.dart';
import 'package:final_year/register.dart';
import 'package:final_year/report_pothole.dart';
import 'package:final_year/walletconnect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:final_year/constants.dart';
import 'package:final_year/widgets/bottom_nav_bar.dart';
import 'package:final_year/widgets/category_card.dart';
import 'package:final_year/widgets/search_bar.dart';

class HomePage extends StatefulWidget {
  final String name;
  final String balance;

  HomePage({required this.name, required this.balance});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context)
        .size; //this gonna give us total height and with of our device
    return Scaffold(
      //bottomNavigationBar: BottomNavBar(),
      body: Stack(
        children: <Widget>[
          Container(
            // Here the height of the container is 45% of our total height
            height: size.height * .45,
            decoration: BoxDecoration(
              color: Color(0xFFF5CEB8),
              image: DecorationImage(
                alignment: Alignment.centerLeft,
                image: AssetImage("assets/images/undraw_pilates_gpdb.png"),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      alignment: Alignment.center,
                      height: 52,
                      width: 52,
                      decoration: BoxDecoration(
                        color: Color(0xFFF2BEA1),
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset("assets/icons/menu.svg"),
                    ),
                  ),
                  // Text(
                  //   "Good Mornign \nShishir",
                  //   style: Theme.of(context)
                  //       .textTheme
                  //       .display1
                  //       .copyWith(fontWeight: FontWeight.w900),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi, " + widget.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Your balance: " + widget.balance,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20))
                      ],
                    ),
                  ),
                  //SearchBar(),
                  SizedBox(
                    height: 100,
                  ),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: .85,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: <Widget>[
                        CategoryCard(
                          title: "Report Pothole",
                          svgSrc: "assets/icons/Reports_Flat_Icon.svg",
                          imagePath: "assets/images/report.png",
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ReportPothole()),
                            );
                          },
                        ),
                        CategoryCard(
                          title: "View Certificates",
                          svgSrc: "assets/icons/Excrecises.svg",
                          imagePath: "assets/images/certificate.png",
                          press: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CertificatePage(
                                        name: widget.name,
                                        tokens: int.parse(widget.balance))));
                          },
                        ),
                        CategoryCard(
                          imagePath: "assets/images/profile.png",
                          title: "Profile",
                          svgSrc: "assets/icons/Meditation.svg",
                          press: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyProfile(
                                          name: widget.name,
                                          email: "123@abc.com",
                                        )));
                          },
                        ),
                        CategoryCard(
                          imagePath: "assets/images/transactions.png",
                          title: "My transactions",
                          svgSrc: "assets/icons/yoga.svg",
                          press: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyPotholes()));
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
