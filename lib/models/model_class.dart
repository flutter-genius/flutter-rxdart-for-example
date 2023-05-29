import 'package:meta/meta.dart';

/// WARNING! Constructors, overloaded operators aren't enforced in subclasses by Dart. Your Model class should implement the following:
/// - DataModel.fromFB (named constructor) - transform data from server into model class
/// - DataModel.fromJson (named constructor) - transform data from raw JSON into the model class (eg. from Redux Persistor)
/// - toJson (method) - generate JSON from the model
/// - copyWith - convenience method to create new object based on current one.
/// - bool operator ==(other) - == operator overload to compare this object with another
/// - hashCode - generate custom hash (required by overloading == operator)
/// See DataModel class for details.
@immutable
abstract class DataModel {
  // final int id;
  // final bool debug = false;

  DataModel();

  /// named constructor
  // DataModel.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson();

  copyWith(/*{int id}*/);

  @override
  int get hashCode;

  bool operator ==(other) {
    return this.toString() == other.toString();
  }

  @override
  String toString() {
    return this.toJson().toString();
  }
}

class EventModelVersion {
  final int version;

  EventModelVersion(this.version);
}
