
import 'package:flutter/material.dart';
import 'package:hittapa/global.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:language_pickers/language.dart';
import 'package:hittapa/widgets/hittapa_outline.dart';

// ignore: must_be_immutable
class LanguageNewPicker extends StatefulWidget {
  List<dynamic> defaultLanguages;
  List<String> recentLanguages;
  final ValueChanged<Language> onValuePicked;
  LanguageNewPicker({this.defaultLanguages, this.recentLanguages, this.onValuePicked});
  @override
  _LanguageNewPickerState createState() => _LanguageNewPickerState();
}

class _LanguageNewPickerState extends State<LanguageNewPicker>{

  List<Language> _allLanguages = [];
  List<Language> _recentLanguages = [];
  List<Language> _defaultLanguages = [];
 
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
     List languageList = widget.defaultLanguages;
    languageList?.forEach((item) => _allLanguages.add(Language.fromMap(item)));
    languageList = widget.recentLanguages;
    languageList?.forEach((item) {
      _allLanguages.forEach((element) { 
        if (element.isoCode == item) {
          _recentLanguages.add(element);
        }
      });
     });
    _defaultLanguages = _allLanguages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BACKGROUND_COLOR,
      appBar: AppBar(
        leading: IconButton(
          icon: SvgPicture.asset('assets/svg/close.svg'),
          onPressed: () => Navigator.of(context).pop(),),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        backgroundColor: Colors.white,
        title: Text("Select Language", style: TextStyle(
          color: TITLE_TEXT_COLOR,
          fontWeight: FontWeight.w600,
          fontSize: 21),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            HittapaOutline(
              child: TextFormField(
                keyboardType: TextInputType.text,
                style: TextStyle(
                    fontSize: 15, color: BORDER_COLOR),
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                      color: HINT_COLOR, fontSize: 15),
                  hintText: 'Type to search for language',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 15),
                  suffixIcon: Icon(Icons.search, size: 25, color: BORDER_COLOR),
                ),
                onChanged: (value){
                  print(value);
                  List<Language> _searchResult = [];
                  _defaultLanguages.forEach((element) {
                    if(element.name.toLowerCase().contains(value.toLowerCase())) {
                      _searchResult.add(element);
                    }
                   });
                  setState(() {
                    _allLanguages = _searchResult;
                  });
                },
                onSaved: (value) {},
              ),
            ),
             _recentWidget(),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.only(bottom:5),
              width: MediaQuery.of(context).size.width-30,
              child: Text('All', style: TextStyle(color: DART_TEXT_COLOR, fontSize:16)),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 2, color: BORDER_COLOR),)
              )
            ),
            _languageLists()
          ]
        )
      ),
    );
  }

  Widget _recentWidget() {
    if (_recentLanguages.length == 0) return Container();
    return Container(
      child:Column(
        children:[
          Container(
            padding: EdgeInsets.only(bottom:5, top: 20),
            width: MediaQuery.of(context).size.width-30,
            child: Row(
              children:[
                Text('Recent used language', style: TextStyle(color: DART_TEXT_COLOR, fontSize:16)),
                SizedBox(width: 10),
                SvgPicture.asset('assets/time_outline.svg')
              ]
            ),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(width: 2, color: BORDER_COLOR),)
            )
          ),
          Column(
            children: _recentLanguages.map((e) =>_languageItem(e)).toList()
          )
        ]
      )

    );
  }

  Widget _languageLists() {
    return Column(
        children: _allLanguages.map((e) => _languageItem(e)).toList(),
      );
  }

  Widget _languageItem(Language language) {
    return InkWell(
      onTap: (){
        print(language.isoCode);
        widget.onValuePicked(language);
        Navigator.of(context).pop();
      },
      child: Container(
        padding: EdgeInsets.only(bottom:10, top: 10, left: 10),
        width: MediaQuery.of(context).size.width-30,
        child: Text(language.name, style: TextStyle(color: DART_TEXT_COLOR, fontSize:16)),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 0.5, color: BORDER_COLOR),)
        )
      )
    );
  }
}
