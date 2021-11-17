import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_sign_up/screen/home.dart';
import 'package:firebase_sign_up/screen/login/forgot_password.dart';
import 'package:firebase_sign_up/screen/login/sign_up.dart';
import 'package:firebase_sign_up/service/service.dart';
import 'package:firebase_sign_up/widget/form/formActionButton.dart';
import 'package:firebase_sign_up/widget/form/formContent.dart';
import 'package:firebase_sign_up/widget/form/formEmailTextField.dart';
import 'package:firebase_sign_up/widget/form/formPassTextField.dart';
import 'package:firebase_sign_up/widget/form/formTopTitle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  String email = "";

  String password = "";

  final passwordController = TextEditingController();

  final emailController = TextEditingController();

  userLogin() async {
    try {
      TextInput.finishAutofillContext();
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print("Böyle bir email kaydı yok.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Böyle bir email kaydı yok."),
          ),
        );
      } else if (e.code == 'wrong-password') {
        print("Yanlış şifre girdiniz.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Hatalı bir şifre girdiniz."),
          ),
        );
      }
      throw {e.code, e.message};
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Bir Şeyler Yanlış Gitti"),
            );
          } else if (snapshot.error != null) {
            print(snapshot.error.toString());
            return Text(snapshot.error.toString());
          } else if (snapshot.hasData) {
            context.read<ServiceProvider>().getUserData();

            return Home();
          } else {
            return Form(
              key: _formKey,
              child: formContent(
                context,
                AutofillGroup(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      formTopTitle(context, "Giriş"),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 50),
                        child: formEmailTextField(emailController),
                      ),
                      Container(
                        height: 95,
                        margin: EdgeInsets.only(left: 50, right: 50, top: 10),
                        child: Stack(
                          children: [
                            FormPassTextField(passwordController),
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    fixedSize: Size(130, 5),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ForgotPassword()));
                                  },
                                  child: Text(
                                    "Şifreni unuttun mu?",
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 13),
                                  ),
                                )),
                          ],
                        ),
                      ),
                      formActionButton(
                          context,
                          () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                email = emailController.text;
                                password = passwordController.text;
                              });
                              userLogin();
                            }
                          },
                          "Giriş",
                          "Hesabınız yok mu?",
                          "Kaydol",
                          () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                  pageBuilder: (context, a, b) => SignUp(),
                                  transitionDuration: Duration(seconds: 0)),
                            );
                          }),
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: Divider(
                            color: Colors.black87,
                          )),
                          Text(" veya "),
                          Expanded(
                              child: Divider(
                            color: Colors.black87,
                          )),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Spacer(
                              flex: 3,
                            ),
                            IconButton(
                              onPressed: () =>
                                  context.read<ServiceProvider>().googleLogin(),
                              icon: FaIcon(
                                FontAwesomeIcons.google,
                              ),
                            ),
                            Spacer(
                              flex: 1,
                            ),
                            IconButton(
                              onPressed: () => context
                                  .read<ServiceProvider>()
                                  .facebookLogin(),
                              icon: FaIcon(
                                FontAwesomeIcons.facebook,
                              ),
                            ),
                            Spacer(
                              flex: 3,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
