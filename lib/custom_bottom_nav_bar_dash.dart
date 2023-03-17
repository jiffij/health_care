import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'color.dart';

class CustomBottomNavBarDash extends StatefulWidget {
  final int defaultSelectedIndex;
  final Function(int) onChange;
  final List<IconData> iconList;
  final List<String> textList;
  final Color backgroundColor;
  final Color selectedColor;
  final Color unselectedColor;
  final double radius;
  final double sizeIcon;
  final bool showLabel;

  CustomBottomNavBarDash({
    this.defaultSelectedIndex = 0,
    required this.onChange,
    required this.iconList,
    required this.textList,
    this.backgroundColor = Colors.white,
    this.selectedColor = themeColor,
    this.unselectedColor = Colors.grey,
    this.radius = 0.0,
    this.sizeIcon = 24,
    this.showLabel = true,
  });

  @override
  _CustomBottomNavBarDashState createState() => _CustomBottomNavBarDashState();
}

class _CustomBottomNavBarDashState extends State<CustomBottomNavBarDash> {
  int _selectedIndex = 0;
  List<IconData> _iconList = [];
  List<String> _textList = [];

  void updateBottomNavBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.defaultSelectedIndex;
    _iconList = widget.iconList;
    _textList = widget.textList;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _navBarItemList = [];

    for (var i = 0; i < _iconList.length; i++) {
      _navBarItemList.add(buildNavBarItem(_iconList[i], i, _textList[i]));
    }

    return Container(
      decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(widget.radius),
              topRight: Radius.circular(widget.radius))),
      child: Row(
        children: _navBarItemList,
      ),
    );
  }

  Widget buildNavBarItem(IconData icon, int index, String text) {
    return GestureDetector(
      onTap: () {
        widget.onChange(index);
        _selectedIndex = index;
      },
      child: Container(
        decoration: BoxDecoration(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / _iconList.length,
              padding: const EdgeInsets.only(bottom: 6, top: 16),
              child: Icon(
                icon,
                size: widget.sizeIcon,
                color: _selectedIndex == index
                    ? widget.selectedColor
                    : widget.unselectedColor,
              ),
            ),
            Visibility(
              visible: widget.showLabel,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  '$text',
                  style: GoogleFonts.comfortaa(textStyle: TextStyle(
                      height: 0,
                      fontSize: 10,
                      color: _selectedIndex == index
                          ? widget.selectedColor
                          : widget.unselectedColor)),
                ),
              ),
            ),
            _selectedIndex == index
                ? selectedIndicator()
                : unselectedIndicator(),
          ],
        ),
      ),
    );
  }

  Widget selectedIndicator() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      width: 40,
      height: 4,
      margin: const EdgeInsets.only(top: 3),
      decoration: BoxDecoration(
          color: widget.selectedColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          )),
    );
  }

  Widget unselectedIndicator() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      width: 40,
      height: 0,
      margin: const EdgeInsets.only(top: 7),
      color: Colors.transparent,
    );
  }
}