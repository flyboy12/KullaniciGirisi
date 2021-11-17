import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_sign_up/screen/login/login.dart';
import 'package:firebase_sign_up/widget/form/formActionButton.dart';
import 'package:firebase_sign_up/widget/form/formContent.dart';
import 'package:firebase_sign_up/widget/form/formPassTextField.dart';
import 'package:firebase_sign_up/widget/form/formTopTitle.dart';
import 'package:flutter/material.dart';

class NewPassword extends StatefulWidget {
  NewPassword({Key? key}) : super(key: key);

  @override
  _NewPasswordState createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  final _formKey = GlobalKey<FormState>();
  var newPassword = "";
  final newPasswordTextEditingController = TextEditingController();
  final User currentUser = FirebaseAuth.instance.currentUser!;
  changePassword() async {
    try {
      currentUser.updatePassword(newPassword);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "Şifreniz Değişmiştir, Lütfen Yeni Şifrenizle Yeniden Giriş Yapınız.")));
    } catch (e) {}
  }

  @override
  void dispose() {
    newPasswordTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Form(
          key: _formKey,
          child: formContent(
              context,
              Column(
                children: [
                  formTopTitle(context, "Yeni Şifre Oluşturma"),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: FormPassTextField(
                      newPasswordTextEditingController,
                    ),
                  ),
                  formActionButton(context, () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        newPassword = newPasswordTextEditingController.text;
                      });
                      changePassword();
                    }
                  }, "Şifreyi Yenile", "", "", () {}),
                ],
              ))),
    );
  }
}
