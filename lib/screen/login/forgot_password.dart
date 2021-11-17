import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_sign_up/screen/login/login.dart';
import 'package:firebase_sign_up/screen/login/sign_up.dart';

import 'package:firebase_sign_up/widget/form/formContent.dart';
import 'package:firebase_sign_up/widget/form/formEmailTextField.dart';
import 'package:firebase_sign_up/widget/form/formTopTitle.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();

  var email = "";

  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Şifre Sıfırlama Emaili Yollanmıştır")));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print("Kullanıcı Bulunamadı");
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Kayıtlı bir email bulunamadı")));
      }
    }
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              formTopTitle(context, "Şifremi Unuttum"),
              Container(
                margin: EdgeInsets.symmetric(vertical: 30, horizontal: 50),
                child: formEmailTextField(emailController),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            email = emailController.text;
                          });
                          resetPassword();
                        }
                      },
                      child: Text("Emaili Yolla")),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      },
                      child: Text(
                        "Giriş",
                        style: TextStyle(color: Colors.black),
                      )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Bir hesabınız yok mu?"),
                  TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            PageRouteBuilder(
                                pageBuilder:
                                    (context, animation1, animation2) =>
                                        SignUp(),
                                transitionDuration: Duration(seconds: 0)),
                            (route) => false);
                      },
                      child: Text(
                        "Kaydol",
                        style: TextStyle(
                          color: Colors.amber,
                        ),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
