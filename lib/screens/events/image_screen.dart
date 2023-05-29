import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hittapa/global.dart';
import 'package:hittapa/models/appState.dart';
import 'package:hittapa/models/event.dart';
import 'package:hittapa/models/event_subcategory.dart';
import 'package:hittapa/widgets/image_picker_handler.dart';
import 'package:hittapa/global_export.dart';
import 'package:hittapa/widgets/round_gradient_button.dart';

class ImageScreen extends StatefulWidget {
  final EventModel event;
  final GlobalKey<FormState> fKey;
  final Function onImageSelected;
  final Function onSelectURLs;
  final Function onContinue;
  final EventSubcategoryModel subcategory;
  final List<String> imageUrls;
  final List<File> images;

  ImageScreen(
      {this.event,
        this.fKey,
        this.onImageSelected,
        this.onSelectURLs,
        this.onContinue,
        this.images,
        this.imageUrls,
        this.subcategory});

  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen>
    with TickerProviderStateMixin, ImagePickerListener {
  AnimationController _controller;
  ImagePickerHandler imagePicker;
  List<File> images = [];
  EventModel event;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    imagePicker = ImagePickerHandler(this, _controller);
    imagePicker.init(context);
    event = widget.event;
  }

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return StoreConnector<AppState, dynamic>(
        converter: (store) => store,
        builder: (context, store) {
          AppState state = store.state;
          var event = state.newEvent;
          return  Container(
            decoration: BoxDecoration(
              color: BACKGROUND_COLOR
            ),
            child: ListView(
              children: <Widget>[
                // Container(
                //   margin: EdgeInsets.only(top: 35, bottom: 15, left: MediaQuery.of(context).size.width*0.1, right: MediaQuery.of(context).size.width*0.1),
                //   child: Center(
                //     child: Text(
                //       'Select the exact type of cycling you want to create',
                //       style: TextStyle(fontSize: 20, color: Colors.white,),
                //       textAlign: TextAlign.center
                //     ),
                //   )
                // ),
                Container(
                  height: MediaQuery.of(context).size.height - 300,
                  // margin: event.imageUrls.length > 3 ? EdgeInsets.only(top: MediaQuery.of(context).size.height*0.15) : EdgeInsets.only(top: MediaQuery.of(context).size.height*0.15),
                  child: GridView.count(
                    crossAxisCount: 3,
                    childAspectRatio: 0.75,
                    // padding: EdgeInsets.all(10),
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0,
                    children: <Widget>[
                      ...event.imageUrls
                          .map((e){
                        int index = event.imageUrls.indexOf(e);
                        return Container(
                          // margin: EdgeInsets.symmetric(horizontal: 7),

                          child: GestureDetector(
                            child: Column(
                              children: <Widget>[
                                Stack(
                                  children: <Widget>[
                                    ClipRRect(
                                      // borderRadius: BorderRadius.all(Radius.circular(16)),
                                      child: CachedNetworkImage(
                                        width: MediaQuery.of(context).size.width / 3 - 4,
                                        height: MediaQuery.of(context).size.width/3/0.75 - 6,
                                        imageUrl: e ?? '',
                                        placeholder: (context, url) => Icon(Icons.image),
                                        errorWidget: (context, url, err) => Icon(Icons.image),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 6,
                                      right: 6,
                                      child: isCheckedURL(e) ? SvgPicture.asset(
                                          'assets/checked_with_background.svg')
                                          : SvgPicture.asset(
                                          'assets/unchecked_with_background.svg'),
                                    )
                                  ],
                                ),
                                // SizedBox(
                                //   height: 5,
                                // ),
                                // Text(
                                //   event.imageUrlsNames.length > index ? '${event.imageUrlsNames[index]}' : 'Default',
                                //   style: TextStyle(color: BORDER_COLOR,
                                //       fontWeight: FontWeight.w500,
                                //       fontSize: 13),
                                // ),
                                SizedBox(
                                  height: 5,
                                )
                              ],
                            ),
                            onTap: () {
                              setState(() {
                                String imageName =  event.imageUrlsNames.length > index ? '${event.imageUrlsNames[index]}' : 'MAIN';
                                widget.onSelectURLs(e, imageName);
                              });
                            },
                          ),
                        );
                      }).toList(),
                      // ...images.map((e) => Container(
                      //   margin: EdgeInsets.symmetric(
                      //       horizontal: 7),
                      //   child: GestureDetector(
                      //     child: Column(
                      //       children: <Widget>[
                      //         Stack(
                      //           children: <Widget>[
                      //             ClipRRect(
                      //               // borderRadius: BorderRadius.all(Radius.circular(16)),
                      //               child: Image.file(e,
                      //                 width: MediaQuery.of(context).size.width / 3 - 10,
                      //                 height: 140,
                      //                 fit: BoxFit.cover,
                      //               ),
                      //             ),
                      //             Positioned(
                      //               top: 6,
                      //               right: 6,
                      //               child: isCheckedFile(e)
                      //                   ? SvgPicture.asset(
                      //                   'assets/checked_with_background.svg')
                      //                   : SvgPicture.asset(
                      //                   'assets/unchecked_with_background.svg'),
                      //             )
                      //           ],
                      //         ),
                      //         SizedBox(
                      //           height: 5,
                      //         ),
                      //         // Text(
                      //         //   LocaleKeys.global_default.tr(),
                      //         //   style: TextStyle(
                      //         //       color: NAVIGATION_NORMAL_TEXT_COLOR,
                      //         //       fontWeight:
                      //         //       FontWeight.w500,
                      //         //       fontSize: 13),
                      //         // ),
                      //         // SizedBox(
                      //         //   height: 5,
                      //         // )
                      //       ],
                      //     ),
                      //     onTap: () {
                      //       setState(() {
                      //         widget.onImageSelected(e, 'MAIN');
                      //       });
                      //     },
                      //   ),
                      // )).toList(),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 15, bottom: 15, left: MediaQuery.of(context).size.width*0.1, right: MediaQuery.of(context).size.width*0.1),
                  child: Center(
                    child: Text(
                      "Select the image that suits your event best or upload your image below", 
                      style: TextStyle(
                        fontSize: 17, 
                        color: NAVIGATION_NORMAL_TEXT_COLOR,
                        fontWeight: FontWeight.w500
                      ),
                      textAlign: TextAlign.center,                      
                    ),
                  )
                ),
                Container(
                  padding: EdgeInsets.only(top: 10, left: 40, right: 40),
                  child: HittapaRoundGradientButton(
                    text: "CONTINUE",
                    startColor: LIGHTBLUE_BUTTON_COLOR,
                    endColor: LIGHTBLUE_BUTTON_COLOR,
                    isDisable: widget.images.length > 0 || widget.imageUrls.length > 0 ? false : true,
                    onClick: (){
                      widget.onContinue();
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10, left: 40, right: 40),
                  child: HittapaRoundGradientButton(
                    text: "UPLOAD YOUR OWN IMAGE",
                    startColor: LIGHTBLUE_BUTTON_COLOR,
                    endColor: LIGHTBLUE_BUTTON_COLOR,
                    onClick: (){
                      imagePicker.showDialog(context);
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  userImage(File image) {
    setState(() {
      if (images == null) images = [];
      images.add(image);
    });
    widget.onImageSelected(image, 'uploaded');
  }

  isCheckedURL(String element) {
    return widget.imageUrls.indexOf(element) >= 0;
  }

  isCheckedFile(File file) {
    return widget.images.indexOf(file) >= 0;
  }
}
