import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:google_fonts/google_fonts.dart';
import '../color.dart';
import 'profile_userInfo.dart';
import 'profile_otherInfo.dart';
//import '../../helper/firebase_helper.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int pageIndex = 0;
  //String fullname = '';

  List<Widget> pages = [
    UserInfoPage(),
    /*
    TransectionPage(),
    TransectionPage(),
    TransectionPage(),
    TransectionPage(),
    */
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
          title: Text('My Profile'),
          elevation: 0,
          toolbarHeight: 80,
          backgroundColor: lighttheme,
          titleTextStyle: appbar_title,
          centerTitle: true,
          //shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25))),
          leading: Padding(
            padding: EdgeInsets.symmetric(
                vertical: defaultVerPadding / 2,
                horizontal: defaultHorPadding / 1.5),
            // back button
            /*
            child: ElevatedButton(
                style: ButtonStyle(
                    //maximumSize: MaterialStatePropertyAll(Size(5, 5)),
                    elevation: MaterialStatePropertyAll(1),
                    shadowColor: MaterialStatePropertyAll(themeColor),
                    side: MaterialStatePropertyAll(BorderSide(
                      width: 1,
                      color: themeColor,
                    )),
                    backgroundColor: MaterialStatePropertyAll(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))))),
                onPressed: () => Navigator.of(context).pop(true),
                child: Icon(
                  Icons.arrow_back,
                  size: 23,
                  color: themeColor,
                ))),
             */
            //leadingWidth: 95,
          )
          /*
    return Scaffold(
      backgroundColor: lighttheme,
      appBar: AppBar(
        //title: Text('Search For Doctor'),
        elevation: 0,
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        titleTextStyle: GoogleFonts.comfortaa(
            textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w500)),
        centerTitle: true,
        title: Text('My Profile'),
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25))),
        leading: Padding(
            padding: EdgeInsets.symmetric(
                vertical: defaultVerPadding / 2,
                horizontal: defaultHorPadding / 1.5),
            child: ElevatedButton(
                style: ButtonStyle(
                    //minimumSize: MaterialStatePropertyAll(Size(60, 60)),
                    elevation: MaterialStatePropertyAll(1),
                    shadowColor: MaterialStatePropertyAll(themeColor),
                    side: MaterialStatePropertyAll(BorderSide(
                      width: 1,
                      color: themeColor,
                    )),
                    backgroundColor: MaterialStatePropertyAll(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))))),
                onPressed: () => Navigator.of(context).pop(true),
                child: Icon(
                  Icons.arrow_back,
                  size: 23,
                  color: themeColor,
                ))),
        leadingWidth: 95,
        */
          /*
                  actions: [
                    Padding(
                    padding: EdgeInsets.symmetric(vertical: defaultVerPadding/2, horizontal: defaultHorPadding/1.5),
                    child: ElevatedButton(
                    style: ButtonStyle(
                      minimumSize: MaterialStatePropertyAll(Size(55,55)),
                      elevation: MaterialStatePropertyAll(1),
                      shadowColor: MaterialStatePropertyAll(themeColor),
                      side: MaterialStatePropertyAll(BorderSide(
                          width: 1,
                          color: themeColor,
                        )),
                      backgroundColor: MaterialStatePropertyAll(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))))
                    ),
                      onPressed: () {
                        setState((){isBookmarked = !isBookmarked;}); // TODO: add/remove doctor from bookmark
                      },
                      child: Icon(isBookmarked? Icons.bookmark: Icons.bookmark_border, size: 23,color: themeColor,)
                    )),
                  ],*/
          ),
      body: getBody(),
      //bottomNavigationBar: getFooter(),
      floatingActionButton: SafeArea(
        child: SizedBox(
            // height: 30,
            // width: 40,
            /*
          child: FloatingActionButton(
            onPressed: () {},
            child: Icon(
              Icons.add,
              size: 20,
            ),
            backgroundColor: buttoncolor,
            // shape:
            //     BeveledRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),*/
            ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget getBody() {
    return IndexedStack(
      index: pageIndex,
      children: pages,
    );
  }

  /*
  Widget getFooter() {
    List<IconData> iconItems = [
      CupertinoIcons.home,
      CupertinoIcons.creditcard,
      CupertinoIcons.money_dollar,
      CupertinoIcons.person,
    ];
    return AnimatedBottomNavigationBar(
        backgroundColor: primary,
        icons: iconItems,
        splashColor: secondary,
        inactiveColor: black.withOpacity(0.5),
        gapLocation: GapLocation.center,
        activeIndex: pageIndex,
        notchSmoothness: NotchSmoothness.softEdge,
        leftCornerRadius: 10,
        iconSize: 25,
        rightCornerRadius: 10,
        elevation: 2,
        onTap: (index) {
          setTabs(index);
        });
  }
  */

  setTabs(index) {
    setState(() {
      pageIndex = index;
    });
  }

/*
    void start() async {
    String uid = getUID();
    Map<String, dynamic>? user = await readFromServer('patient/$uid');
    fullname = user?['first name'] + ' ' + user?['last name'];
  }
  */
}
