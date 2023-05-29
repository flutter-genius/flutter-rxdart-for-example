class Requirement {
  int _id;
  String _name;
  String _value;
  String _other;
  String _description;
  String _checked;
  String _unchecked;
  bool _status;

  int get id => this._id ?? -1;

  String get name => this._name ?? '';

  String get value => this._value ?? '';

  String get other => this._other ?? '';

  String get description => this._description ?? '';

  String get checked => this._checked ?? '';

  String get unchecked => this._unchecked ?? '';

  bool get status => this._status ?? false;

  Requirement({
    int id,
    String name,
    String value,
    String other,
    String description,
    String checked,
    String unchecked,
    bool status,
  }) {
    this._id = id;
    this._name = name;
    this._value = value;
    this._other = other;
    this._description = description;
    this._checked = checked;
    this._unchecked = unchecked;
    this._status = status;
  }

  Requirement.map(dynamic obj) {
    this._id = obj['id'];
    this._name = obj['name'];
    this._value = obj['value'];
    this._other = obj['other'];
    this._description = obj['description'];
    this._checked = obj['checked'];
    this._unchecked = obj['unchecked'];
    this._status = obj['status'];
  }

  Requirement.fromMap(Map<String, dynamic> obj) {
    this._id = obj['id'];
    this._name = obj['name'];
    this._value = obj['value'];
    this._other = obj['other'];
    this._description = obj['description'];
    this._checked = obj['checked'];
    this._unchecked = obj['unchecked'];
    this._status = obj['status'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (this._id != null) map['id'] = this._id;
    if (this._name != null) map['name'] = this._name;
    if (this._value != null) map['value'] = this._value;
    if (this._other != null) map['other'] = this._other;
    if (this._description != null) map['description'] = this._description;
    if (this._checked != null) map['checked'] = this._checked;
    if (this._unchecked != null) map['unchecked'] = this._unchecked;
    if (this._status != null) map['status'] = this._status;
    return map;
  }
}
