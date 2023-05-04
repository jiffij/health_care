import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:simple_login/helper/loading/loading_popup.dart';
import 'package:simple_login/helper/loading_screen.dart';
import 'package:simple_login/yannie_version/widget/title_with_more_btn.dart';

import '../../helper/firebase_helper.dart';
import '../color.dart';
import '../constant.dart';
import '../doctor.dart';
import '../widget/doctorCard.dart';

class DoctorSearch extends StatefulWidget {
  const DoctorSearch({
    Key? key
  }) : super(key: key);

  @override
  State<DoctorSearch> createState() => _DoctorSearchState();
}

class _DoctorSearchState extends State<DoctorSearch> {
 
  int selectedPrice = 0;
  int selectedSpecialty = 0;
  int selectedExp = 0;
  String selectedGender = "None";
  final TextEditingController _doctorNameController = TextEditingController(text: "");
  bool nameError = false;
  List<List> defaultDoctorList = [];
  List<List> filteredDoctorList = [];
  List<List> sortedDoctorList = [];
  bool ready = false;
  bool searchNull = true;

  @override
  initState() {
    super.initState();
    prepare();
  }

  double getRating() {
    double temp = 0;

    return temp;
  }

  Future<void> prepare() async {
    await start();
    setState(() {ready = true;});
  }

  Future start() async {
    List<String> doctorListId = await getColId('doctor');
    print(doctorListId);
    for (var id in doctorListId)
    {
      Map<String, dynamic>? doctor = await readFromServer('doctor/$id');
      var firstname = doctor?['first name'];
      var lastname = doctor?['last name'];
      var fullname = '$firstname $lastname';
      var url = doctor?['profilePic'];
      var profilePic = await loadStorageUrl(url);
      var title = doctor?['title'];
      var exp = doctor?['exp'];
      var fRating = calRating(doctor?['1'], doctor?['2'], doctor?['3'], doctor?['4'], doctor?['5']);
      defaultDoctorList.insert(0, [fullname, id, profilePic, title, fRating, exp]);
      
    }
    filteredDoctorList = ratingSort(defaultDoctorList);
  }

  //sorting of doctors

  List<List> ratingSort(List<List<dynamic>> mylist) {
    int comparisonIndex = 4;
    List<List<dynamic>> templist = mylist..sort((x, y) => 
    (x[comparisonIndex] as dynamic).compareTo((y[comparisonIndex] as dynamic)));
    templist = List.from(templist.reversed);
    return templist;
  }

  void doctorFilter(String input) {
    filteredDoctorList.clear();
    for (var doctor in defaultDoctorList)
    {
      var fullname = '${doctor[0]}}';
      if ((fullname).toLowerCase().trim().contains(input.toLowerCase().trim()))
      {
        filteredDoctorList.insert(0, doctor);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          title: Text('Doctor List'),
          elevation: 0,
          toolbarHeight: 80,
          backgroundColor: lighttheme,
          titleTextStyle: appbar_title,
          centerTitle: true,
          //shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25))),
          leading: Padding(
            padding: EdgeInsets.symmetric(vertical: defaultVerPadding/2, horizontal: defaultHorPadding/1.5),
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
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))))
            ),
              onPressed: () => Navigator.of(context).pop(true),
              child: Icon(Icons.arrow_back, size: 23,color: themeColor,)
            )),
          leadingWidth: 95,
        ),
        body: SafeArea(
            //child: Padding(
              //padding: EdgeInsets.only(left: defaultHorPadding/2, right: defaultHorPadding/2, top: defaultVerPadding),
               child: ready? Column(
                children: [ 
                  Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: defaultHorPadding, vertical: defaultVerPadding),
                                  child: Form(
                                    onChanged: () {
                                      
                                      setState(() {
                                        
                                        if (_doctorNameController.text.isEmpty) searchNull = true;
                                        else {
                                          searchNull = false;
                                          doctorFilter(_doctorNameController.text);
                                          filteredDoctorList = ratingSort(filteredDoctorList);
                                        }
                                      });
                                    },
                                    child: TextFormField(
                                      controller: _doctorNameController,
                                      style: GoogleFonts.comfortaa(textStyle: TextStyle(color: Colors.black)),
                                      decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.all(Radius.circular(20))),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.all(Radius.circular(20))),
                                        prefixIcon: Icon(
                                          Icons.search,
                                          color: themeColor,
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        labelText: "Enter Doctor's Name",
                                        labelStyle: GoogleFonts.comfortaa(textStyle: TextStyle(color: redOrange)),
                                        hintStyle: GoogleFonts.comfortaa(textStyle: TextStyle(color: redOrange)),
                                        suffixIcon: !searchNull? IconButton(
                                                        onPressed: () {
                                                          _doctorNameController.clear();
                                                          FocusScopeNode currentFocus = FocusScope.of(context);
                                                          if (!currentFocus.hasPrimaryFocus) {
                                                            currentFocus.unfocus();
                                                          }
                                                        },
                                                        icon: Icon(Icons.dangerous_outlined), color: Color.fromARGB(255, 148, 148, 148),iconSize: 25,):null,
                                      ),
                                    ),
                                  ),
                                ),
            TitleWithMoreBtn(title: _doctorNameController.text.isEmpty? "Recommended": "Search for \"" + _doctorNameController.text + "\":", press: (){}, withBtn: false),
            SizedBox(height: 20,),
            
            Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: defaultHorPadding/2),
              child: ShaderMask(
              shaderCallback: (Rect rect) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 183, 176, 184),
                    Colors.transparent,
                    Colors.transparent,
                    Color.fromARGB(255, 208, 191, 211),
                  ],
                  stops: [0.0, 0.04, 0.93, 1.0],
                ).createShader(rect);
              },
              blendMode: BlendMode.dstOut,
              child: ClipRect(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  primary: true,
                  itemCount: searchNull?ratingSort(defaultDoctorList).length : filteredDoctorList.length,
                  itemBuilder: (context, index) => DoctorCard(doctor: searchNull?ratingSort(defaultDoctorList)[index]:filteredDoctorList[index], ctx: context,),
                ),
              ),
            )),
          ),
                        
                ],
              ) : Center(
                child: LoadingAnimationWidget.threeRotatingDots(color: lighttheme, size: 50)
              )
          //)
        )
      )
    );
  }
}
