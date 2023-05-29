import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/user.dart';
import 'package:hittapa/utils/enumHelpers.dart';
import 'package:hittapa/global_export.dart';

class AuthGenderSelector extends StatefulWidget {
  final String selected;
  final Function onTaped;

  AuthGenderSelector({this.selected, this.onTaped});

  @override
  _AuthGenderSelectorState createState() => _AuthGenderSelectorState();
}

class _AuthGenderSelectorState extends State<AuthGenderSelector> {

  

  List<String> _labels =  [];
  
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    for(int i=0; i<GenderType.values.length; i++) {
      if(GenderType.values[i] != GenderType.all_gender) {
        _labels.add(enumHelper.enum2str(GenderType.values[i])[0].toUpperCase() + enumHelper.enum2str(GenderType.values[i]).substring(1));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 13, bottom: 1),
          child: Text(
            LocaleKeys.create_account_select_gender.tr(),
            style: TextStyle(fontSize: 13, color: BORDER_COLOR, fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 1),
          child: RadioButtonGroup(
            labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            orientation: GroupedButtonsOrientation.HORIZONTAL,
            activeColor: GOOGLE_COLOR,
            labels: _labels,
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
                  GestureDetector(
                    child: txt,
                    onTap: () => widget.onTaped(enumHelper.enum2str(GenderType.values[i])),
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
