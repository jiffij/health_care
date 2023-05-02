import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:google_fonts/google_fonts.dart';
import '../color.dart';
import 'package:icon_badge/icon_badge.dart';
import '../../helper/firebase_helper.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  String fullname = '';

  @override
  void initState() {
    super.initState();
    start();
  }

  // Test
  void start() async {
    String uid = getUID();
    Map<String, dynamic>? user = await readFromServer('patient/$uid');
    fullname = user?['first name'] + ' ' + user?['last name'];

    //setState(() {print(user);});
    setState(() {});
  }
  // Test

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    // Test
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    List<List> notificationslist = [
      ['Upcoming appointment', 0xf06bb, 'MaterialIcons', 4],
      ['Medical Report', 0xe285, 'MaterialIcons', 5],
      ['Unread message', 0xe3e0, 'MaterialIcons', 6],
      ['Upcoming appointment', 0xf06bb, 'MaterialIcons', 7],
      ['Medical Report', 0xe285, 'MaterialIcons', 8],
    ];
    // Test

    return SafeArea(
        child: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 25, left: 25, right: 25, bottom: 10),
            decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: grey.withOpacity(0.03),
                    spreadRadius: 10,
                    blurRadius: 3,
                    // changes position of shadow
                  ),
                ]),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 20, bottom: 25, right: 20, left: 20),
              child: Column(
                children: [
                  /*
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Icon(Icons.bar_chart), Icon(Icons.more_vert)],
                  ),
                  */
                  SizedBox(
                    height: 15,
                  ),
                  Column(
                    children: [
                      Container(
                        width: 70,
                        height: 60,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(
                                    "https://i.ibb.co/7gpgsPx/Icon.png&auto=format&fit=crop&w=800&q=60"),
                                fit: BoxFit.cover)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: (size.width - 40) * 0.6,
                        child: Column(
                          children: [
                            Text(
                              '$fullname',
                              //'Abbie Wilson',
                              style: GoogleFonts.comfortaa(
                                  color: lighttheme, fontSize: 24),
                            ),
                            /*
                            Text(
                              "Abbie Wilson",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 47, 106, 173)),
                            ),*/
                            /*
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Software Developer",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: black),
                            ),*/
                          ],
                        ),
                      )
                    ],
                  ),
                  // Margin
                  SizedBox(
                    height: 30,
                  ),
                  // Additional Info

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Heart Rate',
                            style: GoogleFonts.comfortaa(
                                color: lighttheme, fontSize: 14),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text('80',
                              style: GoogleFonts.comfortaa(
                                  color: Colors.black, fontSize: 20)),
                        ],
                      ),
                      Container(
                        width: 0.5,
                        height: 40,
                        color: black.withOpacity(0.3),
                      ),
                      Column(
                        children: [
                          Text(
                            'Blood Type',
                            style: GoogleFonts.comfortaa(
                                color: lighttheme, fontSize: 14),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text('O',
                              style: GoogleFonts.comfortaa(
                                  color: Colors.black, fontSize: 20)),
                        ],
                      ),
                      Container(
                        width: 0.5,
                        height: 40,
                        color: black.withOpacity(0.3),
                      ),
                      Column(
                        children: [
                          Text(
                            'Weight',
                            style: GoogleFonts.comfortaa(
                                color: lighttheme, fontSize: 14),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text('43 kg',
                              style: GoogleFonts.comfortaa(
                                  color: Colors.black, fontSize: 20)),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Notification',
                          style: GoogleFonts.comfortaa(
                              color: Colors.black, fontSize: 20),
                        ),
                        IconBadge(
                          icon: Icon(Icons.notifications_none),
                          itemCount: 8,
                          badgeColor: Colors.red,
                          //itemColor: mainFontColor,
                          itemColor: Colors.black,
                          hideZero: true,
                          top: -1,
                          onTap: () {
                            print('test');
                          },
                        ),
                      ],
                    )
                  ],
                ),
                // Text("Overview",
                //     style: TextStyle(
                //       fontWeight: FontWeight.bold,
                //       fontSize: 20,
                //       color: mainFontColor,
                //     )),
                /*
                Text("Jan 16, 2023",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: mainFontColor,
                    )),*/
              ],
            ),
          ),
          /*
          SizedBox(
            height: 5,
          ),*/
          /*
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                          top: 20,
                          left: 25,
                          right: 25,
                        ),
                        decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: grey.withOpacity(0.03),
                                spreadRadius: 10,
                                blurRadius: 3,
                                // changes position of shadow
                              ),
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, right: 20, left: 20),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: arrowbgColor,
                                  borderRadius: BorderRadius.circular(15),
                                  // shape: BoxShape.circle
                                ),
                                child: Center(
                                    child: Icon(Icons.arrow_upward_rounded)),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              /*
                              Expanded(
                                child: Container(
                                  width: (size.width - 90) * 0.7,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Sent",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "Sending Payment to Clients",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: black.withOpacity(0.5),
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ]),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "\$150",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: black),
                                      )
                                    ],
                                  ),
                                ),
                              )*/
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                          top: 10,
                          left: 25,
                          right: 25,
                        ),
                        decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: grey.withOpacity(0.03),
                                spreadRadius: 10,
                                blurRadius: 3,
                                // changes position of shadow
                              ),
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, right: 20, left: 20),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: arrowbgColor,
                                  borderRadius: BorderRadius.circular(15),
                                  // shape: BoxShape.circle
                                ),
                                child: Center(
                                    child: Icon(Icons.arrow_downward_rounded)),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Container(
                                  width: (size.width - 90) * 0.7,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Receive",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "Receiving Payment from company",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: black.withOpacity(0.5),
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ]),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "\$250",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: black),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                          top: 10,
                          left: 25,
                          right: 25,
                        ),
                        decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: grey.withOpacity(0.03),
                                spreadRadius: 10,
                                blurRadius: 3,
                                // changes position of shadow
                              ),
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, right: 20, left: 20),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: arrowbgColor,
                                  borderRadius: BorderRadius.circular(15),
                                  // shape: BoxShape.circle
                                ),
                                child: Center(
                                    child: Icon(CupertinoIcons.money_dollar)),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Container(
                                  width: (size.width - 90) * 0.7,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Loan",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "Loan for the Car",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: black.withOpacity(0.5),
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ]),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "\$400",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: black),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )*/
          notificationlist(width, height, notificationslist),
        ],
      ),
    ));
  }

  // Test
  Widget notificationlist(double globalwidth, double globalheight, list) =>
      DefaultTextStyle.merge(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              /*
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Container(
                  margin: const EdgeInsets.only(left: 12),
                  height: globalheight * 0.05,
                  width: globalwidth,
                  /*
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text('Notification',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                  ),*/
                ),
              ),
              */
            ),
            SizedBox(
              height: globalheight * 0.4,
              //height: globalheight * 0.3,
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.all(12),
                // The number of itemCount depends on the number of appointment
                // 5 is the number of appointment for testing only
                itemCount: 5,
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 15);
                },
                itemBuilder: (context, index) {
                  return notification(
                      index, globalwidth, globalheight, list[index]);
                },
              ),
            ),
          ],
        ),
      );

  Widget notification(
          int index, double globalwidth, double globalheight, List list) =>
      Align(
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Container(
            height: globalheight * 0.11,
            width: globalwidth * 0.85,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 255, 255, 255),
              boxShadow: const [
                BoxShadow(
                    color: Color.fromARGB(255, 215, 222, 234), spreadRadius: 1),
              ],
            ),
            child: Row(
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Container(
                    margin: const EdgeInsets.only(left: 20, right: 10),
                    height: globalheight * 0.07,
                    width: globalheight * 0.07,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 220, 237, 249),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        child: Icon(IconData(list[1], fontFamily: list[2]),
                            color: const Color.fromARGB(255, 28, 107, 164)),
                      ),
                    ),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Todo: The text need to divide automatically into multiple line when overflow
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        /* Reference
                        Text(
                          'Notification',
                          style: GoogleFonts.comfortaa(
                              color: Colors.black, fontSize: 20),
                        ),
                        */
                        child: Text('${list[3]} ${list[0]}',
                            style: GoogleFonts.comfortaa(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        /*
                        child: Text('Tap to view your ${list[0]}',
                            style: GoogleFonts.comfortaa(
                                color: Colors.black, fontSize: 12)),
                        */
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
