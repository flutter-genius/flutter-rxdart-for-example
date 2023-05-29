import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/utils/enumHelpers.dart';
import 'package:hittapa/global_export.dart';

class EventGenderSelector extends StatefulWidget {
  final String selected;
  final Function onTaped;

  EventGenderSelector({this.selected, this.onTaped});

  @override
  _GenderSelectorState createState() => _GenderSelectorState();
}

enum EventGenderType { all_gender, male, female }

class _GenderSelectorState extends State<EventGenderSelector> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 13, bottom: 1),
          child: Text(
            LocaleKeys.global_gender.tr(),
            style: TextStyle(fontSize: 11, color: BORDER_COLOR),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
          child: RadioButtonGroup(
            labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            orientation: GroupedButtonsOrientation.HORIZONTAL,
            activeColor: GOOGLE_COLOR,
            labels: EventGenderType.values.map((g) =>
            "${enumHelper.enum2str(g)[0].toUpperCase()}${enumHelper.enum2str(g).substring(1)}"
            ).toList(),
            picked: widget.selected.length > 0 ? "${widget.selected[0].toUpperCase()}${widget.selected.substring(1)}" : '',
            onSelected: (String value) => widget.onTaped(value.toLowerCase()),
            itemBuilder: (Radio rb, Text txt, int i) {
              return Row(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: rb,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  txt,
                  SizedBox(
                    width: 20,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
