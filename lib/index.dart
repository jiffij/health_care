import 'dart:math';

import 'package:badges/badges.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'color.dart';

import 'doctorCard.dart';

class IndexScreen extends StatefulWidget {
  const IndexScreen({Key? key}) : super(key: key);

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  Faker faker = Faker();
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
    return Scaffold(body: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 35,
          ),
          
          SizedBox(
            width: size.width * 0.9,
            child: TextFormField(
              style: GoogleFonts.comfortaa(textStyle: const TextStyle(color: Colors.black)),
              cursorColor: greenMed,
              enableSuggestions: true,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                  filled: true,
                  alignLabelWithHint: true,
                  fillColor: Colors.white,
                  hintStyle: GoogleFonts.comfortaa(textStyle: const TextStyle(color: Color.fromARGB(255, 148, 148, 148))),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Icon(Icons.search, color: themeColor,),
                  ),
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
                    child: Icon(Icons.tune, color: themeColor),
                  ),
                  hintText: "Search for doctor",
                  prefixIconConstraints:
                      const BoxConstraints(maxHeight: 17, maxWidth: 50),
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
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
          ),
          
          ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: min(10, 12),
            itemBuilder: (context, index) => DoctorCard(faker: faker),
          )
        ],
      ),
    ));
  }
}