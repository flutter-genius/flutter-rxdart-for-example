import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/global_export.dart';

class TempoSelector extends StatefulWidget {
  final String selected;
  final Function onTaped;

  TempoSelector({this.selected, this.onTaped});

  @override
  _TempoSelectorState createState() => _TempoSelectorState();
}

class _TempoSelectorState extends State<TempoSelector> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 13, bottom: 1),
          child: Text(
            LocaleKeys.global_tempo.tr(),
            style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.w600, color: BORDER_COLOR),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
          child: RadioButtonGroup(
            labelStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            orientation: GroupedButtonsOrientation.HORIZONTAL,
            activeColor: GOOGLE_COLOR,
            labels: tempos,
            picked: widget.selected,
            onSelected: (String value) => widget.onTaped(value),
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
                  GestureDetector(
                    child: txt,
                    onTap: () => widget.onTaped(tempos[i]),
                  ),
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
