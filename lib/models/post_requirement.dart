class PostRequirement {
  int _requirementId;
  String _value;
  String _other;
  bool _status;

  int get requirementId => this._requirementId ?? -1;

  String get value => this._value;

  String get other => this._other;

  bool get status => this._status ?? false;

  set value(String value) {
    this._value = value;
  }

  set other(String value) {
    this._other = value;
  }

  PostRequirement({
    int requirementId,
    String value,
    String other,
    bool status,
  }) {
    this._requirementId = requirementId;
    this._value = value;
    this._other = other;
    this._status = status;
  }

  PostRequirement.map(dynamic obj) {
    this._requirementId = obj['requirement_id'];
    this._value = obj['value'];
    this._other = obj['other'];
    this._status = obj['status'];
  }

  PostRequirement.fromMap(Map<String, dynamic> obj) {
    this._requirementId = obj['requirement_id'];
    this._value = obj['value'];
    this._other = obj['other'];
    this._status = obj['status'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (this._requirementId != null)
      map['requirement_id'] = this._requirementId;
    if (this._value != null) map['value'] = this._value;
    if (this._other != null) map['other'] = this._other;
    if (this._status != null) map['status'] = this._status;
    return map;
  }
}
