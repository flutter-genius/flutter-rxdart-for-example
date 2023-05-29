import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/location_requirement.dart';
import 'package:hittapa/widgets/age_slider.dart';
import 'package:hittapa/widgets/round_button.dart';
import 'package:hittapa/global_export.dart';

class LocationCategoryPicker extends StatefulWidget {
  final List<LocationRequirement> selectedCategories;
  final Function onItemChecked;

  LocationCategoryPicker(
      {@required this.selectedCategories, @required this.onItemChecked});

  @override
  _LocationCategoryPickerState createState() => _LocationCategoryPickerState();
}

class _LocationCategoryPickerState extends State<LocationCategoryPicker> {
  List<LocationRequirement> _selectedCategories = [];
  List<String> _categories = [LocaleKeys.global_indoor.tr(), LocaleKeys.global_outdoor.tr(), LocaleKeys.global_free_cost.tr(), LocaleKeys.global_food.tr(), LocaleKeys.global_bevarages.tr(), LocaleKeys.global_age_range.tr(), LocaleKeys.global_booking.tr(), LocaleKeys.global_sleep_over.tr(), LocaleKeys.global_wifi.tr(), LocaleKeys.global_lorem_a.tr(), LocaleKeys.global_lorem_b.tr(), LocaleKeys.global_lorem_c.tr()];
  bool _isRangeShow = false;
  String _ageRange = LocaleKeys.global_age_range.tr();
  int _lowAge = 0, _upAge = 0;

  @override
  void initState() {
    super.initState();
    _selectedCategories = widget.selectedCategories;
    if(isCheckedItem(_ageRange)) _isRangeShow = true;
    for(int i=0; i<_selectedCategories.length; i++){
      if(_selectedCategories[i].description==_ageRange) {
        _lowAge = int.parse(_selectedCategories[i].value);
        _upAge = int.parse(_selectedCategories[i].other);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: const Color(0xFF696969),
              spreadRadius: -5,
              blurRadius: 14,
            ),
          ],
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(40), topLeft: Radius.circular(40)),
          color: Colors.white),
      child: Center(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 14, bottom: 17),
              width: 45,
              height: 6,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                  color: CIRCLE_AVATAR_COLOR),
            ),
            Text(
              LocaleKeys.widget_select_type_categories.tr(),
              style: TextStyle(
                  fontSize: 17,
                  color: NAVIGATION_NORMAL_TEXT_COLOR,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 30,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _categories.map((e) => Container(
                        margin: EdgeInsets.symmetric(vertical: 7),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: <Widget>[
                                SizedBox(
                                  child: Checkbox(
                                    value: isCheckedItem(e),
                                    onChanged: (value) {
                                      if (isCheckedItem(e)) {
                                        setState(() {
                                          if(_ageRange==e) _isRangeShow = false;
                                          _selectedCategories.removeWhere((element) => element.description==e);
                                        });
                                      } else {
                                        setState(() {
                                          LocationRequirement _locationRequriement = new LocationRequirement();
                                          _locationRequriement.description = e;
                                          _locationRequriement.requirementId = (_categories.indexOf(e)).toString();
                                          if(_ageRange==e) {
                                            _isRangeShow = true;
                                            _locationRequriement.value = '18';
                                            _locationRequriement.other = '65';
                                          }

                                          _selectedCategories.add(_locationRequriement);
                                        });
                                      }
                                    },
                                    activeColor: BORDER_COLOR,
                                    checkColor: Colors.white,
                                    hoverColor: GRAY_COLOR,
                                  ),
                                  height: 19,
                                  width: 19,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(e, style: TextStyle(fontSize: 14, color: Colors.black),),
                              ],
                            ),
                            _isRangeShow && e==_ageRange
                                ? Container(
                              width: MediaQuery.of(context).size.width-60,
                              padding: EdgeInsets.only(top: 10),
                              child: AgeSlider(
                                text: LocaleKeys.event_detail_age_range.tr() + ' ('+ LocaleKeys.global_from.tr() +' 18 '+ LocaleKeys.global_to.tr() +' 65)',
                                min: 18,
                                max: 65,
                                ageRangeEnd: _upAge==0 ? 65 : _upAge,
                                ageRangeStart: _lowAge==0 ? 18 : _lowAge,
                                onChange: (double newLowerValue, double newUpperValue) {
                                  for(int i=0; i<_selectedCategories.length; i++){
                                    if(_selectedCategories[i].description == e) {
                                      _selectedCategories[i].value = newLowerValue.toInt().toString();
                                      _selectedCategories[i].other = newUpperValue.toInt().toString();
                                    }
                                  }
                                },
                              ),
                            )
                                : Container()
                          ],
                        ),
                      )).toList(),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: HittapaRoundButton(
                      text: LocaleKeys.global_discard.tr().toUpperCase(),
                      isNormal: true,
                      onClick: () => Navigator.of(context).pop(),
                    ),
                  ),
                  Expanded(
                    child: HittapaRoundButton(
                      text: LocaleKeys.global_cancel.tr().toUpperCase(),
                      onClick: () {
                        widget.onItemChecked(_selectedCategories);
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                ],
              ),
              margin: EdgeInsets.only(bottom: 10, right: 15, left: 15),
            )
          ],
        ),
      ),
    );
  }

  isCheckedItem(String item) {
    var contain = _selectedCategories.where((element) => element.description == item);
    if (contain.isEmpty)
      return false;
    //value not exists
    else
      //value exists
      return true;
  }
}
