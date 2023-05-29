import 'dart:convert';
import 'dart:io';
import 'package:hittapa/services/node_auth_service.dart';

// file upload to the node.js server
Future<String> uploadFileApi(File image, String type) async{
  if(image==null) return null;
  String base64Image = base64Encode(image.readAsBytesSync());
  String extension = image?.path?.split('.')?.last;
  String result = await NodeAuthService().uploadFile(base64Image, type, extension);
  return result;
}

/// avatar upload to the node.js server
Future<String> uploadAvatarApi(File image, String uid) async {
  if(image==null) return null;
  String base64Image = base64Encode(image.readAsBytesSync());
  String extension = image?.path?.split('.')?.last;
  String result = await NodeAuthService().uploadAvatar(base64Image, uid, extension);
  return result;
}
