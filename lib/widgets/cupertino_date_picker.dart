

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hittapa/global.dart';

enum HittapaDateType { year, month, date, hour, minute }

class HittapaCupertinoDatePicker extends StatefulWidget {
  final HittapaDateType dateType;
  final String value;
  final String title;
  final Function onChange;
  final bool isSelected;
  final bool isTitled;
  final int maxValue;
  final int minValue;

  HittapaCupertinoDatePicker({
    this.dateType,
    this.value = '',
    this.title = '',
    this.isSelected = false,
    this.onChange,
    this.isTitled = true,
    this.maxValue = 0,
    this.minValue = 0,
  });
  
  @override
  _HittapaCupertinoDatePickerState createState() => _HittapaCupertinoDatePickerState();
}

class _HittapaCupertinoDatePickerState extends State<HittapaCupertinoDatePicker> {
  List<String> _items = [];
  List hittapaDateLists = [
    ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31'],
    ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
    [
      '2021', '2022', '2023', '2024', '2025', '2026', '2027', '2028', '2029', '2030',
      '2031', '2032', '2033', '2034', '2035', '2036', '2037', '2038', '2039', '2040',
      '2041', '2042', '2043', '2044', '2045', '2046', '2047', '2048', '2049', '2050',
      '2051', '2052', '2053', '2054', '2055', '2056', '2057', '2058', '2059', '2060',
      '2061', '2062', '2063', '2064', '2065', '2066', '2067', '2068', '2069', '2070',
      '2071', '2072', '2073', '2074', '2075', '2076', '2077', '2078', '2079', '2080',
      '2081', '2082', '2083', '2084', '2085', '2086', '2087', '2088', '2089', '2090',
      '2091', '2092', '2093', '2094', '2095', '2096', '2097', '2098', '2099', '2100',
    ],
    ['00', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23'],
    [
      '00', '01', '02', '03', '04', '05', '06', '07', '08', '09', 
      '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', 
      '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', 
      '30', '31', '32', '33', '34', '35', '36', '37', '38', '39', 
      '40', '41', '42', '43', '44', '45', '46', '47', '48', '49', 
      '50', '51', '52', '53', '54', '55', '56', '57', '58', '59',
    ],
  ];
  FixedExtentScrollController scrollController;
  bool _isSelected;

  @override
  void initState() {
    super.initState();
    _items = _getLists();
    int _index = 0;
    _isSelected = widget.isSelected;
    if (widget.value != '') {
      _index = _items.indexOf(widget.value);
    }
    if (widget.maxValue != 0) {
      _index = _items.indexOf(widget.maxValue.toString());
    }
    scrollController = FixedExtentScrollController(initialItem: _index);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  List _getLists() {
    List<String> _mLists = hittapaDateLists[0];
    if (widget.dateType == HittapaDateType.month) _mLists = hittapaDateLists[1];
    if (widget.dateType == HittapaDateType.year) _mLists = hittapaDateLists[2];
    if (widget.dateType == HittapaDateType.hour) _mLists = hittapaDateLists[3];
    if (widget.dateType == HittapaDateType.minute) _mLists = hittapaDateLists[4];
    if (widget.maxValue != 0) {
      _mLists = [];
      for (var i = widget.minValue; i <= widget.maxValue; i++) {
        _mLists.add(i.toString());
      }
    }
    return _mLists;
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      child: Column(
        children: [
          widget.title != '' && widget.isTitled ? Text(
            widget.title,
            style: TextStyle(
              color: TITLE_TEXT_COLOR,
              fontWeight: FontWeight.w600,
              fontSize: 16
            ),
          ) : Container(),
          Container(
            width: 80,
            height: 140,
            child: Stack(
              children: [
                SizedBox(
                  height: 140,
                  width: 80,
                  child: CupertinoPicker(
                    scrollController: scrollController,
                    looping: HittapaDateType.year == widget.dateType ? false : true,
                    children: _items.map((e) => Center(
                      child: Text(
                        e,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    )).toList(),
                    onSelectedItemChanged: (value) {
                      setState(() {
                        _isSelected = true;
                      });
                      String _value = '';
                      _value = _items[value];
                      widget.onChange(_value);
                    },
                    itemExtent: 40,
                  ),
                ),
                _isSelected ? Container() : Positioned(
                  top: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                    width: 70,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 5, color: GRAY_COLOR),
                        bottom: BorderSide(width: 5, color: GRAY_COLOR),
                      ),
                      color: Colors.grey[100],
                    ),
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        color: HINT_COLOR,
                        fontWeight: FontWeight.w700,
                        fontSize: 16
                      ),
                    ),
                  ),
                  )
                ),    
              ],
            ),
          ),
        ],
      )
    );
  }
}