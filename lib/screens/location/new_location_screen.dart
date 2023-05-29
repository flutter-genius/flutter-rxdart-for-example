import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoder/geocoder.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/appState.dart';
import 'package:hittapa/models/location.dart';
import 'package:hittapa/models/location_category.dart';
import 'package:hittapa/models/location_requirement.dart';
import 'package:hittapa/models/models.dart';
import 'package:hittapa/models/open_day_time.dart';
import 'package:hittapa/models/venue.dart';
import 'package:hittapa/services/file_upload.dart';
import 'package:hittapa/services/node_service.dart';
import 'package:hittapa/utils/navigator.dart';
import 'package:hittapa/utils/validator.dart';
import 'package:hittapa/widgets/hittapa_outline.dart';
import 'package:hittapa/widgets/image_picker_handler.dart';
import 'package:hittapa/widgets/location_category_picker.dart';
import 'package:hittapa/widgets/round_button.dart';
import 'package:hittapa/widgets/select_open_daytime_widget.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:hittapa/widgets/location_event_category_picker.dart';
import 'package:hittapa/global_export.dart';

class NewLocationScreen extends StatefulWidget {
  @override
  _NewLocationScreenState createState() => _NewLocationScreenState();
}

class _NewLocationScreenState extends State<NewLocationScreen>
    with TickerProviderStateMixin, ImagePickerListener {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AnimationController _controller;
  ImagePickerHandler imagePicker;
  List<File> images = [];
  List<LocationCategoryModel> selectedEventCategories = [];
  List<VenueOpenTimesModel> selectedVenueOpenTimesModel;
  List<LocationRequirement> selectedCategories = [];
  File logo;
  String name;
  String webSite;
  String phoneNumber;
  String description;
  bool isEveryDayOpen;
  bool isLogo = false;
  Address _address;
  bool _isLoading = false;
  String addressLine;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    imagePicker = ImagePickerHandler(this, _controller);
    imagePicker.init(context);
  }

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return StoreConnector<AppState, dynamic>(
        converter: (store) => store.state.user,
        builder: (context, user) {
          return ModalProgressHUD(
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                leading: IconButton(
                  icon: SvgPicture.asset('assets/arrow-back.svg'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
                backgroundColor: Colors.white,
                title: Text(
                  LocaleKeys.location_location.tr(),
                  style: TextStyle(
                      color: TITLE_TEXT_COLOR,
                      fontWeight: FontWeight.w600,
                      fontSize: 21),
                ),
                centerTitle: true,
              ),
              body: Container(
                margin: EdgeInsets.symmetric(horizontal: 14),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 24),
                              child: Text(
                                 LocaleKeys.create_event_basic_information.tr(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: NAVIGATION_NORMAL_TEXT_COLOR),
                              ),
                            )
                          ],
                        ),
                        Divider(
                          color: SEPARATOR_COLOR,
                        ),
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.symmetric(vertical: 20),
                          child: GestureDetector(
                            child: Stack(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                  child: logo == null
                                      ? SvgPicture.asset('assets/logo_placeholder.svg')
                                      : Image.file(
                                    logo,
                                    fit: BoxFit.cover,
                                    width: 100,
                                    height: 100,
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  child: Container(
                                      width: 32,
                                      height: 32,
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(16))),
                                      child: SvgPicture.asset('assets/edit_icon.svg',
                                          color: GRADIENT_COLOR_ONE)
                                  ),
                                )
                              ],
                            ),
                            onTap: () {
                              isLogo = true;
                              imagePicker.showDialog(context, max: 100);
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: Text(
                             LocaleKeys.create_location_name.tr(),
                            style: TextStyle(
                                color: BORDER_COLOR,
                                fontSize: 11,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        HittapaOutline(
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: NAVIGATION_NORMAL_TEXT_COLOR),
                            decoration: InputDecoration(
                                hintStyle: TextStyle(color: BORDER_COLOR),
                                hintText:  LocaleKeys.create_location_eg_company_name.tr(),
                                border: InputBorder.none),
                            onSaved: (value) => name = value,
                            validator: validateRequired,
                            autofocus: false,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 19, bottom: 5),
                          child: Text(
                             LocaleKeys.create_location_category.tr(),
                            style: TextStyle(
                                color: BORDER_COLOR,
                                fontSize: 11,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        selectedCategories.length==0 ? HittapaOutline(
                          child: GestureDetector(
                            child: Row(
                              children: <Widget>[
                                Text( LocaleKeys.create_location_select_categories.tr(),
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: BORDER_COLOR)),
                                Expanded(
                                  child: SizedBox(),
                                ),
                                Icon(Icons.keyboard_arrow_down)
                              ],
                            ),
                            onTap: () => onLocationClickCategory(),
                          ),
                        )
                            : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                              child: Text(
                                getCategoriesString(selectedCategories),
                                style: TextStyle(
                                    fontSize: 15,
                                    color: NAVIGATION_NORMAL_TEXT_COLOR,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                   LocaleKeys.global_preview_edit.tr(),
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: BORDER_COLOR,
                                      fontWeight: FontWeight.w500),
                                ),
                                Container(
                                  width: 32,
                                  height: 32,
                                  padding: EdgeInsets.all(8),
                                  margin: EdgeInsets.symmetric(horizontal: 14),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(16)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF696969),
                                          spreadRadius: -5,
                                          blurRadius: 14,
                                        ),
                                      ]),
                                  child: GestureDetector(
                                    child: SvgPicture.asset(
                                        'assets/edit_icon.svg',
                                        color: GRADIENT_COLOR_ONE),
                                    onTap: () => onLocationClickCategory(),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20, bottom: 5),
                          child: Text(
                             LocaleKeys.location_location.tr(),
                            style: TextStyle(
                                color: BORDER_COLOR,
                                fontSize: 11,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Text(
                           LocaleKeys.create_location_your_location_is.tr(),
                          style: TextStyle(
                              color: GRADIENT_COLOR_ONE,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        GestureDetector(
                          child: HittapaOutline(
                            child: Row(
                              children: <Widget>[
                                SvgPicture.asset('assets/geo_pin.svg'),
                                SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: Text(
                                    addressLine == null
                                        ?  LocaleKeys.create_event_select_on_the_map.tr()
                                        : '$addressLine',
                                    style: TextStyle(
                                      color: BORDER_COLOR,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () => navigateToMapScreen(context, null, user.uid).then((value) {
                            _address = value==null ? null :value['address'];
                            addressLine = value==null ? null : value['addressLine'];
                          }),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Text(
                             LocaleKeys.create_location_opening_days.tr(),
                            style: TextStyle(
                                color: BORDER_COLOR,
                                fontWeight: FontWeight.w600,
                                fontSize: 13),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          child: selectedVenueOpenTimesModel == null
                              ? HittapaOutline(
                            child: GestureDetector(
                              child: Row(
                                children: <Widget>[
                                  Text(
                                     LocaleKeys.create_event_select_date_time.tr(),
                                    style: TextStyle(
                                        color: BORDER_COLOR,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13),
                                  ),
                                  Expanded(
                                    child: SizedBox(),
                                  ),
                                  Icon(Icons.keyboard_arrow_down)
                                ],
                              ),
                              onTap: () => onClickDayTime(),
                            ),
                          )
                              : Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 20),
                                child: Text(
                                  LocaleKeys.create_location_your_choose.tr(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17,
                                      color: TITLE_TEXT_COLOR),
                                ),
                              ),
                              isEveryDayOpen
                                  ? Text(
                               LocaleKeys.create_location_open_all.tr(),
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: TITLE_TEXT_COLOR),
                              )
                                  : Column(
                                children: selectedVenueOpenTimesModel
                                    .map((e) => Container(
                                  width: MediaQuery.of(context)
                                      .size
                                      .width /
                                      2,
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        '${e.day} :',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight:
                                            FontWeight.w600,
                                            color:
                                            TITLE_TEXT_COLOR),
                                      ),
                                      Expanded(
                                        child: SizedBox(),
                                      ),
                                      Text(
                                        e.isClose
                                            ? '${e.openTime} - ${e.closeTime}'
                                            : LocaleKeys.global_close.tr(),
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight:
                                            FontWeight.w600,
                                            color:
                                            TITLE_TEXT_COLOR),
                                      )
                                    ],
                                  ),
                                ))
                                    .toList(),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    LocaleKeys.global_preview_edit.tr(),
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: BORDER_COLOR,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Container(
                                    width: 32,
                                    height: 32,
                                    padding: EdgeInsets.all(8),
                                    margin: EdgeInsets.symmetric(horizontal: 14),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(16)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFF696969),
                                            spreadRadius: -5,
                                            blurRadius: 14,
                                          ),
                                        ]),
                                    child: GestureDetector(
                                      child: SvgPicture.asset(
                                          'assets/edit_icon.svg',
                                          color: GRADIENT_COLOR_ONE),
                                      onTap: () => onClickDayTime(),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20, bottom: 5),
                          child: Text(
                            LocaleKeys.create_location_website.tr(),
                            style: TextStyle(
                                color: BORDER_COLOR,
                                fontWeight: FontWeight.w600,
                                fontSize: 13),
                          ),
                        ),
                        HittapaOutline(
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: NAVIGATION_NORMAL_TEXT_COLOR),
                            keyboardType: TextInputType.url,
                            decoration: InputDecoration(
                                hintStyle: TextStyle(color: BORDER_COLOR),
                                hintText: LocaleKeys.create_location_eg_website.tr(),
                                border: InputBorder.none),
                            validator: validateUrl,
                            onSaved: (value) => webSite = value,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20, bottom: 5),
                          child: Text(
                            LocaleKeys.create_location_telephone.tr(),
                            style: TextStyle(
                                color: BORDER_COLOR,
                                fontWeight: FontWeight.w600,
                                fontSize: 13),
                          ),
                        ),
                        HittapaOutline(
                          child: TextFormField(
                            keyboardType: TextInputType.phone,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: NAVIGATION_NORMAL_TEXT_COLOR),
                            decoration: InputDecoration(
                                hintStyle: TextStyle(color: BORDER_COLOR),
                                hintText: LocaleKeys.create_location_contact_number.tr(),
                                border: InputBorder.none),
                            validator: validateRequired,
                            onSaved: (value) => phoneNumber = value,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20, bottom: 5),
                          child: Text(
                            LocaleKeys.create_location_description.tr(),
                            style: TextStyle(
                                color: BORDER_COLOR,
                                fontWeight: FontWeight.w600,
                                fontSize: 13),
                          ),
                        ),
                        HittapaOutline(
                          height: 120,
                          child: TextFormField(
                            maxLines: 10,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: NAVIGATION_NORMAL_TEXT_COLOR),
                            decoration: InputDecoration(
                                hintStyle: TextStyle(color: BORDER_COLOR),
                                hintMaxLines: 10,
                                hintText:
                                LocaleKeys.create_location_eg_description.tr(),
                                border: InputBorder.none),
                            validator: validateRequired,
                            onSaved: (value) => this.description = value,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20, bottom: 5),
                          child: Text(
                            LocaleKeys.create_location_images.tr(),
                            style: TextStyle(
                                color: BORDER_COLOR,
                                fontWeight: FontWeight.w600,
                                fontSize: 13),
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: <Widget>[
                              ...images
                                  .map((e) => Container(
                                margin: EdgeInsets.only(right: 20),
                                width: 72,
                                height: 72,
                                child: ClipRRect(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                                  child: Container(
                                    child: Image(
                                      fit: BoxFit.cover,
                                      image: ExactAssetImage(e.path),
                                    ),
                                  ),
                                ),
                              ))
                                  .toList(),
                              Container(
                                margin: EdgeInsets.only(right: 20),
                                width: 72,
                                child: GestureDetector(
                                  child: HittapaOutline(
                                    height: 72,
                                    child: Center(
                                      child: Icon(Icons.add),
                                    ),
                                  ),
                                  onTap: () {
                                    isLogo = false;
                                    imagePicker.showDialog(context);
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: HittapaRoundButton(
                        text: LocaleKeys.global_cancel.tr().toUpperCase(),
                        isNormal: true,
                        onClick: () => Navigator.of(context).pop(),
                      ),
                    ),
                    Expanded(
                      child: HittapaRoundButton(
                        text: LocaleKeys.global_preview_publish.tr().toUpperCase(),
                        onClick: () => onPublish(user),
                      ),
                    )
                  ],
                ),
                margin: EdgeInsets.only(bottom: 20, right: 15, left: 15),
              ),
            ),
            inAsyncCall: _isLoading,
          );
        });
  }

  @override
  userImage(File _image) {
    setState(() {
      if (isLogo) {
        logo = _image;
      } else {
        if (images == null) images = [];
        images.add(_image);
      }
    });
  }

//   open bottom slide up dialog
  onClickCategory() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return LocationEventCategoryPicker(
            onItemChecked: (values) {
              setState(() {
                selectedCategories = values;
              });
            },
            selectedCategories: selectedEventCategories,
          );
        });
  }

  //   open bottom slide up dialog
  onLocationClickCategory() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return LocationCategoryPicker(
            onItemChecked: (values) {
              setState(() {
                selectedCategories = values;
              });
            },
            selectedCategories: selectedCategories,
          );
        });
  }

  // open datetime picker
  onClickDayTime() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SelectOpenDateTimeWidget(
            onItemChecked: (values, value) {
              setState(() {
                selectedVenueOpenTimesModel = values;
                isEveryDayOpen = value ?? false;
              });
            },
            selectedVenueOpenTimesModel: selectedVenueOpenTimesModel,
            isOpenEveryDay: isEveryDayOpen,
          );
        });
  }

  // request to create new location
  onPublish(UserModel user) async {
    if (logo == null) {
      hittaPaToast(LocaleKeys.toast_select_your_logo.tr(), 0);
      return;
    }
    if ((images ?? []).length < 1) {
      hittaPaToast(LocaleKeys.toast_select_your_location_images.tr(), 0);
      return;
    }
    if (selectedVenueOpenTimesModel == null) {
      hittaPaToast(LocaleKeys.toast_select_opening_days.tr(), 0);
      return;
    }
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        _isLoading = true;
      });
      List<String> _images = [];
      String _logo = await uploadFileApi(logo, 'venue/logo');
      print('***** this is the image upload result url ***** ' + _logo);
      for (int i=0; i < images.length; i++)
        _images.add(await uploadFileApi(images[i], 'venue/images'));
      VenueModel _location = VenueModel(
        name: this.name,
        location: LocationModel(
          coordinates: [this._address.coordinates.latitude,
            this._address.coordinates.longitude],
          address: this.addressLine,
          country: this._address.countryName,
          city: this._address.locality,
          state: this._address.adminArea,
          postCode: this._address.postalCode,
          street: this._address.thoroughfare ?? this._address.subAdminArea,
        ),
        desc: description,
        websiteUrl: webSite,
        is24Opened: isEveryDayOpen,
        phoneNumber: phoneNumber,
        eventCategories: selectedEventCategories,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        openTimes: selectedVenueOpenTimesModel,
        ownerId: user.uid,
        imageUrls: _images,
        logo: _logo,
        eventIds: [],
        reviews: 0,
        image: _images[0],
        point: 0.0,
        categories: selectedCategories
      );
      var _result = await NodeService().createLocation(_location.toFB());
      if(_result != null && _result['data'] != null) {
        _location = _location.copyWith(id:  _result['data']['_id'] );
      }
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
      navigateToLocationDetailScreen(context, _location,
          images: images,
          logo: logo,
          categories: selectedEventCategories,
          openTimes: selectedVenueOpenTimesModel);
    }
  }
}
