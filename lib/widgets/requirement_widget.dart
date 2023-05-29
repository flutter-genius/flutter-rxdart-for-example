import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hittapa/models/post_requirement.dart';

import '../global.dart';
import 'package:hittapa/global_export.dart';

// ignore: must_be_immutable
class RequirementWidget extends StatelessWidget {
  final List<PostRequirement> list;
  final Function onRequirement;
  bool isAccepted;

  RequirementWidget(this.list, this.onRequirement, this.isAccepted);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            generateDrivingCell(list),
            generateChildrenCell(list),
            generateTempoCell(list)
          ],
        ),
      ),
    );
  }

  generateGenderAndAgeCell(List<PostRequirement> list2) {
    PostRequirement _gender;
    PostRequirement _age;
    list?.forEach((element) {
      if (element.requirementId == 1) _gender = element;
      if (element.requirementId == 2) _age = element;
    });
    if (_gender == null && _age == null) {
      return Container();
    }
    print(_age.toMap());
    return InkWell(
      onTap: (){
        onRequirement();
      },
      child: Container(
        margin: EdgeInsets.only(right: 5),
        child: Column(
          children: <Widget>[
            Text(
              LocaleKeys.event_detail_age_range.tr(),
              style: TextStyle(
                  color: BORDER_COLOR, fontWeight: FontWeight.w600, fontSize: 14),
            ),
            SizedBox(
              height: 3,
            ),
            Row(
              children: <Widget>[
                SvgPicture.asset(
                  'assets/group_icon.svg',
                  color: BORDER_COLOR,
                  width: 21,
                  height: 20,
                ),
                SizedBox(
                  width: 3,
                ),
                Text(
                  '${_gender?.value != null ? '${_gender.value[0].toUpperCase()}${_gender.value.substring(1)}' ?? 'Both' : ''} ${_age != null ?
                  '${_age.value ?? '18'}-${int.parse(_age.other ?? '66') < 64 ? _age.other : (_age.other ?? '65') + '+'}' : ''}',
                  style: TextStyle(
                      color: NAVIGATION_NORMAL_TEXT_COLOR,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                )
              ],
            )
          ],
        ),
      )
    );
  }

  generateLanguageCell(List<PostRequirement> list) {
    PostRequirement _language;
    list?.forEach((element) {
      if (element.requirementId == 3) _language = element;
    });
    if (_language == null) {
      return Container();
    }
    return InkWell(
      onTap: (){
        onRequirement();
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              LocaleKeys.global_language.tr(),
              style: TextStyle(
                  color: BORDER_COLOR, fontWeight: FontWeight.w600, fontSize: 11),
            ),
            SizedBox(
              height: 4,
            ),
            Stack(
              children: <Widget>[
                SvgPicture.asset(
                  'assets/language_container.svg',
                  color: BORDER_COLOR,
                  fit: BoxFit.fill,
                  width: 30,
                ),
                Positioned(
                  top: 2,
                  left: 7,
                  child: Text(
                    _language.value != null ? _language.value.toUpperCase() : 'En',
                    style: TextStyle(
                        color: NAVIGATION_NORMAL_TEXT_COLOR,
                        fontSize: 11,
                        fontWeight: FontWeight.w600),
                  ),
                )
              ],
            )
          ],
        ),
      )
    );
  }

  generateDrivingCell(List<PostRequirement> list) {
    PostRequirement _driving;
    list?.forEach((element) {
      if (element.requirementId == 8) _driving = element;
    });
    if (_driving == null) return Container();
    print(_driving.value);
    return InkWell(
      onTap: (){
        onRequirement();
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Driver license",
              style: TextStyle(
                  color: BORDER_COLOR, fontWeight: FontWeight.w600, fontSize: 14),
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SvgPicture.asset(
                  'assets/driving_licence.svg',
                  color: BORDER_COLOR,
                  width: 30,
                ),
                SizedBox(width: 5,),
                Text(
                  _driving.value != null ? _driving.value.replaceAll('Cat.', '') :
                  'A1',
                  style: TextStyle(
                      color: NAVIGATION_NORMAL_TEXT_COLOR,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ],
            )
          ],
        ),
      )
    );
  }

  generateChildrenCell(List<PostRequirement> list) {
    PostRequirement _children;
    list?.forEach((element) {
      if (element.requirementId == 9) _children = element;
    });
    if (_children == null) return Container();
    return InkWell(
      onTap: (){
        onRequirement();
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              LocaleKeys.event_detail_children_age.tr(),
              style: TextStyle(
                  color: BORDER_COLOR, fontWeight: FontWeight.w600, fontSize: 14),
            ),
            SizedBox(
              height: 3,
            ),
            Row(
              children: <Widget>[
                InkWell(
                  onTap: (){

                  },
                  child: SvgPicture.asset(
                    'assets/svg/warning.svg',
                    width: 20,
                    color: GRADIENT_COLOR_ONE,
                  ),
                ),
                SizedBox(
                  width: 3,
                ),
                SvgPicture.asset(
                  'assets/has_child_icon.svg',
                  color: BORDER_COLOR,
                ),
                SizedBox(
                  width: 3,
                ),
                Text(
                  '${_children.value} - ${_children.other}',
                  style: TextStyle(
                      color: NAVIGATION_NORMAL_TEXT_COLOR,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                )
              ],
            )
          ],
        ),
      )
    );
  }

  generateTempoCell(List<PostRequirement> list) {
    PostRequirement _tempo;
    list?.forEach((element) {
      if (element.requirementId == 7) _tempo = element;
    });
    if (_tempo == null) return Container();
    return InkWell(
      onTap: (){
        onRequirement();
      },
      child: Container(
        margin: EdgeInsets.only(left: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            isAccepted ? Container() : Text(
              LocaleKeys.global_tempo.tr(),
              style: TextStyle(
                  color: BORDER_COLOR, fontWeight: FontWeight.w600, fontSize: 14),
            ),
            isAccepted ? Container() : SizedBox(
              height: 3,
            ),
            Row(
              children: <Widget>[
                SvgPicture.asset(
                  'assets/tempo_icon.svg',
                  color: BORDER_COLOR,
                ),
                SizedBox(
                  width: 3,
                ),
                Text(
                  _tempo.value,
                  style: TextStyle(
                      color: NAVIGATION_NORMAL_TEXT_COLOR,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                )
              ],
            )
          ],
        ),
      )
    );
  }
}
