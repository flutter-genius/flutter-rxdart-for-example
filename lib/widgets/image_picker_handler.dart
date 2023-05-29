import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'Image_picker_dialog.dart';

class ImagePickerHandler {
  ImagePickerDialog imagePicker;
  AnimationController _controller;
  ImagePickerListener _listener;
  int max;

  ImagePickerHandler(this._listener, this._controller);

  openCamera() async {
    imagePicker.dismissDialog();
    var image = await ImagePicker().pickImage(source: ImageSource.camera);
    cropImage(image?.path);
  }

  openGallery() async {
    imagePicker.dismissDialog();
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    cropImage(image?.path);
  }

  void init(BuildContext cont) {
    imagePicker = ImagePickerDialog(
      context: cont,
      controller: _controller,
      listener: this,
    );
    imagePicker.initState();
  }

  Future cropImage(String image) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image ?? '',
      maxWidth: max ?? 1024,
      maxHeight: max ?? 1024,
    );
    if (croppedFile != null) _listener.userImage(croppedFile);
  }

  showDialog(BuildContext context, {int max}) {
//    imagePicker.
    imagePicker.getImage(context);
  }
}

abstract class ImagePickerListener {
  userImage(File _image);
}
