import 'package:firebase_sign_up/service/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class FormPassTextField extends StatelessWidget {
  final TextEditingController passwordController;
  FormPassTextField(this.passwordController);
  @override
  Widget build(BuildContext context) {
    final pr = context.watch<DesignProvider>();
    return TextFormField(
      controller: passwordController,
      keyboardType: TextInputType.visiblePassword,
      autofillHints: [AutofillHints.password],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Lütfen bir şifre giriniz';
        } else if (value.length < 5) {
          return 'Lütfen şifrenizi eksik girmeyiniz';
        }
        return null;
      },
      autofocus: false,
      obscureText: pr.obscureText,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: () => pr.suffixIconProcess(),
          icon: Icon(
            Icons.remove_red_eye_sharp,
            color: pr.suffixColor,
          ),
        ),
        labelText: "Şifre",
        labelStyle: TextStyle(fontSize: 17, color: Colors.amber),
        errorStyle: TextStyle(color: Colors.black26),
      ),
    );
  }
}
