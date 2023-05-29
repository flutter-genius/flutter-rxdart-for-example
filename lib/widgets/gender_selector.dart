import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/user.dart';
import 'package:hittapa/utils/enumHelpers.dart';
import 'package:hittapa/global_export.dart';

class GenderSelector extends StatefulWidget {
  final String selected;
  final Function onTaped;

  GenderSelector({this.selected, this.onTaped});

  @override
  _GenderSelectorState createState() => _GenderSelectorState();
}

class _GenderSelectorState extends State<GenderSelector> {

  

  List<String> _labels =  [];
  // ignore: non_constant_identifier_names
  List<String> _labels_two =  [];
  
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    for(int i=0; i<GenderType.values.length; i++) {
      if(i%2==0) _labels.add(enumHelper.enum2str(GenderType.values[i])[0].toUpperCase() + enumHelper.enum2str(GenderType.values[i]).substring(1));
      else _labels_two.add(enumHelper.enum2str(GenderType.values[i])[0].toUpperCase() + enumHelper.enum2str(GenderType.values[i]).substring(1));
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
            style: TextStyle(fontSize: 17, color: BORDER_COLOR, fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RadioButtonGroup(
                labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                activeColor: GOOGLE_COLOR,
                labels: _labels,
                picked: widget.selected.length > 0 ? "${widget.selected[0].toUpperCase()}${widget.selected.substring(1)}" : '',
                onSelected: (String value) => widget.onTaped(value.toLowerCase()),
                itemBuilder: (Radio rb, Text txt, int i) {
                  return Container(
                    width: 150,
                    padding: EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: rb,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        InkWell(
                          child: Container(
                            child: txt,
                          ),
                          onTap: () => widget.onTaped(enumHelper.enum2str(GenderType.values[i*2])),
                        ),
                      ],
                    ),
                  );
                },
              ),
              RadioButtonGroup(
                labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                // orientation: GroupedButtonsOrientation.HORIZONTAL,
                activeColor: GOOGLE_COLOR,
                labels: _labels_two,
                picked: widget.selected.length > 0 ? "${widget.selected[0].toUpperCase()}${widget.selected.substring(1)}" : '',
                onSelected: (String value) => widget.onTaped(value.toLowerCase()),
                itemBuilder: (Radio rb, Text txt, int i) {
                  return Container(
                    width: 150,
                    padding: EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: rb,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        InkWell(
                          child: Container(
                            child: txt,
                          ),
                          onTap: () => widget.onTaped(enumHelper.enum2str(GenderType.values[i*2+1])),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],)
        ),
      ],
    );
  }
}
