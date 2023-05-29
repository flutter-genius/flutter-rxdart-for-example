import 'package:flutter/material.dart';

class IsScroller extends ChangeNotifier {
  bool _isTop = true, _isAction = false;
  bool get isTop => this._isTop;
  bool get isAction => this._isAction;

  bool _pending = true;

  set isTop(bool val) {
    if (_pending == false || this._isTop == val) return;
    this._isTop = val;
    _pending = false;
    notifyListeners();
    Future.delayed(Duration(milliseconds: 500), () {
      _pending = true;
    });
  }

  set isAction(bool val) {
    this._isAction = true;
    notifyListeners();
  }
}
