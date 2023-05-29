import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/global_export.dart';

class DriverLicenseSelector extends StatefulWidget {
  final String selected;
  final Function onTaped;

  DriverLicenseSelector({this.selected, this.onTaped});

  @override
  _DriverLicenseSelectorState createState() => _DriverLicenseSelectorState();
}

class _DriverLicenseSelectorState extends State<DriverLicenseSelector> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 13, bottom: 1),
          child: Text(
            LocaleKeys.widget_driving_license.tr(),
            style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.w600, color: BORDER_COLOR),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width - 40,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
          child: RadioButtonGroup(
            labelStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            orientation: GroupedButtonsOrientation.HORIZONTAL,
            activeColor: GOOGLE_COLOR,
            labels: driverLisence,
            picked: widget.selected,
            onSelected: (String value) => widget.onTaped(value),
            itemBuilder: (Radio rb, Text txt, int i) {
              return Expanded(
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: rb,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    GestureDetector(
                      child: txt,
                      onTap: () => widget.onTaped(driverLisence[i]),
                    ),
                    Expanded(child: SizedBox(),)
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
