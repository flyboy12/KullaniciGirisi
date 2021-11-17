import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DesignProvider extends ChangeNotifier {
  Color? _suffixColor = Colors.grey[350];
  Color get suffixColor => _suffixColor!;
  bool _obscureText = true;
  bool get obscureText => _obscureText;

  suffixIconProcess() {
    //Burada TextFormFieldın şifre gösterme özelliği eklenmiştir
    _obscureText = !_obscureText;
    _obscureText
        ? _suffixColor = Colors.grey[350]
        : _suffixColor = Colors.amber;
    notifyListeners();
  }
}
