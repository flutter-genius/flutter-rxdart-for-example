import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hittapa/actions/actions.dart';
import 'package:hittapa/actions/user.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/models.dart';
import 'package:hittapa/screens/events/event_posted.dart';
import 'package:hittapa/screens/events/image_screen.dart';
import 'package:hittapa/screens/events/basic_screen.dart';
import 'package:hittapa/screens/events/requirements_screen.dart';
import 'package:hittapa/widgets/round_button.dart';
import 'package:hittapa/widgets/round_gradient_button.dart';
import 'package:hittapa/widgets/show_confirm_dialog.dart';
import 'package:redux/redux.dart';

import '../../config.dart';
import 'event_summary.dart';
import 'package:hittapa/services/file_upload.dart';
import 'package:hittapa/global_export.dart';

class NewEventScreen extends StatefulWidget {
  @override
  _NewEventScreenState createState() => _NewEventScreenState();
}

class _NewEventScreenState extends State<NewEventScreen>{
  PageController _pageController = PageController(keepPage: true);
  bool menuShown = false, _isOneImage = false;
  String _nextTxt = LocaleKeys.create_event_next_step.tr();
  String _previousTxt = LocaleKeys.global_cancel.tr().toUpperCase(), _selectedImageName;
  bool showAppbar = false, _isLoading = false;
  int currentPage = 0;
  double menuHeight = 0.0;
  final GlobalKey<FormState> layoutKey = GlobalKey<FormState>();
  List<File> _images = [];
  List<String> _imageUrls = [];

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return StoreConnector<AppState, dynamic>(
        converter: (store) => store,
        builder: (context, store) {
          AppState state = store.state;
          EventModel event = state.newEvent;
          EventCategoryModel category = state.eventCategories
              .firstWhere((category) => category.id == event.categoryId);
          EventSubcategoryModel subcategory = category.subcategories.firstWhere(
              (subcategory) => subcategory.id == event.subcategoryId);

          // if(subcategory.imageLists.length < 2) {
          //  if(!_isOneImage) {
          //    currentPage = 1;
          //    _imageUrls = event.imageUrls;
          //    store.dispatch(UpdateEvent(store.state.newEvent
          //        .copyWith(imageUrls: event.imageUrls, imageUrl: event.imageUrls[0])));
          //    showAppbar = true;
          //  }
          //   _isOneImage = true;
          // }
          Widget appBar;
          if (showAppbar) {
            appBar = currentPage==3 ? AppBar(
              leading: IconButton(
                icon: SvgPicture.asset('assets/arrow-back.svg', color: BACKGROUND_COLOR,),
                onPressed: () {
                   _pageController.previousPage(
                                  duration: Duration(milliseconds: 700),
                                  curve: Curves.easeOutCubic);
                },
              ),
              backgroundColor: Colors.transparent,
              elevation: 0
            ) : AppBar(
              leading: IconButton(
                icon: SvgPicture.asset('assets/arrow-back.svg', color: GOOGLE_COLOR,),
                onPressed: () => Navigator.of(context).pop(),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              backgroundColor: Colors.white,
              title: Text(
                subcategory.name,
                style: TextStyle(
                    color: TITLE_TEXT_COLOR,
                    fontWeight: FontWeight.w600,
                    fontSize: 21),
              ),
              centerTitle: true,
            );
          }

          return Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: CARD_BACKGROUND_COLOR,
            appBar: appBar,
            body: PageView(
              physics: NeverScrollableScrollPhysics(),
              onPageChanged: _onPageChanged,
              controller: _pageController,
              children: _isOneImage ? <Widget>[
                RequirementsScreen(
                  requirements: event.requirements,
                  event: event,
                ),
                BasicInfoScreen(
                  fKey: layoutKey,
                ),
                EventSummary(event: event, owner: state.user, files: _images,),
                EventPosted(event: event, owner: state.user, files: _images,)
              ] : <Widget>[
                ImageScreen(
                  event: event,
                  fKey: layoutKey,
                  subcategory: subcategory,
                  onImageSelected: (img, name) {
                    int n = _images.indexOf(img);
                    setState(() {
                      if (n < 0) {
                        _images.add(img);
                        _selectedImageName = name;
                        // onImageSave(store);
                      } else {
                        _images.removeAt(n);
                      }
                    });
                  },
                  onSelectURLs: (url, name) {
                    int n = _imageUrls.indexOf(url);
                    setState(() {
                      if (n < 0) {
                        _selectedImageName = name;
                        _imageUrls.add(url);
                        // onImageSave(store);
                      } else {
                        _imageUrls.removeAt(n);
                      }
                    });
                  },
                  imageUrls: _imageUrls,
                  images: _images,
                  onContinue: () {
                    onImageSave(store);
                  }
                ),
                RequirementsScreen(
                  requirements: event.requirements,
                  event: event,
                ),
                BasicInfoScreen(
                  fKey: layoutKey,
                ),
                EventSummary(
                  event: event,
                  owner: state.user,
                  files: _images,
                  onImageSelected: (img, name) {
                    int n = _images.indexOf(img);
                    setState(() {
                      if (n < 0) {
                        _images.add(img);
                        _selectedImageName = name;
                      } else {
                        _images.removeAt(n);
                      }
                    });
                  },
                ),
                EventPosted(event: event, owner: state.user, files: _images,)
              ],
            ),
            bottomNavigationBar: currentPage==4 || (!_isOneImage && currentPage==0) ? null : Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [TAB_COLOR, TAB_TWO_COLOR]
                  ),
                ),
                padding: EdgeInsets.only(bottom: 25, right: 17, left: 17, top:10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: HittapaRoundButton(
                        text: _previousTxt,
                        onClick: () {
                          if(_isOneImage) {
                            if (_pageController.page < 1) {
                              Navigator.of(context).pop();
                            } else {
                              _pageController.previousPage(
                                  duration: Duration(milliseconds: 700),
                                  curve: Curves.easeOutCubic);
                            }
                          } else {
                            if (_pageController.page < 2) {
                              Navigator.of(context).pop();
                            } else {
                              _pageController.previousPage(
                                  duration: Duration(milliseconds: 700),
                                  curve: Curves.easeOutCubic);
                            }
                          }
                        },
                        isNormal: true,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: HittapaRoundGradientButton(
                        text: _nextTxt,
                        onClick: () {
                          if (currentPage == 0) onImageSave(store);
                          if (currentPage == 1) onRequirementsSave(event);
                          if (currentPage == 2) onBasicSave(event);
                          if (currentPage == 3) onPostEvent(store, subcategory);
                        },
                        startColor: LIGHTBLUE_BUTTON_COLOR,
                        endColor: LIGHTBLUE_BUTTON_COLOR,
                      ),
                    ),
                  ],
                ),
              ),
          );
        });
  }

  _onPageChanged(int page) {
    if (debug) print("_onPageChanged");
    if(_isOneImage) {
      page++;
    }
    currentPage = page;
    setState(() {
      if (page == 0) {
        _previousTxt = LocaleKeys.global_cancel.tr().toUpperCase();
        _nextTxt = LocaleKeys.create_event_next_step.tr();
        showAppbar = false;
      } else if( page ==1 ){
        _previousTxt = LocaleKeys.global_cancel.tr().toUpperCase();
        _nextTxt = LocaleKeys.create_event_next_step.tr();
        showAppbar = true;
      } else if (page == 2) {
        _previousTxt = LocaleKeys.create_event_previous_step.tr().toUpperCase();
        _nextTxt = LocaleKeys.create_event_preview_and_post.tr().toUpperCase();
        showAppbar = true;
      } else if (page == 3) {
        _previousTxt = LocaleKeys.create_event_edit_post.tr().toUpperCase();
        _nextTxt = LocaleKeys.create_event_post_activity.tr().toUpperCase();
        showAppbar = true;
      } else {
        _previousTxt = LocaleKeys.create_event_previous_step.tr().toUpperCase();
        _nextTxt = LocaleKeys.create_event_next_step.tr();
        showAppbar = false;
      }
    });
  }

  onBasicSave(EventModel e) async {
    if (layoutKey.currentState.validate()) {
      layoutKey.currentState.save();
      if (e.location == null ||
          e.location.address.isEmpty ||
          e.startDT == null ||
          e.endDT == null) {
        String _error = LocaleKeys.toast_fill_all.tr();
        if(e.location == null) _error = LocaleKeys.toast_fill_location.tr();
        if(e.location !=null && e.location.address.isEmpty == null) _error = LocaleKeys.toast_fill_location_address.tr();
        if(e.startDT == null) _error = LocaleKeys.toast_select_start_date.tr();
        if(e.endDT == null) _error = LocaleKeys.toast_select_duration.tr();
        hittaPaToast(_error, 1);
        return;
      }

      await _pageController.nextPage(
          duration: Duration(milliseconds: 700), curve: Curves.easeOutCubic);
    } else {
      hittaPaToast(LocaleKeys.toast_fill_title_description.tr(), 1);
    }
  }

  // on next from Participant screen
  onRequirementsSave(EventModel event) {
    bool state = true;
    String _error = '';
    for(int i=0; i<event.requirements.length; i++){
      if(event.requirements[i].value == null) {
        state = false;
        switch (event.requirements[i].requirementId) {
          case 8:
            _error = LocaleKeys.toast_select_driver_license.tr();
            break;
          case 7:
            _error = LocaleKeys.toast_select_tempo.tr();
            break;
          case 9:
            _error = LocaleKeys.toast_select_children_age.tr();
            break;
          case 3:
            _error = LocaleKeys.toast_select_primary_speaking_language.tr();
            break;
          case 2:
            _error = LocaleKeys.toast_select_age.tr();
            break;
          case 1:
            _error = LocaleKeys.toast_select_gender.tr();
            break;
          default:
            _error = LocaleKeys.toast_fill_all.tr();
        }
      }
    }
    if (event.maxParticipantsNo <= 0) {
      state = false;
      _error = 'Please select participants';
    }
    if (state) {
      _pageController.nextPage(
          duration: Duration(milliseconds: 700), curve: Curves.easeOutCubic);
    } else {
      hittaPaToast(_error, 1);
    }
  }

  // on next from layout screen
  onDetailsSave(Store<AppState> store) {
    if (layoutKey.currentState.validate()) {
      layoutKey.currentState.save();
      if ((_images.length + _imageUrls.length) > 0) {
        if (_imageUrls.length > 0) {
          store.dispatch(UpdateEvent(store.state.newEvent
              .copyWith(imageUrls: _imageUrls, imageUrl: _imageUrls[0])));
        } else {
          store.dispatch(UpdateEvent(store.state.newEvent
              .copyWith(imageUrls: [], imageUrl: '')));
        }
        _pageController.nextPage(
            duration: Duration(milliseconds: 700),
            curve: Curves.easeOutCubic);
      } else {
        hittaPaToast(LocaleKeys.toast_select_images.tr(), 1);
      }
    }
  }

  // image save
  onImageSave(Store<AppState> store) {
    if ((_images.length + _imageUrls.length) > 0) {
      if (_imageUrls.length > 0) {
        if(_selectedImageName != null && _selectedImageName.toLowerCase() != 'main' && _selectedImageName.toLowerCase() != 'default') {
          store.dispatch(UpdateEvent(store.state.newEvent
              .copyWith(imageUrls: _imageUrls, imageUrl: _imageUrls[0], name: _selectedImageName)));
        } else {
          store.dispatch(UpdateEvent(store.state.newEvent
              .copyWith(imageUrls: _imageUrls, imageUrl: _imageUrls[0])));
        }
      } else {
        store.dispatch(UpdateEvent(store.state.newEvent
            .copyWith(imageUrls: [], imageUrl: '')));
      }
//      currentPage++;
      _pageController.nextPage(
          duration: Duration(milliseconds: 700),
          curve: Curves.easeOutCubic);
    } else {
      hittaPaToast(LocaleKeys.toast_select_images.tr(), 1);
    }
  }

  showAlertBox() async {
    await showDialog(context: context, useSafeArea: false, builder: (context) => ConfirmDialog(
        title: Center(child: Text(LocaleKeys.global_error.tr(), style: TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold))),
        icon: Container(),
        firstButton: MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          color: Colors.white,
          child: Text(LocaleKeys.global_ok.tr().toUpperCase()),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),
        yourWidget: Container(
          child: Text(LocaleKeys.global_something_went.tr(), style: TextStyle(fontSize: 17, color: Colors.white)),
        )
    ));
  }

  openEventConfirmationDialog() async {
    await showDialog(context: context, useSafeArea: false, builder: (context) => ConfirmDialog(
        title: Center(child: Text(LocaleKeys.event_detail_thank_you_for_event.tr(), style: TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold))),
        icon: Container(),
        firstButton: MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          color: Colors.white,
          child: Text(LocaleKeys.global_ok.tr(),),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),
        yourWidget: Container(
          child: Text(
            LocaleKeys.event_detail_we_value_you_opinion.tr(),
            textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17, color: Colors.white),
          ),
        )
    ));
  }

  onPostEvent(Store<AppState> store, EventSubcategoryModel sub) async {
    if (debug) print("currentPage == 3");

     await showDialog(context: context,  useSafeArea: false, builder: (context) => ConfirmDialog(
        title: Center(child: Text(_isLoading ? LocaleKeys.create_event_posted.tr() : LocaleKeys.popup_agree_to_the_term_dot.tr(), textAlign: TextAlign.center, style: TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold),),),
        firstButton: _isLoading ? Container() : HittapaRoundButton(
          text: LocaleKeys.global_discard.tr().toUpperCase(),
          isPopUp: true,
          onClick: ()  => Navigator.of(context).pop(),
          isNormal: true,
        ),
        secondButton: _isLoading ? Container() : HittapaRoundButton(
          text: LocaleKeys.global_continue.tr().toUpperCase(),
          isGoogleColor: true,
          isPopUp: true,
          onClick: () async {
            
            if (!_isLoading) {
              String thumbnail = sub.thumbnail;
              if ((_images ?? []).length > 0 && (_imageUrls ?? []).length < 1) {
                thumbnail = await uploadFileApi(_images[0], 'events');
              }

              if (_images != null && _images.length > 0) {
                _imageUrls = [];
                for (int i = 0; i < _images.length; i++) {
                  String url = await uploadFileApi(_images[i], 'events');
                  _imageUrls.add(url);
                }
              }

              saveNewEventToFB(
                store: store,
                thumbnail: thumbnail,
                imageUrls: _imageUrls,
                onSuccess: () {
                  List<EventSubcategoryModel> _recentSubcategories = store.state.user.recentSubcategories??[];
                  List<String> _recentLanguages = store.state.user.recentLanguages??[];
                  EventCategoryModel _selectedCategory = store.state.eventCategories.firstWhere((element) => element.id == store.state.newEvent.categoryId);
                  EventSubcategoryModel _selectedSubcategory = _selectedCategory.subcategories.firstWhere((element) => element.id == store.state.newEvent.subcategoryId);
                  bool _isUpdated = false;
                  if (_recentSubcategories.where((element) => element.id == _selectedSubcategory.id).length == 0) {
                    if(_recentSubcategories.length >= 10) _recentSubcategories.removeLast();
                    _recentSubcategories.insert(0, _selectedSubcategory);
                    _isUpdated = true;
                  }
                  if (store.state.newEvent.language != null && !_recentLanguages.contains(store.state.newEvent.language)) {
                    if (_recentLanguages.length >= 10) _recentLanguages.removeLast();
                    _recentLanguages.insert(0, store.state.newEvent.language);
                    _isUpdated = true;
                  }
                  if(_isUpdated) {
                    store.dispatch(updateUser(
                        store.state.user.copyWith(
                          recentSubcategories: _recentSubcategories,
                          recentLanguages: _recentLanguages
                        )
                    ));
                  }
                  Navigator.of(context).pop();
                  _pageController.nextPage(
                      duration: Duration(milliseconds: 100),
                      curve: Curves.easeOutCubic);
                },
                onFail: (error) {
                  Navigator.of(context).pop();
                }
              );
            }

            setState(() {
              _isLoading = true;
            });
          },
        ),
        icon: Container(),
        yourWidget: _isLoading ? Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              child: Center(
                child: Text(
                  LocaleKeys.create_event_we_value_your_opinion.tr(),
                  style: TextStyle(color: Colors.white, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 10,),
            Text(
              LocaleKeys.create_event_have_fun.tr(),
              textAlign: TextAlign.center,
            )
          ],
        ) : Column(
          children: <Widget>[
            Text(
              LocaleKeys.create_event_we_value_your_opinion.tr(),
              style: TextStyle(color: Colors.white, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10,),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  style: TextStyle(color: Colors.white,),
                  text: LocaleKeys.hittapa_sign_by_clicking_continue.tr(),
                  children: <TextSpan>[
                    TextSpan(
                        text: LocaleKeys.global_terms_of_use.tr(),
                        style: TextStyle(
                            decoration: TextDecoration.underline
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async{
                            await launchURL('hittapa.com/terms');
                          }
                    ),
                    TextSpan(
                        text:  " " + LocaleKeys.hittapa_sign_and_acknowledging.tr() + " ",
                    ),
                    TextSpan(
                        text: LocaleKeys.hittapa_sign_privacy_policy.tr(),
                        style: TextStyle(
                            decoration: TextDecoration.underline
                        ),
                        recognizer: TapGestureRecognizer()
                                ..onTap = () async{
                                  await launchURL('hittapa.com/privacy');
                                }
                    )
                  ]
              ),
            ),
          ],
        )
    ));
  }
}
