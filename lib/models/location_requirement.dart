class LocationRequirement {
  String _requirementId;
  String _value;
  String _other;
  String _description;
  bool _status;

  String get requirementId => this._requirementId ?? -1;

  String get value => this._value;

  String get other => this._other;

  String get description => this._description;

  bool get status => this._status ?? false;

  set value(String value) {
    this._value = value;
  }

  set requirementId(String value) {
    this._requirementId = value;
  }

  set other(String value) {
    this._other = value;
  }

  set description(String value) {
    this._description = value;
  }

  LocationRequirement({
    String requirementId,
    String value,
    String other,
    String description,
    bool status,
  }) {
    this._requirementId = requirementId;
    this._value = value;
    this._other = other;
    this._status = status;
    this._description = description;
  }

  LocationRequirement.map(dynamic obj) {
    this._requirementId = obj['requirementId'];
    this._value = obj['value'];
    this._other = obj['other'];
    this._status = obj['status'];
    this._description = obj['description'];
  }

  LocationRequirement.fromMap(Map<String, dynamic> obj) {
    this._requirementId = obj['requirementId'];
    this._value = obj['value'];
    this._other = obj['other'];
    this._status = obj['status'];
    this._description = obj['description'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (this._requirementId != null)
      map['requirementId'] = this._requirementId;
    if (this._value != null) map['value'] = this._value;
    if (this._other != null) map['other'] = this._other;
    if (this._status != null) map['status'] = this._status;
    if(this._description != null) map['description'] = this._description;
    return map;
  }
}
