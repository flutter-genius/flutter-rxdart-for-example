import 'package:flutter/material.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/location_category.dart';
import 'package:hittapa/services/node_service.dart';
import 'package:hittapa/widgets/round_button.dart';
import 'package:hittapa/global_export.dart';

class LocationEventCategoryPicker extends StatefulWidget {
  final List<LocationCategoryModel> selectedCategories;
  final Function onItemChecked;

  LocationEventCategoryPicker(
      {@required this.selectedCategories, @required this.onItemChecked});

  @override
  _LocationCategoryPickerState createState() => _LocationCategoryPickerState();
}

class _LocationCategoryPickerState extends State<LocationEventCategoryPicker> {
  List<LocationCategoryModel> _selectedCategories = [];
  List<LocationCategoryModel> _categories = [];

  _loadData() async {
    var _result = await NodeService().getLocationCategories();
    if(_result != null && _result['data']!= null && _result['data'].length > 0 ) {
      _categories = _result['data'].map((e) => LocationCategoryModel.fromJson(e)).toList();
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _selectedCategories = widget.selectedCategories;
    _loadData();
//    Firestore.instance.collection(FB.LOCATION_CATEGORIES_COLLECTION)
//        .snapshots().listen((event) {
//          _categories = event.documents.map((e) => LocationCategoryModel.fromFB(e)).toList();
//    });
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
                  children: <Widget>[
                    Expanded(child: SizedBox(),),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _categories.map((e) => Container(
                        margin: EdgeInsets.symmetric(vertical: 7),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              child: Checkbox(
                                value: isCheckedItem(e),
                                onChanged: (value) {
                                  if (isCheckedItem(e)) {
                                    setState(() {
                                      _selectedCategories.removeAt(
                                          _selectedCategories.indexOf(e));
                                    });
                                  } else {
                                    setState(() {
                                      _selectedCategories.add(e);
                                    });
                                  }
                                },
                                activeColor: BORDER_COLOR,
                                checkColor: Colors.white,
                                hoverColor: GRAY_COLOR,
//                                      materialTapTargetSize: materialTapTargetSize,
                              ),
                              height: 19,
                              width: 19,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            GestureDetector(
                              child: Text(
                                e.name,
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: NAVIGATION_NORMAL_TEXT_COLOR),
                              ),
                              onTap: () {
                                if (isCheckedItem(e)) {
                                  setState(() {
                                    _selectedCategories.removeAt(
                                        _selectedCategories.indexOf(e));
                                  });
                                } else {
                                  setState(() {
                                    _selectedCategories.add(e);
                                  });
                                }
                              },
                            )
                          ],
                        ),
                      )).toList(),
                    ),
                    Expanded(child: SizedBox(),),
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
                      text: LocaleKeys.global_save.tr().toUpperCase(),
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

  isCheckedItem(LocationCategoryModel item) {
    return _selectedCategories.indexOf(item) >= 0;
  }
}
