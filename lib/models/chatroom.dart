// import 'package:hittapa/models/event.dart';
// import 'package:hittapa/models/message.dart';
// import 'package:hittapa/models/user.dart';

// class ChatRoom {
//   MessageModel lastMessage;
//   EventModel event;
//   UserModel lastUser;
//   int unReadCount = 0;

//   ChatRoom.fromFB(dynamic obj) {
//     lastMessage = MessageModel.fromMap(obj['last_message'] ?? {});
//     lastUser = UserModel.fromFB(obj['last_user'] ?? {});
//     event = EventModel.fromFB(obj);
//     unReadCount = obj['unread_message_counter'] ?? 0;
//   }
// }
