import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hittapa/models/event.dart';
import 'package:hittapa/models/user.dart';
import 'package:hittapa/widgets/event_unaccepted_card.dart';
import 'package:hittapa/widgets/hittapa_imageview.dart';
import 'package:hittapa/widgets/image_picker_handler.dart';

import '../../config.dart';
import '../../global.dart';

class EventSummary extends StatefulWidget {
  final EventModel event;
  final UserModel owner;
  final List<File> files;
  final Function onImageSelected;

  EventSummary({this.event, this.owner, this.files, this.onImageSelected});

  @override
  _EventSummaryScreen createState() => _EventSummaryScreen();
}

class _EventSummaryScreen extends State<EventSummary>  with TickerProviderStateMixin, ImagePickerListener {

  AnimationController _controller;
  ImagePickerHandler imagePicker;
  List<File> images = [];

  EventModel event;
  UserModel owner;
  List<File> files;

  bool isExpanded;

  onExpanded() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  onRequirement() {
    
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    event = widget.event;
    owner = widget.owner;
    files = widget.files;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    imagePicker = ImagePickerHandler(this, _controller);
    imagePicker.init(context);
    isExpanded = false;
  }

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    if (debug) print("EventSummary:build ${event.imageUrls}");

    return Scaffold(
        backgroundColor: CARD_BACKGROUND_COLOR,
        body: Stack(children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  HittapaImageView(
                        title: event.name,
                        eventId: event.id,
                        images: files.length > 0 ? [] : event.imageUrls,
                        files: files,
                        eventOwner: owner,
                        user: owner,
                        isGuest: true,
                      ),
                      EventUnacceptedCard(event, null, owner, isExpanded, onExpanded, onRequirement)
                ]
              )
            ),
          ),
          // Positioned(
          //   top: MediaQuery.of(context).size.width-105,
          //   left: 20,
          //   child: isExpanded ? Container() :  InkWell(
          //     onTap: (){
          //       imagePicker.showDialog(context);
          //     },
          //     child: Container(
          //       width: 135,
          //       height: 50,
          //       alignment: Alignment.center,
          //       padding: EdgeInsets.all(3),
          //       decoration: BoxDecoration(
          //         color: Color(0x30000000),
          //         borderRadius: BorderRadius.all(Radius.circular(20)),
          //         border: Border.all(color: Colors.white, width: 1)
          //       ),
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           Text('Upload own Image', style: TextStyle(color: Colors.white, fontSize: 15)),
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             crossAxisAlignment: CrossAxisAlignment.center,
          //             children: [
          //               Text('Option', style: TextStyle(color: Colors.white, fontSize: 15)),
          //               files.length == 0 ? SvgPicture.asset(
          //                 "assets/svg/image_lock.svg",
          //                 width: 25,
          //                 height: 15,
          //                 // color: BORDER_COLOR,
          //               ) : Image(
          //                 image: ExactAssetImage(files[0].path),
          //                 width: 25,
          //                 height: 15
          //               ),
          //               SizedBox(width: 3),
          //               files.length > 1 ? Image(
          //                 image: ExactAssetImage(files[1].path),
          //                 width: 25,
          //                 height: 15
          //               ) : SvgPicture.asset(
          //                 "assets/svg/image_lock.svg",
          //                 width: 25,
          //                 height: 15,
          //                 // color: BORDER_COLOR,
          //               ),
          //               SizedBox(width: 3),
          //               files.length > 2 ? Image(
          //                 image: ExactAssetImage(files[2].path),
          //                 width: 25,
          //                 height: 15
          //               ) : SvgPicture.asset(
          //                 "assets/svg/image_lock.svg",
          //                 width: 25,
          //                 height: 15,
          //                 // color: BORDER_COLOR,
          //               ),
          //             ],
          //           )
          //         ],
          //       ),
          //     ),
          //   ),
          // )
        ])
    );
  }

  @override
  userImage(File image) {
    if (image != null) {
      setState(() {
        if (files == null) files = [];
        files.add(image);
        if (files.length > 3) {
          files.removeAt(0);
        }
      });
      widget.onImageSelected(image, 'Default');
    }
  }

}
