import 'package:flutter/material.dart';

TextFormField formEmailTextField(
  TextEditingController controller,
) {
  return TextFormField(
    autofocus: false,
    controller: controller,
    keyboardType: TextInputType.emailAddress,
    autofillHints: [AutofillHints.email],
    decoration: InputDecoration(
      labelText: "Email",
      labelStyle: TextStyle(fontSize: 17, color: Colors.amber),
      errorStyle: TextStyle(color: Colors.black26),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Lütfen bir email giriniz';
      } else if (!value.contains('@')) {
        return 'Lütfen geçerli bir email giriniz';
      }
      return null;
    },
  );
}
