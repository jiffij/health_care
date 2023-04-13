import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_login/searchbar.dart';

import 'color.dart';
import 'doctorCard.dart';

class DoctorSearch extends StatefulWidget {
  const DoctorSearch({
    Key? key
  }) : super(key: key);

  @override
  State<DoctorSearch> createState() => _DoctorSearchState();
}

class _DoctorSearchState extends State<DoctorSearch> {

  final PageController _pageController = PageController(viewportFraction: 0.9);
  double _price = 0;
  List<String> priceRange = [
    "None", 
    "below \$150",
    "\$150 - \$300",
    "\$301 - \$500",
    "\$501 - \$700",
    "above \$700",
  ];

  List<String> categoryRange = [
    "None", 
    
    "Psychiatrist",
    "Pediatrician",
    "Gynecologist",
    "Dermatologist",
    "Otolaryngologist",
    
    "Internal Medicine",
  ];
  int selectedPrice = 0;
  int selectedCategory = 0;
  double exp = 0;
  List<String> expRange = ["0+", "2+", "5+", "10+", "15+", "20+"];
  int selectedExp = 0;
  String selectedGender = "None";


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          title: Text('Search For Doctor'),
          elevation: 0,
          toolbarHeight: 80,
          backgroundColor: Colors.white,
          titleTextStyle: appbar_title,
          centerTitle: true,
          //shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25))),
          leading: Padding(
            padding: EdgeInsets.symmetric(vertical: defaultVerPadding/2, horizontal: defaultHorPadding/1.5),
            child: ElevatedButton(
            style: ButtonStyle(
              elevation: MaterialStatePropertyAll(0),
              side: MaterialStatePropertyAll(BorderSide(
                  width: 1,
                  color: themeColor,
                )),
              backgroundColor: MaterialStatePropertyAll(Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))))
            ),
              onPressed: () => Navigator.of(context).pop(true),
              child: Icon(Icons.arrow_back, size: 23,color: themeColor,)
            )),
          leadingWidth: 95,
        ),
        body: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: defaultHorPadding/1.5, right: defaultHorPadding/1.5, top: defaultVerPadding),
               child: Column(
                children: [ TextFormField(
              style: GoogleFonts.comfortaa(textStyle: const TextStyle(color: Colors.black)),
              cursorColor: themeColor,
              cursorWidth: 1,
              enableSuggestions: true,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 25, horizontal: defaultHorPadding),
                  filled: true,
                  alignLabelWithHint: true,
                  fillColor: Colors.white,
                  hintStyle: GoogleFonts.comfortaa(textStyle: const TextStyle(color: Color.fromARGB(255, 148, 148, 148), fontSize: 15)),
                  // prefixIcon: Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: defaultHorPadding/1.5),
                  //   child: Icon(Icons.search, color: themeColor,size: 30,),
                  // ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.white,
                          enableDrag: true,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30))),
                          builder: (_) => StatefulBuilder(
                                builder: (context, setState) =>
                                    SingleChildScrollView(
                                  padding: EdgeInsets.symmetric(horizontal: defaultHorPadding, vertical: defaultVerPadding),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Text(
                                          "Filters",
                                          style: GoogleFonts.comfortaa(textStyle: TextStyle(
                                              fontSize: 17,
                                              color: themeColor,
                                              fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                      Divider(
                                        indent: 0,
                                        endIndent: 0,
                                        height: 30,
                                        thickness: 1,
                                        color: lighttheme.withOpacity(0.3),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),

                                      Row(
                                        children: [
                                          Text(
                                            "Categories",
                                            style: GoogleFonts.comfortaa(textStyle: TextStyle(
                                                fontSize: 16,
                                                color: greenDark,
                                                fontWeight: FontWeight.w500)),
                                          ),
                                         ],
                                       ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        child: Wrap(
                                          spacing: 10,
                                          runSpacing: 15,
                                          runAlignment: WrapAlignment.start,
                                          alignment: WrapAlignment.start,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.start,
                                          children: List.generate(
                                              categoryRange.length,
                                              (index) => IntrinsicWidth(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        setState(
                                                          () {
                                                            selectedCategory =
                                                                index;
                                                          },
                                                        );
                                                      },
                                                      child: Container(
                                                        height: 30,
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 16),
                                                        decoration: BoxDecoration(
                                                            color: index ==
                                                                    selectedCategory
                                                                ? themeColor
                                                                : bgColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15)),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          categoryRange[index],
                                                          style: GoogleFonts.comfortaa(textStyle: TextStyle(
                                                              color: index ==
                                                                      selectedCategory
                                                                  ? Colors.white
                                                                  : themeColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                        ),
                                      ),
                                      
                                      const Padding(
                                        padding: EdgeInsets.only(bottom: 15),
                                        child: Divider(
                                          color: Color.fromARGB(255, 206, 211, 211),
                                          indent: 0,
                                          endIndent: 0,
                                          height: 1,
                                        ),
                                      ),


                                      Row(
                                        children: [
                                          Text(
                                            "Price",
                                            style: GoogleFonts.comfortaa(textStyle: TextStyle(
                                                fontSize: 16,
                                                color: greenDark,
                                                fontWeight: FontWeight.w500)),
                                          ),
                                         ],
                                       ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        child: Wrap(
                                          spacing: 10,
                                          runSpacing: 15,
                                          runAlignment: WrapAlignment.start,
                                          alignment: WrapAlignment.start,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.start,
                                          children: List.generate(
                                              priceRange.length,
                                              (index) => IntrinsicWidth(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        setState(
                                                          () {
                                                            selectedPrice =
                                                                index;
                                                          },
                                                        );
                                                      },
                                                      child: Container(
                                                        height: 30,
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 16),
                                                        decoration: BoxDecoration(
                                                            color: index ==
                                                                    selectedPrice
                                                                ? themeColor
                                                                : bgColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15)),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          priceRange[index],
                                                          style: GoogleFonts.comfortaa(textStyle: TextStyle(
                                                              color: index ==
                                                                      selectedPrice
                                                                  ? Colors.white
                                                                  : themeColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                        ),
                                      ),
                                      
                                      const Padding(
                                        padding: EdgeInsets.only(bottom: 15),
                                        child: Divider(
                                          color: Color.fromARGB(255, 206, 211, 211),
                                          indent: 0,
                                          endIndent: 0,
                                          height: 1,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Experience",
                                            style: GoogleFonts.comfortaa(textStyle: TextStyle(
                                                fontSize: 16,
                                                color: greenDark,
                                                fontWeight: FontWeight.w500)),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        child: Wrap(
                                          spacing: 6,
                                          runSpacing: 12,
                                          runAlignment: WrapAlignment.start,
                                          alignment: WrapAlignment.start,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.start,
                                          children: List.generate(
                                              expRange.length,
                                              (index) => IntrinsicWidth(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        setState(
                                                          () {
                                                            selectedExp = index;
                                                          },
                                                        );
                                                      },
                                                      child: Container(
                                                          height: 30,
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16),
                                                          decoration: BoxDecoration(
                                                              color: index ==
                                                                      selectedExp
                                                                  ? themeColor
                                                                  : bgColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15)),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            expRange[index],
                                                            style: GoogleFonts.comfortaa(textStyle: TextStyle(
                                                                color: index ==
                                                                        selectedExp
                                                                    ? Colors
                                                                        .white
                                                                    : themeColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                          )),
                                                    ),
                                                  )),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(bottom: 15),
                                        child: Divider(
                                          color: Color.fromARGB(255, 206, 211, 211),
                                          indent: 0,
                                          endIndent: 0,
                                          height: 1,
                                        ),
                                      ),
                                      Text(
                                        "Gender",
                                        style: GoogleFonts.comfortaa(textStyle: TextStyle(
                                            fontSize: 16,
                                            color: greenDark,
                                            fontWeight: FontWeight.w500)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        child: Wrap(
                                          spacing: 6,
                                          runSpacing: 12,
                                          runAlignment: WrapAlignment.start,
                                          alignment: WrapAlignment.start,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.start,
                                          children: [
                                            IntrinsicWidth(
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(
                                                    () {
                                                      selectedGender = "None";
                                                    },
                                                  );
                                                },
                                                child: Container(
                                                    height: 30,
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 32),
                                                    decoration: BoxDecoration(
                                                        color: "None" ==
                                                                selectedGender
                                                            ? themeColor
                                                            : bgColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15)),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "None",
                                                      style: GoogleFonts.comfortaa(textStyle: TextStyle(
                                                          color: "None" ==
                                                                  selectedGender
                                                              ? Colors.white
                                                              : themeColor,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                    )),
                                              ),
                                            ),
                                            IntrinsicWidth(
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(
                                                    () {
                                                      selectedGender = "Male";
                                                    },
                                                  );
                                                },
                                                child: Container(
                                                    height: 30,
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 32),
                                                    decoration: BoxDecoration(
                                                        color: "Male" ==
                                                                selectedGender
                                                            ? themeColor
                                                            : bgColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15)),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "Male",
                                                      style: GoogleFonts.comfortaa(textStyle: TextStyle(
                                                          color: "Male" ==
                                                                  selectedGender
                                                              ? Colors.white
                                                              : themeColor,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                    )),
                                              ),
                                            ),
                                            IntrinsicWidth(
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(
                                                    () {
                                                      selectedGender = "Female";
                                                    },
                                                  );
                                                },
                                                child: Container(
                                                    height: 30,
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 32),
                                                    decoration: BoxDecoration(
                                                        color: "Female" ==
                                                                selectedGender
                                                            ? themeColor
                                                            : bgColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15)),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "Female",
                                                      style: GoogleFonts.comfortaa(textStyle: TextStyle(
                                                          color: "Female" ==
                                                                  selectedGender
                                                              ? Colors.white
                                                              : themeColor,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                    )),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 50,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 7),
                                        child: ElevatedButton(
                                          onPressed: () {},
                                          child: Text(
                                            "Apply Filter",
                                            style: GoogleFonts.comfortaa(textStyle: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 17)),
                                          ),
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      themeColor),
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ))),
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 50,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 7),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              selectedPrice = 0;
                                              selectedExp = 0;
                                              selectedCategory = 0;
                                              selectedGender = "None";
                                            });
                                          },
                                          child: Text(
                                            "Clear All",
                                            style: GoogleFonts.comfortaa(textStyle: TextStyle(
                                                color: themeColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 17)),
                                          ),
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.white),
                                              overlayColor:
                                                  MaterialStateProperty.all(
                                                      greenLight.withOpacity(
                                                          0.2)),
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                      side: BorderSide(
                                                          color: themeColor)))),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ));
                    },
                    child: Padding(padding: EdgeInsets.only(right: defaultHorPadding), child: Icon(Icons.tune, color: themeColor, size: 25,)),
                  ),
                  hintText: "Enter doctor's name",
                  //prefixIconConstraints:
                      //const BoxConstraints(maxHeight: 17, maxWidth: 50),
                  isDense: true,
                  prefixStyle: GoogleFonts.comfortaa(textStyle: TextStyle(color: themeColor)),
                  enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(color: themeColor),
                                            borderRadius:
                                                BorderRadius.all(Radius.circular(30))),
                  focusedBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(color: themeColor),
                                            borderRadius:
                                                BorderRadius.all(Radius.circular(30))),),
            ),
            SizedBox(height: 20,),
                        Expanded(
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: false,
                            primary: true,
                            itemCount: min(5, 12),
                            itemBuilder: (context, index) => DoctorCard(faker: faker),
                          )
                        )
                ],
              )
          )
        )
      )
    );
  }
}