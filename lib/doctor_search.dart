import 'package:flutter/material.dart';
import 'package:simple_login/searchbar.dart';

import 'color.dart';

class DoctorSearch extends StatefulWidget {
  const DoctorSearch({
    Key? key
  }) : super(key: key);

  @override
  State<DoctorSearch> createState() => _DoctorSearchState();
}

class _DoctorSearchState extends State<DoctorSearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('Search For Doctor'),
        elevation: 0,
        backgroundColor: Colors.white,
        titleTextStyle: appbar_title,
        centerTitle: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(36), bottomRight: Radius.circular(36))),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultHorPadding, vertical: defaultVerPadding),
          child: Column(
            children: [
              const SearchBar(),
            ],
          )
        )
      ),
    );
  }
}