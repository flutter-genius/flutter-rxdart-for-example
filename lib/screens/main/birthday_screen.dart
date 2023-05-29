import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hittapa/config.dart';
import 'package:hittapa/widgets/cupertino_date_picker.dart';
import 'package:hittapa/widgets/round_gradient_button.dart';

import 'package:hittapa/global.dart';

class BirthDayScreen extends StatefulWidget {
  final DateTime birthday;
  BirthDayScreen({this.birthday});
  @override
  _BirthDayScreenState createState() => _BirthDayScreenState();
}

class _BirthDayScreenState extends State<BirthDayScreen> {
  String _year= '', _month='', _day='';
  List monthList = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  bool _isDisable = true;

  @override
  void initState() {
    super.initState();
    if (widget.birthday != null) {
      _year = widget.birthday.year.toString();
      _month = monthList[widget.birthday.month - 1];
      _day = widget.birthday.day.toString();
      if (_day.length == 1) _day = "0" + _day;
      _checkButtonState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CARD_BACKGROUND_COLOR,   
      body: Container(
        padding: EdgeInsets.only(top: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 48,
              margin: EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: BACKGROUND_COLOR,
                borderRadius: BorderRadius.all(Radius.circular(16)),
                boxShadow: [
                  BoxShadow(
                    color: GRAY_COLOR,
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0,3)
                  )
                ]
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: SvgPicture.asset('assets/svg/close.svg'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Container(
                    child: Text(
                      "Select date of birth",
                      style: TextStyle(
                        color: NAVIGATION_NORMAL_TEXT_COLOR,
                        fontSize: 18,
                        fontWeight: FontWeight.w400
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 50,
                  )
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Text(
                    "Selected date of birth",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 14),
                    width: 140,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: BACKGROUND_COLOR,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Text(
                      "$_day $_month  $_year",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400
                      ),
                    ),
                  ),
                  Container(
                    height: 48,
                    width: 300,
                    child: HittapaRoundGradientButton(
                      isDisable: _isDisable,
                      onClick: (){
                        var data = DateTime(int.parse(_year), monthList.indexOf(_month) + 1, int.parse(_day));
                        Navigator.of(context).pop(data);
                      },
                      text: "SAVE THE SHOOSED DATE",
                      startColor: LIGHTBLUE_BUTTON_COLOR,
                      endColor: LIGHTBLUE_BUTTON_COLOR,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 24, horizontal: 14),
                    margin: EdgeInsets.only(top: 20),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: GRAY_COLOR, width: 2))
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HittapaCupertinoDatePicker(
                          dateType: HittapaDateType.year,
                          minValue: 1930,
                          maxValue: DateTime.now().year - MINIMAL_USER_AGE,
                          value: _year,
                          title: 'Year',
                          isSelected: _year != '',
                          isTitled: true,
                          onChange: (value) {
                            _checkButtonState();
                            setState(() {
                              _year = value;
                            });
                          }
                        ),
                        HittapaCupertinoDatePicker(
                          dateType: HittapaDateType.month,
                          value: _month,
                          title: 'Month',
                          isSelected: _month != '',
                          isTitled: true,
                          onChange: (value) {
                            _checkButtonState();
                            setState(() {
                              _month = value;
                            });
                          }
                        ),
                        HittapaCupertinoDatePicker(
                          dateType: HittapaDateType.date,
                          value: _day,
                          title: 'Day',
                          isSelected: _day != '',
                          isTitled: true,
                          onChange: (value) {
                            _checkButtonState();
                            setState(() {
                              _day = value;
                            });
                          }
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _checkButtonState(){
    if (_day != '' && _month != '' && _year != '') {
      setState(() {
        _isDisable = false;
      });
    } else {
      setState(() {
        _isDisable = true;
      });
    }
  }
}