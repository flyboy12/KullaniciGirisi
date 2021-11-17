import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_sign_up/screen/login/login.dart';
import 'package:firebase_sign_up/service/service.dart';
import 'package:firebase_sign_up/widget/form/formEmailTextField.dart';
import 'package:firebase_sign_up/widget/form/formPassTextField.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  var email = "";
  var password = "";
  var userName = "";
  bool _isLoading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final userNameController = TextEditingController();

  registration() async {
    try {
      setState(() {
        _isLoading = true;
        email = emailController.text;
        password = passwordController.text;
        userName = userNameController.text;
      });

      String r = DateTime.now().toIso8601String();
      final ref = FirebaseStorage.instance.ref('usersImage/$r');
      final UploadTask task = ref.putFile(File(selectedImage!.path));
      final snapshot = await task.whenComplete(() {});
      final dowloandUrl = await snapshot.ref.getDownloadURL();
      print(dowloandUrl);

      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          )
          .whenComplete(
              () => ServiceProvider().addUserCloud(userName, dowloandUrl));
      print(userCredential);

      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => Login()), (route) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print("Zayıf Şifre");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Girdiğiniz şifre zayıf bir şifredir.",
            style: TextStyle(color: Colors.red),
          ),
          backgroundColor: Colors.white,
        ));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Girdiğiniz email kayıtlı bir kullanıcıya aittir  .",
            style: TextStyle(color: Colors.red),
          ),
          backgroundColor: Colors.white,
        ));
        print('Bu email zaten kullanılıyor.');
      }
    }
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    userNameController.dispose();
    super.dispose();
  }

  XFile? selectedImage;
  Future getImage() async {
    XFile? image =
        await ImagePicker.platform.getImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = image!;
    });
  }

  bool isObscure = false;
  int _currentStep = 0;
  @override
  Widget build(BuildContext context) {
    List<Step> _getStep() => [
          Step(
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
              title: Text("Kullanıcı\nBilgileri"),
              content: Column(
                children: [
                  TextFormField(
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Lütfen Kullanıcı Adınızı Giriniz";
                      }
                    },
                    controller: userNameController,
                    decoration: InputDecoration(
                      labelText: "Kullanıcı Adı",
                      labelStyle: TextStyle(fontSize: 17, color: Colors.amber),
                      errorStyle: TextStyle(color: Colors.black26),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    onTap: () {
                      getImage();
                    },
                    leading: CircleAvatar(
                      radius: 30,
                      child: selectedImage == null
                          ? Icon(Icons.photo_camera)
                          : ClipRRect(
                              child: Image.file(
                                File(selectedImage!.path),
                                fit: BoxFit.fill,
                              ),
                            ),
                    ),
                    title: Text(selectedImage == null
                        ? "Profil fotoğrafı seçiniz"
                        : selectedImage!.name),
                  ),
                ],
              ),
              isActive: _currentStep >= 0),
          Step(
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
              title: Text("Giriş\nBilgileri"),
              content: Column(
                children: [
                  formEmailTextField(emailController),
                  FormPassTextField(passwordController),
                ],
              ),
              isActive: _currentStep >= 1),
          Step(
              state: _currentStep > 2 ? StepState.complete : StepState.indexed,
              title: Text("Bilgileri\nÖnizleme"),
              content: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    child: selectedImage == null
                        ? Icon(Icons.photo_camera)
                        : Image.file(
                            File(selectedImage!.path),
                            fit: BoxFit.fitWidth,
                          ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    leading: Icon(Icons.person, color: Colors.amber),
                    title: Text(userNameController.text),
                  ),
                  ListTile(
                    leading: Icon(Icons.mail, color: Colors.amber),
                    title: Text(emailController.text),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.password,
                      color: Colors.amber,
                    ),
                    title:
                        Text(isObscure ? passwordController.text : "*********"),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.remove_red_eye,
                        color: isObscure ? Colors.amber : Colors.grey[500],
                      ),
                      onPressed: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                    ),
                  )
                ],
              ),
              isActive: _currentStep >= 2),
        ];

    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.18,
                      child: Container(
                        alignment: Alignment.bottomLeft,
                        color: Colors.amber,
                        child: Text(
                          "Kaydol",
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: Colors.white),
                        ),
                        padding: EdgeInsets.only(left: 20, bottom: 10),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 15),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.82,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Stepper(
                        controlsBuilder: (context,
                            {onStepCancel, onStepContinue}) {
                          return Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Divider(),
                              Row(
                                children: [
                                  if (_currentStep != 0)
                                    Expanded(
                                        child: TextButton(
                                      onPressed: onStepCancel,
                                      child: Text("Geri"),
                                    )),
                                  Expanded(
                                      child: TextButton(
                                    onPressed: onStepContinue,
                                    child: Text(
                                        _currentStep == 2 ? "Kaydol" : "İleri"),
                                  )),
                                ],
                              ),
                            ],
                          );
                        },
                        steps: _getStep(),
                        type: StepperType.horizontal,
                        currentStep: _currentStep,
                        onStepContinue: () {
                          final isLastStep =
                              _currentStep == _getStep().length - 1;
                          if (selectedImage == null && _currentStep == 0) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "Lütfen bir profil fotoğrafı yükleyiniz")));
                          } else if (!_formKey.currentState!.validate()) {
                            return null;
                          } else if (isLastStep) {
                            registration();
                          } else {
                            setState(() {
                              _currentStep += 1;
                            });
                          }
                        },
                        onStepCancel: () {
                          if (_currentStep != 0) {
                            setState(() {
                              _currentStep--;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
